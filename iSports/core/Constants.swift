import Foundation

enum Constants {
    
    // MARK: - API Configuration
    enum API {
        static let baseURL = "https://apiv2.allsportsapi.com"
    }
    
    // MARK: - Storyboards
    enum Storyboards {
        static let main = "Main"
    }
    
    // MARK: - ViewController Identifiers
    enum ViewControllers {
        static let mainTabBarVC = "MainTabBarController"
        static let onBoardingVC = "OnBoardingViewController"
        static let sportsVC = "SportsViewController"
        static let leaguesVC = "LeaguesViewController"
        static let leagueDetailsVC = "LeagueDetailsViewController"
        static let teamVC = "TeamViewController"
        static let favoritesVC = "FavViewController"
    }
    
    // MARK: - Cell Identifiers
    enum Cells {
        static let sportCollectionCell = "SportCollectionViewCell"
        static let leagueTableCell = "LeagueTableViewCell"
        static let upcomingEventCell = "UpcomingEventCell"
        static let latestEventCell = "LatestEventCell"
        static let teamCollectionCell = "TeamCell"
        static let sectionHeaderView = "SectionHeaderView"
        static let emptyStateCell = "EmptyStateCell"
        static let bannerCell = "BannerCollectionViewCell"
    }
    
    enum Defaults{
        static let themeKey = "themeKey"
        static let onboarding = "onboarding"
        static let soundKey = "soundKey"
    }
    
    enum Icons{
        static let lightMode = "moon.fill"
        static let darkMode = "sun.max.fill"
        static let soundOff = "speaker.wave.2.fill"
        static let soundOn = "speaker.slash.fill"
        static let isFav = "star.fill"
        static let noFav = "star"
    }
    
    enum Lottie{
        static let emptyEvents = "empty_events"
    }

    enum Sounds {
        static let whistle = (name: "whistle", ext: "mp3")
        static let cheering = (name: "cheering", ext: "mp3")
        static let remove = (name: "paper", ext: "mp3")
        static let fav = (name: "pop", ext: "mp3")
        static let click = (name: "click", ext: "mp3")
        static let basketball = (name: "basketball", ext: "mp3")
        static let tennis = (name: "tennis", ext: "mp3")
        
        static func getSound(for sportName: String) -> (name: String, ext: String) {
            switch sportName.lowercased() {
            case "basketball":
                return basketball
            case "tennis", "cricket":
                return tennis
            case "football":
                return whistle
            default:
                return whistle
            }
        }
    }
}

