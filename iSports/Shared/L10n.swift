import Foundation

enum L10n: String {
    // Tab Bar
    case home = "tab_home"
    case favourites = "tab_favourites"
    case settings = "tab_settings"
    
    // Sports
    case basketball = "sport_basketball"
    case football = "sport_football"
    case tennis = "sport_tennis"
    case cricket = "sport_cricket"
    
    // Onboarding
    case onboardingSkip = "onboarding_skip"
    case onboardingNext = "onboarding_next"
    case onboardingGetStarted = "onboarding_get_started"
    
    case onboardingTitle1 = "onboarding_title_1"
    case onboardingDesc1 = "onboarding_desc_1"
    case onboardingTitle2 = "onboarding_title_2"
    case onboardingDesc2 = "onboarding_desc_2"
    case onboardingTitle3 = "onboarding_title_3"
    case onboardingDesc3 = "onboarding_desc_3"
    
    // League Details
    case leagueUpcomingEvents = "league_upcoming_events"
    case leagueLatestResults = "league_latest_results"
    case leaguePlayers = "league_players"
    case leagueTeams = "league_teams"
    case leagueNoUpcoming = "league_no_upcoming"
    case leagueNoResults = "league_no_results"
    case leagueNoTeams = "league_no_teams"
    case errorSomethingWentWrong = "error_something_went_wrong"
    case ok = "ok"
    
    // Match Details
    case matchStatistics = "match_statistics"
    case matchLineups = "match_lineups"
    case matchEvents = "match_events"
    case matchDetailsTitle = "match_details_title"
    case matchVs = "match_vs"
    
    // Team & Player Details
    case teamDetailsTitle = "team_details_title"
    case playerTennisTitle = "player_tennis_title"
    case playerProfileTitle = "player_profile_title"
    case teamsInLeagueTitle = "teams_in_league_title"
    case teamDetailsComingSoon = "team_details_coming_soon"
    case teamDetailsComingSoonMessage = "team_details_coming_soon_message"
    
    case GOALKEEPERS = "GOALKEEPERS"
    case DEFENDERS = "DEFENDERS"
    case MIDFIELDERS = "MIDFIELDERS"
    case FORWARDS = "FORWARDS"
    
    case playerBirthday = "player_birthday"
    case playerCountry = "player_country"
    case playerRank = "player_rank"
    case playerTitles = "player_titles"
    case playerMatchesWon = "player_matches_won"
    case playerMatchesLost = "player_matches_lost"
    case playerClayWl = "player_clay_wl"
    case playerHardWl = "player_hard_wl"
    case playerGrassWl = "player_grass_wl"
    
    case playerAge = "player_age"
    case playerSquadNumber = "player_squad_number"
    case playerMatchesPlayed = "player_matches_played"
    case playerGoals = "player_goals"
    case playerRating = "player_rating"
    
    // Settings Theme Modes
    case lightMode = "settings_light_mode"
    case darkMode = "settings_dark_mode"
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    static func sport(for name: String) -> String {
        switch name.lowercased() {
        case "football": return L10n.football.localized
        case "basketball": return L10n.basketball.localized
        case "tennis": return L10n.tennis.localized
        case "cricket": return L10n.cricket.localized
        default: return NSLocalizedString(name, comment: "")
        }
    }
}
