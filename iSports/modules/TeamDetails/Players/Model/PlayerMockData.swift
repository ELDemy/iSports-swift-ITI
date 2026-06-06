import Foundation

class PlayerMockData {
    static func getAllPlayers() -> [PlayerModel] {
        return [
            // Goalkeepers
            PlayerModel(playerKey: 1, playerName: "Manuel Neuer", playerNumber: "1", playerCountry: nil, playerType: "Goalkeepers", playerAge: "38", playerImage: "onboarding1", playerLogo: nil, teamName: nil, teamKey: nil, playerMinutes: nil, playerBirthdate: nil, playerIsCaptain: nil,
                       playerMatchPlayed: nil, playerGoals: "6",playerRating: "6"),
            PlayerModel(playerKey: 2, playerName: "Sven Ulreich", playerNumber: "26", playerCountry: nil, playerType: "Goalkeepers", playerAge: "35", playerImage: "onboarding2", playerLogo: nil, teamName: nil, teamKey: nil, playerMinutes: nil, playerBirthdate: nil, playerIsCaptain: nil,
                        playerMatchPlayed: nil, playerGoals: "6",playerRating: "6"),
            PlayerModel(playerKey: 3, playerName: "Daniel Peretz", playerNumber: "18", playerCountry: nil, playerType: "Goalkeepers", playerAge: "23", playerImage: "onboarding3", playerLogo: nil, teamName: nil, teamKey: nil, playerMinutes: nil, playerBirthdate: nil, playerIsCaptain: nil,
                        playerMatchPlayed: nil, playerGoals: "6",playerRating: "6"),
            
            // Defenders
            PlayerModel(playerKey: 4, playerName: "Matthijs de Ligt", playerNumber: "4", playerCountry: nil, playerType: "Defenders", playerAge: "24", playerImage: "onboarding1", playerLogo: nil, teamName: nil, teamKey: nil, playerMinutes: nil, playerBirthdate: nil, playerIsCaptain: nil,
                        playerMatchPlayed: nil, playerGoals: "6",playerRating: "6"),
            PlayerModel(playerKey: 5, playerName: "Alphonso Davies", playerNumber: "19", playerCountry: nil, playerType: "Defenders", playerAge: "23", playerImage: "onboarding2", playerLogo: nil, teamName: nil, teamKey: nil, playerMinutes: nil, playerBirthdate: nil, playerIsCaptain: nil,
                        playerMatchPlayed: nil, playerGoals: "6",playerRating: "6"),
            PlayerModel(playerKey: 6, playerName: "Dayot Upamecano", playerNumber: "2", playerCountry: nil, playerType: "Defenders", playerAge: "25", playerImage: "onboarding3", playerLogo: nil, teamName: nil, teamKey: nil, playerMinutes: nil, playerBirthdate: nil, playerIsCaptain: nil,
                        playerMatchPlayed: nil, playerGoals: "6",playerRating: "6"),
            PlayerModel(playerKey: 7, playerName: "Kim Min-jae", playerNumber: "3", playerCountry: nil, playerType: "Defenders", playerAge: "27", playerImage: "onboarding1", playerLogo: nil, teamName: nil, teamKey: nil, playerMinutes: nil, playerBirthdate: nil, playerIsCaptain: nil,
                        playerMatchPlayed: nil, playerGoals: "6",playerRating: "6"),
            
            // Midfielders
            PlayerModel(playerKey: 8, playerName: "Joshua Kimmich", playerNumber: "6", playerCountry: nil, playerType: "Midfielders", playerAge: "29", playerImage: "onboarding2", playerLogo: nil, teamName: nil, teamKey: nil, playerMinutes: nil, playerBirthdate: nil, playerIsCaptain: nil,
                        playerMatchPlayed: nil, playerGoals: "6",playerRating: "6"),
            PlayerModel(playerKey: 9, playerName: "Leon Goretzka", playerNumber: "8", playerCountry: nil, playerType: "Midfielders", playerAge: "29", playerImage: "onboarding3", playerLogo: nil, teamName: nil, teamKey: nil, playerMinutes: nil, playerBirthdate: nil, playerIsCaptain: nil,
                        playerMatchPlayed: nil, playerGoals: "6",playerRating: "6"),
            PlayerModel(playerKey: 10, playerName: "Jamal Musiala", playerNumber: "42", playerCountry: nil, playerType: "Midfielders", playerAge: "21", playerImage: "onboarding1", playerLogo: nil, teamName: nil, teamKey: nil, playerMinutes: nil, playerBirthdate: nil, playerIsCaptain: nil,
                        playerMatchPlayed: nil, playerGoals: "6",playerRating: "6"),
            
            // Forwards
            PlayerModel(playerKey: 11, playerName: "Harry Kane", playerNumber: "9", playerCountry: nil, playerType: "Forwards", playerAge: "30", playerImage: "onboarding2", playerLogo: nil, teamName: nil, teamKey: nil, playerMinutes: nil, playerBirthdate: nil, playerIsCaptain: nil,
                        playerMatchPlayed: nil, playerGoals: "6",playerRating: "6"),
            PlayerModel(playerKey: 12, playerName: "Leroy Sané", playerNumber: "10", playerCountry: nil, playerType: "Forwards", playerAge: "28", playerImage: "onboarding3", playerLogo: nil, teamName: nil, teamKey: nil, playerMinutes: nil, playerBirthdate: nil, playerIsCaptain: nil,
                        playerMatchPlayed: nil, playerGoals: "6",playerRating: "6"),
            PlayerModel(playerKey: 13, playerName: "Thomas Müller", playerNumber: "25", playerCountry: nil, playerType: "Forwards", playerAge: "34", playerImage: "onboarding1", playerLogo: nil, teamName: nil, teamKey: nil, playerMinutes: nil, playerBirthdate: nil, playerIsCaptain: nil,
                        playerMatchPlayed: nil, playerGoals: "6",playerRating: "6"),
            PlayerModel(playerKey: 14, playerName: "Kingsley Coman", playerNumber: "11", playerCountry: nil, playerType: "Forwards", playerAge: "27", playerImage: "onboarding2", playerLogo: nil, teamName: nil, teamKey: nil, playerMinutes: nil, playerBirthdate: nil, playerIsCaptain: nil,
                        playerMatchPlayed: nil, playerGoals: "6",playerRating: "6")
        ]
    }
}
