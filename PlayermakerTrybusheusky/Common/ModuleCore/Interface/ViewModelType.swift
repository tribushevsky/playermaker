//
//  ViewModelType.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 30/07/2025.
//

public protocol ViewModelType {

	associatedtype In
	associatedtype Out

	func transform(input: In) -> Out

}
