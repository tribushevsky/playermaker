//
//  Signal+Extensions.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 30/07/2025.
//

import RxSwift
import RxCocoa

extension Signal {

	public func asDriverOnErrorJustComplete() -> Driver<Element> {
		asDriver { error in
			Driver.empty()
		}
	}

	public func asDriverOnErrorDoNothing() -> Driver<Element> {
		asDriver { error in
			Driver.never()
		}
	}

}
