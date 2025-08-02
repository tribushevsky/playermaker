// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Delete {
    internal enum Sure {
      /// Delete
      internal static let action = L10n.tr("Localizable", "delete.sure.action", fallback: "Delete")
      /// Cancel
      internal static let cancel = L10n.tr("Localizable", "delete.sure.cancel", fallback: "Cancel")
      /// ARE YOU SURE?
      internal static let title = L10n.tr("Localizable", "delete.sure.title", fallback: "ARE YOU SURE?")
    }
  }
  internal enum Error {
    internal enum Action {
      /// OK
      internal static let ok = L10n.tr("Localizable", "error.action.ok", fallback: "OK")
    }
    internal enum SomethingWentWrong {
      internal enum TryLater {
        /// Please, try later!
        internal static let message = L10n.tr("Localizable", "error.something_went_wrong.try_later.message", fallback: "Please, try later!")
        /// Something went wrong
        internal static let title = L10n.tr("Localizable", "error.something_went_wrong.try_later.title", fallback: "Something went wrong")
      }
    }
  }
  internal enum FavoritesList {
    /// Add New Devices
    internal static let mainButton = L10n.tr("Localizable", "favorites_list.main_button", fallback: "Add New Devices")
    /// Not found
    internal static let placeholder = L10n.tr("Localizable", "favorites_list.placeholder", fallback: "Not found")
    /// Favorite Devices
    internal static let title = L10n.tr("Localizable", "favorites_list.title", fallback: "Favorite Devices")
    internal enum Sort {
      /// Name
      internal static let name = L10n.tr("Localizable", "favorites_list.sort.name", fallback: "Name")
      /// UUID
      internal static let uuid = L10n.tr("Localizable", "favorites_list.sort.uuid", fallback: "UUID")
    }
  }
  internal enum Identity {
    /// Localizable.strings
    ///   PlayermakerTrybusheusky
    /// 
    ///   Created by Uladzimir Trybusheusky on 30/07/2025.
    internal static let developerName = L10n.tr("Localizable", "identity.developer_name", fallback: "Vladimir Tribushevsky")
  }
  internal enum SearchDevices {
    /// Search Devices...
    internal static let title = L10n.tr("Localizable", "search_devices.title", fallback: "Search Devices...")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
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
