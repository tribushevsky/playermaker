//
//  GradientView.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 02/08/2025.
//

import UIKit

@IBDesignable
open class GradientView: UIView {

	enum Axis {
		case vertical
		case horizontal
	}

	private var gradientLayer: CAGradientLayer?

	@IBInspectable
	var gradientStartColor: UIColor = .clear {
		didSet {
			setNeedsLayout()
			layoutIfNeeded()
		}
	}

	@IBInspectable
	var gradientEndColor: UIColor = .clear {
		didSet {
			setNeedsLayout()
			layoutIfNeeded()
		}
	}

	var axis: Axis = .vertical {
		didSet {
			gradientLayer?.removeFromSuperlayer()
			gradientLayer = nil

			setNeedsLayout()
			layoutIfNeeded()
		}
	}

	open override func layoutSubviews() {
		super.layoutSubviews()

		if gradientLayer == nil {
			let gradient = CAGradientLayer()
			layer.insertSublayer(gradient, at: 0)

			gradientLayer = gradient
		}

		gradientLayer?.colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
		gradientLayer?.startPoint = axis == .horizontal ? .init(x: 0, y: 0.5) : .init(x: 0.5, y: 0)
		gradientLayer?.endPoint = axis == .horizontal ? .init(x: 1, y: 0.5) : .init(x: 0.5, y: 1)
		gradientLayer?.frame = bounds
		gradientLayer?.cornerRadius = layer.cornerRadius
	}

}
