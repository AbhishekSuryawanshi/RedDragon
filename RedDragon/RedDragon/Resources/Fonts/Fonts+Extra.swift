//
//  Fonts+Extra.swift
//  RedDragon
//
//  Created by Qasr01 on 24/10/2023.
//

import UIKit

fileprivate let appFontName = "Roboto"

struct Fonts {
    static let fontBlack       = "\(appFontName)-Black"
    static let fontBold        = "\(appFontName)-Bold"
    static let fontMedium      = "\(appFontName)-Medium"
    static let fontRegular     = "\(appFontName)-Regular"
    static let fontLight       = "\(appFontName)-Light"
    static let fontThin        = "\(appFontName)-Thin"
}

func fontRegular(_ size: CGFloat) -> UIFont {
    let font = UIFont(name: Fonts.fontRegular, size: size) ?? UIFont.systemFont(ofSize: size)
    return font
}
func fontMedium(_ size: CGFloat) -> UIFont {
    let font = UIFont(name: Fonts.fontMedium, size: size) ?? UIFont.systemFont(ofSize: size)
    return font
}
func fontBold(_ size: CGFloat) -> UIFont {
    let font = UIFont(name: Fonts.fontBold, size: size) ?? UIFont.boldSystemFont(ofSize: size)
    return font
}
func fontBlack(_ size: CGFloat) -> UIFont {
    let font = UIFont(name: Fonts.fontBlack, size: size) ?? UIFont.boldSystemFont(ofSize: size)
    return font
}
