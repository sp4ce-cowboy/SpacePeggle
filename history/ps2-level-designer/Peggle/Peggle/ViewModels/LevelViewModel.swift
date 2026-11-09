import SwiftUI
/// This class is the main ViewModel for the Peggle Level Designer and controls
/// the LevelView. It conforms to ObservableObject and therefore can be encapsulated
/// as a StateObject within LevelView.
///
/// Information Flow: The ViewModel exposes @Published properties that the View
/// observes. Whenever the ViewModel updates these properties, the View reacts
/// by updating the UI.
///
/// Implementation: The @StateObject property wrapper in the
/// View can hold an instance of the ViewModel. When @Published properties change,
/// SwiftUI automatically updates the views that depend on them.
///
/// Check Representation assertions are commented out (to ensure proper functioning)
/// of the App and can be uncommented for debugging/analysis purposes.
class LevelViewModel: ObservableObject {
    let radius = Utility.UNIVERSAL_PEG_DIAMETER / 2

    @Published var isRemove = false
    @Published var pegIsRemoved = false
    @Published var color = PegColor.defaultColor
    @Published var levelNameInput: String = ""
    @Published var pegs: [Peg] = []

    func handleTap(in location: CGPoint, for geometry: GeometryProxy) {
        if isRemove {
            removePeg(ifTappedAt: location)
        } else {
            addPeg(at: location, for: geometry, withColor: color)
        }
        /*assert(checkRepresentation(geometry))*/
    }

    func handleLongPress(forPegAt index: Int) {
        removePeg(at: index)
    }

    func addPeg(at location: CGPoint, for geometry: GeometryProxy, withColor: PegColor) {
        if isValidLocation(location, geometry) {
            pegs.append(Peg(centerPosition: location, color: color))
        }
        /*assert(checkRepresentation(geometry))*/
    }

    /// Internal implementation of moving the peg
    func movePeg(at index: Int, to location: CGPoint) {
        pegs[index].centerPosition = location
    }

    /// Moves the peg permanently to a specified location taking into account the
    /// possible collisions that might occur during the course of the drag gesture.
    func movePegPermanently(at index: Int, from startLocation: CGPoint,
                            to endLocation: CGPoint, for geometry: GeometryProxy) {

        // The outer guard statment ensures that the final location is valid
        guard isValidLocationForMoving(endLocation, geometry, index) else {

            // The inner guard statement ensures that the intial location remains valid
            // before the peg is return to it.
            guard isValidLocationForMoving(startLocation, geometry, index) else {

                // In the worst case scenario, the peg is removed entirely, preserving
                // representation invariants permanently
                removePeg(at: index)
                return
            }

            // If the final location is invalid, then the peg is returned to the original
            // location
            movePeg(at: index, to: startLocation)
            return
        }

        // In the best case scenario, the peg is moved without error
        movePeg(at: index, to: endLocation)
        /*assert(checkRepresentation(geometry)*/
    }

    /// Internal implementation of the remove peg method
    func removePeg(at index: Int) {
        pegs.remove(at: index)
    }

    /// Remove a Peg at a specified location if it contains a Peg
    func removePeg(ifTappedAt location: CGPoint) {
        if let index = pegs.firstIndex(where: { peg in
            distanceBetween(peg: peg, point: location) <= radius
        }) {
            pegs.remove(at: index)
            return
        }
    }

    /// Returns true if the peg obeys all constrains
    func isValidLocation(_ location: CGPoint, _ geometry: GeometryProxy) -> Bool {
        isWithinPlayableArea(location, geometry) && !isOverlapping(location)
    }

    /// Returns true if the peg obeys all constraints (ignoring itself)
    func isValidLocationForMoving(_ location: CGPoint,
                                  _ geometry: GeometryProxy, _ index: Int) -> Bool {
        isWithinPlayableArea(location, geometry)
        && !isOverlappingExclusively(location, index: index)
    }

    /// Returns true if placing a peg at the input location would keep it within
    /// the playable area.
    func isWithinPlayableArea(_ location: CGPoint, _ geometry: GeometryProxy) -> Bool {
        let rawHeight = geometry.size.height * Utility.TOP_HEIGHT_MODIFIER
        let adjustedHeight = rawHeight - radius

        let rawWidth = geometry.size.width
        let adjustedWidth = rawWidth - radius

        /* Using the peg radius as the bounds ensures that the peg always stays
           entirely within the playable area */
        let isValidHorizontalBounds = location.x > radius && location.x < adjustedWidth
        let isValidVerticalBounds = location.y > radius && location.y < adjustedHeight

        return isValidVerticalBounds && isValidHorizontalBounds
    }

    /// Returns true if placing a peg at the input location would overlap with
    /// any existing pegs.
    func isOverlapping(_ location: CGPoint) -> Bool {
        let overlapping = pegs.contains { existingPeg in
            let distance = distanceBetween(peg: existingPeg, point: location)

            /* Check if the new peg overlaps any existing peg. A multiple of the radius is
               used as the collision distance is calculated by taking the difference in the
               distance between the centers of 2 pegs. */
            return distance <= (2 * radius)
        }
        return overlapping
    }

    /// Returns true if moving a peg to the input location would overlap with
    /// any existing pegs, excluding itself.
    func isOverlappingExclusively(_ location: CGPoint, index: Int) -> Bool {
        let overlapping = pegs.contains { existingPeg in
            let distance = distanceBetween(peg: existingPeg, point: location)
            let isSamePeg = existingPeg.id == pegs[index].id

            return distance <= (2 * radius) && !isSamePeg
        }
        return overlapping
    }

    /// Returns the distance between a point and (the center of) a Peg
    func distanceBetween(peg: Peg, point: CGPoint) -> CGFloat {
        sqrt(pow(peg.centerPosition.x - point.x, 2) + pow(peg.centerPosition.y - point.y, 2))
    }

}
