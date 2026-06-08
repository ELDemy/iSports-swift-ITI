
import Foundation
import CoreData
import UIKit
class CoreDataManager
{
    static let shared = CoreDataManager()
    private init(){}
    
    var contex : NSManagedObjectContext{
        return (UIApplication.shared.delegate as! AppDelegate)
            .persistentContainer.viewContext
    }
    
    
    func saveLeague(id: Int16, name: String, logo: String?, sportName: String) {
        let league = Leagues(context: contex)
        league.leagueId = id
        league.leagueName = name
        league.leagueLogo = logo
        league.sportName = sportName
        do {
           try contex.save()
            print("Saved successfully")
        }catch {
            print("failed to save ", error.localizedDescription)
        }
        
    }
    func fetchLeague() -> [Leagues]
    {
        let request : NSFetchRequest<Leagues> = Leagues.fetchRequest()
        do {
       let data =  try contex.fetch(request)
            return data
        }catch{
            print(error.localizedDescription)
            return []
        }
    }
    
    func deleteLeague (league : Leagues)
    {
        contex.delete(league)
        do {
            try contex.save()
            print( "Deleted successfully")
        }catch{
            print(error.localizedDescription)
        }
      
    }
    func isFavorite(id: Int16) -> Leagues? {
            let request: NSFetchRequest<Leagues> = Leagues.fetchRequest()
            request.predicate = NSPredicate(format: "leagueId == %d", id)
            
            do {
                let data = try contex.fetch(request)
                return data.first
            } catch {
                print("Failed to fetch favorite: ", error.localizedDescription)
                return nil
            }
        }
        
 
        func toggleFavorite(id: Int16, name: String, logo: String? , sportName: String) -> Bool {
            if let existingLeague = isFavorite(id: id) {
               
                deleteLeague(league: existingLeague)
                return false
            } else {
                saveLeague(id: id, name: name, logo: logo , sportName: sportName)
                return true
            }
        }
    func toggleLeagueFavoriteStatus(apiLeague: LeagueModel, sportName: String) {
        let leagueId = Int16(apiLeague.leagueKey ?? 0)
        let leagueName = apiLeague.leagueName ?? NSLocalizedString("UNKNOWN", comment: "")
        let logoUrlString = apiLeague.leagueLogo
        
        let isSaved = CoreDataManager.shared.toggleFavorite(id: leagueId, name: leagueName, logo: logoUrlString, sportName: sportName)
        
        if isSaved {
            print("Saved successfully with URL")
        } else {
            print("Deleted successfully")
        }
    }

}
