//
//  RootView.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

import UIKit
import RxSwift
import RxCocoa

final class RootView: Window<RootViewModel> {
	
	private let isVisiblePublishRelay: PublishRelay<Void> = PublishRelay()

	// MARK: - Lifecycle

	override func makeKeyAndVisible() {
		super.makeKeyAndVisible()

		setupView()
		setupBinding()
		finalizeSetup()
	}

}

// MARK: - Setup View

extension RootView {
	
	private func setupView() {
		self.backgroundColor = UIColor(white: 0, alpha: 1)
	}

}

// MARK: - Setup Binding

extension RootView {
	
	private func setupBinding() {
		let input = RootViewModel.Input(
			isVisibleTrigger: isVisiblePublishRelay.asDriverOnErrorDoNothing()
		)

		let output = viewModel.transform(input: input)
		
		output.tools.drive().disposed(by: disposeBag)
	}
	
	private func finalizeSetup() {
		isVisiblePublishRelay.accept(Void())
	}

}
