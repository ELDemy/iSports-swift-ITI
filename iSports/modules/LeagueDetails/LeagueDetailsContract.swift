import Foundation

protocol LeagueDetailsViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func displayData(upcoming: [Event], latest: [LatestEvent], teams: [Team])
    func reloadData()
    func toggleFavoriteState(isFavorite: Bool)
}

protocol LeagueDetailsPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapFavorite()
    func didSelectTeam(at index: Int)
}
