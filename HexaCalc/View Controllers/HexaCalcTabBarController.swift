//
//  HexaCalcTabBarController.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2025-02-26.
//  Copyright © 2025 Anthony Hopkins. All rights reserved.
//

import UIKit

class HexaCalcTabBarController: UITabBarController, StateControllerProtocol {

    // All VCs in storyboard order: Hex=0, Binary=1, Decimal=2, Settings=3
    private var allViewControllers: [UIViewController] = []
    private var enabledStates: [Bool] = [true, true, true, true]
    var stateController: StateController?

    func setState(state: StateController) {
        stateController = state
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 17.0, *) {
            traitOverrides.horizontalSizeClass = .compact
        }

        // Capture the full VC list before any tabs are removed
        allViewControllers = viewControllers ?? []

        guard let savedPreferences = DataPersistence.loadPreferences() else { return }

        // Populate shared state so all child VCs have it when their viewDidLoad runs
        stateController?.convValues.setCalculatorTextColour = savedPreferences.setCalculatorTextColour
        stateController?.convValues.colour = savedPreferences.colour
        stateController?.convValues.copyActionIndex = savedPreferences.copyActionIndex
        stateController?.convValues.pasteActionIndex = savedPreferences.pasteActionIndex
        stateController?.convValues.historyButtonViewIndex = savedPreferences.historyButtonViewIndex
        stateController?.convValues.historyEnabled = savedPreferences.historyEnabled
        stateController?.convValues.defaultTabIndex = savedPreferences.defaultTabIndex

        TelemetryManager.sharedTelemetryManager.userDisabled = !savedPreferences.telemetryEnabled

        // Remove disabled tabs before any child VC loads (avoids mutating viewControllers
        // from within a child VC's own viewDidLoad, which crashes on iOS 26+)
        if !savedPreferences.hexTabState { setTab(0, enabled: false) }
        if !savedPreferences.binTabState { setTab(1, enabled: false) }
        if !savedPreferences.decTabState { setTab(2, enabled: false) }

        // Honor the user's default tab preference
        let defaultIndex = Int(savedPreferences.defaultTabIndex)
        if defaultIndex < allViewControllers.count, defaultIndex != 3 {
            let targetVC = allViewControllers[defaultIndex]
            if let newIndex = viewControllers?.firstIndex(of: targetVC) {
                selectedIndex = newIndex
            }
        }
    }

    // Enable or disable a tab by its original storyboard index.
    func setTab(_ index: Int, enabled: Bool) {
        guard index < enabledStates.count else { return }

        // At runtime: if the currently active tab is being disabled, switch away first
        if !enabled,
           let current = selectedViewController,
           index < allViewControllers.count,
           current == allViewControllers[index] {
            let nextVC = allViewControllers.enumerated()
                .first { $0.offset != index && enabledStates[$0.offset] }?.element
            if let nextVC = nextVC {
                selectedViewController = nextVC
            }
        }

        enabledStates[index] = enabled
        viewControllers = allViewControllers.enumerated()
            .filter { enabledStates[$0.offset] }
            .map { $0.element }
    }
}
