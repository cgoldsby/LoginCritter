//
//  LoginViewController.swift
//  LoginCritter
//
//  Created by Christopher Goldsby on 3/30/18.
//  Copyright © 2018 Christopher Goldsby. All rights reserved.
//

import UIKit

private let critterViewDimension: CGFloat = 160
private let critterViewTopMargin: CGFloat = 70

final class LoginViewController: UIViewController {

    private let critterView = CritterView(frame: CGRect(x: 0, y: 0, width: critterViewDimension, height: critterViewDimension))

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    // MARK: - Private

    private func setUpView() {
        view.backgroundColor = Colors.dark
        view.addSubview(critterView)
        setUpCritterViewConstraints()
        setUpNotification()

        dev_setUpTestUI()
    }

    private func setUpCritterViewConstraints() {
        critterView.translatesAutoresizingMaskIntoConstraints = false
        critterView.heightAnchor.constraint(equalToConstant: critterViewDimension).isActive = true
        critterView.widthAnchor.constraint(equalTo: critterView.heightAnchor).isActive = true
        critterView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        critterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: critterViewTopMargin).isActive = true
    }

    private func setUpNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }

    @objc private func applicationDidEnterBackground() {
        dev_neutralAnimation()
    }

    // MARK: - Dev

    private lazy var activeAnimationSlider = UISlider()

    private func dev_setUpTestUI() {
        let animateButton = UIButton(type: .system)
        animateButton.setTitle("Activate", for: .normal)
        animateButton.setTitleColor(.white, for: .normal)
        animateButton.addTarget(self, action: #selector(dev_activeAnimation), for: .touchUpInside)

        let resetButton = UIButton(type: .system)
        resetButton.setTitle("Neutral", for: .normal)
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.addTarget(self, action: #selector(dev_neutralAnimation), for: .touchUpInside)

        let validateButton = UIButton(type: .system)
        validateButton.setTitle("Ecstatic", for: .normal)
        validateButton.setTitleColor(.white, for: .normal)
        validateButton.addTarget(self, action: #selector(dev_ecstaticAnimation), for: .touchUpInside)

        activeAnimationSlider.tintColor = Colors.light
        activeAnimationSlider.isEnabled = false
        activeAnimationSlider.addTarget(self, action: #selector(dev_activeAnimationSliderValueChanged(sender:)), for: .valueChanged)

        let stackView = UIStackView(
            arrangedSubviews:
            [
                animateButton,
                resetButton,
                validateButton,
                activeAnimationSlider
            ]
        )
        stackView.axis = .vertical
        stackView.spacing = 15
        view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    @objc private func dev_activeAnimation() {
        critterView.startHeadRotation(startAt: activeAnimationSlider.value)
        activeAnimationSlider.isEnabled = true
    }

    @objc private func dev_neutralAnimation() {
        critterView.stopHeadRotation()
        activeAnimationSlider.isEnabled = false
    }

    @objc private func dev_ecstaticAnimation() {
        critterView.validateAnimation()
    }

    @objc private func dev_activeAnimationSliderValueChanged(sender: UISlider) {
        critterView.updateHeadRotation(to: sender.value)
    }
}
