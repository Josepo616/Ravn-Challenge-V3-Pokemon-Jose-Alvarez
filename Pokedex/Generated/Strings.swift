// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Implementation Details

internal enum L10n {
    static func tr(_ table: String, _ key: String, fallback value: String, language: Languages) -> String {
        let locale = Locale(identifier: language.localeIdentifier)
        let format = Bundle.main.localizedString(forKey: key, value: value, table: table)
        return String(format: format, locale: locale)
    }
}
// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
