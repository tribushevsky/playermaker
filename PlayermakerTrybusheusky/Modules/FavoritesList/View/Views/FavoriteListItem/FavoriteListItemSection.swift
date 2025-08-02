//
//  FavoriteListItemSection.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 02/08/2025.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct FavoriteListItemSection {

	var items: [FavoriteListItemViewModel]

}

extension FavoriteListItemSection: AnimatableSectionModelType {

	var identity: some Hashable {
		""
	}

	init(original: FavoriteListItemSection, items: [FavoriteListItemViewModel]) {
		self = original
		self.items = items
	}

}

extension FavoriteListItemViewModel: IdentifiableType, Equatable {

	var identity: some Hashable {
		title + subtitle
	}


	static func == (lhs: FavoriteListItemViewModel, rhs: FavoriteListItemViewModel) -> Bool {
		lhs.title == rhs.title &&
		lhs.subtitle == rhs.subtitle
	}

}
