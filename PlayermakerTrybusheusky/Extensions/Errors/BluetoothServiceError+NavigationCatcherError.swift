//
//  BluetoothServiceError+NavigationCatcherError.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 03/08/2025.
//

import UIKit

extension BluetoothServiceError: NavigationCatcherError {

	var title: String? {
		typealias Loc = L10n.Error.Bluetooth.Title
		switch self {
		case .bluetoothOff:
			return Loc.turnedOff
		case .unauthorized:
			return Loc.unauthorized
		case .unknownState:
			return Loc.general
		}
	}

	var message: String? {
		typealias Loc = L10n.Error.Bluetooth.Message
		switch self {
		case .bluetoothOff:
			return Loc.turnedOff
		case .unauthorized:
			return Loc.unauthorized
		case .unknownState:
			return Loc.general
		}
	}

	var style: UIAlertController.Style {
		.alert
	}

	var actions: [NavigationCatcherAction] {
		typealias Loc = L10n.Error.Action
		switch self {
		case .unauthorized:
			return [
				NavigationCatcherAction(title: Loc.settings, style: .action),
				NavigationCatcherAction(title: Loc.cancel, style: .cancel)
			]
		case .bluetoothOff,
				.unknownState:
			return [
				NavigationCatcherAction(title: Loc.ok, style: .ok)
			]
		}
	}

}
