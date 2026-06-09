//
//  skileton.swift
//  iSports
//
//  Created by JETSMobileLabMini9 on 09/06/2026.
//

import UIKit
import SkeletonView

// MARK: - UICollectionViewDataSource & Delegate
extension LeagueDetailsViewController: UICollectionViewDelegate, SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        guard let section = LeagueSection(rawValue: indexPath.section) else {
            return "UpcomingEventCell"
        }
        switch section {
        case .upcoming:
            return "UpcomingEventCell"
        case .latest:
            return LatestEventsContainerCell.reuseIdentifier
        case .teams:
            return "TeamCircularCell"
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sec = LeagueSection(rawValue: section) else { return 0 }
        switch sec {
        case .upcoming: return 3
        case .latest: return 1
        case .teams: return 5
        }
    }
    
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return LeagueSection.allCases.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        LeagueSection.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sec = LeagueSection(rawValue: section) else { return 0 }
        switch sec {
        case .upcoming: return max(upcomingEvents.count, 1)   // 1 = empty state cell
        case .latest:   return 1                              // container cell (handles empty internally)
        case .teams:    return max(teams.count, 1)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = LeagueSection(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        switch section {

        case .upcoming:
            if upcomingEvents.isEmpty {
                return emptyCell(for: collectionView, at: indexPath, section: .upcoming)
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingEventCell",
                                                          for: indexPath) as! UpcomingEventCell
            cell.configure(with: upcomingEvents[indexPath.row])
            return cell

        case .latest:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LatestEventsContainerCell.reuseIdentifier,
                for: indexPath) as! LatestEventsContainerCell
            cell.configure(with: latestEvents)
            cell.onEventTapped = { [weak self] event in
                self?.navigateToMatchDetails(with: event)
            }
            return cell

        case .teams:
            if teams.isEmpty {
                return emptyCell(for: collectionView, at: indexPath, section: .teams)
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCircularCell",
                                                          for: indexPath) as! TeamCircularCell
            cell.configure(with: teams[indexPath.row])
            return cell
        }
    }

    private func emptyCell(for cv: UICollectionView,
                           at indexPath: IndexPath,
                           section: LeagueSection) -> EmptySectionCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: EmptySectionCell.reuseIdentifier,
                                          for: indexPath) as! EmptySectionCell
        cell.configure(icon: section.emptyIcon, message: section.emptyMessage)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier,
            for: indexPath) as! SectionHeaderView

        if let section = LeagueSection(rawValue: indexPath.section) {
            let title = section.title(for: currentSportName)
            let count: Int? = {
                switch section {
                case .upcoming: return upcomingEvents.isEmpty ? nil : upcomingEvents.count
                case .latest:   return latestEvents.isEmpty   ? nil : latestEvents.count
                case .teams:    return teams.isEmpty           ? nil : teams.count
                }
            }()
            header.configure(title: title, count: count)
        }
        return header
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = LeagueSection(rawValue: indexPath.section) else { return }
        switch section {
        case .upcoming:
            guard !upcomingEvents.isEmpty else { return }
            navigateToMatchDetails(with: upcomingEvents[indexPath.row])
            
        case .latest:
            break
            
        case .teams:
            guard !teams.isEmpty else { return }
            let selectedTeam = teams[indexPath.row]
            let sport = sportName.lowercased()
        
            if sport == "basketball" || sport == "cricket" {
                let alert = UIAlertController(
                    title: "Coming Soon",
                    message: "Team details for \(sport.capitalized) will be available soon. Stay tuned!",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
                return
            }
            
            if sport == "tennis" {
                let playerVC = PlayerDetailsViewController()
                let minimalPlayer = PlayerModel(
                    playerKey: selectedTeam.teamKey,
                    playerName: selectedTeam.teamName,
                    playerNumber: nil,
                    playerCountry: nil,
                    playerType: nil,
                    playerAge: nil,
                    playerImage: selectedTeam.teamLogo,
                    playerLogo: selectedTeam.teamLogo,
                    teamName: nil,
                    teamKey: nil,
                    playerMinutes: nil,
                    playerBirthdate: nil,
                    playerIsCaptain: nil,
                    playerMatchPlayed: nil,
                    playerGoals: nil,
                    playerRating: nil,
                    playerBday: nil,
                    stats: nil
                )
                playerVC.player = minimalPlayer
                playerVC.sportName = self.sportName
                navigationController?.pushViewController(playerVC, animated: true)
            } else {
                guard let vc = storyboard?.instantiateViewController(withIdentifier: "TeamDetailsViewController")
                        as? TeamDetailsViewController else { return }
                vc.team = selectedTeam
                vc.sportName = self.sportName
                navigationController?.pushViewController(vc, animated: true)
            }
            presenter.didSelectTeam(at: indexPath.row)
        }
    }
    
    private func navigateToMatchDetails(with event: Event) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "MatchDetailsViewController")
                as? MatchDetailsViewController else { return }
        
        let presenter = MatchDetailsPresenter(view: vc, event: event)
        vc.presenter = presenter
        navigationController?.pushViewController(vc, animated: true)
    }
}
