//
//  CountryRow.swift
//  TestAppCountries
//
//  Created by Aleksandr Ataev on 06.12.2024.
//

import SwiftUI

struct CountryRow: View {
    let country: Country

    @State private var cachedFlag: UIImage?
    @State private var isShowingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        HStack(alignment: .center, spacing: Constant.spacing) {
            // Флаг страны
            flag

            // Название страны и регион
            countryAndRegion
        }
        .padding()
        .background(Color.gray.opacity(Constant.opacity))
        .cornerRadius(Constant.cornerRadius)
        .overlay {
            RoundedRectangle(cornerRadius: Constant.cornerRadius)
                .strokeBorder(
                    Color.gray.opacity(Constant.borderOpacity),
                    lineWidth: Constant.lineWidth
                )
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text("Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    //MARK: - Functions
    private func loadFlagAsync() {
        guard let url = URL(string: country.flags.png) else {
            if !isShowingAlert {
                alertMessage = "Invalid URL for the country flag."
                isShowingAlert = true
            }
            return
        }

        if let cachedImage = SVGCache.shared.object(forKey: url as NSURL) {
            self.cachedFlag = cachedImage
            return
        }

        let diskCache = DiskCache()
        if let diskImage = diskCache.loadImage(forKey: url.absoluteString) {
            self.cachedFlag = diskImage
            SVGCache.shared.setObject(diskImage, forKey: url as NSURL)
            return
        }

        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    diskCache.saveImage(image, forKey: url.absoluteString)
                    SVGCache.shared.setObject(image, forKey: url as NSURL)

                    DispatchQueue.main.async {
                        self.cachedFlag = image
                    }
                } else {
                    DispatchQueue.main.async {
                        if !self.isShowingAlert {
                            alertMessage = "Failed to decode image."
                            isShowingAlert = true
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    if !self.isShowingAlert {
                        if (error as? URLError) != nil {
                            alertMessage = "No internet connection."
                        } else {
                            alertMessage = "Failed to load data from the server."
                        }
                        isShowingAlert = true
                    }
                }
            }
        }
    }

    //MARK: - Components
    private var flag: some View {
        VStack {
            if let cachedFlag = cachedFlag {
                Image(uiImage: cachedFlag)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: Constant.Image.size.width,
                        height: Constant.Image.size.height
                    )
                    .shadow(
                        color: .primary.opacity(Constant.Image.opacity),
                        radius: Constant.Image.shadowRadius
                    )
            } else {
                ProgressView()
                    .frame(
                        width: Constant.Image.size.width,
                        height: Constant.Image.size.height
                    )
                    .onAppear {
                        loadFlagAsync()
                    }
            }
        }
    }

    private var countryAndRegion: some View {
        VStack(alignment: .leading, spacing: Constant.intent) {
            Text(country.localizedCommonName)
                .font(.headline)
                .foregroundColor(.primary)

            Text(country.region.rawValue)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    //MARK: - Constants
    private struct Constant {
        struct Image {
            static let shadowRadius: CGFloat = 5
            static let opacity: CGFloat = 0.5
            static let size: CGSize = CGSize(width: 100, height: 60)
        }

        static let spacing: CGFloat = 16
        static let opacity: CGFloat = 0.2
        static let cornerRadius: CGFloat = 12
        static let borderOpacity: CGFloat = 0.3
        static let lineWidth: CGFloat = 1
        static let intent: CGFloat = 8
    }
}
