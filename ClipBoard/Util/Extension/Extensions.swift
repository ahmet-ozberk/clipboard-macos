//
//  Extensions.swift
//  ClipBoard
//
//  Created by Ahmet OZBERK on 10.03.2025.
//

import SwiftUI
import SwiftUICore

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

extension View {
    @ViewBuilder
    func onThemeChange(perform action: @escaping (Bool) -> Void) -> some View {
        self.modifier(ThemeChangeModifier(action: action))
    }

    func bindThemeState(to isDarkMode: Binding<Bool>) -> some View {
        self.onThemeChange { scheme in
            isDarkMode.wrappedValue = scheme
        }
    }

    func dynamicBackground() -> some View {
        self.modifier(DynamicBackgroundModifier())
    }
}

struct ThemeChangeModifier: ViewModifier {
    let action: (Bool) -> Void
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content
            .onAppear {
                action(colorScheme == .dark)
            }
            .onChange(of: colorScheme) { oldValue, newValue in
                action(newValue == .dark)
            }
    }
}

struct DynamicBackgroundModifier: ViewModifier {
    @State private var isDarkMode: Bool = false
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content
            .background(
                isDarkMode
                    ? AppColors.backgroundDark : AppColors.backgroundLight
            )
            .onThemeChange { theme in
                self.isDarkMode = theme
            }
    }
}
