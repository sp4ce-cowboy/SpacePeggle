//
//  BucketView.swift
//  SpacePeggle
//
//  Created by Rubesh on 27/2/24.
//

import SwiftUI

struct BucketView: View {
    @State private var moveLeft = false

    var body: some View {
        // The bucket image
        Image("bucket")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 200)
            // Position is dynamically changed based on moveLeft state
            .position(x: moveLeft ? 100 : UIScreen.main.bounds.width - 100,
                      y: UIScreen.main.bounds.height - 130)
            .onAppear {
                // Trigger the animation when the view appears
                withAnimation(Animation
                    .linear(duration: 2)
                    .repeatForever(autoreverses: true)) {
                    moveLeft.toggle()
                }
            }
    }
}

#Preview {
    BucketView()
}
