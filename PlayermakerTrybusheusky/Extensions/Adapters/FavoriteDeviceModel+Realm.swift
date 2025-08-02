//
//  FavoriteDeviceModel+Realm.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 02/08/2025.
//

extension FavoriteDeviceModel {

	init(object: RealmFavoriteDeviceModel) {
		self.uuid = object.uuid
		self.name = object.name
	}

}
