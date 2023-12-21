//
//  Fonts+Extra.swift
//  RedDragon
//
//  Created by Qasr01 on 24/10/2023.
//

import UIKit

fileprivate let appFontName = "GillSans"

/*
 GillSans
 GillSans-Bold
 GillSans-BoldItalic
 GillSans-Italic
 GillSans-Light
 GillSans-LightItalic
 GillSans-SemiBold
 GillSans-SemiBoldItalic
 GillSans-UltraBold
 */

struct Fonts {
    static let fontBold        = "\(appFontName)-Bold"
    static let fontSemiBold    = "\(appFontName)-SemiBold"
    static let fontRegular     = "\(appFontName)"
    static let fontLight       = "\(appFontName)-Light"
}

func fontLight(_ size: CGFloat) -> UIFont {
    let font = UIFont(name: Fonts.fontLight, size: size) ?? UIFont.systemFont(ofSize: size)
    return font
}
func fontRegular(_ size: CGFloat) -> UIFont {
    let font = UIFont(name: Fonts.fontRegular, size: size) ?? UIFont.systemFont(ofSize: size)
    return font
}
func fontSemiBold(_ size: CGFloat) -> UIFont {
    let font = UIFont(name: Fonts.fontSemiBold, size: size) ?? UIFont.boldSystemFont(ofSize: size)
    return font
}
func fontBold(_ size: CGFloat) -> UIFont {
    let font = UIFont(name: Fonts.fontBold, size: size) ?? UIFont.boldSystemFont(ofSize: size)
    return font
}
