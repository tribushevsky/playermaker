//
//  OptionalType.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 31/07/2025.
//

protocol OptionalType {

	associatedtype Wrapped
	var asOptional:  Wrapped? { get }

}

extension Optional: OptionalType {

	var asOptional: Wrapped? { return self }

}

