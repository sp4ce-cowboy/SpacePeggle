import SwiftUI

/// This extension adds the checkRepresentation method to the LevelViewModel.
/// Since the LevelViewModel encapsulates information about the pegs on the current
/// game board, this seemed like the most appropriate class to add the checkRepresentation
/// extension to.
///
/// Representation Invariants:
/// - Pegs cannot go out-of-bound of the Game area or overlap UI elements
/// - Pegs should not overlap other pegs in their final position (i.e. not while dragging)
extension LevelViewModel {

    /// Checks that all pegs are within the playable area and do not overlap with each other.
    func checkRepresentation(_ geometry: GeometryProxy) -> Bool {

        // Check that all pegs are within the playable area.
        let allPegsWithinPlayableArea = pegs.allSatisfy { peg in
            isWithinPlayableArea(peg.centerPosition, geometry)
        }

        // Check that no pegs overlap with each other.
        let noPegsOverlap = checkRepresentationWithoutGeometry(pegs)

        // Return true only if all pegs are within the playable area and no pegs overlap.
        return allPegsWithinPlayableArea && noPegsOverlap
    }

    /// Checks that all pegs do not overlap without relying on the current geometry
    func checkRepresentationWithoutGeometry(_ pegs: [Peg]) -> Bool {
        let noPegsOverlap = !pegs.indices.contains { index in
            let peg = pegs[index]

            // Exclude the current peg when checking for overlapping pegs.
            let remainingPegs = pegs.enumerated().filter { $0.offset != index }.map { $0.element }
            return remainingPegs.contains { isOverlappingWith(existingPeg: $0, currentPeg: peg) }
        }

        // Return true only if no pegs overlap.
        return noPegsOverlap
    }

    /// Helper function to determine if a peg is overlapping with another.
    private func isOverlappingWith(existingPeg: Peg, currentPeg: Peg) -> Bool {
        let distance = distanceBetween(peg: existingPeg, point: currentPeg.centerPosition)
        return distance <= 2 * radius
    }

}
