# Login Critter
> An animated avatar that responds to text fields interactions 🐻

![Demo gif](/assets/demo.gif)

Inspired by the amazing work done by other designers and developers, specifically Darin Senneff's [amazing work](https://dribbble.com/shots/4249163-Animated-login-form-avatar?utm_campaign=iOS%2BDev%2BWeekly&utm_medium=web&utm_source=iOS%2BDev%2BWeekly%2BIssue%2B349). 🎩🌟 I wanted to try and create a similar animated "Login avatar" in Swift.

The Login Critter uses several `UIPropertyAnimator`. The head rotation is controlled by updating the `fractionComplete` property for an animator. As the user types, the animator's fraction complete is calculated by `text width / text field width`.

## Avatar Assets
The Login Critter assets are broken down in to "Parts": body, head, eyes, ears, nose, muzzle, etc. Each "Part" can be individually animated. They are just vector PDFs because I wanted to focus on the animations and not worry about creating shapes programmatically.

I used Affinity Designer for creating the mock up and assets. (I'm falling in love with this program. 😍) I've included the [raw asset](/assets/login-critter.afdesign) in this repo.

## Avatar States
The Login Critter has a neutral, active, ecstatic, and shy state.

For simplicity, the neutral state is just the identity transform for all the Part layers. The neutral state can be triggered by tapping the background.

The active state has two phases a start and end. The start and end active phases corresponds to the avatar turning from left to right. The active state can be triggered by tapping the email text field.

The ecstatic state is unique because it can be used in combination with all other states, i.e. the avatar can be both ecstatic and neutral. The ecstatic state can be triggered by typing **`@`** in the email text field.

The shy state is only used in combination with the neutral state and can be triggered by tapping the password text field.

The peek state is only used in combination with the shy state and can be toggled On or Off using the "show password" button in the password text field.

There is also a "saved" state. The "saved" state is the current active transformation that is stored when returning to the neutral state. For example, if the active state is 50% complete, the avatar is looking straight down, and transitions to the neutral state, then when returning to the active state the avatar will animate to 50% complete instead of 0% complete.

| Neutral                             | Active                            | Ecstatic                              | Shy                         | Peek                          |
| :----------------------------------:|:---------------------------------:| :------------------------------------:| :--------------------------:| :----------------------------:|
| ![Neutral png](/assets/neutral.png) | ![Active png](/assets/active.png) | ![Ecstatic png](/assets/ecstatic.png) | ![Shy png](/assets/shy.png) | ![Peek png](/assets/peek.png) |

The "Parts" transformations for each state begin with it's `identity`, the neutral state, then scale, rotate and/or translate is applied.

## Debug Mode
There is a [debug mode flag](https://github.com/cgoldsby/LoginCritter/blob/012eecbf51a07d6ba389ff865ae30074b001702e/LoginCritter/Sources/Login/LoginViewController.swift#L203) that when set to `true` it will show a debug UI. But, be wary, strange behavior might occur if you use both the text field and the debug UI. It's best to use either the text field or debug UI when testing.

## Meta
It's rare that I get a chance to do animations and thought this might be a fun little project. Thanks for checking it out! 🙇‍

Chris Goldsby – [@goldsbychris](https://twitter.com/goldsbychris)

Distributed under the MIT license. See ``LICENSE`` for more information.

Questions? Comments? I would love to hear your feedback. :heart:
