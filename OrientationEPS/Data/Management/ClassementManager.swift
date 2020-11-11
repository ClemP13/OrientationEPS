//
//  ClassementManager.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 18/10/2020.
//

import Foundation

struct ClassementManager {
    let storage:OriEPS = OriEPS()

    func afficherClassement(objCourse: Course, type : Int, parcours: Int) -> [DetailClassement] {
        var parcId : UUID?
        if parcours > 0 {
            parcId = ParcoursManager(courseId: objCourse.id).parcoursList[parcours - 1].id
        }
        var Classement : [DetailClassement]?
        if type == 0 {
            let ClasseProv = fetchClassement(objCourse: objCourse, parcId: parcId)
             Classement = ClasseProv.sorted{
                $0.nbParcoursRealises > $1.nbParcoursRealises
            }
        }else if type == 4{
            let ClasseProv = fetchClassement(objCourse: objCourse, parcId: parcId)
            Classement = ClasseProv.sorted{ ($0.tempsMoy == 0 ? Int32.max : $0.tempsMoy) < ($1.tempsMoy == 0 ? Int32.max : $1.tempsMoy)   
            }
        }else if type == 3{
            let ClasseProv = fetchClassement(objCourse: objCourse, parcId: parcId)
            Classement = ClasseProv.sorted{ ($0.rkMoyen == 0 ? Int32.max : $0.rkMoyen) < ($1.rkMoyen == 0 ? Int32.max : $1.rkMoyen)
            }
        }else if type == 5{
            let ClasseProv = fetchClassement(objCourse: objCourse, parcId: parcId)
            Classement = ClasseProv.sorted{ ($0.tempsTotal == 0 ? Int32.max : $0.tempsTotal) < ($1.tempsTotal == 0 ? Int32.max : $1.tempsTotal)
            }
        }else if type == 1{
            let ClasseProv = fetchClassement(objCourse: objCourse, parcId: parcId)
             Classement = ClasseProv.sorted{
                $0.nbErreur < $1.nbErreur
            }
        }else if type == 2{
            let ClasseProv = fetchClassement(objCourse: objCourse, parcId: parcId)
             Classement = ClasseProv.sorted{
                $0.nbValid > $1.nbValid
            }
        }

        return Classement!
    }
    
    func TempsAvecBonusMalus (objCourse: Course , tps: Int32, nbErreur: Int32, nbValid: Int32) -> Int32 {
        var temps = tps
        let malus = nbErreur * Int32(objCourse.tempsMalus)
        let bonus = nbValid * Int32(objCourse.tempsBonus)
        temps += malus
        temps -= bonus
        
        if temps < 0 {
            temps = 0
        }
        return temps
    }
    
    func fetchClassement(objCourse: Course, parcId: UUID?) -> [DetailClassement] {
        let ListGroupe = storage.fetchGroupeList(crsId: objCourse.id)
        var classementList : [DetailClassement] = []
        for gr in ListGroupe {
            let nbValid = Int32(storage.getNbValidTotalesParGroupe(grId: gr.id, crsId: objCourse.id, parcId: parcId))
            let nbErreur = Int32(storage.getNbErreursTotalesParGroupe(grId: gr.id, crsId: objCourse.id, parcId: parcId))
            let nbParcRealises = Int32(storage.getNbParcoursRealises(grId: gr.id, crsId: objCourse.id, parcId: parcId))
            let total = Int32(TempsAvecBonusMalus(objCourse: objCourse, tps: storage.getTempsTotalParGroupe(grId: gr.id, crsId: objCourse.id, parcId: parcId), nbErreur: nbErreur, nbValid: nbValid))
            let moy = Int32(TempsAvecBonusMalus(objCourse: objCourse, tps: storage.getTempsMoyenParGroupe(grId: gr.id, crsId: objCourse.id, parcId: parcId), nbErreur: nbErreur, nbValid: nbValid))
            let rkMoyen = Int32(storage.getRKMoyenParGroupe(grId: gr.id, crsId: objCourse.id, parcId: parcId))
            let item = DetailClassement(groupe: gr, nbValid: nbValid, nbErreur: nbErreur, tempsMoy: moy, tempsTotal: total, nbParcoursRealises: nbParcRealises, rkMoyen: rkMoyen)
            classementList.append(item)
        }
        return classementList
    }
    
}
