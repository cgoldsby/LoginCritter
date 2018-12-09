//
//  CritterView.swift
//  LoginCritter
//
//  Created by Christopher Goldsby on 3/30/18.
//  Copyright © 2018 Christopher Goldsby. All rights reserved.
//

import UIKit

final class CritterView: UIView {

    var isActiveStartAnimating: Bool {
        guard let activeStartAnimation = activeStartAnimator else { return false }
        return activeStartAnimation.state == .active
    }

    var isEcstatic: Bool = false {
        didSet {
            mouth.isEcstatic = isEcstatic
            if oldValue != isEcstatic {
                ecstaticAnimation()
            }
        }
    }

    var isShy: Bool = false {
        didSet {
            leftArm.isShy = isShy
            rightArm.isShy = isShy
            guard oldValue != isShy else { return }
            shyAnimation()
        }
    }

    var isPeeking: Bool = false {
        didSet {
            guard oldValue != isPeeking else { return }
            togglePeekingState()
        }
    }

    private let body = Body()
    private let head = Head()
    private let leftArm = LeftArm()
    private let leftEar = LeftEar()
    private let leftEarMask = LeftEarMask()
    private let leftEye = LeftEye()
    private let mouth = Mouth()
    private let muzzle = Muzzle()
    private let nose = Nose()
    private let rightArm = RightArm()
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
                self.mouth,
                self.leftArm,
                self.rightArm]
    }()

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setUpView()
    }

    // MARK: - Private

    private func setUpView() {
        backgroundColor = .light
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

        addSubview(leftArm)
        addSubview(rightArm)
    }

    private func setUpMask() {
        mask = UIView(frame: bounds)
        mask?.backgroundColor = .black
        mask?.layer.cornerRadius = bounds.width / 2
    }

    // MARK: - Animation

    private var neutralAnimator: UIViewPropertyAnimator?
    private var activeStartAnimator: UIViewPropertyAnimator?
    private var activeEndAnimator: UIViewPropertyAnimator?
    private var savedState = [SavedState]()

    func startHeadRotation(startAt fractionComplete: Float) {
        let shouldSaveCurrentState = activeEndAnimator != nil

        stopAllAnimations()

        if shouldSaveCurrentState {
            saveCurrentState()
        }

        activeStartAnimator = UIViewPropertyAnimator(
            duration: 0.2,
            curve: .easeIn,
            animations: { self.savedState.isEmpty ? self.focusCritterInitialState() : self.restoreToSavedState() })

        activeEndAnimator = UIViewPropertyAnimator(
            duration: 0.2,
            curve: .linear,
            animations: focusCritterFinalState
        )

        activeStartAnimator?.addCompletion {
            [weak self] _ in
            self?.focusCritterInitialState()
            self?.activeEndAnimator?.fractionComplete = CGFloat(fractionComplete)
        }

        activeStartAnimator?.startAnimation()
    }

    func updateHeadRotation(to fractionComplete: Float) {
        activeEndAnimator?.fractionComplete = CGFloat(fractionComplete)
    }

    func stopHeadRotation() {
        if let neutralAnimation = neutralAnimator, neutralAnimation.state == .inactive {
            return
        }

        let shouldSaveCurrentState = activeEndAnimator != nil

        stopAllAnimations()

        if shouldSaveCurrentState {
            saveCurrentState()
        }

        neutralAnimator = UIViewPropertyAnimator(duration: 0.1725, curve: .easeIn) {
            self.parts.applyInactiveState()
        }

        neutralAnimator?.startAnimation()
    }

    private func ecstaticAnimation() {
        let duration = 0.125
        let eyeAnimationKey = "eyeCrossFade"
        leftEye.layer.removeAnimation(forKey: eyeAnimationKey)
        rightEye.layer.removeAnimation(forKey: eyeAnimationKey)

        let crossFade = CABasicAnimation(keyPath: "contents")
        crossFade.duration = duration
        crossFade.fromValue = isEcstatic ? UIImage.Critter.eye.cgImage : UIImage.Critter.doeEye.cgImage
        crossFade.toValue = isEcstatic ? UIImage.Critter.doeEye.cgImage : UIImage.Critter.eye.cgImage
        crossFade.fillMode = .forwards
        crossFade.isRemovedOnCompletion = false

        leftEye.layer.add(crossFade, forKey: eyeAnimationKey)
        rightEye.layer.add(crossFade, forKey: eyeAnimationKey)

        let dimension = isEcstatic ? 12.7 : 11.7
        let ecstaticAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeIn) {
            self.leftEye.layer.bounds = CGRect(x: 0, y: 0, width: dimension, height: dimension)
            self.rightEye.layer.bounds = CGRect(x: 0, y: 0, width: dimension, height: dimension)
            self.mouth.applyEcstaticState()
        }

        ecstaticAnimator.startAnimation()
    }

    // MARK: - Internal Animations for CritterView

    private func togglePeekingState() {
        let animation = isPeeking ? parts.applyPeekState : parts.applyUnPeekState
        let peekAnimator = UIViewPropertyAnimator(duration: 0.15, curve: .easeIn, animations: animation)
        peekAnimator.startAnimation()
    }
    
    private func shyAnimation() {
        let shyAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .easeIn) {
            self.leftArm.applyShyState()
            self.rightArm.applyShyState()
        }

        shyAnimator.startAnimation()
    }

    private func stopAllAnimations() {
        neutralAnimator?.stopAnimation(true)
        neutralAnimator = nil

        activeStartAnimator?.stopAnimation(true)
        activeStartAnimator = nil

        activeEndAnimator?.stopAnimation(true)
        activeEndAnimator = nil
    }

    private func focusCritterInitialState() {
        parts.applyActiveStartState()
        
    }

    private func focusCritterFinalState() {
        parts.applyActiveEndState()
    }
    
    private func saveCurrentState() {
        savedState = parts.map { $0.currentState() }
    }

    private func restoreToSavedState() {
        savedState.forEach { $0() }
    }
}
