//
//  SearchDevicesViewModelError.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 03/08/2025.
//

import Foundation

enum SearchDevicesViewModelError: LocalizedError {

	case objectNotFound

	var localizedDescription: String {
		switch self {
		case .objectNotFound:
			L10n.Error.SearchDevices.NotFound.title
		}
	}

	var recoverySuggestion: String? {
		switch self {
		case .objectNotFound:
			L10n.Error.SearchDevices.NotFound.message
		}
	}

}
