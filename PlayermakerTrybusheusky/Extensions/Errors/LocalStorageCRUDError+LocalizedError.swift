//
//  LocalStorageCRUDError+LocalizedError.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 02/08/2025.
//

import Foundation

extension LocalStorageCRUDError: LocalizedError {

	var localizedDescription: String {
		switch self {
		case .objectNotFound:
			L10n.Error.SomethingWentWrong.TryLater.title
		}
	}

	var recoverySuggestion: String? {
		switch self {
		case .objectNotFound:
			L10n.Error.SomethingWentWrong.TryLater.message
		}
	}

}
