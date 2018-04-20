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
private let textFieldTopMargin: CGFloat = 38.8
private let textFieldWidth: CGFloat = 206
private let textFieldHeight: CGFloat = 37
private let textFieldHorizontalMargin: CGFloat = 16.5
private let textFieldSpacing: CGFloat = 22

final class LoginViewController: UIViewController, UITextFieldDelegate {

    private let critterView = CritterView(frame: CGRect(x: 0, y: 0, width: critterViewDimension, height: critterViewDimension))

    private lazy var emailTextField: UITextField = {
        let textField = createTextField()
        textField.placeholder = "Email"
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .next
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = createTextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.returnKeyType = .go
        return textField
    }()

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    // MARK: - UITextFieldDelegate

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            let deadlineTime = DispatchTime.now() + .milliseconds(100)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) { // 🎩✨ Magic to ensure animation starts
                let fractionComplete = self.fractionComplete(for: textField)
                self.critterView.startHeadRotation(startAt: fractionComplete)
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        else {
            passwordTextField.resignFirstResponder()
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            critterView.stopHeadRotation()
        }
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard !critterView.isActiveStartAnimating else { return }

        let fractionComplete = self.fractionComplete(for: textField)
        critterView.updateHeadRotation(to: fractionComplete)

        if let text = textField.text {
            critterView.isEcstatic = text.range(of: "@") != nil
        }
    }

    // MARK: - Private

    private func setUpView() {
        view.backgroundColor = Colors.dark
        view.addSubview(critterView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        setUpCritterViewConstraints()
        setUpEmailTextFieldConstraints()
        setUpPasswordTextFieldConstraints()
        setUpGestures()
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

    private func setUpEmailTextFieldConstraints() {
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant: textFieldWidth).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: critterView.bottomAnchor, constant: textFieldTopMargin).isActive = true
    }

    private func setUpPasswordTextFieldConstraints() {
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        passwordTextField.widthAnchor.constraint(equalToConstant: textFieldWidth).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: textFieldSpacing).isActive = true
    }

    private func setUpGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }

    private func setUpNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }

    @objc private func applicationDidEnterBackground() {
        stopHeadRotation()
    }

    private func fractionComplete(for textField: UITextField) -> Float {
        guard let text = textField.text, let font = textField.font else { return 0 }
        let textFieldWidth = textField.bounds.width - (2 * textFieldHorizontalMargin)
        return min(Float(text.size(withAttributes: [NSAttributedStringKey.font : font]).width / textFieldWidth), 1)
    }

    @objc private func handleTap() {
        stopHeadRotation()
    }

    private func stopHeadRotation() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        critterView.stopHeadRotation()
    }

    private func createTextField() -> UITextField {
        let view = UITextField(frame: CGRect(x: 0, y: 0, width: textFieldWidth, height: textFieldHeight))
        view.backgroundColor = .white
        view.layer.cornerRadius = 4.07
        view.tintColor = Colors.dark
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        view.spellCheckingType = .no
        view.delegate = self
        view.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        let frame = CGRect(x: 0, y: 0, width: textFieldHorizontalMargin, height: textFieldHeight)
        view.leftView = UIView(frame: frame)
        view.leftViewMode = .always

        view.rightView = UIView(frame: frame)
        view.rightViewMode = .always

        view.font = UIFont.systemFont(ofSize: 14.0)
        view.textColor = Colors.text

        return view
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
        stackView.spacing = 5
        view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    @objc private func dev_activeAnimation() {
        critterView.startHeadRotation(startAt: activeAnimationSlider.value)
        activeAnimationSlider.isEnabled = true
    }

    @objc private func dev_neutralAnimation() {
        stopHeadRotation()
        activeAnimationSlider.isEnabled = false
    }

    @objc private func dev_ecstaticAnimation() {
        critterView.isEcstatic = !critterView.isEcstatic
    }

    @objc private func dev_activeAnimationSliderValueChanged(sender: UISlider) {
        critterView.updateHeadRotation(to: sender.value)
    }
}
