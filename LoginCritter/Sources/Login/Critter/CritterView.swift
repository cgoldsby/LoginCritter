//
//  CritterView.swift
//  LoginCritter
//
//  Created by Christopher Goldsby on 3/30/18.
//  Copyright © 2018 Christopher Goldsby. All rights reserved.
//

import UIKit

final class CritterView: UIView {

    private let body = Body()
    private let head = Head()
    private let leftEar = LeftEar()
    private let leftEarMask = LeftEarMask()
    private let leftEye = LeftEye()
    private let mouth = Mouth()
    private let muzzle = Muzzle()
    private let nose = Nose()
    private let rightEar = RightEar()
    private let rightEarMask = RightEarMask()
    private let rightEye = RightEye()

    private lazy var parts: [CritterAnimatable] = {
        return [self.body,
                self.head,
                self.leftEar,
                self.rightEar,
                self.leftEarMask,
                self.rightEarMask,
                self.leftEye,
                self.rightEye,
                self.muzzle,
                self.nose,
                self.mouth]
    }()

    private var isEcstatic = false

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setUpView()
    }

    // MARK: - Private

    private func setUpView() {
        backgroundColor = Colors.light
        setUpMask()

        addSubview(body)
        addSubview(head)

        head.addSubview(leftEar)
        head.addSubview(rightEar)
        head.addSubview(leftEarMask)
        head.addSubview(rightEarMask)
        head.addSubview(leftEye)
        head.addSubview(rightEye)
        head.addSubview(muzzle)

        muzzle.addSubview(nose)
        muzzle.addSubview(mouth)
    }

    private func setUpMask() {
        mask = UIView(frame: bounds)
        mask?.backgroundColor = .black
        mask?.layer.cornerRadius = bounds.width / 2
    }

    // MARK: - Animation

    private var neutralAnimation: UIViewPropertyAnimator?
    private var activeStartAnimation: UIViewPropertyAnimator?
    private var activeEndAnimation: UIViewPropertyAnimator?
    private var savedState = [SavedState]()

    func startHeadRotation(startAt fractionComplete: Float) {
        let shouldSaveCurrentState = activeEndAnimation != nil

        stopAllAnimations()

        if shouldSaveCurrentState {
            saveCurrentState()
        }

        activeStartAnimation = UIViewPropertyAnimator(
            duration: 0.2,
            curve: .easeIn,
            animations: { self.savedState.isEmpty ? self.focusCritterInitialState() : self.restoreToSavedState() })

        activeEndAnimation = UIViewPropertyAnimator(
            duration: 0.2,
            curve: .linear,
            animations: focusCritterFinalState
        )

        activeStartAnimation?.addCompletion {
            [weak self] _ in
            self?.focusCritterInitialState()
            self?.activeEndAnimation?.fractionComplete = CGFloat(fractionComplete)
        }

        activeStartAnimation?.startAnimation()
    }

    func updateHeadRotation(to fractionComplete: Float) {
        activeEndAnimation?.fractionComplete = CGFloat(fractionComplete)
    }

    func stopHeadRotation() {
        let shouldSaveCurrentState = activeEndAnimation != nil

        stopAllAnimations()

        if shouldSaveCurrentState {
            saveCurrentState()
        }

        neutralAnimation = UIViewPropertyAnimator(duration: 0.1725, curve: .easeIn) {
            self.parts.applyInactiveState()
        }

        neutralAnimation?.startAnimation()
    }

    func validateAnimation() {
        isEcstatic = !isEcstatic

        let duration = 0.125
        let eyeAnimationKey = "eyeCrossFade"
        leftEye.layer.removeAnimation(forKey: eyeAnimationKey)
        rightEye.layer.removeAnimation(forKey: eyeAnimationKey)

        let crossFade = CABasicAnimation(keyPath: "contents")
        crossFade.duration = duration
        crossFade.fromValue = isEcstatic ? UIImage.Critter.eye.cgImage : UIImage.Critter.doeEye.cgImage
        crossFade.toValue = isEcstatic ? UIImage.Critter.doeEye.cgImage : UIImage.Critter.eye.cgImage
        crossFade.fillMode = kCAFillModeForwards
        crossFade.isRemovedOnCompletion = false

        leftEye.layer.add(crossFade, forKey: eyeAnimationKey)
        rightEye.layer.add(crossFade, forKey: eyeAnimationKey)

        let dimension = isEcstatic ? 12.7 : 11.7
        let validateAnimation = UIViewPropertyAnimator(duration: duration, curve: .easeIn) {
            self.leftEye.layer.bounds = CGRect(x: 0, y: 0, width: dimension, height: dimension)
            self.rightEye.layer.bounds = CGRect(x: 0, y: 0, width: dimension, height: dimension)
        }

        validateAnimation.startAnimation()
    }

    private func stopAllAnimations() {
        neutralAnimation?.stopAnimation(true)
        neutralAnimation = nil

        activeStartAnimation?.stopAnimation(true)
        activeStartAnimation = nil

        activeEndAnimation?.stopAnimation(true)
        activeEndAnimation = nil
    }

    private func focusCritterInitialState() {
        parts.applyActiveStartState()
    }

    private func focusCritterFinalState() {
        parts.applyActiveEndState()
    }

    func saveCurrentState() {
        savedState = parts.map { $0.currentState() }
    }

    func restoreToSavedState() {
        savedState.forEach { $0() }
    }
}
