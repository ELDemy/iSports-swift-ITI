//
//  Leagues+CoreDataProperties.swift
//  iSports
//
//  Created by JETSMobileLabMini7 on 08/06/2026.
//
//

import Foundation
import CoreData


extension Leagues {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Leagues> {
        return NSFetchRequest<Leagues>(entityName: "Leagues")
    }

    @NSManaged public var leagueId: Int16
    @NSManaged public var leagueLogo: String?
    @NSManaged public var leagueName: String?
    @NSManaged public var sportName: String?

}

extension Leagues : Identifiable {

}
