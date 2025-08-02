//
//  UIWindow+Rx.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 30/07/2025.
//

import UIKit
import RxSwift

extension Reactive where Base: UIWindow {

	var makeKeyAndVisible: Observable<Void> {
		return sentMessage(#selector(UIWindow.makeKeyAndVisible)).mapToVoid()
	}

	func setRootViewController(
		_ viewController: UIViewController,
		animated: Bool,
		duration: TimeInterval = 0,
		options: UIView.AnimationOptions = []
	) -> Observable<Void> {
		guard !base.isKeyWindow || base.isHidden else {
			base.rootViewController = viewController

			guard animated else {
				return Observable.just(Void())
			}

			return Observable.create { observer in
				UIView.transition(
					with: base,
					duration: duration,
					options: options
				) {
					observer.onNext(Void())
				}

				return Disposables.create()
			}
		}

		return makeKeyAndVisible.take(1).flatMapLatest { _ in
			base.rootViewController = viewController

			guard animated else {
				return Observable.just(Void())
			}

			return Observable.create { observer in
				UIView.transition(
					with: base,
					duration: duration,
					options: options
				) {
					observer.onNext(Void())
				}

				return Disposables.create()
			}
		}
	}

}
