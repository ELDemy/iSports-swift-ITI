import UIKit
import SkeletonView
import Lottie
class LeaguesViewController: UIViewController, LeaguesView {
   
    

    @IBOutlet weak var tableView: UITableView!
    var presenter: LeaguePresenter!
    
    override func viewDidLoad() {
            super.viewDidLoad()
        let accent = UIColor(named: "accentColor") ?? .systemGreen
        self.title = NSLocalizedString(presenter.sport.capitalized, comment: "")

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [
            .foregroundColor: accent,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]

        let backItemAppearance = UIBarButtonItemAppearance()
        backItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.backButtonAppearance = backItemAppearance
        
        let backImage = UIImage(systemName: "chevron.backward")?
            .withTintColor(accent, renderingMode: .alwaysOriginal)
        appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)

        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = accent
            
            let nib = UINib(nibName: "TableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "cell")
            
            tableView.dataSource = self
            tableView.delegate = self
            
            tableView.rowHeight = 100
            tableView.estimatedRowHeight = 100
            tableView.isSkeletonable = true
            tableView.separatorStyle = .none
            
            self.view.layoutIfNeeded()
                    
            tableView.showAnimatedGradientSkeleton()
            presenter.fetchLeague()
        }
    func hideLoading() {
            tableView.hideSkeleton()
            

            let emptyView = EmptyStateView(
                message: String(format: NSLocalizedString("LEAGUES_NO_DATA", comment: ""), presenter.sport.capitalized),
                animationName: Constants.Lottie.emptyEvents
            )
            tableView.backgroundView = emptyView
            tableView.separatorStyle = .none
            
            tableView.reloadData()
        }
        
        func showLeagues() {
            tableView.hideSkeleton()
            
            if presenter.getCount() == 0 {
                let emptyView = EmptyStateView(
                    message: NSLocalizedString("LEAGUES_SEARCH_EMPTY", comment: ""),
                    animationName: Constants.Lottie.emptyEvents
                )
                tableView.backgroundView = emptyView
                tableView.separatorStyle = .none
            } else {
                tableView.backgroundView = nil
                tableView.separatorStyle = .none
            }
            
            tableView.reloadData()
        }
}


extension LeaguesViewController: SkeletonTableViewDataSource {
    
  
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "cell"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell

      
        cell.favBtn.isHidden = false

        let league = presenter.getLeague(at: indexPath.row)
        let placeholderImage = UIImage(named: presenter.sport)

        cell.setup(league, placeholder: placeholderImage)

        let isFav = presenter.isFavorite(at: indexPath.row)
        cell.updateFavIcon(isFav: isFav)

        cell.onFavTapped = { [weak self] in
            guard let self = self else { return }
            let newState = self.presenter.toggleFavorite(at: indexPath.row)
            cell.updateFavIcon(isFav: newState)
        }

        return cell
    }
}
extension LeaguesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("DEBUG: Row \(indexPath.row) was tapped")
            
            if presenter != nil {
                presenter.didSelectLeague(at: indexPath.row)
            } else {
                print("DEBUG: Presenter is nil!")
            }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension LeaguesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.filterLeagues(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() 
    }
}
