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
    private let leftEye = UIImageView(image: UIImage.Critter.eye)
    private let mouthOpen = UIImageView(image: UIImage.Critter.mouthOpen)
    private let muzzle = UIImageView(image: UIImage.Critter.muzzle)
    private let nose = UIImageView(image: UIImage.Critter.nose)
    private let rightEar = RightEar()
    private let rightEarMask = UIImageView(image: UIImage.Critter.head)
    private let rightEye = UIImageView(image: UIImage.Critter.eye)

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
        rightEarMask.layer.anchorPoint = CGPoint(x: 0, y: 0)
        rightEarMask.frame = head.bounds
        rightEarMask.mask = {
            let mask = UIView()
            mask.backgroundColor = .black
            var frame = head.bounds
            frame.origin.x = frame.midX
            frame.size.width = frame.width / 2
            mask.frame = frame
            return mask
        }()

        head.addSubview(leftEye)
        leftEye.frame = CGRect(x: 21.8, y: 28.8, width: 11.7, height: 11.7)

        head.addSubview(rightEye)
        rightEye.frame = CGRect(x: 72.4, y: 28.8, width: 11.7, height: 11.7)

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
             self.leftEarMask
                ].applyInactiveState()

            self.leftEye.layer.transform = .identity
            self.mouthOpen.layer.transform = .identity
            self.muzzle.layer.transform = .identity
            self.nose.layer.transform = .identity
            self.rightEarMask.layer.transform = .identity
            self.rightEye.layer.transform = .identity
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
         leftEarMask].applyActiveStartState()

        rightEarMask.layer.transform = CATransform3D
            .identity
            .scale(.x, by: 0.82)

        let eyeScale: CGFloat = 1.12
        let eyeTransform = CATransform3D
            .identity
            .scale(.x, by: eyeScale)
            .scale(.y, by: eyeScale)
            .scale(.z, by: 1.01) // 🎩✨ Magic to prevent 'jumping'

        var p1 = CGPoint(x: 21.8, y: 28.8)
        var p2 = CGPoint(x: 11.5, y: 37)

        leftEye.layer.transform = eyeTransform
            .translate(.x, by: p2.x - p1.x)
            .translate(.y, by: p2.y - p1.y)

        p1 = CGPoint(x: 72.4, y: 28.8)
        p2 = CGPoint(x: 62.1, y: 37)

        rightEye.layer.transform = eyeTransform
            .translate(.x, by: p2.x - p1.x)
            .translate(.y, by: p2.y - p1.y)

        p1 = CGPoint(x: 24, y: 43)
        p2 = CGPoint(x: 12.9, y: 45.1)

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
         leftEarMask].applyActiveEndState()

        rightEarMask.layer.transform = .identity

        let eyeScale: CGFloat = 1.12
        let eyeTransform = CATransform3D
            .identity
            .scale(.x, by: eyeScale)
            .scale(.y, by: eyeScale)
            .scale(.z, by: 1.01) // 🎩✨ Magic to prevent 'jumping'

        var p1 = CGPoint(x: 21.8, y: 28.8)
        var p2 = CGPoint(x: 11.5, y: 37)

        leftEye.layer.transform = eyeTransform
            .translate(.x, by: -(p2.x - p1.x))
            .translate(.y, by: p2.y - p1.y)

        p1 = CGPoint(x: 72.4, y: 28.8)
        p2 = CGPoint(x: 62.1, y: 37)

        rightEye.layer.transform = eyeTransform
            .translate(.x, by: -(p2.x - p1.x))
            .translate(.y, by: p2.y - p1.y)

        p1 = CGPoint(x: 24, y: 43)
        p2 = CGPoint(x: 12.9, y: 45.1)

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
        focusIntermediateState[.leftEye] = leftEye.layer.transform
        focusIntermediateState[.mouthOpen] = mouthOpen.layer.transform
        focusIntermediateState[.muzzle] = muzzle.layer.transform
        focusIntermediateState[.nose] = nose.layer.transform
        focusIntermediateState[.rightEarMask] = rightEarMask.layer.transform
        focusIntermediateState[.rightEar] = rightEar.currentState
        focusIntermediateState[.rightEye] = rightEye.layer.transform
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
