import SwiftUI

class Bucket {

    var velocity = Vector(x: -100, y: 0)

    var bucketLeft: BucketLeft
    var bucketRight: BucketRight

    var centerPosition: Vector {
        Vector(x: (bucketLeft.centerPosition.x + bucketRight.centerPosition.x).half,
               y: (bucketLeft.centerPosition.y + bucketRight.centerPosition.y).half)
    }

    var width: Double {
        (bucketRight.centerPosition.x + bucketRight.width.half)
        - (bucketLeft.centerPosition.x + bucketLeft.width.half)
    }

    var height: Double {
        bucketRight.height
    }

    init(bucketLeft: BucketLeft = BucketLeft(), bucketRight: BucketRight = BucketRight()) {
        self.bucketLeft = bucketLeft
        self.bucketRight = bucketRight
        self.bucketLeft.bucket = self
        self.bucketRight.bucket = self
    }

    func containsObject(_ object: any UniversalObject) -> Bool {
        let withinXAxis = object.rightCenter.x <= bucketRight.leftCenter.x
        && object.leftCenter.x >= bucketLeft.rightCenter.x

        let withinYAxis = object.topCenter.y >= bucketRight.topCenter.y
        && object.bottomCenter.y <= bucketRight.bottomCenter.y
        return withinXAxis && withinYAxis
    }
}
