//
//  ReviewManager.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2022-04-11.
//  Copyright © 2022 Anthony Hopkins. All rights reserved.
//
//  Referenced: https://www.raywenderlich.com/9009-requesting-app-ratings-and-reviews-tutorial-for-ios
//

import Foundation
import StoreKit

class ReviewManager {

    static let minimumReviewWorthyActionCount = 2
    
    static let reviewCountKey = "ReviewWorthyActionCount"
    static let reviewRequestVersionKey = "LastVersionReviewRequested"

    static func requestReviewIfAppropriate() {
      let defaults = UserDefaults.standard
      let bundle = Bundle.main

      var actionCount = defaults.integer(forKey: reviewCountKey)

      actionCount += 1

      defaults.set(actionCount, forKey: reviewCountKey)

      guard actionCount >= minimumReviewWorthyActionCount else {
        return
      }

      let bundleVersionKey = kCFBundleVersionKey as String
      let currentVersion = bundle.object(forInfoDictionaryKey: bundleVersionKey) as? String
      let lastVersion = defaults.string(forKey: reviewRequestVersionKey)

      guard lastVersion == nil || lastVersion != currentVersion else {
        return
      }

      SKStoreReviewController.requestReview()

      defaults.set(0, forKey: reviewCountKey)
      defaults.set(currentVersion, forKey: reviewRequestVersionKey)
    }

}
