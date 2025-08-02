//
//  CrucialActionHandableProtocol.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 02/08/2025.
//

import RxSwift
import RxCocoa

protocol CrucialActionHandableProtocol {

	func handleSure<Crucial>(
		actionTrigger: Observable<Crucial>,
		on container: UIViewController?,
		title: String?,
		message: String?,
		actionTitle: String,
		cancelTitle: String
	) -> Observable<Crucial>

}

extension CrucialActionHandableProtocol {

	func handleSure<Crucial>(
		actionTrigger: Observable<Crucial>,
		on container: UIViewController?,
		title: String? = nil,
		message: String? = nil,
		actionTitle: String,
		cancelTitle: String
	) -> Observable<Crucial> {
		actionTrigger.flatMapLatest { crucial -> Observable<Crucial> in
			guard let container else {
				return Observable.fatalEmpty(msg: "\(#function): container is nil.")
			}

			return Observable.create { observer in
				let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

				let cancel = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
					alertController.dismiss(animated: true)
				}

				let action = UIAlertAction(title: actionTitle, style: .destructive) { _ in
					alertController.dismiss(animated: true)
					observer.onNext(crucial)
				}

				alertController.addAction(cancel)
				alertController.addAction(action)
				container.present(alertController, animated: true)

				return Disposables.create()
			}
		}
	}

}

