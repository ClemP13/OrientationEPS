//
//  Course.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 29/09/2020.
//

import Foundation

class CourseActuelle : ObservableObject {
    @Published var id : UUID?
    @Published var nomCourse : String = ""
    @Published var dateCreation : Date? = nil
    @Published var tempsBonus : Int16 = 0
    @Published var tempsMalus : Int16 = 0
    
}

struct Course : Identifiable {
    var id = UUID()
    let nomCourse : String
    let dateCreation : Date
    let tempsBonus : Int16
    let tempsMalus : Int16
}

struct Groupe : Identifiable {
    var id = UUID()
    let courseId : UUID
    let nomGroupe : String
}

struct Detail : Identifiable {
    var id = UUID()
    let courseId : UUID
    let groupeId : UUID
    let arrivee : Date?
    let depart : Date?
    let temps : Int32
    let parcoursId : UUID
    let nomGroupe : String
    let nomParcours : String
    let nbErreur : Int16
    let nbValidation : Int16
}

struct Parcours : Identifiable {
    var id = UUID()
    let courseId : UUID
    let parcoursNum : Int16
    let parcoursNom : String
    let distance : Int16
}

struct DetailEnCourse : Identifiable {
    var id = UUID()
    let groupe : Groupe
    let temps : Int32
    let detail : Detail
}

struct DetailClassement : Identifiable {
    var id = UUID()
    let groupe : Groupe
    let nbValid : Int32
    let nbErreur : Int32
    let tempsMoy : Int32
    let tempsTotal : Int32
    let nbParcoursRealises : Int32
    let rkMoyen: Int32
}

struct MaquetteParcours : Identifiable {
    var id = UUID()
    let nomParcours : String
    let nomMaquette : String
    let distance : Int16
}

struct MaquetteGroupe : Identifiable {
    var id = UUID()
    let nomGroupe : String
    let nomMaquette : String
}

struct ParcoursModificationTemps : Identifiable {
    var id = UUID()
    let parcours : Parcours
    let detail : Detail
}
