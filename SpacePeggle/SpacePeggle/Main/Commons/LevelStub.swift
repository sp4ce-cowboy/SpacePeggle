import SwiftUI

struct LevelStub {

    /// This level stub generates some random Pegs to be used for simulation
    /// of a predesigned level
    func getLevelOneStub() -> Level {
        Level(name: "Level1",
              gameObjects: LevelStub.getGameObjects(
                for: LevelStub().gameObjectsStubOne))
    }

    func getLevelTwoStub() -> Level {
        Level(name: "Level2",
              gameObjects: LevelStub.getGameObjects(
                for: LevelStub().gameObjectsStubTwo))
    }

    func getLevelThreeStub() -> Level {
        Level(name: "Level1",
              gameObjects: LevelStub.getGameObjects(
                for: LevelStub().gameObjectsStubThree))
    }

    static func getGameObjects(for objects: [any GameObject]) -> [UUID: any GameObject] {
        var objectsMap: [UUID: any GameObject] = [:]
        objects.forEach { object in
            objectsMap[object.id] = object
        }
        return objectsMap
    }

    /// To test for level refreshing
    let singleObjectStub: [any GameObject] = [
        NormalPeg(centerPosition: Vector(x: 195, y: 633))
    ]

    private let gameObjectsStubOne: [any GameObject] = [
        NormalPeg(centerPosition: Vector(scaled_x: 0.232, scaled_y: 0.53), id: UUID()),
        NormalPeg(centerPosition: Vector(scaled_x: 0.623, scaled_y: 0.392), id: UUID()),
        NormalPeg(centerPosition: Vector(scaled_x: 0.843, scaled_y: 0.408), id: UUID()),
        NormalPeg(centerPosition: Vector(scaled_x: 0.751, scaled_y: 0.655), id: UUID()),
        NormalPeg(centerPosition: Vector(scaled_x: 0.429, scaled_y: 0.77), id: UUID()),
        NormalPeg(centerPosition: Vector(scaled_x: 0.415, scaled_y: 0.568), id: UUID()),
        NormalPeg(centerPosition: Vector(scaled_x: 0.713, scaled_y: 0.507), id: UUID()),
        NormalPeg(centerPosition: Vector(scaled_x: 0.492, scaled_y: 0.684), id: UUID()),
        NormalPeg(centerPosition: Vector(scaled_x: 0.181, scaled_y: 0.704), id: UUID()),
        NormalPeg(centerPosition: Vector(scaled_x: 0.273, scaled_y: 0.306), id: UUID()),
        NormalPeg(centerPosition: Vector(scaled_x: 0.463, scaled_y: 0.43), id: UUID()),
        GoalPeg(centerPosition: Vector(scaled_x: 0.169, scaled_y: 0.626), id: UUID()),
        GoalPeg(centerPosition: Vector(scaled_x: 0.653, scaled_y: 0.588), id: UUID()),
        GoalPeg(centerPosition: Vector(scaled_x: 0.141, scaled_y: 0.389), id: UUID())
    ]

    private let gameObjectsStubTwo: [any GameObject] = [
        BlockPeg(centerPosition: Vector(scaled_x: 0.232, scaled_y: 0.53), id: UUID()),
        NormalPeg(centerPosition: Vector(scaled_x: 0.623, scaled_y: 0.392), id: UUID()),
        NormalPeg(centerPosition: Vector(scaled_x: 0.843, scaled_y: 0.408), id: UUID()),
        NormalPeg(centerPosition: Vector(scaled_x: 0.751, scaled_y: 0.655), id: UUID()),
        BlockPeg(centerPosition: Vector(scaled_x: 0.429, scaled_y: 0.77), id: UUID()),
        BlockPeg(centerPosition: Vector(scaled_x: 0.415, scaled_y: 0.568), id: UUID()),
        NormalPeg(centerPosition: Vector(scaled_x: 0.713, scaled_y: 0.507), id: UUID()),
        BlockPeg(centerPosition: Vector(scaled_x: 0.492, scaled_y: 0.684), id: UUID()),
        NormalPeg(centerPosition: Vector(scaled_x: 0.181, scaled_y: 0.704), id: UUID()),
        BlockPeg(centerPosition: Vector(scaled_x: 0.273, scaled_y: 0.306), id: UUID()),
        NormalPeg(centerPosition: Vector(scaled_x: 0.463, scaled_y: 0.43), id: UUID()),
        GoalPeg(centerPosition: Vector(scaled_x: 0.169, scaled_y: 0.626), id: UUID()),
        GoalPeg(centerPosition: Vector(scaled_x: 0.653, scaled_y: 0.588), id: UUID()),
        GoalPeg(centerPosition: Vector(scaled_x: 0.141, scaled_y: 0.389), id: UUID())
    ]

    private let gameObjectsStubThree: [any GameObject] = [
        NormalPeg(centerPosition: Vector(scaled_x: 0.232, scaled_y: 0.53), id: UUID()),
        NormalPeg(centerPosition: Vector(scaled_x: 0.623, scaled_y: 0.392), id: UUID()),
        GoalPeg(centerPosition: Vector(scaled_x: 0.843, scaled_y: 0.408), id: UUID()),
        BlockPeg(centerPosition: Vector(scaled_x: 0.751, scaled_y: 0.655), id: UUID()),
        NormalPeg(centerPosition: Vector(scaled_x: 0.429, scaled_y: 0.77), id: UUID()),
        GoalPeg(centerPosition: Vector(scaled_x: 0.415, scaled_y: 0.568), id: UUID()),
        NormalPeg(centerPosition: Vector(scaled_x: 0.713, scaled_y: 0.507), id: UUID()),
        NormalPeg(centerPosition: Vector(scaled_x: 0.492, scaled_y: 0.684), id: UUID()),
        GoalPeg(centerPosition: Vector(scaled_x: 0.181, scaled_y: 0.704), id: UUID()),
        NormalPeg(centerPosition: Vector(scaled_x: 0.273, scaled_y: 0.306), id: UUID()),
        NormalPeg(centerPosition: Vector(scaled_x: 0.463, scaled_y: 0.43), id: UUID()),
        GoalPeg(centerPosition: Vector(scaled_x: 0.169, scaled_y: 0.626), id: UUID()),
        GoalPeg(centerPosition: Vector(scaled_x: 0.653, scaled_y: 0.588), id: UUID()),
        GoalPeg(centerPosition: Vector(scaled_x: 0.141, scaled_y: 0.389), id: UUID())
    ]

}
