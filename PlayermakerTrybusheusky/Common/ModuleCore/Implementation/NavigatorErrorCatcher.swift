//
//  NavigatorErrorCatcher.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 02/08/2025.
//

import Foundation
import RxSwift
import RxCocoa

class NavigatorErrorCatcher<Output>: Navigator<Output> {

	func catchAlert(error: NavigationCatcherError) -> Observable<NavigationCatcherAction> {
		Observable.create { [unowned self] observer in
			guard let navigationController = self.navigationController else {
				observer.onCompleted()
				return Disposables.create()
			}

			let alertController = UIAlertController(title: error.title, message: error.message, preferredStyle: error.style)

			error.actions.forEach { action in
				let alertAction = UIAlertAction(title: action.title, style: action.style.alertStyle) { _ in
					alertController.dismiss(animated: true)
					observer.onNext(action)
				}

				alertController.addAction(alertAction)
			}

			navigationController.present(alertController, animated: true)

			return Disposables.create()
		}
	}

	func showError(error: NavigationCatcherError) {
		let alertController = UIAlertController(title: error.title, message: error.message, preferredStyle: error.style)

		error.actions.forEach { action in
			let alertAction = UIAlertAction(title: action.title, style: action.style.alertStyle) { _ in
				alertController.dismiss(animated: true)
			}

			alertController.addAction(alertAction)
		}

		if let navigationController = navigationController {
			navigationController.topViewController?.present(alertController, animated: true)
		} else if let currentView {
			currentView.present(alertController, animated: true)
		}
	}

}

extension ObservableType {

	func asDriverCatchErrorDoNothing<T>(
		action: NavigationCatcherAction,
		catcher: NavigatorErrorCatcher<T>
	) -> Driver<Element> {
		asDriver { error in
			guard let error = error as? LocalizedError else {
				return Driver.never()
			}

			let navigationError = CustomNavigationCatcherError(
				title: error.localizedDescription,
				message: error.recoverySuggestion,
				style: .alert,
				actions: [action]
			)

			catcher.showError(error: navigationError)

			return Driver.never()
		}
	}

	func asDriverCatchError<T>(catcher: NavigatorErrorCatcher<T>) -> Driver<NavigationCatcherAction> {
		self.flatMapLatest { _ -> Observable<NavigationCatcherAction> in Observable<NavigationCatcherAction>.never() }
			.asDriver(onErrorRecover: { [weak catcher] error in
				guard
					let catcher,
					let navigationError = error as? NavigationCatcherError
				else {
					return Driver.fatalEmpty(msg: "Error should conform NavigationCatcherError")
				}

				return catcher.catchAlert(error: navigationError).asDriverOnErrorDoNothing()
		})
	}

}

extension ObservableType where Element: OptionalType {

	func unwrappedAsDriverCatchWarning<T>(
		warningAction: NavigationCatcherAction,
		catcher: NavigatorErrorCatcher<T>,
		error: Error
	) -> Driver<Element.Wrapped> {
		flatMap { value -> Observable<Element.Wrapped> in
			guard let value = value.asOptional else {
				return Observable.error(error)
			}

			return Observable.just(value)
		}.asDriverCatchErrorDoNothing(action: warningAction, catcher: catcher)
	}

}

extension Single {

	func asDriverCatchErrorDoNothing<T>(
		action: NavigationCatcherAction,
		catcher: NavigatorErrorCatcher<T>
	) -> Driver<Element> {
		asDriver { error in
			guard let error = error as? LocalizedError else {
				return Driver.never()
			}

			let navigationError = CustomNavigationCatcherError(
				title: error.localizedDescription,
				message: error.recoverySuggestion,
				style: .alert,
				actions: [action]
			)

			catcher.showError(error: navigationError)

			return Driver.never()
		}
	}

}

struct NavigationCatcherAction {

	enum Style {
		case ok
		case cancel
		case action
	}

	let title: String
	let style: Style

}

protocol NavigationCatcherError {

	var title: String? { get }
	var message: String? { get }
	var style: UIAlertController.Style { get }
	var actions: [NavigationCatcherAction] { get }

}

struct CustomNavigationCatcherError: NavigationCatcherError {

	var title: String?
	var message: String?
	var style: UIAlertController.Style
	var actions: [NavigationCatcherAction]

}

extension NavigationCatcherAction.Style {

	var alertStyle: UIAlertAction.Style {
		switch self {
		case .ok:
			return .default
		case .action:
			return .default
		case .cancel:
			return .cancel
		}
	}

}


