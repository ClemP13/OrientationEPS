//
//  ArriveeManager.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 19/10/2020.
//

import Foundation

struct ArriveeManager {
    let storage:OriEPS = OriEPS()
    

    func dernierParcours(groupeId: UUID) -> Detail {
        let touslesparcours = storage.fetchRealise(grId: groupeId)
        let parcoursDansLordre = touslesparcours.sorted{
            $0.arrivee! > $1.arrivee!
        }
        let dernierParcours = parcoursDansLordre[0]
        return dernierParcours
    }
    
    
    
}
