//
//  DetailView.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 11/10/2020.
//

import Foundation

struct DetailManager {
    var enCourseList:[Detail]
    var parcoursRealiseList:[Detail]
    var allParcoursDeLaCourse:[Parcours]
    let storage:OriEPS = OriEPS()
    let groupe : Groupe
    
    init(groupe:Groupe) {
        self.groupe = groupe
        enCourseList = storage.fetchEnCourse(grId: groupe.id).sorted{
            $0.nomGroupe < $1.nomGroupe
        }
        parcoursRealiseList = storage.fetchRealise(grId: groupe.id).sorted{
            switch ($0.nomParcours.last!.isNumber, $1.nomParcours.last!.isNumber) {
            case (true, false):
                return false
            case (false, true):
                return true
            default:
                return $0.nomParcours < $1.nomParcours
            }
        }
        allParcoursDeLaCourse = storage.fetchParcoursList(crsId: groupe.courseId)
    }
    
    @discardableResult
    mutating func depart(courseId:UUID, groupeId: UUID, parcoursId: UUID, nomGroupe: String, nomParcours: String) -> Detail {
        let depart: Date = Date()
        let newDetail = Detail(courseId: courseId, groupeId: groupeId, arrivee: nil, depart: depart, temps: Int32(0), parcoursId: parcoursId, nomGroupe: nomGroupe, nomParcours: nomParcours, nbErreur: 0, nbValidation : 0)
        storage.depart(detail: newDetail)
        enCourseList = storage.fetchEnCourse(grId: groupeId).sorted{
            $0.nomGroupe < $1.nomGroupe
        }
        return newDetail
    }
    
    @discardableResult
    mutating func creerDetailParModifTemps(courseId:UUID, groupeId: UUID, parcoursId: UUID, nomGroupe: String, nomParcours: String, temps: Int32) -> Detail {
        let depart: Date = Date()
        let newDetail = Detail(courseId: courseId, groupeId: groupeId, arrivee: depart, depart: depart, temps: temps, parcoursId: parcoursId, nomGroupe: nomGroupe, nomParcours: nomParcours, nbErreur: 0, nbValidation : 0)
        storage.depart(detail: newDetail)
        enCourseList = storage.fetchEnCourse(grId: groupeId).sorted{
            $0.nomGroupe < $1.nomGroupe
        }
        return newDetail
    }
    
    mutating func arrivee() {
        let arr = Date()
        let diffComponents = Calendar.current.dateComponents([.second], from: enCourseList[0].depart!, to: arr)
        let temps = Int32(diffComponents.second!)
        storage.arrivee(detail: enCourseList[0], arr: arr, temps: temps)
        enCourseList = storage.fetchEnCourse(grId: groupe.id).sorted{
            $0.nomGroupe < $1.nomGroupe
        }
        parcoursRealiseList = storage.fetchRealise(grId: groupe.id).sorted{
            switch ($0.nomParcours.last!.isNumber, $1.nomParcours.last!.isNumber) {
            case (true, false):
                return false
            case (false, true):
                return true
            default:
                return $0.nomParcours < $1.nomParcours
            }
        }
    }
    
    func removeDetail(detail:Detail) {
        storage.removeDetail(detail: detail)
    }
    
    func updateDetailTemps(detailId:UUID, temps: Int32 ) {
        storage.updateDetailTemps(detailId: detailId, temps: temps)
    }
    
    func ListeParcoursRestants() -> [Parcours] {
        var listeParcoursRestants = allParcoursDeLaCourse
        for parcoursFait in parcoursRealiseList {
            listeParcoursRestants = listeParcoursRestants.filter { $0.id != parcoursFait.parcoursId }
        }
        listeParcoursRestants.sort{
            switch ($0.parcoursNom.last!.isNumber, $1.parcoursNom.last!.isNumber) {
            case (true, false):
                return false
            case (false, true):
                return true
            default:
                return $0.parcoursNom < $1.parcoursNom
            }
        }
        return listeParcoursRestants
    }
    
    func aTermine(groupeId: UUID, suiviManager: SuiviManager) -> Bool{
        let aTermine = suiviManager.groupesAyantTermines().contains(where: { $0.id == groupeId })
        return aTermine
    }
    
    func recordParcours(parcoursId: UUID) -> Detail {
        let rec: Detail
        let record = storage.fetchRecordParcours(parcoursId: parcoursId, courseId: groupe.courseId)
        if record.count >= 1 {
        rec = record[0]
        }else{
            rec = Detail(courseId: groupe.courseId, groupeId: groupe.id, arrivee: nil, depart: nil, temps: 0, parcoursId: parcoursId, nomGroupe: "Aucun", nomParcours: "", nbErreur : 0, nbValidation : 0)
        }
        return rec
    }
    

}
