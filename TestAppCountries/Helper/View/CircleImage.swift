//
//  CircleImage.swift
//  TestAppCountries
//
//  Created by Aleksandr Ataev on 06.12.2024.
//

import SwiftUI

struct CircleImage: View {
    var svgURL: URL

    var body: some View {
        SVGImageView(url: svgURL)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
    }
}
