//
//  RootDependencies.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

final class RootDependencies: RootDependenciesProtocol {

	let identityService: IdentityServiceProtocol

	init(identityService: IdentityServiceProtocol) {
		self.identityService = identityService
	}

}
