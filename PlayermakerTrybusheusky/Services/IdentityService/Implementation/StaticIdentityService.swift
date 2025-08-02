//
//  StaticIdentityService.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 31/07/2025.
//

final class StaticIdentityService {}

extension StaticIdentityService: IdentityServiceProtocol {

	var developerName: String {
		L10n.Identity.developerName
	}

}
