//
//  SwiftUIView.swift
//  PeggleGameplay
//
//  Created by Rubesh on 17/2/24.
//

import SwiftUI

/// A View of a Peg
struct PegView {
    static let DIAMETER: CGFloat = Constants.UNIVERSAL_LENGTH
    var peg: Peg
    var pegImageName: String {
        let pegType = peg.gameObjectType
        return ObjectSet.defaultGameObjectSet[pegType]?.name ??
        ObjectSet.DEFAULT_IMAGE_STUB
    }

    var body: some View {
        Image(pegImageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: PegView.DIAMETER, height: PegView.DIAMETER)
            .position(peg.centerPosition.point)

    }
}
