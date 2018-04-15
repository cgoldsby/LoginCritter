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
    private let mouthOpen = UIImageView(image: UIImage.Critter.mouthOpen)
    private let muzzle = UIImageView(image: UIImage.Critter.muzzle)
    private let nose = UIImageView(image: UIImage.Critter.nose)
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
        muzzle.frame = CGRect(x: 24, y: 43, width: 57.5, height: 46.8)

        muzzle.addSubview(nose)
        nose.frame = CGRect(x: 22.4, y: 1.7, width: 12.7, height: 9.6)

        muzzle.addSubview(mouthOpen)
        mouthOpen.frame = CGRect(x: 15.5, y: 24.6, width: 26.4, height: 18.7)
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
             self.rightEye].applyInactiveState()

            self.mouthOpen.layer.transform = .identity
            self.muzzle.layer.transform = .identity
            self.nose.layer.transform = .identity
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
         rightEye].applyActiveStartState()

        var p1 = CGPoint(x: 24, y: 43)
        var p2 = CGPoint(x: 12.9, y: 45.1)

        muzzle.layer.transform = CATransform3D
            .identity
            .translate(.x, by: p2.x - p1.x)
            .translate(.y, by: p2.y - p1.y)

        p1 = CGPoint(x: 22.4, y: 1.7)
        p2 = CGPoint(x: 13.2, y: 5.2)

        nose.layer.transform = CATransform3D
            .identity
            .translate(.x, by: p2.x - p1.x)
            .translate(.y, by: p2.y - p1.y)

        p1 = CGPoint(x: 15.5, y: 24.6)
        p2 = CGPoint(x: 14.9, y: 22.1)

        mouthOpen.layer.transform = CATransform3D
            .identity
            .translate(.x, by: p2.x - p1.x)
            .translate(.y, by: p2.y - p1.y)
    }

    private func focusCritterFinalState() {
        [body,
         head,
         leftEar,
         rightEar,
         leftEarMask,
         rightEarMask,
         leftEye,
         rightEye].applyActiveEndState()

        var p1 = CGPoint(x: 24, y: 43)
        var p2 = CGPoint(x: 12.9, y: 45.1)

        muzzle.layer.transform = CATransform3D
            .identity
            .translate(.x, by: -(p2.x - p1.x))
            .translate(.y, by: p2.y - p1.y)

        p1 = CGPoint(x: 22.4, y: 1.7)
        p2 = CGPoint(x: 13.2, y: 5.2)

        nose.layer.transform = CATransform3D
            .identity
            .translate(.x, by: -(p2.x - p1.x))
            .translate(.y, by: p2.y - p1.y)

        p1 = CGPoint(x: 15.5, y: 24.6)
        p2 = CGPoint(x: 14.9, y: 22.1)

        mouthOpen.layer.transform = CATransform3D
            .identity
            .translate(.x, by: -(p2.x - p1.x))
            .translate(.y, by: p2.y - p1.y)
    }

    func storeCurrentState() {
        focusIntermediateState[.body] = body.currentState
        focusIntermediateState[.head] = head.currentState
        focusIntermediateState[.leftEarMask] = leftEarMask.currentState
        focusIntermediateState[.leftEar] = leftEar.currentState
        focusIntermediateState[.leftEye] = leftEye.currentState
        focusIntermediateState[.mouthOpen] = mouthOpen.layer.transform
        focusIntermediateState[.muzzle] = muzzle.layer.transform
        focusIntermediateState[.nose] = nose.layer.transform
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
