//
//  SVGImageView.swift
//  TestAppCountries
//
//  Created by Aleksandr Ataev on 06.12.2024.
//

import SwiftUI
import SVGKit

final class SVGCache {
    static let shared = NSCache<NSURL, UIImage>()
}

struct SVGImageView: View {
    let url: URL

    @State private var uiImage: UIImage?
    @State private var isShowingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        Group {
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 250, height: 250)
            } else {
                ProgressView()
                    .padding()
                    .onAppear {
                        loadSVGAsync()
                    }
            }
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text("Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func loadSVGAsync() {
        if let cachedImage = SVGCache.shared.object(forKey: url as NSURL) {
            self.uiImage = cachedImage
            return
        }

        let diskCache = DiskCache()
        if let diskImage = diskCache.loadImage(forKey: url.absoluteString) {
            self.uiImage = diskImage
            SVGCache.shared.setObject(diskImage, forKey: url as NSURL)
            return
        }

        DispatchQueue.global(qos: .background).async {
            do {
                if let svg = SVGKImage(contentsOf: url), let renderedImage = svg.uiImage {
                    diskCache.saveImage(renderedImage, forKey: self.url.absoluteString)
                    SVGCache.shared.setObject(renderedImage, forKey: self.url as NSURL)
                    
                    DispatchQueue.main.async {
                        self.uiImage = renderedImage
                    }
                } else {
                    throw NetworkError.unknownError("Failed to render SVG image.")
                }
            } catch {
                DispatchQueue.main.async {
                    if (error as? URLError) != nil {
                        alertMessage = "No internet connection."
                    } else {
                        alertMessage = error.localizedDescription
                    }
                    isShowingAlert = true
                }
            }
        }
    }
}
