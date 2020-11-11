//
//  SuiviManager.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 17/10/2020.
//

import Foundation

struct SuiviManager {
    let courseId : UUID
    let storage = OriEPS()
    var parcoursEnCoursList: [Detail]
    
    init(courseId: UUID) {
        self.courseId = courseId
        parcoursEnCoursList = storage.fetchParcoursEnCours(crsId: courseId)
    }
    
    func groupeEnCourseList() -> [DetailEnCourse] {
        var groupeEnCourseList: [DetailEnCourse] = []
        for det in parcoursEnCoursList {
            let now = Date()
            let diffComponents = Calendar.current.dateComponents([.second], from: det.depart!, to: now)
            let temps = Int32(diffComponents.second!)
            let prov = storage.fetchGroupeList(crsId: courseId).filter{ $0.id == det.groupeId }
            let prov2 = DetailEnCourse(groupe: prov[0], temps: temps, detail: det)
            groupeEnCourseList.append(prov2)
        }
        groupeEnCourseList.sort {
            $0.temps > $1.temps
        }
        return groupeEnCourseList
    }
    
    func groupeEnAttenteList() -> [Groupe] {
        var groupeEnAttenteList: [Groupe] = []
        var listeGlobale: [Groupe] = []
        listeGlobale = storage.fetchGroupeList(crsId: courseId)
        groupeEnAttenteList = listeGlobale.filter{
            let dict = $0
            return !parcoursEnCoursList.contains{ dict.id == $0.groupeId }
        }
        groupeEnAttenteList = groupeEnAttenteList.filter{
            let dict = $0
            return !groupesAyantTermines().contains{ dict.id == $0.id }
        }
        groupeEnAttenteList.sort {
            $0.nomGroupe.localizedStandardCompare($1.nomGroupe) == .orderedAscending
        }
        return groupeEnAttenteList
    }
    
    func nbParcoursRealises(groupeId: UUID) -> Int {
        var nbParcoursRealises: Int = 0
        nbParcoursRealises = storage.getNbParcoursRealises(grId: groupeId, crsId: courseId, parcId: nil)
        return nbParcoursRealises
    }
    
    
    func groupesAyantTermines() -> [Groupe]{
        let nbParcours = storage.getNbParcours(crsId: courseId)
        var groupesAyantTermines : [Groupe] = []
        for gr in storage.fetchGroupeList(crsId: courseId) {
            if nbParcoursRealises(groupeId: gr.id) == nbParcours {
                groupesAyantTermines.append(gr)
            }
        }
        return groupesAyantTermines
    }
    
    func termineDepuis(groupeId:UUID) -> Int32{
        let termineDepuis: Int32
        let detail = storage.termineDepuis(grId: groupeId, crsId: courseId)
        let fin = detail[0].arrivee
        let now = Date()
        let diffComponents = Calendar.current.dateComponents([.second], from: fin!, to: now)
        termineDepuis = Int32(diffComponents.second!)

        return termineDepuis
    }
}
