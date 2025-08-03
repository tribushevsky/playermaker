//
//  RealmFavoriteDeviceModel.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 02/08/2025.
//

import Foundation
import RealmSwift

class RealmFavoriteDeviceModel: Object {

	@objc dynamic var uuid: String
	@objc dynamic var name: String?

	init(model: FavoriteDeviceModel) {
		self.uuid = model.uuid
		self.name = model.name
	}

	override init() {
		self.uuid = ""
		self.name = nil
	}

	override static func primaryKey() -> String? {
	  return "uuid"
	}

}

// MARK: Modification

extension RealmFavoriteDeviceModel {

	func update(by model: FavoriteDeviceModel) {
		name = model.name
	}

}
