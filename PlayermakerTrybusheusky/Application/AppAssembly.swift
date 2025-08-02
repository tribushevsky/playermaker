//
//  AppAssembly.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

import Foundation
import Swinject

final class AppAssembly {

	private let assembler: Assembler = Assembler()

	var navigationDependencyResolver: NavigationDependencyResolver {
		assembler.resolver.resolve(NavigationDependencyResolver.self)!
	}

	var serviceDependencyResolver: ServiceDependencyResolverProtocol {
		assembler.resolver.resolve(ServiceDependencyResolverProtocol.self)!
	}

	func launch() {
		assembler.apply(
			assemblies: [
				NavigationDependencyResolverAssembly(),
				ServiceDependencyResolverAssembly()
			]
		)
	}

}
