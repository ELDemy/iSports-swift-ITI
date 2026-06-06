import Foundation

protocol TeamsViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadData()
    func showError(message: String)
}

class TeamsPresenter {
    private weak var view: TeamsViewProtocol?
    private(set) var teams: [Team] = []
    
    init(view: TeamsViewProtocol) {
        self.view = view
    }
    
    func fetchTeams(sportName: String, leagueId: Int) {
        view?.showLoading()
        AlamofireManager.shared.getTeams(sportName: sportName, leagueId: leagueId) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                switch result {
                case .success(let fetchedTeams):
                    self?.teams = fetchedTeams
                    self?.view?.reloadData()
                case .failure(let error):
                    self?.view?.showError(message: error.localizedDescription)
                }
            }
        }
    }
}
