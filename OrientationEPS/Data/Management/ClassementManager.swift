//
//  ClassementManager.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 18/10/2020.
//

import Foundation

struct ClassementManager {
    let storage:OriEPS = OriEPS()
    func afficherClassement(course: CourseActuelle, type : Int, parcours: Int) -> [DetailClassement] {
        var parcId : UUID?
        if parcours > 0 { parcId = ParcoursManager(courseId: course.id!).parcoursList[parcours - 1].id }
        var Classement : [DetailClassement]?
        let ClasseProv = fetchClassement(courseId: course.id!, parcId: parcId, bonus: course.tempsBonus, malus: course.tempsMalus)
        if type == 0 {
             Classement = ClasseProv.sorted{ $0.nbParcoursRealises > $1.nbParcoursRealises }
        }else if type == 4{
            Classement = ClasseProv.sorted{ ($0.tempsMoy == 0 ? Int32.max : $0.tempsMoy) < ($1.tempsMoy == 0 ? Int32.max : $1.tempsMoy) }
        }else if type == 3{
            Classement = ClasseProv.sorted{ ($0.rkMoyen == 0 ? Int32.max : $0.rkMoyen) < ($1.rkMoyen == 0 ? Int32.max : $1.rkMoyen)}
        }else if type == 5{
            Classement = ClasseProv.sorted{ ($0.tempsTotal == 0 ? Int32.max : $0.tempsTotal) < ($1.tempsTotal == 0 ? Int32.max : $1.tempsTotal) }
        }else if type == 1{
             Classement = ClasseProv.sorted{ $0.nbErreur < $1.nbErreur }
        }else if type == 2{
             Classement = ClasseProv.sorted{  $0.nbValid > $1.nbValid }
        }

        return Classement!
    }
    
    func TempsAvecBonusMalus (tps: Int32, nbErreur: Int32, nbValid: Int32, bonus: Int16, malus: Int16) -> Int32 {
        var temps = tps
        let malus = nbErreur * Int32(malus)
        let bonus = nbValid * Int32(bonus)
        temps += malus
        temps -= bonus
        
        if temps < 0 {
            temps = 0
        }
        return temps
    }
    
    func fetchClassement(courseId: UUID, parcId: UUID?, bonus: Int16, malus: Int16) -> [DetailClassement] {
        let ListGroupe = storage.fetchGroupeList(crsId: courseId)
        var classementList : [DetailClassement] = []
        for gr in ListGroupe {
            let nbValid = Int32(storage.getNbValidTotalesParGroupe(grId: gr.id, crsId: courseId, parcId: parcId))
            let nbErreur = Int32(storage.getNbErreursTotalesParGroupe(grId: gr.id, crsId: courseId, parcId: parcId))
            let nbParcRealises = Int32(storage.getNbParcoursRealises(grId: gr.id, crsId: courseId, parcId: parcId))
            let total = Int32(TempsAvecBonusMalus(tps: storage.getTempsTotalParGroupe(grId: gr.id, crsId: courseId, parcId: parcId), nbErreur: nbErreur, nbValid: nbValid, bonus: bonus, malus: malus))
            let moy = Int32(TempsAvecBonusMalus(tps: storage.getTempsMoyenParGroupe(grId: gr.id, crsId: courseId, parcId: parcId), nbErreur: nbErreur, nbValid: nbValid, bonus: bonus, malus: malus))
            let rkMoyen = Int32(storage.getRKMoyenParGroupe(grId: gr.id, crsId: courseId, parcId: parcId))
            let item = DetailClassement(groupe: gr, nbValid: nbValid, nbErreur: nbErreur, tempsMoy: moy, tempsTotal: total, nbParcoursRealises: nbParcRealises, rkMoyen: rkMoyen)
            classementList.append(item)
        }
        return classementList
    }
    
}
