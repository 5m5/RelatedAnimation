//
//  ViewController.swift
//  RelatedAnimation
//
//  Created by Mikhail Andreev on 08.07.2023.
//

import UIKit

class ViewController: UIViewController
{
	private enum Constants
	{
		static let scaleFactor: CGFloat = 1.5
		static let angle: CGFloat = 90 * .pi / 180
		static let animationDuration: TimeInterval = 1
	}

	private lazy var rectangle = makeRectangle()
	private lazy var slider = makeSlider()

	override func viewDidLoad()
	{
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		view.addSubview(rectangle)
		view.addSubview(slider)
	}

	override func viewWillLayoutSubviews()
	{
		super.viewWillLayoutSubviews()

		guard rectangle.transform == .identity else { return }

		rectangle.frame = .init(
			x: view.layoutMargins.left,
			y: view.layoutMargins.top * Constants.scaleFactor + 20,
			width: 100,
			height: 100
		)

		slider.frame.origin.x = view.layoutMargins.left
		slider.frame.origin.y = rectangle.frame.maxY * Constants.scaleFactor
		slider.frame.size.width = view.frame.width - slider.frame.minX * 2
	}
}

private extension ViewController
{
	func makeRectangle() -> UIView
	{
		let rectangle = UIView()
		rectangle.backgroundColor = .systemBlue
		rectangle.layer.cornerRadius = 8
		return rectangle
	}

	func makeSlider() -> UISlider
	{
		let slider = UISlider()
		slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
		slider.addTarget(self, action: #selector(sliderTouchUp), for: .touchUpInside)
		return slider
	}

	@objc func sliderValueChanged(_ sender: UISlider)
	{
		animateRectangle(scaleFactor: CGFloat(sender.value))
	}

	func animateRectangle(scaleFactor: CGFloat)
	{
		let optimizedFactor = scaleFactor * 0.5 + 1
		let leftPositionForRectangleCenter = view.layoutMargins.left + rectangle.frame.width / 2
		let rightPositionForRectangleCenter = view.frame.maxX - leftPositionForRectangleCenter - view.layoutMargins.right - rectangle.frame.width / 2
		rectangle.center.x = leftPositionForRectangleCenter + rightPositionForRectangleCenter * scaleFactor
		let rotationAngle = scaleFactor * Constants.angle
		let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
		let transform = rotationTransform.scaledBy(
			x: optimizedFactor,
			y: optimizedFactor
		)
		rectangle.transform = transform
	}

	@objc func sliderTouchUp(_ sender: UISlider)
	{
		guard
			slider.value != slider.maximumValue,
			slider.value != slider.minimumValue
		else
		{
			return
		}

		UIView.animate(withDuration: Constants.animationDuration) {
			sender.setValue(sender.maximumValue, animated: true)
			self.sliderValueChanged(sender)
		}
	}
}
