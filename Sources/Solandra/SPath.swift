import CoreGraphics

public enum SPathError: Error {
  case noEdges
  case noPoints
  case notEnoughEdges(required: Int)
}

public struct CurveSpec {
  var positive: Bool
  var curveSize: Double
  var curveAngle: Double
  var bulbousness: Double
  var twist: Double
}

public enum SPathEdge {
  case line(from: CGPoint, to: CGPoint)
  case curve(from: CGPoint, to: CGPoint, curve: CurveSpec)
  
  var to: CGPoint {
    switch self {
    case .curve(_, let to, _):
      return to
    case .line(_, let to):
      return to
    }
  }
  
  var from: CGPoint {
    switch self {
    case .curve(let from, _, _):
      return from
    case .line(let from, _):
      return from
    }
  }
  
  func transformed(by transform: (CGPoint) -> CGPoint) -> SPathEdge {
    switch self {
    case let .line(from, to):
      return .line(from: transform(from), to: transform(to))
    case let .curve(from: from, to: to, curve: curve):
      return .curve(from: transform(from), to: transform(to), curve: curve)
    }
  }
  
  func addTo(context: CGContext) {
    switch self {
    case .line(_, let to):
      context.addLine(to: to)
    case .curve(_, let to, let curve):
      let polarity: Double = curve.positive ? 1 : -1
      let u = to - from
      let d = u.magnitude
      let m = from + u * 0.5
      let perp = (u.rotated(-Double.pi / 2)).normalized
      let rotatedPerp = perp.rotated(curve.curveAngle)
      let controlMid = m + rotatedPerp * curve.curveSize * polarity * d * 0.5
      let perpOfRot = rotatedPerp.rotated(-Double.pi / 2 - curve.twist).normalized
      let control1 = controlMid + perpOfRot * ((curve.bulbousness * d) / 2)
      let control2 = controlMid + perpOfRot * (-(curve.bulbousness * d) / 2)
      
      context.addCurve(to: to, control1: control1, control2: control2)
    }
  }
}

public enum ShapeAlignment {
  case centered, topLeft
}


public struct SPath {
  public var edges: [SPathEdge] = []
  var currentPoint: CGPoint
  
  public init(start: CGPoint) {
    currentPoint = start
  }
  
  public init(points: [CGPoint], closed: Bool = false) throws {
    guard let start = points.first else {
      throw SPathError.noPoints
    }
    
    currentPoint = start
    for p in points.dropFirst() {
      addLine(to: p)
    }
    
    if closed {
      try close()
    }
  }
  
  public mutating func addLine(to: CGPoint) {
    edges.append(.line(from: currentPoint, to: to))
    currentPoint = to
  }
  
  public mutating func addCurve(to: CGPoint, curve: CurveSpec) {
    edges.append(.curve(from: currentPoint, to: to, curve: curve))
    currentPoint = to
  }
  
  private mutating func add(edge: SPathEdge) {
    edges.append(edge)
    currentPoint = edge.to
  }
  
  public func addTo(context: CGContext) {
    if let firstEdge = edges.first {
      context.move(to: firstEdge.from)
    }
    
    for edge in edges {
      edge.addTo(context: context)
    }
  }
  
  public mutating func close() {
    if !edges.isEmpty {
      addLine(to: edges[0].from)
    }
  }
  
  public func transformed(transform: (CGPoint) -> CGPoint) -> SPath {
    var newPath = SPath(start: transform(currentPoint))
    newPath.edges = edges.map { edge in
      edge.transformed(by: transform)
    }
    return newPath
  }
  
  public var points: [CGPoint] {
    edges.map { $0.from }
  }
  
  public var centroid: CGPoint {
    var total = CGPoint.zero
    var n = edges.count
    if n < 1 {
      n = 1
    }
    
    for edge in edges {
      total += edge.from
    }
    return total / n.d
  }
  
  public func moved(by: CGSize) -> SPath {
    transformed {
      $0 + by
    }
  }
  
  public func moved(by: CGPoint) -> SPath {
    transformed {
      $0 + by
    }
  }
  
  public func scaled(by scale: Double, about: CGPoint? = nil) -> SPath {
    let c = about ?? centroid
    return transformed {
      c + ($0 - c) * scale
    }
  }
  
  public func rotated(by angle: Double) -> SPath {
    let c = centroid
    return transformed {
      c + ($0 - c).rotated(angle)
    }
  }
  
  public func segmented() -> [SPath] {
    if edges.count < 2 {
      return [self]
    }
    let c = centroid
    var paths: [SPath] = []
    
    for edge in edges {
      var path = SPath(start: edge.from)
      path.add(edge: edge)
      path.addLine(to: c)
      path.close()
      paths.append(path)
    }
    
    return paths
  }
  
