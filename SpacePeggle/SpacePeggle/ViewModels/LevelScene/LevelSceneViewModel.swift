import SwiftUI

protocol PegManipulation {
    func handleTap(in location: CGPoint, for geometry: GeometryProxy)
    func handleLongPress(forPegAt index: Int)

    // Should be handled by LevelModel
    func addPeg(at location: CGPoint, for geometry: GeometryProxy, withColor: Color)
    func movePegPermanently(at index: Int, from startLocation: CGPoint,
                            to endLocation: CGPoint, for geometry: GeometryProxy)
    func removePeg(at index: Int)
}

protocol PegValidation {
    func isValidLocation(_ location: CGPoint, _ geometry: GeometryProxy) -> Bool
    func isValidLocationForMoving(_ location: CGPoint, _ geometry: GeometryProxy, _ index: Int) -> Bool

    // Should be handled by universal collider
    func isWithinPlayableArea(_ location: CGPoint, _ geometry: GeometryProxy) -> Bool
    func isOverlapping(_ location: CGPoint) -> Bool
    func isOverlappingExclusively(_ location: CGPoint, index: Int) -> Bool
}

protocol GameStateManagement {
    var isRemove: Bool { get set }
    var levelNameInput: String { get set }
}

typealias AbstractLevelSceneViewModel =
ObservableObject & PegManipulation & PegValidation & GameStateManagement

class LevelSceneViewModel: ObservableObject {

}
