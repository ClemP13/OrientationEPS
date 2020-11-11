//
//  ModificationTempsManager.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 30/10/2020.
//

import Foundation

struct ModificationTempsManager {
    let storage:OriEPS = OriEPS()
    
    func getModificationTempsList(crsId: UUID, grId: UUID) -> [ParcoursModificationTemps] {
        var ModifList: [ParcoursModificationTemps] = []
        var item: ParcoursModificationTemps
        let parcoursList = storage.fetchParcoursList(crsId: crsId)
        let detailList = storage.fetchDetailListdunGroupe(crsId: crsId, grId: grId)
        for parc in parcoursList {
            let det = detailList.filter {$0.parcoursId == parc.id}
            if det.count > 0{
                item = ParcoursModificationTemps(parcours: parc, detail: det[0])
            }else{
                item = ParcoursModificationTemps(parcours: parc, detail: Detail(courseId: crsId, groupeId: grId, arrivee: nil, depart: nil, temps: 0, parcoursId: parc.id, nomGroupe: "A", nomParcours: parc.parcoursNom, nbErreur: 0, nbValidation: 0))
            }
            ModifList.append(item)
        }
        return ModifList
    }
    
    
    
}
