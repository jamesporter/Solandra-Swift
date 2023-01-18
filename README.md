# Solandra

Ergonomic Creative Coding with Swift

Create things like this:

![Example solandra thing](./Tests/SolandraTests/__Snapshots__/SolandraTests/testRegular.1.png)

in just a few lines of Swift:

```swift
    let image = Solandra.renderImage(width: 1024, height: 1024) { context, size, s in
      s.background(0.23, 0.74, 0.1)

      s.forTiling(n: 5) { area, i in
        s.setFill(0.93 - 0.02 * i.d, 0.74, 0.6, 0.8)
        let path = SPath.regularPolygon(radius: min(area.width, area.height), at: area.center, n: i + 5)
        s.fill(path)
      }
    }
```
