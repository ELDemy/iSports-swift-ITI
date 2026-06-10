import Foundation

class HomePresenter: HomePresenterProtocol {
    private weak var view: HomeViewProtocol?
    private let router: AppRouterProtocol
    private var sports: [HomeSport] = []

    init(view: HomeViewProtocol, router: AppRouterProtocol) {
        self.view = view
        self.router = router
    }

    func viewDidLoad() {
        sports = [
            HomeSport(name: "football", displayName: L10n.football.localized, image: "football"),
            HomeSport(name: "basketball", displayName: L10n.basketball.localized, image: "basketball"),
            HomeSport(name: "tennis", displayName: L10n.tennis.localized, image: "tennis"),
            HomeSport(name: "cricket", displayName: L10n.cricket.localized, image: "cricket")
        ]
        view?.displaySports(sports)
    }

    func didSelectSport(at index: Int) {
        guard index < sports.count else { return }
        let sport = sports[index]
        router.navigateToLeagues(for: sport.name)
    }
}
