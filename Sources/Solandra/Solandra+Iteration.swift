import Foundation

public typealias SolandraAreaCallback = (CGRect, Int) -> Void

public enum TileType {
  case proporionate, square
}

public enum TileOrder {
  case columnFirst, rowFirst
}

extension Solandra {
  public func forMargin(
    margin: Double,
    callback: SolandraAreaCallback
  ) {
    forTiling(n: 1, margin: margin, callback: callback)
  }
  
  public func forTiling(n: Int,
                        tileType: TileType = .proporionate,
                        margin: Double = 0.1,
                        order: TileOrder = .columnFirst,
                        callback: SolandraAreaCallback) {
    
    var k = 0
    let marginSize = margin * size.width
    let nY = (tileType == TileType.square) ? floor(n.d * (1 / aspectRatio)).i : n
    let deltaX = (size.width - marginSize * 2) / n.d
    let hY = (tileType == TileType.square) ? deltaX * nY.d : size.height - 2 * marginSize
    let deltaY = hY / nY.d
    let sX = marginSize
    let sY = (size.height - hY) / 2
    
    switch order {
    case .columnFirst:
      for i in 0..<n {
        for j in 0..<nY {
          callback(CGRect(
            x: sX + i.d * deltaX,
            y: sY + j.d * deltaY,
            width: deltaX,
            height: deltaY
          ), k)
          k += 1
        }
      }
    case .rowFirst:
      for j in 0..<nY {
        for i in 0..<n {
          callback(CGRect(
            x: sX + i.d * deltaX,
            y: sY + j.d * deltaY,
            width: deltaX,
            height: deltaY
          ), k)
          k += 1
        }
      }
    }
  }
  
  public func forHorizontal(n: Int,
                     margin: Double = 0,
                     callback: SolandraAreaCallback) {
    let sX = margin * size.width
    let eX = (1 - margin) * size.width
    let sY = sX
    let dY = size.height - 2 * sY
    let dX = (eX - sX) / n.d
    
    for i in 0..<n {
      callback(CGRect(x: sX + i.d * dX, y: sY, width: dX, height: dY), i)
    }
  }
  
  
  public func forVertical(
    n: Int,
    margin: Double = 0,
    callback: SolandraAreaCallback) {
      let sX = margin * size.width
      let eY = (1 - margin) * size.width
      let sY = sX
      let dX = size.width - 2 * sX
      let dY = (eY - sY) / n.d
      
      for i in 0..<n {
        callback(CGRect(x: sX, y: sY + i.d * dY, width: dX, height: dY), i)
      }
    }
}
