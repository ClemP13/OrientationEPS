//
//  CoreDataStorage.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 29/09/2020.
//

import Foundation
import CoreData

class OriEPS {
    
    
    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "OrientationEPS")
            container.loadPersistentStores { description, error in
                if let error = error {
                     fatalError("Unable to load persistent stores: \(error)")
                }
            }
            return container
        }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
    // ------------------------------- Course -------------------------------
    func fetchCourseList() -> [Course] {
        let CourseList: [Course]
        let fetchRequest:NSFetchRequest<CDCourse> = CDCourse.fetchRequest()
        if let rawCourseList = try? context.fetch(fetchRequest) {
            CourseList = rawCourseList.compactMap({ (rawCourse: CDCourse) -> Course? in
                Course(fromCoreDataObject: rawCourse)
            })
        } else {
            CourseList = []
        }
        return CourseList
    }
    
    func addNewCourse(course:Course) {
        let newCourse = CDCourse(context: context)
            newCourse.id = course.id
            newCourse.nomCourse = course.nomCourse
            newCourse.dateCreation = course.dateCreation
            newCourse.tempsBonus = course.tempsBonus
            newCourse.tempsMalus = course.tempsMalus
            saveData()
    }
    
    func removeCourse(course:Course){
        if let existingCourse = fetchCDCourse(withId: course.id) {
            context.delete(existingCourse)
            saveData()
        }
    }
    
    func updateNomCourse(course:Course, nom:String){
        if let existingCourse = fetchCDCourse(withId: course.id) {
            existingCourse.nomCourse = nom
            saveData()
        }
    }

    func updateMalus(course:Course, nb:Int16){
        if let existingCourse = fetchCDCourse(withId: course.id) {
            existingCourse.tempsMalus = nb
            saveData()
        }
    }
    func updateBonus(course:Course, nb:Int16){
        if let existingCourse = fetchCDCourse(withId: course.id) {
            existingCourse.tempsBonus = nb
            saveData()
        }
    }
    
    private func fetchCDCourse(withId courseId:UUID) -> CDCourse? {
        let fetchRequest: NSFetchRequest<CDCourse> = CDCourse.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", courseId as CVarArg)
        fetchRequest.fetchLimit = 1
        let fetchResult:[CDCourse]? = try? context.fetch(fetchRequest)
        return fetchResult?.first
    }
  
    
    private func saveData(){
        if context.hasChanges{
            do{
                print("Changement de context")
            try context.save()
            }catch{
                print("Erreur pendant la Sauvegarde CoreData : \(error.localizedDescription)")
            }
        }
    }
    
    
    
    
    // ------------------------------- Parcours -------------------------------
    
    func getNbParcours(crsId : UUID) -> Int {
        let count : Int
        let fetchRequest:NSFetchRequest<CDParcours> = CDParcours.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "courseId == %@", crsId as CVarArg)
            if let cnt = try? context.count(for: fetchRequest){
                count = cnt
            }else{
                count = 0
            }
        return count
        }
    
    
    func fetchParcoursList(crsId:UUID) -> [Parcours] {
        let ParcoursList: [Parcours]
        let fetchRequest:NSFetchRequest<CDParcours> = CDParcours.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "courseId == %@", crsId as CVarArg)
        if let rawParcoursList = try? context.fetch(fetchRequest) {
            ParcoursList = rawParcoursList.compactMap({ (rawParcours: CDParcours) -> Parcours? in
                Parcours(fromCoreDataObject: rawParcours)
            })
        } else {
            ParcoursList = []
        }
        return ParcoursList
    }
    
    func addNewParcours(parcours:Parcours) {
        let newParcours = CDParcours(context: context)
            newParcours.id = parcours.id
            newParcours.parcoursNom = parcours.parcoursNom
            newParcours.parcoursNum = parcours.parcoursNum
            newParcours.courseId = parcours.courseId
            newParcours.distance = parcours.distance
            saveData()
    }
    
    func removeParcours(parcours:Parcours){
        if let existingParcours = fetchCDParcours(parcoursId: parcours.id) {
            context.delete(existingParcours)
            saveData()
        }
    }
    
    func updateNomParcours(parcours: Parcours, nom:String, distance:Int16){
        if let existingParcours = fetchCDParcours(parcoursId: parcours.id) {
            existingParcours.parcoursNom = nom
            existingParcours.distance = distance
            saveData()
        }
    }
    

    private func fetchCDParcours(parcoursId: UUID) -> CDParcours? {
        let fetchRequest: NSFetchRequest<CDParcours> = CDParcours.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", parcoursId as CVarArg)
        fetchRequest.fetchLimit = 1
        let fetchResult:[CDParcours]? = try? context.fetch(fetchRequest)
        return fetchResult?.first
    }
    
    
    
    // ------------------------------- Groupe -------------------------------
    
    
    
    func fetchGroupeList(crsId: UUID) -> [Groupe] {
        let GroupeList: [Groupe]
        let fetchRequest:NSFetchRequest<CDGroupe> = CDGroupe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "courseId == %@", crsId as CVarArg)
        if let rawGroupeList = try? context.fetch(fetchRequest) {
            GroupeList = rawGroupeList.compactMap({ (rawGroupe: CDGroupe) -> Groupe? in
                Groupe(fromCoreDataObject: rawGroupe)
            })        
        } else {
            GroupeList = []
        }
        return GroupeList
    }
    
    private func fetchCDGroupe(withId GroupeId:UUID) -> CDGroupe? {
        let fetchRequest: NSFetchRequest<CDGroupe> = CDGroupe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", GroupeId as CVarArg)
        fetchRequest.fetchLimit = 1
        let fetchResult:[CDGroupe]? = try? context.fetch(fetchRequest)
        return fetchResult?.first
    }
    
    func addNewGroupe(groupe:Groupe) {
        let newGroupe = CDGroupe(context: context)
            newGroupe.id = groupe.id
            newGroupe.nomGroupe = groupe.nomGroupe
            newGroupe.courseId = groupe.courseId
            saveData()
    }
    
    func removeGroupe(groupe:Groupe){
        if let existingGroupe = fetchCDGroupe(withId: groupe.id) {
            context.delete(existingGroupe)
            saveData()
        }
    }
    
    func updateNomGroupe(groupe: Groupe, nom:String){
        if let existingGroupe = fetchCDGroupe(withId: groupe.id) {
            existingGroupe.nomGroupe = nom
            saveData()
        }
    }
    
    // ------------------------------- Detail -------------------------------
    
    func fetchEnCourse(grId: UUID) -> [Detail] {
        let EnCourseList: [Detail]
        let fetchRequest:NSFetchRequest<CDDetail> = CDDetail.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "groupeId == %@ AND arrivee == nil", grId as CVarArg)
        fetchRequest.fetchLimit = 1
        if let rawEnCourse = try? context.fetch(fetchRequest) {
            EnCourseList = rawEnCourse.compactMap({ (rawDetail: CDDetail) -> Detail? in
                Detail(fromCoreDataObject: rawDetail)
            })
        } else {
            EnCourseList = []
        }
        return EnCourseList
    }
    
    func fetchRecordParcours(parcoursId: UUID, courseId: UUID) -> [Detail] {
        let recordParcours: [Detail]
        let fetchRequest:NSFetchRequest<CDDetail> = CDDetail.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "courseId == %@ AND parcoursId == %@ AND temps != 0", courseId as CVarArg, parcoursId as CVarArg)
        fetchRequest.fetchLimit = 1
        let SortDescriptor : NSSortDescriptor = NSSortDescriptor(key: "temps", ascending: true)
        fetchRequest.sortDescriptors = [SortDescriptor]
        if let rawRecord = try? context.fetch(fetchRequest) {
            recordParcours = rawRecord.compactMap({ (rawDetail: CDDetail) -> Detail? in
                Detail(fromCoreDataObject: rawDetail)
            })
        } else {
            recordParcours = []
        }
        return recordParcours
    }
    
    
    func fetchRealise(grId: UUID) -> [Detail] {
        let parcoursRealiseList: [Detail]
        let fetchRequest:NSFetchRequest<CDDetail> = CDDetail.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "groupeId == %@ AND arrivee != nil", grId as CVarArg)
        if let rawParcoursRealise = try? context.fetch(fetchRequest) {
            parcoursRealiseList = rawParcoursRealise.compactMap({ (rawDetail: CDDetail) -> Detail? in
                Detail(fromCoreDataObject: rawDetail)
            })
        } else {
            parcoursRealiseList = []
        }
        return parcoursRealiseList
    }
    
    func depart(detail:Detail) {
        let newDetail = CDDetail(context: context)
            newDetail.id = detail.id
            newDetail.groupeId = detail.groupeId
            newDetail.courseId = detail.courseId
            newDetail.depart = detail.depart
        if detail.arrivee != nil {
            newDetail.arrivee = detail.arrivee
        }
        if detail.temps > 0 {
            newDetail.temps = detail.temps
        }
            newDetail.parcoursId = detail.parcoursId
            newDetail.groupeNom = detail.nomGroupe
            newDetail.nomParcours = detail.nomParcours
            saveData()
    }
    
    func DonneeInitialeAjoutDetail(detail:Detail) {
        let newDetail = CDDetail(context: context)
            newDetail.id = detail.id
            newDetail.groupeId = detail.groupeId
            newDetail.courseId = detail.courseId
            newDetail.depart = detail.depart
            newDetail.arrivee = detail.arrivee
            newDetail.temps = detail.temps
            newDetail.parcoursId = detail.parcoursId
            newDetail.groupeNom = detail.nomGroupe
            newDetail.nomParcours = detail.nomParcours
            newDetail.nbErreur = detail.nbErreur
            newDetail.nbValidation = detail.nbValidation
            saveData()
    }
    
    func arrivee(detail: Detail, arr:Date, temps:Int32){
        if let existingCourse = fetchCDDetail(withId: detail.id) {
            existingCourse.arrivee = arr
            existingCourse.temps = temps
            saveData()
        }
    }
    
    func removeDetail(detail: Detail) {
        if let existingDetail = fetchCDDetail(withId: detail.id) {
            context.delete(existingDetail)
            saveData()
        }
    }
    
    func fetchDetailList(crsId:UUID) -> [Detail] {
        let DetailList: [Detail]
        let fetchRequest:NSFetchRequest<CDDetail> = CDDetail.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "courseId == %@", crsId as CVarArg)
        if let rawDetailList = try? context.fetch(fetchRequest) {
            DetailList = rawDetailList.compactMap({ (rawDetail: CDDetail) -> Detail? in
                Detail(fromCoreDataObject: rawDetail)
            })
        } else {
            DetailList = []
        }
        return DetailList
    }
    
    func fetchDetailListdunGroupe(crsId:UUID, grId: UUID) -> [Detail] {
        let DetailList: [Detail]
        let fetchRequest:NSFetchRequest<CDDetail> = CDDetail.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "courseId == %@ AND groupeId == %@", crsId as CVarArg, grId as CVarArg)
        if let rawDetailList = try? context.fetch(fetchRequest) {
            DetailList = rawDetailList.compactMap({ (rawDetail: CDDetail) -> Detail? in
                Detail(fromCoreDataObject: rawDetail)
            })
        } else {
            DetailList = []
        }
        return DetailList
    }
    
    
    func fetchDetailListdunParcours(crsId:UUID, parcId: UUID) -> [Detail] {
        let DetailList: [Detail]
        let fetchRequest:NSFetchRequest<CDDetail> = CDDetail.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "courseId == %@ AND parcoursId == %@", crsId as CVarArg, parcId as CVarArg)
        if let rawDetailList = try? context.fetch(fetchRequest) {
            DetailList = rawDetailList.compactMap({ (rawDetail: CDDetail) -> Detail? in
                Detail(fromCoreDataObject: rawDetail)
            })
        } else {
            DetailList = []
        }
        return DetailList
    }
    
    func updateNomParcoursDansDetail(detail: Detail, nom:String){
        if let existingDetail = fetchCDDetail(withId: detail.id) {
            existingDetail.nomParcours = nom
            saveData()
        }
    }
    func updateNomGroupeDansDetail(detail: Detail, nom:String){
        if let existingDetail = fetchCDDetail(withId: detail.id) {
            existingDetail.groupeNom = nom
            saveData()
        }
    }
    func updateDetailTemps(detailId: UUID, temps:Int32){
        if let existingDetail = fetchCDDetail(withId: detailId) {
            existingDetail.temps = temps
            saveData()
        }
    }
    
    
    private func fetchCDDetail(withId detailId:UUID) -> CDDetail? {
        let fetchRequest = NSFetchRequest<CDDetail>(entityName: "CDDetail")
        fetchRequest.predicate = NSPredicate(format: "id == %@", detailId as CVarArg)
        fetchRequest.fetchLimit = 1
        let fetchResult:[CDDetail]? = try? context.fetch(fetchRequest)
        return fetchResult?.first
    }
    // ------------------------------- Suivi -------------------------------
    
    func fetchParcoursEnCours(crsId: UUID) -> [Detail] {
        let parcoursEnCoursList: [Detail]
        let fetchRequest:NSFetchRequest<CDDetail> = CDDetail.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "courseId == %@ AND arrivee == nil", crsId as CVarArg)
        if let rawParcoursEnCours = try? context.fetch(fetchRequest) {
            parcoursEnCoursList = rawParcoursEnCours.compactMap({ (rawDetail: CDDetail) -> Detail? in
                Detail(fromCoreDataObject: rawDetail)
            })
        } else {
            parcoursEnCoursList = []
        }
        return parcoursEnCoursList
    }
    
    func getNbParcoursRealises(grId : UUID, crsId : UUID, parcId : UUID?) -> Int {
        let count : Int
        let fetchRequest:NSFetchRequest<CDDetail> = CDDetail.fetchRequest()
        if parcId == nil {
            fetchRequest.predicate = NSPredicate(format: "courseId == %@ AND groupeId == %@ AND arrivee != nil", crsId as CVarArg, grId as CVarArg)
        }else{
            fetchRequest.predicate = NSPredicate(format: "courseId == %@ AND groupeId == %@ AND parcoursId == %@ AND arrivee != nil", crsId as CVarArg, grId as CVarArg, parcId! as CVarArg)
        }
            if let cnt = try? context.count(for: fetchRequest){
                count = cnt
            }else{
                count = 0
            }
        return count
        }
    
    func getNbErreursTotalesParGroupe(grId : UUID, crsId : UUID, parcId: UUID?) -> Int {
        let sum : Int
        let fetchRequest:NSFetchRequest<CDDetail> = CDDetail.fetchRequest()
        if parcId == nil {
        fetchRequest.predicate = NSPredicate(format: "courseId == %@ AND groupeId == %@ AND arrivee != nil", crsId as CVarArg, grId as CVarArg)
        }else{
            fetchRequest.predicate = NSPredicate(format: "courseId == %@ AND groupeId == %@ AND parcoursId == %@ AND arrivee != nil", crsId as CVarArg, grId as CVarArg, parcId! as CVarArg)
        }
            if let cnt = try? context.fetch(fetchRequest){
                sum = cnt.reduce(0) { $0 + ($1.value(forKey: "nbErreur") as? Int ?? 0) }
            }else{
                sum = 0
            }
        return sum
        }
    
    
    func getNbValidTotalesParGroupe(grId : UUID, crsId : UUID, parcId: UUID?) -> Int {
        let sum : Int
        let fetchRequest:NSFetchRequest<CDDetail> = CDDetail.fetchRequest()
        if parcId == nil {
        fetchRequest.predicate = NSPredicate(format: "courseId == %@ AND groupeId == %@ AND arrivee != nil", crsId as CVarArg, grId as CVarArg)
        }else{
            fetchRequest.predicate = NSPredicate(format: "courseId == %@ AND groupeId == %@ AND parcoursId == %@ AND arrivee != nil", crsId as CVarArg, grId as CVarArg, parcId! as CVarArg)
        }
            if let cnt = try? context.fetch(fetchRequest){
                sum = cnt.reduce(0) { $0 + ($1.value(forKey: "nbValidation") as? Int ?? 0) }
            }else{
                sum = 0
            }
        return sum
        }
    
    func getTempsTotalParGroupe(grId : UUID, crsId : UUID, parcId: UUID?) -> Int32 {
        let total : Int32
        let fetchRequest:NSFetchRequest<CDDetail> = CDDetail.fetchRequest()
        if parcId == nil {
        fetchRequest.predicate = NSPredicate(format: "courseId == %@ AND groupeId == %@ AND arrivee != nil", crsId as CVarArg, grId as CVarArg)
        }else{
            fetchRequest.predicate = NSPredicate(format: "courseId == %@ AND groupeId == %@ AND parcoursId == %@ AND arrivee != nil", crsId as CVarArg, grId as CVarArg, parcId! as CVarArg)
        }
            if let cnt = try? context.fetch(fetchRequest){
                total = Int32(cnt.reduce(0) { $0 + ($1.value(forKey: "temps") as? Int ?? 0) })
            }else{
                total = 0
            }
        return total
        }
    
    func getTempsMoyenParGroupe(grId : UUID, crsId : UUID, parcId : UUID?) -> Int32 {
        let total : Int32
        let moy : Int32
        let fetchRequest:NSFetchRequest<CDDetail> = CDDetail.fetchRequest()
        if parcId == nil {
        fetchRequest.predicate = NSPredicate(format: "courseId == %@ AND groupeId == %@ AND arrivee != nil", crsId as CVarArg, grId as CVarArg)
        }else{
            fetchRequest.predicate = NSPredicate(format: "courseId == %@ AND groupeId == %@ AND parcoursId == %@ AND arrivee != nil", crsId as CVarArg, grId as CVarArg, parcId! as CVarArg)
        }
            if let cnt = try? context.fetch(fetchRequest){
                total = Int32(cnt.reduce(0) { $0 + ($1.value(forKey: "temps") as? Int ?? 0) })
                if cnt.count > 0 {
                    moy = total / Int32(cnt.count)
                }else{
                    moy = 0
                }
            }else{
                moy = 0
            }
        return moy
        }
    
    func getRKMoyenParGroupe(grId : UUID, crsId : UUID, parcId: UUID?) -> Int32 {
        var distanceTotale : Int32 = 0
        var tempsTotal : Int32 = 0
        var distMoy : Float = 0.0
        var rk : Int32 = 0
        let listParc = fetchParcoursList(crsId: crsId)
        if parcId != nil{
            let listParc2 = listParc.filter {$0.id == parcId}
            distanceTotale = Int32(listParc2[0].distance)
        }else{
            let listDetailReal = fetchRealise(grId: grId)
            var list : Parcours
            var listPc : [Parcours] = []
            for pc in listDetailReal {
                list = listParc.filter{ $0.id == pc.parcoursId }[0]
                listPc.append(list)
            }
            distanceTotale = Int32(listPc.reduce(0){ $0 + $1.distance })
            }
        let fetchRequest:NSFetchRequest<CDDetail> = CDDetail.fetchRequest()
        if parcId == nil {
        fetchRequest.predicate = NSPredicate(format: "courseId == %@ AND groupeId == %@ AND arrivee != nil", crsId as CVarArg, grId as CVarArg)
        }else{
            fetchRequest.predicate = NSPredicate(format: "courseId == %@ AND groupeId == %@ AND parcoursId == %@ AND arrivee != nil", crsId as CVarArg, grId as CVarArg, parcId! as CVarArg)
        }
            if let cnt = try? context.fetch(fetchRequest){
                tempsTotal = Int32(cnt.reduce(0) { $0 + ($1.value(forKey: "temps") as? Int ?? 0) })
            }else{
                tempsTotal = 0
            }
        if distanceTotale == 0 || tempsTotal == 0 {
            rk = 0
        }else{
            distMoy = Float(distanceTotale) / Float(1000)
            distMoy = Float(tempsTotal) / distMoy
            rk = Int32(distMoy)
        }
        return rk
        }
    
    func termineDepuis(grId : UUID, crsId : UUID) -> [Detail] {
        let detailList : [Detail]
        let fetchRequest:NSFetchRequest<CDDetail> = CDDetail.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "courseId == %@ AND groupeId == %@", crsId as CVarArg, grId as CVarArg)
        fetchRequest.fetchLimit = 1
        let SortDescriptor : NSSortDescriptor = NSSortDescriptor(key: "arrivee", ascending: false)
        fetchRequest.sortDescriptors = [SortDescriptor]
        if let rawDetail = try? context.fetch(fetchRequest) {
            detailList = rawDetail.compactMap({ (rawDetail: CDDetail) -> Detail? in
                Detail(fromCoreDataObject: rawDetail)
            })
        } else {
            detailList = []
        }
        return detailList
        }
    
    // ------------------------------- Classement -------------------------------
    

    

    
    // ------------------------------- Erreur -------------------------------
    
    func updateNbErreur(detail:Detail, nb:Int16){
        if let existingCourse = fetchCDDetail(withId: detail.id) {
            existingCourse.nbErreur = nb
            saveData()
        }
    }
    
    func updateNbValidation(detail:Detail, nb:Int16){
        if let existingCourse = fetchCDDetail(withId: detail.id) {
            existingCourse.nbValidation = nb
            saveData()
        }
    }
    
    // ------------------------------- MaquetteParcours -------------------------------
    
    
    func fetchDistinctMaquetteParcoursList() -> [MaquetteParcours] {
        let MaquetteParcoursList: [MaquetteParcours]
        let fetchRequest:NSFetchRequest<CDMaquetteParcours> = CDMaquetteParcours.fetchRequest()
        fetchRequest.propertiesToFetch = ["nomMaquette"]
        fetchRequest.returnsDistinctResults = true
        if let rawMaquetteParcoursList = try? context.fetch(fetchRequest) {
            MaquetteParcoursList = rawMaquetteParcoursList.compactMap({ (rawMaquetteParcours: CDMaquetteParcours) -> MaquetteParcours? in
                MaquetteParcours(fromCoreDataObject: rawMaquetteParcours)
            })
        } else {
            MaquetteParcoursList = []
        }
        var MaqProv:[MaquetteParcours] = []
        for item in MaquetteParcoursList{
            if MaqProv.filter({ $0.nomMaquette == item.nomMaquette }).count == 0{
                MaqProv.append(item)
            }
        }
        return MaqProv
    }

    
    func fetchDetailMaquetteParcoursList(nomMaquette: String) -> [MaquetteParcours] {
        let DetailMaquetteParcoursList: [MaquetteParcours]
        let fetchRequest:NSFetchRequest<CDMaquetteParcours> = CDMaquetteParcours.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nomMaquette == %@", nomMaquette as CVarArg)
        if let rawMaquetteParcoursList = try? context.fetch(fetchRequest) {
            DetailMaquetteParcoursList = rawMaquetteParcoursList.compactMap({ (rawMaquetteParcours: CDMaquetteParcours) -> MaquetteParcours? in
                MaquetteParcours(fromCoreDataObject: rawMaquetteParcours)
            })
        } else {
            DetailMaquetteParcoursList = []
        }
        return DetailMaquetteParcoursList
    }
    
    func addNewMaquetteParcours(maquetteParcours:MaquetteParcours) {
        let newMaquetteParcours = CDMaquetteParcours(context: context)
            newMaquetteParcours.id = maquetteParcours.id
            newMaquetteParcours.nomMaquette = maquetteParcours.nomMaquette
            newMaquetteParcours.nomParcours = maquetteParcours.nomParcours
            newMaquetteParcours.distance = maquetteParcours.distance
            saveData()
    }
    
    func removeMaquetteParcours(maquetteParcours :MaquetteParcours){
        if let existingMaquetteParcours = fetchCDMaquetteParcours(maquetteId: maquetteParcours.id) {
            context.delete(existingMaquetteParcours)
            saveData()
        }
    }
    
    private func fetchCDMaquetteParcours(maquetteId: UUID) -> CDMaquetteParcours? {
        let fetchRequest: NSFetchRequest<CDMaquetteParcours> = CDMaquetteParcours.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", maquetteId as CVarArg)
        fetchRequest.fetchLimit = 1
        let fetchResult:[CDMaquetteParcours]? = try? context.fetch(fetchRequest)
        return fetchResult?.first
    }
    
    // ------------------------------- MaquetteGroupe -------------------------------
    
    
    func fetchDistinctMaquetteGroupeList() -> [MaquetteGroupe] {
        let MaquetteGroupeList: [MaquetteGroupe]
        let fetchRequest:NSFetchRequest<CDMaquetteGroupe> = CDMaquetteGroupe.fetchRequest()
        fetchRequest.propertiesToFetch = ["nomMaquette"]
        fetchRequest.returnsDistinctResults = true
        if let rawMaquetteGroupeList = try? context.fetch(fetchRequest) {
            MaquetteGroupeList = rawMaquetteGroupeList.compactMap({ (rawMaquetteGroupe: CDMaquetteGroupe) -> MaquetteGroupe? in
                MaquetteGroupe(fromCoreDataObject: rawMaquetteGroupe)
            })
        } else {
            MaquetteGroupeList = []
        }
        var MaqProv:[MaquetteGroupe] = []
        for item in MaquetteGroupeList{
            if MaqProv.filter({ $0.nomMaquette == item.nomMaquette }).count == 0{
                MaqProv.append(item)
            }
        }
        return MaqProv    }
    
    func fetchDetailMaquetteGroupeList(nomMaquette: String) -> [MaquetteGroupe] {
        let DetailMaquetteGroupeList: [MaquetteGroupe]
        let fetchRequest:NSFetchRequest<CDMaquetteGroupe> = CDMaquetteGroupe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nomMaquette == %@", nomMaquette as CVarArg)
        if let rawMaquetteGroupeList = try? context.fetch(fetchRequest) {
            DetailMaquetteGroupeList = rawMaquetteGroupeList.compactMap({ (rawMaquetteGroupe: CDMaquetteGroupe) -> MaquetteGroupe? in
                MaquetteGroupe(fromCoreDataObject: rawMaquetteGroupe)
            })
        } else {
            DetailMaquetteGroupeList = []
        }
        return DetailMaquetteGroupeList
    }
    
    func addNewMaquetteGroupe(maquetteGroupe:MaquetteGroupe) {
        let newMaquetteGroupe = CDMaquetteGroupe(context: context)
            newMaquetteGroupe.id = maquetteGroupe.id
            newMaquetteGroupe.nomMaquette = maquetteGroupe.nomMaquette
            newMaquetteGroupe.nomGroupe = maquetteGroupe.nomGroupe
            saveData()
    }
    
    func removeMaquetteGroupe(maquetteGroupe :MaquetteGroupe){
        if let existingMaquetteGroupe = fetchCDMaquetteGroupe(maquetteId: maquetteGroupe.id) {
            context.delete(existingMaquetteGroupe)
            saveData()
        }
    }
    
    private func fetchCDMaquetteGroupe(maquetteId: UUID) -> CDMaquetteGroupe? {
        let fetchRequest: NSFetchRequest<CDMaquetteGroupe> = CDMaquetteGroupe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", maquetteId as CVarArg)
        fetchRequest.fetchLimit = 1
        let fetchResult:[CDMaquetteGroupe]? = try? context.fetch(fetchRequest)
        return fetchResult?.first
    }
    //-----------------------------Modifications Temps ---------------------------
    

    //-----------------------------Fermeture de la Class ---------------------------
    
    
}


