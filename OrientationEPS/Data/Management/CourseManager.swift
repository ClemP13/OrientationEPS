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
    
    mutating func removeCourse(course:Course) {
        if let courseIndex = courseList.firstIndex(where: { (t) -> Bool in
            t.id == course.id
        }){
            storage.removeCourse(course: courseList[courseIndex])
            for parc in ParcoursManager(courseId: course.id).parcoursList {
                storage.removeParcours(parcours: parc)
            }
            for group in GroupeManager(courseId: course.id).groupeList {
                storage.removeGroupe(groupe: group)
            }
            let allDetailDeLaCourse = storage.fetchDetailList(crsId: course.id)
            for detail in allDetailDeLaCourse {
                storage.removeDetail(detail: detail)
            }
        }
        affListe()
    }
    
    @discardableResult
    mutating func updateNomCourse(course:Course, nouveauNom:String) -> Course {
        let cr = course
        let courseUp = Course(nomCourse: nouveauNom, dateCreation: cr.dateCreation, tempsBonus: cr.tempsBonus, tempsMalus: cr.tempsMalus)
        storage.updateNomCourse(course: cr,nom: nouveauNom)
        affListe()
        return courseUp
    }
    
    func updateMalus(course:Course, malus:Int16) -> Course {
        
        let courseUp = Course(id: course.id, nomCourse: course.nomCourse, dateCreation: course.dateCreation, tempsBonus: course.tempsBonus, tempsMalus: malus)
        if let courseIndex = courseList.firstIndex(where: { (t) -> Bool in
            t.id == course.id
        }){
            storage.updateMalus(course: courseList[courseIndex],nb: malus)
        }
        return courseUp
    }
    
    
    func updateBonus(course:Course, bonus:Int16) -> Course {
        let courseUp = Course(id: course.id, nomCourse: course.nomCourse,  dateCreation: course.dateCreation, tempsBonus: bonus, tempsMalus: course.tempsMalus)
        if let courseIndex = courseList.firstIndex(where: { (t) -> Bool in
            t.id == course.id
        }){
            storage.updateBonus(course: courseList[courseIndex],nb: bonus)
        }
        return courseUp
    }
    
    func indexInListBonusMalus(tempsBonusMalus: Int) -> Int{
        let tempsBonusMalusEnSec = [0,5,10,15,30,45,60,90,120,180,240,300,600,1200,1800]
        let ind = tempsBonusMalusEnSec.firstIndex(of: tempsBonusMalus) ?? 0
        return ind
    }
}
