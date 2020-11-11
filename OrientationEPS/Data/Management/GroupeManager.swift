//
//  GroupeManager.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 03/10/2020.
//

import Foundation


struct GroupeManager {
    var groupeList:[Groupe]
    let storage:OriEPS = OriEPS()
    let courseId : UUID
    
    init(courseId:UUID) {
        self.courseId = courseId
        groupeList = storage.fetchGroupeList(crsId: courseId).sorted{
            $0.nomGroupe.localizedStandardCompare($1.nomGroupe) == .orderedAscending
        }
    }
    mutating func affListe(){
        groupeList = storage.fetchGroupeList(crsId: courseId).sorted{
            $0.nomGroupe.localizedStandardCompare($1.nomGroupe) == .orderedAscending
        }
    }
    
    @discardableResult
    mutating func addGroupe(withName groupeName:String, inCourse courseId:UUID) -> Groupe {
        var group = groupeName
        if group == "" {
            group = "Coureur 1"
            var count = 1
            while groupeList.filter( { return $0.nomGroupe == group } ).count > 0 {
                count += 1
                group =  "Coureur " + String(count)
            }
        }
        let newGroupe = Groupe(courseId: courseId, nomGroupe: group)
        groupeList.append(newGroupe)
        storage.addNewGroupe(groupe: newGroupe)
        affListe()
        return newGroupe
    }

    @discardableResult
    mutating func addGroupeAvecNom(gr: Groupe) -> Groupe {
        let newGroupe = gr
        groupeList.append(newGroupe)
        storage.addNewGroupe(groupe: newGroupe)
        return newGroupe
    }
    
    mutating func removeGroupe(groupe:Groupe) {
        if let groupeIndex = groupeList.firstIndex(where: { (t) -> Bool in
            t.id == groupe.id
        }){
            storage.removeGroupe(groupe: groupeList[groupeIndex])
            groupeList = storage.fetchGroupeList(crsId: courseId)
            let allDetailGroupe = storage.fetchDetailListdunGroupe(crsId: courseId, grId: groupe.id)
            for detail in allDetailGroupe {
                storage.removeDetail(detail: detail)
            }
        }
        affListe()
    }
    
    @discardableResult
    mutating func updateNomGroupe(groupe: Groupe, nouveauNom:String) -> Groupe {
            let gr = groupe
        let groupeUp = Groupe(courseId: gr.id, nomGroupe: nouveauNom)
            storage.updateNomGroupe(groupe: gr, nom: nouveauNom)
            affListe()
        for detail in storage.fetchDetailListdunGroupe(crsId: gr.courseId, grId: gr.id) {
            storage.updateNomGroupeDansDetail(detail: detail, nom: nouveauNom)
        }
        affListe()
        return groupeUp
    }
    
}
