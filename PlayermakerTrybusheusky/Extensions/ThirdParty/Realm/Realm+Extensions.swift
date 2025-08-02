//
//  Realm+Extensions.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 02/08/2025.
//

import RealmSwift

extension Realm {

	/// Performs actions contained within the given block
	/// inside a write transaction with completion block.
	///
	/// - parameter block: write transaction block
	/// - parameter completion: completion executed after transaction block
	func write(transaction block: () -> Void, completion: (() -> Void)?) throws {
		try write(block)
		completion?()
	}

}
