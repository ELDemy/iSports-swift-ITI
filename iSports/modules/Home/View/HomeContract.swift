import Foundation

protocol HomeViewProtocol: AnyObject {
    func displaySports(_ sports: [HomeSport])
}

protocol HomePresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectSport(at index: Int)
}

struct HomeSport {
    let name: String
    let displayName: String
    let image: String
}
