import SwiftUI

class LevelStub {

    /// This level stub generates some random Pegs to be used for simulation
    /// of a predesigned level
    static let levelStub = Level(name: "Level1",
                                 gameObjects: LevelStub.getGameObjects(
                                    for: LevelStub.scaledGameObjectsStub))

    static let objectStub = Level(name: "Level2",
                                  gameObjects: LevelStub.getGameObjects(
                                    for: LevelStub.singleObjectStub))

    static func getGameObjects(for objects: [any GameObject]) -> [UUID: any GameObject] {
        var objectsMap: [UUID: any GameObject] = [:]
        objects.forEach { object in
            objectsMap[object.id] = object
        }
        return objectsMap
    }

    static let gameObjectsStub: [any GameObject] = [
        NormalPeg(centerPosition: Vector(x: 195, y: 633)),
        NormalPeg(centerPosition: Vector(x: 523.5, y: 467.5)),
        NormalPeg(centerPosition: Vector(x: 708, y: 487.5)),
        NormalPeg(centerPosition: Vector(x: 630.5, y: 782.5)),
        NormalPeg(centerPosition: Vector(x: 360.5, y: 919)),
        NormalPeg(centerPosition: Vector(x: 349, y: 678)),
        NormalPeg(centerPosition: Vector(x: 598.5, y: 605)),
        NormalPeg(centerPosition: Vector(x: 413.5, y: 816.5)),
        NormalPeg(centerPosition: Vector(x: 152, y: 840.5)),
        NormalPeg(centerPosition: Vector(x: 229, y: 365)),
        NormalPeg(centerPosition: Vector(x: 389, y: 513)),
        GoalPeg(centerPosition: Vector(x: 142, y: 747)),
        GoalPeg(centerPosition: Vector(x: 548.5, y: 702.5)),
        GoalPeg(centerPosition: Vector(x: 118.5, y: 464))
    ]

    static let scaledGameObjectsStub: [any GameObject] = [
        NormalPeg(centerPosition: Vector(scaled_x: 0.232, scaled_y: 0.53)),
        NormalPeg(centerPosition: Vector(scaled_x: 0.623, scaled_y: 0.392)),
        NormalPeg(centerPosition: Vector(scaled_x: 0.843, scaled_y: 0.408)),
        NormalPeg(centerPosition: Vector(scaled_x: 0.751, scaled_y: 0.655)),
        NormalPeg(centerPosition: Vector(scaled_x: 0.429, scaled_y: 0.77)),
        NormalPeg(centerPosition: Vector(scaled_x: 0.415, scaled_y: 0.568)),
        NormalPeg(centerPosition: Vector(scaled_x: 0.713, scaled_y: 0.507)),
        NormalPeg(centerPosition: Vector(scaled_x: 0.492, scaled_y: 0.684)),
        NormalPeg(centerPosition: Vector(scaled_x: 0.181, scaled_y: 0.704)),
        NormalPeg(centerPosition: Vector(scaled_x: 0.273, scaled_y: 0.306)),
        NormalPeg(centerPosition: Vector(scaled_x: 0.463, scaled_y: 0.43)),
        GoalPeg(centerPosition: Vector(scaled_x: 0.169, scaled_y: 0.626)),
        GoalPeg(centerPosition: Vector(scaled_x: 0.653, scaled_y: 0.588)),
        GoalPeg(centerPosition: Vector(scaled_x: 0.141, scaled_y: 0.389))
    ]

    /// To test for level refreshing
    static let singleObjectStub: [any GameObject] = [
        NormalPeg(centerPosition: Vector(x: 195, y: 633))
    ]

}
