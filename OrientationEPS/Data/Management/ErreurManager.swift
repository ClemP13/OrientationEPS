//
//  ErreurManager.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 21/10/2020.
//

import Foundation

struct ErreurManager {
    let storage:OriEPS = OriEPS()
    
    mutating func updateNbErreur(detail: Detail, nbErreur:Int16,parcoursRealiseList: [Detail]) {
            storage.updateNbErreur(detail: detail, nb: nbErreur)
    }
    
    mutating func updateNbValidation(detail: Detail, nbValid:Int16,parcoursRealiseList: [Detail]) {
            storage.updateNbValidation(detail: detail, nb: nbValid)
    }
    
    func ArrayNbErreur(parcoursRealiseList: [Detail]) -> [Int16] {
        var err : [Int16] = []
        for parc in (parcoursRealiseList) {
            err.append(parc.nbErreur)
        }
        print(err)
        return err
    }
    
    func ArrayNbValid(parcoursRealiseList: [Detail]) -> [Int16] {
        var valid : [Int16] = []
        for parc in (parcoursRealiseList) {
            valid.append(parc.nbValidation)
        }
        print(valid)
        return valid
    }
}
