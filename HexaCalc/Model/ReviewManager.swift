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

// Class to manage interactions with HexaCalc reviewing
class ReviewManager {

    static let minimumReviewWorthyActionCount = 3

    static let reviewCountKey = "ReviewWorthyActionCount"
    static let reviewRequestVersionKey = "LastVersionReviewRequested"
    static let completedCalculationKey = "HasCompletedCalculation"

    static let productURLString = "https://apps.apple.com/app/id1529225315"

    static func incrementReviewWorthyCount() {
        let defaults = UserDefaults.standard

        var actionCount = defaults.integer(forKey: reviewCountKey)

        if actionCount < 3 {
            actionCount += 1
            defaults.set(actionCount, forKey: reviewCountKey)
        }
    }

    static func completedCalculation() {
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: completedCalculationKey) {
            defaults.set(true, forKey: completedCalculationKey)
        }
    }

    // Returns true and commits side effects (reset count, record version) when a
    // review prompt should be shown. Callers are responsible for the actual
    // SKStoreReviewController call so UIKit stays out of this model file.
    static func requestReviewIfAppropriate() -> Bool {
        let defaults = UserDefaults.standard
        let bundle = Bundle.main

        guard defaults.bool(forKey: completedCalculationKey) else {
            return false
        }

        let actionCount = defaults.integer(forKey: reviewCountKey)

        guard actionCount >= minimumReviewWorthyActionCount else {
            return false
        }

        let bundleVersionKey = kCFBundleVersionKey as String
        let currentVersion = bundle.object(forInfoDictionaryKey: bundleVersionKey) as? String
        let lastVersion = defaults.string(forKey: reviewRequestVersionKey)

        guard lastVersion == nil || lastVersion != currentVersion else {
            return false
        }

        defaults.set(0, forKey: reviewCountKey)
        defaults.set(currentVersion, forKey: reviewRequestVersionKey)
        return true
    }
    
    static func getProductURL() -> URL {
        return NSURL(string: productURLString)! as URL
    }
    
    static func getWriteReviewURL() -> URL? {
        let productURL = getProductURL()
        
        var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)

        components?.queryItems = [
          URLQueryItem(name: "action", value: "write-review")
        ]

        guard let writeReviewURL = components?.url else {
          return nil
        }
        
        return writeReviewURL
    }
}
