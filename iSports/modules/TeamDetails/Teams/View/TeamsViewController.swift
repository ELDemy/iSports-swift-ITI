import UIKit


// demy will do it but for my to test my mocked data

class TeamsViewController: UIViewController {
    
    var leagueId: Int = 0
    var sportName: String = "football"
    
    private var presenter: TeamsPresenter!
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 160)
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.hidesWhenStopped = true
        return ai
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = TeamsPresenter(view: self)
        setupUI()
        presenter.fetchTeams(sportName: sportName, leagueId: leagueId)
    }
    
    private func setupUI() {
        title = "Teams In League"
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TeamCollectionViewCell.self, forCellWithReuseIdentifier: TeamCollectionViewCell.identifier)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    
            collectionView.heightAnchor.constraint(equalToConstant: 180),
            
            activityIndicator.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ])
    }
    
   
}

extension TeamsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.teams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeamCollectionViewCell.identifier, for: indexPath) as? TeamCollectionViewCell else {
            return UICollectionViewCell()
        }
        let team = presenter.teams[indexPath.row]
        cell.configure(with: team)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let team = presenter.teams[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailsVC = storyboard.instantiateViewController(withIdentifier: "TeamDetailsViewController") as? TeamDetailsViewController else {
            return
        }
        detailsVC.team = team
        
        if let navigationController = navigationController {
            navigationController.pushViewController(detailsVC, animated: true)
        } else {
            detailsVC.modalPresentationStyle = .fullScreen
            present(detailsVC, animated: true, completion: nil)
        }
    }
}

extension TeamsViewController: TeamsViewProtocol {
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func showError(message: String) {
        print("Error fetching teams: \(message)")
    }
}
