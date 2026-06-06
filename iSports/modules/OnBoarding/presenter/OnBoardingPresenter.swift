import Foundation

protocol OnBoardingViewProtocol: AnyObject {
    func setupPages(count: Int)
    func navigateToPage(at index: Int)
    func navigateToMainScreen()
}

class OnBoardingPresenter {
    private weak var view: OnBoardingViewProtocol?
    private let data: [OnBoardingModel]
    
    init(view: OnBoardingViewProtocol) {
        self.view = view
        self.data = onboardingData
    }
    
    func viewDidLoad() {
        view?.setupPages(count: data.count)
    }
    
    func numberOfPages() -> Int {
        return data.count
    }
    
    func modelForPage(at index: Int) -> OnBoardingModel? {
        guard index >= 0 && index < data.count else { return nil }
        return data[index]
    }
    
    func didTapNext(from index: Int) {
        let nextIndex = index + 1
        if nextIndex < data.count {
            view?.navigateToPage(at: nextIndex)
        } else {
            view?.navigateToMainScreen()
        }
    }
    
    func didTapSkip() {
        view?.navigateToMainScreen()
    }
}
