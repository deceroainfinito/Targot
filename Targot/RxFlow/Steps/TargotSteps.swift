//
//  TargotSteps.swift
//  Targot
//
//

import RxFlow

enum TargotSteps: Step {
  case cardsList

  case newCardDetails(Stepper)

  case cardDetails(withId: String?, andStepper: Stepper)

  case newCardDone

  case addNewPhoto(Stepper)
  case dismissNewPhoto

  case settings
}