  public func exploded(magnitude: Double = 1.2, scale: Double = 1) -> [SPath] {
    if edges.count < 2 {
      return [self]
    }
    let c = centroid
    
    var paths: [SPath] = []
    
    for edge in edges {
      var path = SPath(start: edge.from)
      path.add(edge: edge)
      path.addLine(to: c)
      path.close()
      
      path = path.scaled(by: scale)
      path = path.moved(by: (path.centroid - centroid) * (magnitude - 1.0))
      
      paths.append(path)
    }
    return paths
  }
  
  
  //  /// A way to smooth out a path of lines; after just a few applications it will look like a nice curve.
  //  /// NB this converts the SPath to lines i.e. detail in any existing curves will be lost
  //  /// If the path forms a look you probably want to opt in to the looped option.
  //  public func chaikin(n: Int = 1, looped: Bool = false) -> SPath {
  //    var pts = points
  //    if pts.count < 3 {
  //      return self
  //    }
  //
  //    var newPts: [CGPoint] = []
  //
  //    for _ in 0..<n {
  //      if (!looped) {
  //        newPts.append(pts[0])
  //      }
  //
  //      let m = pts.count - 2
  //      for j in 0..<m {
  //        let a = pts[j]
  //        let b = pts[j + 1]
  //        let c = pts[j + 2]
  //
  //        newPts.append(b.towards(other: a, amount: 0.25))
  //        newPts.append(b.towards(other: c, amount: 0.25))
  //      }
  //
  //      if (!looped) {
  //        newPts.append(pts.last!)
  //      }
  //
  //      pts = newPts
  //      newPts = []
  //    }
  //    // The reason this would throw is due to not enough edges and we already check for that
  //    return try! SPath(points: pts)
  //  }
  
  public static func regularPolygon(
    radius: Double,
    at: CGPoint = CGPoint.zero,
    n: Int = 5,
    startAngle: Double = 0) -> SPath {
      let a = -Double.pi / 2 + startAngle
      let dA = (Double.pi * 2) / n.d
      var path = SPath(start: CGPoint(at.x + radius * cos(a), at.y + radius * sin(a)))
      for i in 1..<n {
        path.addLine(
          to: CGPoint(at.x + radius * cos(a + i.d * dA),
                      at.y + radius * sin(a + i.d * dA)))
      }
      path.close()
      return path
    }
  
  public static func star(r1: Double, r2: Double? = nil, at: CGPoint, n: Int, startAngle: Double = 0 ) throws -> SPath {
    if n < 3 {
      throw SPathError.notEnoughEdges(required: 6)
    }
    
    let a = -Double.pi / 2 + startAngle
    let iR = r2 ?? r1 / 2
    let dA = (Double.pi * 2) / n.d
    
    let currentPoint = CGPoint(at.x + r1 * cos(a), at.y + r1 * sin(a))
    var path = SPath(start: currentPoint)
    
    for i in 1..<n {
      path.addLine(to:
                    CGPoint(at.x + iR * cos(a + (i.d - 0.5) * dA),
                            at.y + iR * sin(a + (i.d - 0.5) * dA)))
      path.addLine(
        to: CGPoint(at.x + r1 * cos(a + i.d * dA),
                    at.y + r1 * sin(a + i.d * dA)))
    }
    path.addLine(
      to: CGPoint(
        at.x + iR * cos(a - 0.5 * dA), at.y + iR * sin(a - 0.5 * dA)))
    path.close()
    return path
  }
  
  public static func spiral(at: CGPoint,
                            n: Int,
                            l: Double,
                            startAngle: Double = 0,
                            rate: Double = 20) -> SPath {
    var a = startAngle
    var r = l
    var path = SPath(start: at + CGPoint(r * cos(a), r * sin(a)))
    
    for _ in 0..<n {
      let dA = 2 * asin(l / (r * 2))
      r += rate * dA
      a += dA
      path.addLine(to: at + CGPoint(r * cos(a), r * sin(a)))
    }
    return path
  }
  
  public static func rectangle(at: CGPoint, width: Double, height: Double, align: ShapeAlignment = .topLeft) -> SPath {
    let start: CGPoint
    switch align {
    case .topLeft:
      start = at
    case .centered:
      start = at - CGPoint(width / 2, height / 2)
    }
    
    var path = SPath(start: start)
    path.addLine(to: start + CGPoint(width, 0))
    path.addLine(to: start + CGPoint(width, height))
    path.addLine(to: start + CGPoint(0, height))
    path.close()
    
    return path
  }
  
  public static func square(at: CGPoint, size: Double, align: ShapeAlignment = .topLeft) -> SPath {
    rectangle(at: at, width: size, height: size, align: align)
  }
}
