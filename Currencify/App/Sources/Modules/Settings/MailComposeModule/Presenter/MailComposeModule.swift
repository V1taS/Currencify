//
//  MailComposeModule.swift
//  Currencify
//
//  Created by Vitalii Sosin on 02.08.2024.
//  Copyright © 2024 SosinVitalii.com. All rights reserved.
//

import UIKit
import MessageUI
import SKAbstractions

final class MailComposeModule: NSObject {
  
  // MARK: - Private variables
  
  private let services: IApplicationServices
  private var mailComposeViewController: MFMailComposeViewController?
  private var finishFlow: (() -> Void)?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///  - services: Сервисы приложения
  init(_ services: IApplicationServices) {
    self.services = services
  }
  
  func canSendMail() -> Bool {
    MFMailComposeViewController.canSendMail()
  }
  
  func start(completion: (() -> Void)?) {
    finishFlow = completion
    let mailComposeViewController = MFMailComposeViewController()
    self.mailComposeViewController = mailComposeViewController
    let systemService = services.userInterfaceAndExperienceService.systemService
    let appVersion = systemService.getAppVersion()
    let systemVersion = systemService.getSystemVersion()
    let systemName = systemService.getSystemName()
    let vendorID = systemService.getDeviceIdentifier()
    let identifierForVendorText = "\(CurrencifyStrings.MailComposeModuleLocalization.Identifier.title): \(vendorID)"
    let systemVersionText = "\(CurrencifyStrings.MailComposeModuleLocalization.SystemVersion.title): \(systemName) \(systemVersion)"
    let appVersionText = "\(CurrencifyStrings.MailComposeModuleLocalization.AppVersion.title): \(appVersion)"
    let messageBody = """


      \(identifierForVendorText)
      \(systemVersionText)
      \(appVersionText)
"""
    
    mailComposeViewController.mailComposeDelegate = self
    mailComposeViewController.setToRecipients([Secrets.supportMail])
    mailComposeViewController.setSubject(CurrencifyStrings.MailComposeModuleLocalization.Subject.title)
    mailComposeViewController.setMessageBody(messageBody, isHTML: false)
    UIViewController.topController?.present(mailComposeViewController, animated: true)
  }
}

// MARK: - MFMailComposeViewControllerDelegate

extension MailComposeModule: MFMailComposeViewControllerDelegate {
  func mailComposeController(_ controller: MFMailComposeViewController,
                             didFinishWith result: MFMailComposeResult,
                             error: Error?) {
    mailComposeViewController?.dismiss(
      animated: true,
      completion: { [weak self] in
        self?.finishFlow?()
        self?.mailComposeViewController = nil
      }
    )
  }
}