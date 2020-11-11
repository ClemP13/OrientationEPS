//
//  ParcoursManager.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 15/10/2020.
//

import Foundation

struct ParcoursManager {
    var parcoursList:[Parcours]
    let storage:OriEPS = OriEPS()
    let ListeAlpha = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    let courseId : UUID
    
    init(courseId:UUID){
        self.courseId = courseId
        parcoursList = storage.fetchParcoursList(crsId: courseId).sorted{
            switch ($0.parcoursNom.last?.isNumber, $1.parcoursNom.last?.isNumber) {
            case (true, false):
                    return false
                case (false, true):
                    return true
                case (nil, _):
                    return false
                case (_, nil):
                    return true
            default:
                return $0.parcoursNom < $1.parcoursNom
            }
        }
    }
    
    mutating func affListe(){
        parcoursList = storage.fetchParcoursList(crsId: courseId).sorted{
            switch ($0.parcoursNom.last?.isNumber, $1.parcoursNom.last?.isNumber) {
            case (true, false):
                    return false
                case (false, true):
                    return true
                case (nil, _):
                    return false
                case (_, nil):
                    return true
            default:
                return $0.parcoursNom < $1.parcoursNom
            }
        }
    }
    
    @discardableResult
    mutating func addParcours(courseId:UUID, parcoursNum:Int16, distance: Int16) -> Parcours {
        var parcoursNom = "Parcours A"
        var num = 0
        while parcoursList.filter({$0.parcoursNom == parcoursNom}).count > 0 {
            num += 1
            parcoursNom = parcNom(num: num)
        }
        
        let newParcours = Parcours(courseId: courseId, parcoursNum: parcoursNum, parcoursNom: parcoursNom, distance: distance)
        parcoursList.append(newParcours)
        storage.addNewParcours(parcours: newParcours)
        return newParcours
    }
    
    @discardableResult
    mutating func addParcoursAvecNom(parc: Parcours, distance: Int16) -> Parcours {
        let newParcours = parc
        parcoursList.append(newParcours)
        affListe()
        storage.addNewParcours(parcours: newParcours)
        return newParcours
    }
    
    mutating func removeParcoursFromStepper(parcours:Parcours) {
        if let parcoursIndex = parcoursList.firstIndex(where: { (t) -> Bool in
            t.id == parcours.id
        }){
            storage.removeParcours(parcours: parcoursList[parcoursIndex])
            affListe()
            let allDetailParcours = storage.fetchDetailListdunParcours(crsId: courseId, parcId: parcours.id)
            for detail in allDetailParcours {
                storage.removeDetail(detail: detail)
            }
        }
    }
    
    @discardableResult
    mutating func updateNomParcours(parcours: Parcours, nouveauNom: String, distance: Int16) -> Parcours {
        let parc = parcours
        let parcoursUp = Parcours(courseId: parc.courseId, parcoursNum: parc.parcoursNum, parcoursNom: nouveauNom, distance: distance)
        storage.updateNomParcours(parcours: parc, nom: nouveauNom, distance: distance)
        affListe()
        for detail in storage.fetchDetailListdunParcours(crsId: parc.courseId, parcId: parc.id) {
            storage.updateNomParcoursDansDetail(detail: detail, nom: nouveauNom)
        }
        return parcoursUp
    }
    
    func parcNom(num: Int) -> String{
        let numr = num - 1
        var nom = "Parcours "
        if num <= 26 {
            nom += ListeAlpha[Int(numr)]
        }else{
            nom += NomPlusLong(num: numr)
        }
        return nom
    }
    
    func NomPlusLong(num: Int) -> String{
        var nom: String
        var numero = num
        var index1 = 0
        while numero > 25 {
 
            index1 += 1
            numero -= 26
        }
        nom = ListeAlpha[Int(numero)]+String(index1)
        return nom
    }
}
