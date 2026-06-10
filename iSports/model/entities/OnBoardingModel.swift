//
//  OnBoardingModel.swift
//  iSports
//
//  Created by JETSMobileLabMini10 on 01/06/2026.
//


import Foundation

struct OnBoardingModel{
    var title : String
    var desc : String
    var image : String
}

let onboardingData: [OnBoardingModel] = [
    OnBoardingModel(
        title: L10n.onboardingTitle1.localized,
        desc: L10n.onboardingDesc1.localized,
        image: "onboarding1"
    ),
    OnBoardingModel(
        title: L10n.onboardingTitle2.localized,
        desc: L10n.onboardingDesc2.localized,
        image: "onboarding2"
    ),
    OnBoardingModel(
        title: L10n.onboardingTitle3.localized,
        desc: L10n.onboardingDesc3.localized,
        image: "onboarding3"
    )
]
