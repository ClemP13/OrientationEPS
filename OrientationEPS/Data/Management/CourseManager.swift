//
//  CourseManager.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 29/09/2020.
//

import Foundation

struct CourseManager {
    var courseList:[Course]
    let storage:OriEPS = OriEPS()
    
    init(){
        courseList = storage.fetchCourseList().sorted{
            $0.dateCreation > $1.dateCreation
        }
    }
    mutating func affListe(){
        courseList = storage.fetchCourseList().sorted{
            $0.dateCreation > $1.dateCreation
        }
    }
    
    mutating func recupListe() -> [Course] {
        let List = storage.fetchCourseList().sorted{
            $0.dateCreation > $1.dateCreation
        }
        return List
    }
    
    @discardableResult
    mutating func addCourse(withName courseName:String) -> Course {
        var courseN: String = courseName
        
        if courseN == "" {
            courseN = "Course 1"
            var count = 1
            while courseList.filter( { return $0.nomCourse == courseN } ).count > 0 {
                count += 1
                courseN = "Course \(count)"
            }
        }else{
            var nom = courseN
            var count = 0
            while courseList.filter( { return $0.nomCourse == nom } ).count > 0 {
                count += 1
                nom = courseN + "(" + String(count) + ")"
            }
            courseN = nom
        }
        let now: Date = Date()
        let newCourse = Course(nomCourse: courseN, dateCreation: now, tempsBonus: 0, tempsMalus: 0)
        courseList.append(newCourse)
        storage.addNewCourse(course: newCourse)
        affListe()
        return newCourse
    }
    
    mutating func removeCourse(courseId:UUID) {
            storage.removeCourse(courseId: courseId)
            for parc in ParcoursManager(courseId: courseId).parcoursList {
                storage.removeParcours(parcours: parc)
            }
            for group in GroupeManager(courseId: courseId).groupeList {
                storage.removeGroupe(groupe: group)
            }
            let allDetailDeLaCourse = storage.fetchDetailList(crsId: courseId)
            for detail in allDetailDeLaCourse {
                storage.removeDetail(detail: detail)
            } 
        affListe()
    }
    
    mutating func updateNomCourse(courseId:UUID, nouveauNom:String) {
        storage.updateNomCourse(courseId: courseId,nom: nouveauNom)
        affListe()
    }
    
    func updateMalus(courseId: UUID, malus:Int16) {
            storage.updateMalus(courseId: courseId,nb: malus)
        CourseActuelle().tempsMalus = malus

    }
    
    
    func updateBonus(courseId:UUID, bonus:Int16) {
        storage.updateBonus(courseId: courseId,nb: bonus)
        CourseActuelle().tempsBonus = bonus
    }
    
    func indexInListBonusMalus(tempsBonusMalus: Int) -> Int{
        let tempsBonusMalusEnSec = [0,5,10,15,30,45,60,90,120,180,240,300,600,1200,1800]
        let ind = tempsBonusMalusEnSec.firstIndex(of: tempsBonusMalus) ?? 0
        return ind
    }
}