// ------------------------------- Extensions -------------------------------

extension Course {
    init?(fromCoreDataObject coreDataObject:CDCourse){
        guard let id = coreDataObject.id,
              let nom = coreDataObject.nomCourse else{
            return nil
        }
        self.id = id
        self.nomCourse = nom
        self.dateCreation = coreDataObject.dateCreation!
        self.tempsMalus = coreDataObject.tempsMalus
        self.tempsBonus = coreDataObject.tempsBonus
        
    }
}

extension Groupe {
    init?(fromCoreDataObject coreDataObject:CDGroupe){
        guard let id = coreDataObject.id,
              let crsid = coreDataObject.courseId,
              let nomGr = coreDataObject.nomGroupe
        else{
            return nil
        }
        self.id = id
        self.courseId = crsid
        self.nomGroupe = nomGr
    }
}

extension Detail {
    init?(fromCoreDataObject coreDataObject:CDDetail){
        guard let id = coreDataObject.id,
              let grId = coreDataObject.groupeId,
              let crsId = coreDataObject.courseId,
              let parc = coreDataObject.parcoursId,
              let nomGr = coreDataObject.groupeNom,
              let nomParc = coreDataObject.nomParcours
        else{
            return nil
        }
        self.id = id
        self.courseId = crsId
        self.groupeId = grId
        self.arrivee = coreDataObject.arrivee
        self.depart = coreDataObject.depart
        self.temps = coreDataObject.temps
        self.parcoursId = parc
        self.nomGroupe = nomGr
        self.nomParcours = nomParc
        self.nbErreur = coreDataObject.nbErreur
        self.nbValidation = coreDataObject.nbValidation
    }
}

