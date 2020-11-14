//
//  CourseListView.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 22/07/2020.
//

import SwiftUI

struct CourseListView: View {
    @State var newCourseName:String = ""
    @State var courseManager = CourseManager()
    @State var list : [Course] = []
    @State var selectedCourse: Course?
    @State private var action : Int? = 0
    @ObservedObject var objCourse = CourseActuelle()
    @State var courseId : UUID = UUID()
    @State var navVisible = false
    
    init() {
        objCourse.id = UUID()
    }
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: getDestination().environmentObject(objCourse), tag: 1, selection: $action){}
                HStack{
                    Link(destination: URL(string: "https://www.youtube.com/channel/UCNdX88jqrWL_SR-4qLRiLPQ")!) {
                        Image(systemName: "video.bubble.left.fill")
                        Text("Explications vidéo")
                        Image(systemName: "video.bubble.left.fill")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.white)
                    )
                }.padding()
                
                
                Form{
                    Section(footer: FooterSupp(nb: list.count, str: "renommer")){
                    HStack {
                        TextField("Nom nouvelle course", text: $newCourseName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button(action: {createNewCourse()}, label: {
                            Image(systemName: "plus")
                                .font(.title)
                        })
                    }
                    
                    if list.filter( { return $0.nomCourse == newCourseName } ).count > 0 {
                        HStack{
                            Image(systemName: "exclamationmark.circle.fill")
                            Text(" Une course avec ce nom existe déjà")
                        }.foregroundColor(.orange)
                        
                    }
                    
                    List {
                        let count = list.count
                        Text("Courses existantes : \(count)")
                        if count == 0 {
                            Text("Aucune Course")
                        }else {
                            ForEach(0 ..< count, id: \.self){ index in
                                HStack {
                                    NavigationLink(destination: getDestination().environmentObject(objCourse).onAppear(){
                                        objCourse.id = list[index].id
                                            objCourse.nomCourse = list[index].nomCourse
                                            objCourse.dateCreation = list[index].dateCreation
                                            objCourse.tempsBonus = list[index].tempsBonus
                                            objCourse.tempsMalus = list[index].tempsMalus
                                    }
                                                   , label: {
                                        Image(systemName: "pencil.circle.fill")
                                            .font(.title)
                                            .onTapGesture {
                                                self.selectedCourse = list[index]
                                            }
                                        ListRow(objCourse: list[index])
                                    })
                                }
                            }.onDelete(perform: { indexSet in
                                DeleteCourse(ind: indexSet)
                            })
                        }
                    }}
                }
                .sheet(item: self.$selectedCourse, content: { select in
                    RenameEditCourseView(objCourse : select, list: $list)
                    
                })
            
        }
            .background(Color.orange)
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack {
                                Text("Orientation")
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color.orange)
                                Text("EPS")
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color("ColorDarkLight"))
                            }.font(.title)
                            .padding()
                            }}
          
            .onAppear(){
                navVisible = true
                list = courseManager.recupListe()
                if !UserDefaults.standard.bool(forKey: "premièreOuverture"){
                    UserDefaults.standard.setValue(true, forKey: "premièreOuverture")
                    insererDataInit()
                }
                
            }
            
        }
        
    }
    func getDestination() -> AnyView {

        if GroupeManager(courseId: objCourse.id!).groupeList.count > 0 && ParcoursManager(courseId: objCourse.id!).parcoursList.count > 0 {
               return AnyView(GeneralView(groupeManager: GroupeManager(courseId: courseId)))
            }else{
                return AnyView(ReglagesView(ReprendreLaCourse: false, groupeManager: GroupeManager(courseId: objCourse.id!), parcoursManager: ParcoursManager(courseId: objCourse.id!)))
                
            }
        }
    
    
    func afficherListe(){
        courseManager.affListe()
    }
    
    func createNewCourse() {
        courseManager.addCourse(withName: newCourseName)
        newCourseName = ""
        list = courseManager.courseList
    }
    
    func DeleteCourse(ind: IndexSet) {
        for i in ind {
            courseManager.removeCourse(courseId: courseManager.courseList[i].id)
        }
        list = courseManager.courseList
    }
    
    
    func insererDataInit() {
        courseManager.addCourse(withName: "Course exemple")
        let courseId = courseManager.courseList[0].id
        courseManager.updateMalus(courseId: courseManager.courseList[0].id, malus: 60)
        courseManager.updateBonus(courseId: courseManager.courseList[0].id, bonus: 5)
        let dist: [Int16] = [1000,1200,1000,800,1100,900]
        let parcName: [String] = ["Parcours A","Parcours B","Parcours C","Parcours D","Parcours E","Parcours F"]
        var parcoursManager = ParcoursManager(courseId: courseId)
        for num in 0 ..< 6 {
            let objParcours = Parcours(courseId: courseId, parcoursNum: Int16(num), parcoursNom: parcName[num], distance: dist[num])
            parcoursManager.addParcoursAvecNom(parc: objParcours, distance: dist[num])
        }
        let name: [String] = ["Clément","Julie","Priscilla","Raphaël","Elie","Aurele","Caroline","Florent","Nora"]
        var groupeManager = GroupeManager(courseId: courseId)
        for num in 0 ..< 9 {
            let gr = Groupe(courseId: courseId, nomGroupe: name[num])
            groupeManager.addGroupeAvecNom(gr: gr)
        }
        let listGroupe = groupeManager.groupeList
        let listParcours = parcoursManager.parcoursList
        for num in 0 ..< listGroupe.count {
            for num2 in 0 ..< listParcours.count {
                let alea = Int.random(in: 0 ..< 10)
                if alea >= 5 {
                    let date = Date()
                    let err = Int16.random(in: 0 ..< 4)
                    let valid = Int16.random(in: 0 ..< 4)
                    let temps = Int32.random(in: 280 ..< 600)
                    let detail = Detail(courseId: courseId, groupeId: listGroupe[num].id, arrivee: date, depart: date, temps: temps, parcoursId: listParcours[num2].id, nomGroupe: listGroupe[num].nomGroupe, nomParcours: listParcours[num2].parcoursNom, nbErreur: err, nbValidation: valid)
                    OriEPS().DonneeInitialeAjoutDetail(detail:detail)
                }
            }
        }
        list = courseManager.courseList
    }
    
}

struct ListRow: View {
    var objCourse: Course
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if objCourse.nomCourse == "Course exemple" {
                    Text(objCourse.nomCourse).italic()
                }else{
                    Text(objCourse.nomCourse)
                }
                HStack{
                    Text("\(ParcoursManager(courseId: objCourse.id).parcoursList.count) parcours - \(String.localizedStringWithFormat(NSLocalizedString("%d coureurs", comment: ""), GroupeManager(courseId: objCourse.id).groupeList.count))")
                        
                        .font(.subheadline).foregroundColor(.gray)
                }
            }
        }
    }
}
