//
//  CritterView.swift
//  LoginCritter
//
//  Created by Christopher Goldsby on 3/30/18.
//  Copyright © 2018 Christopher Goldsby. All rights reserved.
//

import UIKit

final class CritterView: UIView {

    private var isDoeEyed = false

    private let body = Body()
    private let head = Head()
    private let leftEar = LeftEar()
    private let leftEarMask = LeftEarMask()
    private let leftEye = LeftEye()
    private let mouthOpen = Mouth()
    private let muzzle = Muzzle()
    private let nose = Nose()
    private let rightEar = RightEar()
    private let rightEarMask = RightEarMask()
    private let rightEye = RightEye()

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
        muzzle.addSubview(mouthOpen)
    }

    private func setUpMask() {
        mask = UIView(frame: bounds)
        mask?.backgroundColor = .black
        mask?.layer.cornerRadius = bounds.width / 2
    }

    // MARK: - Animation

    private enum Parts {
        case body
        case head
        case leftEar
        case leftEarMask
        case leftEye
        case mouthOpen
        case muzzle
        case nose
        case rightEar
        case rightEarMask
        case rightEye
    }

    private var focusCritterStartAnimation: UIViewPropertyAnimator?
    private var focusCritterEndAnimation: UIViewPropertyAnimator?
    private var focusIntermediateState = [Parts : CATransform3D]()

    func startHeadRotation(startAt fractionComplete: Float) {
        let shouldStoreCurrentState = focusCritterEndAnimation != nil

        stopAllAnimations()

        if shouldStoreCurrentState {
            storeCurrentState()
        }

        focusCritterStartAnimation = UIViewPropertyAnimator(
            duration: 0.2,
            curve: .easeIn,
            animations: { self.focusIntermediateState.isEmpty ? self.focusCritterInitialState() : self.restoreState() })

        focusCritterEndAnimation = UIViewPropertyAnimator(
            duration: 0.2,
            curve: .linear,
            animations: focusCritterFinalState
        )

        focusCritterStartAnimation?.addCompletion {
            [weak self] _ in
            self?.focusCritterInitialState()
            self?.focusCritterEndAnimation?.fractionComplete = CGFloat(fractionComplete)
        }

        focusCritterStartAnimation?.startAnimation()
    }

    func updateHeadRotation(to fractionComplete: Float) {
        focusCritterEndAnimation?.fractionComplete = CGFloat(fractionComplete)
    }

    func stopHeadRotation() {
        let shouldStoreCurrentState = focusCritterEndAnimation != nil

        stopAllAnimations()

        if shouldStoreCurrentState {
            storeCurrentState()
        }

        let neutralAnimation = UIViewPropertyAnimator(duration: 0.1725, curve: .easeIn) {
            [self.body,
             self.head,
             self.leftEar,
             self.rightEar,
             self.leftEarMask,
             self.rightEarMask,
             self.leftEye,
             self.rightEye,
             self.muzzle,
             self.nose,
             self.mouthOpen].applyInactiveState()
        }

        neutralAnimation.startAnimation()
    }

    func validateAnimation() {
        isDoeEyed = !isDoeEyed

        let duration = 0.125
        let eyeAnimationKey = "eyeCrossFade"
        leftEye.layer.removeAnimation(forKey: eyeAnimationKey)
        rightEye.layer.removeAnimation(forKey: eyeAnimationKey)

        let crossFade = CABasicAnimation(keyPath: "contents")
        crossFade.duration = duration
        crossFade.fromValue = isDoeEyed ? UIImage.Critter.eye.cgImage : UIImage.Critter.doeEye.cgImage
        crossFade.toValue = isDoeEyed ? UIImage.Critter.doeEye.cgImage : UIImage.Critter.eye.cgImage
        crossFade.fillMode = kCAFillModeForwards
        crossFade.isRemovedOnCompletion = false

        leftEye.layer.add(crossFade, forKey: eyeAnimationKey)
        rightEye.layer.add(crossFade, forKey: eyeAnimationKey)

        let dimension = isDoeEyed ? 12.7 : 11.7
        let validateAnimation = UIViewPropertyAnimator(duration: duration, curve: .easeIn) {
            self.leftEye.layer.bounds = CGRect(x: 0, y: 0, width: dimension, height: dimension)
            self.rightEye.layer.bounds = CGRect(x: 0, y: 0, width: dimension, height: dimension)
        }

        validateAnimation.startAnimation()
    }

    private func stopAllAnimations() {
        focusCritterStartAnimation?.stopAnimation(true)
        focusCritterStartAnimation = nil

        focusCritterEndAnimation?.stopAnimation(true)
        focusCritterEndAnimation = nil
    }

    private func focusCritterInitialState() {
        [body,
         head,
         leftEar,
         rightEar,
         leftEarMask,
         rightEarMask,
         leftEye,
         rightEye,
         muzzle,
         nose,
         mouthOpen].applyActiveStartState()
    }

    private func focusCritterFinalState() {
        [body,
         head,
         leftEar,
         rightEar,
         leftEarMask,
         rightEarMask,
         leftEye,
         rightEye,
         muzzle,
         nose].applyActiveEndState()
    }

    func storeCurrentState() {
        focusIntermediateState[.body] = body.currentState
        focusIntermediateState[.head] = head.currentState
        focusIntermediateState[.leftEarMask] = leftEarMask.currentState
        focusIntermediateState[.leftEar] = leftEar.currentState
        focusIntermediateState[.leftEye] = leftEye.currentState
        focusIntermediateState[.mouthOpen] = mouthOpen.currentState
        focusIntermediateState[.muzzle] = muzzle.currentState
        focusIntermediateState[.nose] = nose.currentState
        focusIntermediateState[.rightEarMask] = rightEarMask.currentState
        focusIntermediateState[.rightEar] = rightEar.currentState
        focusIntermediateState[.rightEye] = rightEye.currentState
    }

    func restoreState() {
        body.layer.transform = focusIntermediateState[.body]!
        head.layer.transform = focusIntermediateState[.head]!
        leftEar.layer.transform = focusIntermediateState[.leftEar]!
        leftEarMask.layer.transform = focusIntermediateState[.leftEarMask]!
        leftEye.layer.transform = focusIntermediateState[.leftEye]!
        mouthOpen.layer.transform = focusIntermediateState[.mouthOpen]!
        muzzle.layer.transform = focusIntermediateState[.muzzle]!
        nose.layer.transform = focusIntermediateState[.nose]!
        rightEar.layer.transform = focusIntermediateState[.rightEar]!
        rightEarMask.layer.transform = focusIntermediateState[.rightEarMask]!
        rightEye.layer.transform = focusIntermediateState[.rightEye]!
    }
}
