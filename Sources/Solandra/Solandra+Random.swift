import Foundation

// SHould really generate this somehow?
extension Solandra {
  public func random() -> Double {
    rng.random()
  }
  
  public func randomInt() -> Int {
    rng.randomInt()
  }
  
  public func randomInt(max: Int) -> Int {
    rng.randomInt(max: max)
  }
  
  public func randomInt(min: Int, max: Int) -> Int {
    rng.randomInt(min: min, max: max)
  }
  
  public func randomBool() -> Bool {
    rng.randomBool()
  }
  
  public func uniformGridPoint(minX: Int, maxX: Int, minY: Int, maxY: Int) -> (Int, Int) {
    rng.uniformGridPoint(minX: minX, maxX: maxX, minY: minY, maxY: maxY)
  }
  
  /**
   +/- 1
   */
  public func randomPolarity() -> Int {
    rng.randomPolarity()
  }
  
  // TODO consider making below 2 safe in some way
  public func sample<T>(_ from: Array<T>) -> T {
    rng.sample(from)
  }

  public func samples<T>(n: Int, from: Array<T>) -> Array<T> {
    rng.samples(n: n, from: from)
  }
  
  public func shuffled<T>(items: Array<T>) -> Array<T> {
    rng.shuffled(items: items)
  }
  
  public func gaussian(mean: Double = 0, sd: Double = 1) -> Double {
    rng.gaussian(mean: mean, sd: sd)
  }
  
  public func poisson(lambda: Int) -> Int {
    rng.poisson(lambda: lambda)
  }
}
