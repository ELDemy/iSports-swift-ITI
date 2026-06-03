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
        title: "Your Ultimate Sports Hub",
        desc: "Everything you need to follow matches, scores, and sports news in one place.",
        image: "onboarding1"
    ),
    OnBoardingModel(
        title: "Personalized for You",
        desc: "Choose your favorite teams and receive updates tailored to your interests.",
        image: "onboarding2"
    ),
    OnBoardingModel(
        title: "Ready for Every Match",
        desc: "Stay connected to every game with instant updates and key match insights.",
        image: "onboarding3"
    )
]
