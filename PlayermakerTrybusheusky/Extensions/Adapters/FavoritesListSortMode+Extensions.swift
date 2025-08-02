//
//  FavoritesListSortMode+Extensions.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 02/08/2025.
//

extension FavoritesListSortMode {

	var sortCriterion: FavoriteDeviceSortCriterion {
		switch self {
		case .name: .name
		case .uuid: .uuid
		}
	}

}
