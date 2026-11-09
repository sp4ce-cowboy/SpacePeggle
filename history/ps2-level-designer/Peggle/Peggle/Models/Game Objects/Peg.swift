import SwiftUI

/// This struct is the Model of the Peg.
struct Peg: CodableGameObject {
    let id: UUID
    var centerPosition: CGPoint
    var color: PegColor.RawValue

    /// Custom CodingKeys to handle encoding
    enum CodingKeys: String, CodingKey {
        case id, centerPositionX, centerPositionY, color
    }

    init(centerPosition: CGPoint, color: PegColor, id: UUID) {
        self.centerPosition = centerPosition
        self.color = color.rawValue
        self.id = id
    }

    init(centerPosition: CGPoint, color: PegColor) {
        self.init(centerPosition: centerPosition, color: color, id: UUID())
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let x = try container.decode(CGFloat.self, forKey: .centerPositionX)
        let y = try container.decode(CGFloat.self, forKey: .centerPositionY)
        let color = try container.decode(String.self, forKey: .color)

        self.init(centerPosition: CGPoint(x: x, y: y),
                  color: PegColor(rawValue: color) ?? PegColor.defaultColor, id: id)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(centerPosition.x, forKey: .centerPositionX)
        try container.encode(centerPosition.y, forKey: .centerPositionY)
        try container.encode(color, forKey: .color)
    }

    /// Given an input position and an array of Pegs, this function determines if the array
    /// contains a peg at a that position and returns that Peg if it does and nil otherwise
    static func containsPeg(pegs: [Peg], containsPegAt point: CGPoint) -> Peg? {

        if let index = pegs.firstIndex(where: { peg in
            let distance = sqrt(pow(peg.centerPosition.x - point.x, 2) +
                                pow(peg.centerPosition.y - point.y, 2))
            return distance <= Utility.UNIVERSAL_PEG_DIAMETER / 2 // Check if the point is within the peg's radius
        }) {
            return pegs[index]
        }

        return nil
    }

}
