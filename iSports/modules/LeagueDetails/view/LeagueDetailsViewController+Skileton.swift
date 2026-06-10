//
//  skileton.swift
//  iSports
//
//  Created by JETSMobileLabMini9 on 09/06/2026.
//

import SkeletonView
import UIKit

extension LeagueDetailsViewController: UICollectionViewDelegate,
    SkeletonCollectionViewDataSource
{

    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        LeagueSection.allCases.count
    }

    func collectionSkeletonView(
        _ skeletonView: UICollectionView,
        cellIdentifierForItemAt indexPath: IndexPath
    ) -> ReusableCellIdentifier {
        guard let section = LeagueSection(rawValue: indexPath.section) else {
            return "UpcomingEventCell"
        }
        switch section {
        case .upcoming: return "UpcomingEventCell"
        case .latest: return LatestEventsContainerCell.reuseIdentifier
        case .teams: return "TeamCircularCell"
        }
    }

    func collectionSkeletonView(
        _ skeletonView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch LeagueSection(rawValue: section) {
        case .upcoming: return 3
        case .latest: return 1
        case .teams: return 5
        default: return 0
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        LeagueSection.allCases.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch LeagueSection(rawValue: section) {
        case .upcoming: return max(upcomingEvents.count, 1)
        case .latest: return 1
        case .teams: return max(teams.count, 1)
        default: return 0
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let section = LeagueSection(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        switch section {
        case .upcoming:
            guard !upcomingEvents.isEmpty else {
                return emptyCell(
                    for: collectionView,
                    at: indexPath,
                    section: .upcoming
                )
            }
            let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: "UpcomingEventCell",
                    for: indexPath
                ) as! UpcomingEventCell
            cell.configure(with: upcomingEvents[indexPath.row])
            return cell

        case .latest:
            let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: LatestEventsContainerCell
                        .reuseIdentifier,
                    for: indexPath
                ) as! LatestEventsContainerCell
            cell.configure(with: latestEvents)
            cell.onEventTapped = { [weak self] event in
                guard let self else { return }
                presenter.didSelectEvent(event: event)
            }
            return cell

        case .teams:
            guard !teams.isEmpty else {
                return emptyCell(
                    for: collectionView,
                    at: indexPath,
                    section: .teams
                )
            }
            let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: "TeamCircularCell",
                    for: indexPath
                ) as! TeamCircularCell
            cell.configure(with: teams[indexPath.row])
            return cell
        }
    }

    private func emptyCell(
        for cv: UICollectionView,
        at indexPath: IndexPath,
        section: LeagueSection
    ) -> EmptySectionCell {
        let cell =
            cv.dequeueReusableCell(
                withReuseIdentifier: EmptySectionCell.reuseIdentifier,
                for: indexPath
            ) as! EmptySectionCell
        cell.configure(icon: section.emptyIcon, message: section.emptyMessage)
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let header =
            collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                for: indexPath
            ) as! SectionHeaderView

        guard let section = LeagueSection(rawValue: indexPath.section) else {
            return header
        }
        let count: Int? = {
            switch section {
            case .upcoming:
                return upcomingEvents.isEmpty ? nil : upcomingEvents.count
            case .latest: return latestEvents.isEmpty ? nil : latestEvents.count
            case .teams: return teams.isEmpty ? nil : teams.count
            }
        }()
        header.configure(
            title: section.title(for: currentSportName),
            count: count
        )
        return header
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let section = LeagueSection(rawValue: indexPath.section) else {
            return
        }
        switch section {
        case .upcoming:
            break

        case .latest:
            guard !latestEvents.isEmpty else { return }
            presenter.didSelectEvent(event: latestEvents[indexPath.row])
            break

        case .teams:
            guard !teams.isEmpty else { return }

            let team = teams[indexPath.row]
            let sport = sportName.lowercased()

            let selected = presenter.didSelectTeam(team: team)
            if !selected {
                let alert = UIAlertController(
                    title: "Coming Soon",
                    message:
                        "Team details for \(sport.capitalized) will be available soon.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
                return
            }
        }
    }
}