extension Parcours {
    init?(fromCoreDataObject coreDataObject:CDParcours){
        guard let id = coreDataObject.id,
              let crsId = coreDataObject.courseId,
              let parcNom = coreDataObject.parcoursNom
        else{
            return nil
        }
        self.id = id
        self.courseId = crsId
        self.parcoursNum = coreDataObject.parcoursNum
        self.parcoursNom = parcNom
        self.distance = coreDataObject.distance
    }
}

extension MaquetteParcours {
    init?(fromCoreDataObject coreDataObject:CDMaquetteParcours){
        guard let id = coreDataObject.id,
              let nomMaqu = coreDataObject.nomMaquette,
              let parcNom = coreDataObject.nomParcours
        else{
            return nil
        }
        self.id = id
        self.nomMaquette = nomMaqu
        self.nomParcours = parcNom
        self.distance = coreDataObject.distance
    }
}

extension MaquetteGroupe {
    init?(fromCoreDataObject coreDataObject:CDMaquetteGroupe){
        guard let id = coreDataObject.id,
              let nomMaqu = coreDataObject.nomMaquette,
              let grNom = coreDataObject.nomGroupe
        else{
            return nil
        }
        self.id = id
        self.nomMaquette = nomMaqu
        self.nomGroupe = grNom
    }
}
