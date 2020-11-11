//
//  MaquetteManager.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 28/10/2020.
//

import Foundation

struct MaquetteManager {
    let storage:OriEPS = OriEPS()
    var MaquetteDistinctParcoursList:[MaquetteParcours]
    var MaquetteDistinctGroupeList:[MaquetteGroupe]
    
    init() {
        MaquetteDistinctGroupeList = storage.fetchDistinctMaquetteGroupeList().sorted{
            $0.nomMaquette < $1.nomMaquette
        }
        MaquetteDistinctParcoursList = storage.fetchDistinctMaquetteParcoursList().sorted{
            $0.nomMaquette < $1.nomMaquette
        }
        
    }
    
    mutating func affListeParcours() {
        MaquetteDistinctParcoursList = storage.fetchDistinctMaquetteParcoursList().sorted{
            $0.nomMaquette < $1.nomMaquette
        }
    }
    mutating func affListeGroupe() {
        MaquetteDistinctGroupeList = storage.fetchDistinctMaquetteGroupeList().sorted{
            $0.nomMaquette < $1.nomMaquette
        }
    }
    
    @discardableResult
    mutating func addMaquetteParcours(maquetteParcours:MaquetteParcours) -> MaquetteParcours {
        let newMaquette = MaquetteParcours(nomParcours: maquetteParcours.nomParcours, nomMaquette: maquetteParcours.nomMaquette, distance: maquetteParcours.distance)
        MaquetteDistinctParcoursList.append(newMaquette)
        storage.addNewMaquetteParcours(maquetteParcours: newMaquette)
        return newMaquette
    }
    
    @discardableResult
    mutating func addMaquetteGroupe(maquetteGroupe:MaquetteGroupe) -> MaquetteGroupe {
        let newMaquette = MaquetteGroupe(nomGroupe: maquetteGroupe.nomGroupe, nomMaquette: maquetteGroupe.nomMaquette)
        MaquetteDistinctGroupeList.append(newMaquette)
        storage.addNewMaquetteGroupe(maquetteGroupe: newMaquette)
        return newMaquette
    }
    
    mutating func removeMaquetteParcours(maquetteParcours:MaquetteParcours) {
            let detailMaquetteParcoursList = storage.fetchDetailMaquetteParcoursList(nomMaquette: maquetteParcours.nomMaquette)
            for detail in detailMaquetteParcoursList {
                storage.removeMaquetteParcours(maquetteParcours: detail)
            }
        affListeParcours()
    }
    
    mutating func removeMaquetteGroupe(maquetteGroupe:MaquetteGroupe) {
            let detailMaquetteGroupeList = storage.fetchDetailMaquetteGroupeList(nomMaquette: maquetteGroupe.nomMaquette)
            for detail in detailMaquetteGroupeList {
                storage.removeMaquetteGroupe(maquetteGroupe: detail)
            }
        affListeGroupe()
    }
    
    func nbParcoursInMaquette(nomMaquette: String) -> Int{
       let nb = storage.fetchDetailMaquetteParcoursList(nomMaquette: nomMaquette).count
        return nb
    }
    func nbGroupeInMaquette(nomMaquette: String) -> Int{
       let nb = storage.fetchDetailMaquetteGroupeList(nomMaquette: nomMaquette).count
        return nb
    }
    
    func getListDetailMaquetteParcours(nomMaquette: String) -> [MaquetteParcours]{
        let list = storage.fetchDetailMaquetteParcoursList(nomMaquette: nomMaquette)
        return list
    }
    
    func getListDetailMaquetteGroupe(nomMaquette: String) -> [MaquetteGroupe]{
        let list = storage.fetchDetailMaquetteGroupeList(nomMaquette: nomMaquette)
        return list
    }
}

