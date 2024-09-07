//
//  MainScreenView.swift
//  CurrencyCore
//
//  Created by Vitalii Sosin on 07.09.2024.
//

import SKStyle
import SKUIKit
import SwiftUI

struct MainScreenView: View {
  
  // MARK: - Internal properties
  
  @StateObject
  var presenter: MainScreenPresenter
  
  // MARK: - Body
  
  var body: some View {
    VStack {
      Spacer()
      Text("snvjhwenvker")
      Spacer()
    }
  }
}

// MARK: - Private

private extension MainScreenView {}

// MARK: - Preview

struct MainScreenView_Previews: PreviewProvider {
  static var previews: some View {
    UIViewControllerPreview {
      MainScreenAssembly().createModule().viewController
    }
  }
}
