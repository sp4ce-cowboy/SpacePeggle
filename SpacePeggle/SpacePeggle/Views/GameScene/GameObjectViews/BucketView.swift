//
//  BucketView.swift
//  SpacePeggle
//
//  Created by Rubesh on 27/2/24.
//

import SwiftUI

struct BucketView: View {
    @EnvironmentObject var viewModel: GameSceneViewModel

    var bucket: Bucket { viewModel.bucket }
    var center: Vector { bucket.centerPosition }
    var imageName: String { viewModel.bucketImage }

    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(viewModel.bucketImageAspectRatio, contentMode: .fit)
            .frame(width: bucket.width, height: bucket.height)
            .position(center.point)
            .onAppear {
                Logger.log("BucketCenter is \(bucket.centerPosition)")
            }
    }
}
