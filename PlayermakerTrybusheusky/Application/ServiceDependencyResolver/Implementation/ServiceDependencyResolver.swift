//
//  ServiceDependencyResolver.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 30/07/2025.
//

import Swinject

final class ServiceDependencyResolver {

	private let resolver: Resolver

	init(resolver: Resolver) {
		self.resolver = resolver
	}

}

// MARK: - ServiceDependencyResolverProtocol

extension ServiceDependencyResolver: ServiceDependencyResolverProtocol {}
