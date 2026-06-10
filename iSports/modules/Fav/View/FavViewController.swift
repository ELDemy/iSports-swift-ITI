//
//  FavViewController.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 02/05/2026.
//

import UIKit

class FavViewController: UIViewController, FavView {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var presenter: FavPresenter = {
            let nav = self.navigationController ?? UINavigationController()
            let router = AppRouter(navigationController: nav)
            return FavPresenter(view: self, router: router, sportName: "football")
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: - Styled Navigation Bar
        navigationItem.title = ""
        navigationController?.navigationBar.prefersLargeTitles = false

        let accent = UIColor(named: "accentColor") ?? .systemGreen
        let dynamicColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .white : accent
        }
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [
            .foregroundColor: dynamicColor,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]

        let backItemAppearance = UIBarButtonItemAppearance()
        backItemAppearance.normal.titleTextAttributes = [.foregroundColor: dynamicColor]
        appearance.backButtonAppearance = backItemAppearance
        
        let backImage = UIImage(systemName: "chevron.backward")
        appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)

        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = dynamicColor
        
        if presenter == nil {
            let router = AppRouter(navigationController: self.navigationController ?? UINavigationController())
            presenter = FavPresenter(view: self, router: router, sportName: "football")
        }
        
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.fetchFavorites()
    }
    
    func showEmptyState() {
        tableView.isHidden = false
        
 
        let emptyView = EmptyStateView(
            message: "No Favorites Yet\n\nExplore sports and add your favorite leagues to see them here!",
            animationName: Constants.Lottie.emptyEvents
        )
        
        tableView.backgroundView = emptyView
        tableView.separatorStyle = .none
        tableView.reloadData()
    }

    func showFavorites() {
        tableView.isHidden = false
        
        tableView.backgroundView = nil
        tableView.separatorStyle = .singleLine
        tableView.reloadData()
    }
    
    func confirmDeletion(at indexPath: IndexPath) {
        // Creating the Alert Controller
        let alert = UIAlertController(
            title: "Remove from Favorites",
            message: "Are you sure you want to remove this league from your favorites?",
            preferredStyle: .alert
        )
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            if let cell = self.tableView.cellForRow(at: indexPath) {
                UIView.animate(withDuration: 0.3, animations: {
                    cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    cell.alpha = 0
                }) { _ in
                    let sectionCountBefore = self.presenter.getNumberOfSections()
                    self.presenter.removeFavorite(at: indexPath)
                    let sectionCountAfter = self.presenter.getNumberOfSections()
                    
                    self.tableView.beginUpdates()
                    if sectionCountAfter < sectionCountBefore {
                        self.tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
                    } else {
                        self.tableView.deleteRows(at: [indexPath], with: .left)
                    }
                    self.tableView.endUpdates()
                    
                    if self.presenter.getNumberOfSections() == 0 {
                        self.showEmptyState()
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension FavViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.getNumberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getCount(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
            
            let coreDataLeague = presenter.getLeague(at: indexPath)
            
            cell.labelTxt.text = coreDataLeague.leagueName
            
            let sportType = coreDataLeague.sportName?.lowercased() ?? "football"
            let placeholderName = sportType
            
            let placeholderImage = UIImage(named: placeholderName)
            
            if let logoUrlString = coreDataLeague.leagueLogo, let url = URL(string: logoUrlString) {
                cell.imageV.sd_setImage(with: url, placeholderImage: placeholderImage)
            } else {
                cell.imageV.image = placeholderImage
            }
            
            cell.updateFavIcon(isFav: true)
            
            cell.onFavTapped = { [weak self] in
                guard let self = self else { return }
                self.confirmDeletion(at: indexPath)
            }
            
            return cell
        }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "AppPrimary") ?? .systemGreen
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .natural
        
        let sport = presenter.getSportName(for: section)
        label.text = L10n.sport(for: sport)
        
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: headerView.topAnchor),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
        
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.confirmDeletion(at: indexPath)
        }
    }
}

extension FavViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectLeague(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
