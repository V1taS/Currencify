//
//  ImageViewerView.swift
//  Currencify
//
//  Created by Vitalii Sosin on 16.09.2024.
//

import SKStyle
import SKUIKit
import SwiftUI
import SKAbstractions

struct ImageViewerView: View {
  
  // MARK: - Internal properties
  
  @StateObject
  var presenter: ImageViewerPresenter
  
  // MARK: - Body
  
  var body: some View {
    VStack {
      ScrollView(.vertical, showsIndicators: false) {
        if let finalImage = presenter.finalImage {
          Image(uiImage: finalImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
        }
      }
      
      MainButtonView(
        text: CurrencifyStrings.ImageViewerLocalization
          .Notifications.Button.title,
        action: {
          Task {
            await presenter.saveImageToGallery()
          }
        }
      )
      .padding(.all, .s4)
    }
  }
}

// MARK: - Private

private extension ImageViewerView {}

// MARK: - Preview

struct ImageViewerView_Previews: PreviewProvider {
  static var previews: some View {
    UIViewControllerPreview {
      ImageViewerAssembly().createModule(
        image: nil,
        services: ApplicationServicesStub()
      ).viewController
    }
  }
}
