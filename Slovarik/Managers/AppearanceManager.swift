//
//  AppAppearanceConfiguration.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 4/19/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit
import Tabman

extension String {
    
    var hexUIColor: UIColor {
        var cString = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) { cString.remove(at: cString.startIndex) }
        if ((cString.count) != 6) { return UIColor.gray }
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255,
            blue: CGFloat(rgbValue & 0x0000FF) / 255,
            alpha: CGFloat(1)
        )
    }
    
}


class AppearanceManager: Codable {
    
    private static var `default`: AppearanceManager { return AppearanceManager() }
    private(set) static var recovered: AppearanceManager = {
        guard let data = UserDefaults.standard.data(forKey: "recovered") else { return .default }
        do {
            return try JSONDecoder().decode(AppearanceManager.self, from: data)
        } catch {
            return .default
        }
    }()
    
    private(set) var blurContentAlpha: CGFloat = 0.6
    private(set) var gradientColors: [String] = ["#FCB045", "#FD1D1D", "#833AB4"]
    private(set) var allColors: [String] = ["#FCB045", "#FD1D1D", "#833AB4"]
    
    func saveCurrentAppearance() {
        do {
            let data = try JSONEncoder().encode(self)
            UserDefaults.standard.set(data, forKey: "recovered")
        } catch {
            fatalError()
        }
    }
    
    func setColors(gradientColors: [String], allColors: [String]) {
        self.gradientColors = gradientColors
        self.allColors = allColors
        saveCurrentAppearance()
    }

    func reloadAppearance() {
        UIApplication.shared.windows.forEach { window in
            window.subviews.forEach {
                $0.removeFromSuperview()
                window.addSubview($0)
            }
        }
    }
    
}

private extension AppearanceManager {
    
    static func applyNavigationBar() {
        let appearance = UINavigationBar.appearance()
        appearance.tintColor = UIColor.label
    }
    
}

extension AppearanceManager: P_SwizzlingInjection {
    
    static func inject() {
        applyNavigationBar()
    }
    
}
