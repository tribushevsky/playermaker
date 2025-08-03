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
  internal enum DeviceInfo {
    /// Name:
    internal static let nameTitle = L10n.tr("Localizable", "device_info.name_title", fallback: "Name:")
    /// Save
    internal static let save = L10n.tr("Localizable", "device_info.save", fallback: "Save")
    /// Device info
    internal static let title = L10n.tr("Localizable", "device_info.title", fallback: "Device info")
    /// UUID:
    internal static let uuidTitle = L10n.tr("Localizable", "device_info.uuid_title", fallback: "UUID:")
  }
  internal enum Error {
    internal enum Action {
      /// Cancel
      internal static let cancel = L10n.tr("Localizable", "error.action.cancel", fallback: "Cancel")
      /// OK
      internal static let ok = L10n.tr("Localizable", "error.action.ok", fallback: "OK")
      /// Settings
      internal static let settings = L10n.tr("Localizable", "error.action.settings", fallback: "Settings")
    }
    internal enum Bluetooth {
      internal enum Message {
        /// Please, try later!
        internal static let general = L10n.tr("Localizable", "error.bluetooth.message.general", fallback: "Please, try later!")
        /// Turn on Bluetooth in the Settings/Bluetooth
        internal static let turnedOff = L10n.tr("Localizable", "error.bluetooth.message.turned_off", fallback: "Turn on Bluetooth in the Settings/Bluetooth")
        /// Allow Bluetooth access in the PlayermakerTrybusheusky app's settings
        internal static let unauthorized = L10n.tr("Localizable", "error.bluetooth.message.unauthorized", fallback: "Allow Bluetooth access in the PlayermakerTrybusheusky app's settings")
      }
      internal enum Title {
        /// Something went wrong
        internal static let general = L10n.tr("Localizable", "error.bluetooth.title.general", fallback: "Something went wrong")
        /// Bluetooth Turned Off
        internal static let turnedOff = L10n.tr("Localizable", "error.bluetooth.title.turned_off", fallback: "Bluetooth Turned Off")
        /// Bluetooth permissions not granted
        internal static let unauthorized = L10n.tr("Localizable", "error.bluetooth.title.unauthorized", fallback: "Bluetooth permissions not granted")
      }
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
    internal enum Item {
      /// Unknown Name
      internal static let unknownName = L10n.tr("Localizable", "favorites_list.item.unknown_name", fallback: "Unknown Name")
    }
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
    internal enum Item {
      /// RSSI
      internal static let rssiTitle = L10n.tr("Localizable", "search_devices.item.rssi_title", fallback: "RSSI")
      /// Unknown Name
      internal static let unknownName = L10n.tr("Localizable", "search_devices.item.unknown_name", fallback: "Unknown Name")
    }
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
