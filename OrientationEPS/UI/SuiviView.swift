//
//  SuiviView.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 17/10/2020.
//
import SwiftUI

struct SuiviView: View {
    @EnvironmentObject var objCourse : CourseActuelle
    @State var suiviManager: SuiviManager
    @State var groupeEnCourse: [DetailEnCourse] = []
    @State var groupeEnAttente: [Groupe] = []
    @State var groupeAyantTermine: [Groupe] = []
    @State private var action: Int? = 0
    @State var newDate = Date()
    let listActuelle = ListActuelle()
    let timer2 = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    let timer3 = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
       
                Form{
                    Section(header: HeaderEnCourse()){
                        if groupeEnCourse.count > 0 {
                            List{
                            ForEach(groupeEnCourse){ gr in
                                NavigationLink(
                                    destination: GroupeDetailsView(objGroupe: gr.groupe, detailManager: DetailManager(groupe: gr.groupe), parcoursManager: ParcoursManager(courseId: objCourse.id!), listeParcoursRestants: DetailManager(groupe: gr.groupe).ListeParcoursRestants()).environmentObject(objCourse).environmentObject(listActuelle),
                                    label: {
                                        HStack{
                                            Text(gr.groupe.nomGroupe)
                                            Spacer()
                                            Text(gr.detail.nomParcours).italic()
                                            Image(systemName: "arrow.right")
                                            Text(TempsAffichable().secondsToMinutesSeconds(temps: gr.temps))
                                        }
                                    })
                            }
                            }
                        }else{
                            Text("Aucun groupe")
                        }

                        
                    }.onReceive(timer2) { (time) in
                        groupeEnCourse = suiviManager.groupeEnCourseList()
                    }

                    Section(header: HeaderEnAttente()){
                        if groupeEnAttente.count > 0{
                            ForEach(groupeEnAttente){ gr in
                                NavigationLink(
                                    destination: GroupeDetailsView(objGroupe: gr,detailManager: DetailManager(groupe: gr), parcoursManager: ParcoursManager(courseId: gr.courseId), listeParcoursRestants: DetailManager(groupe: gr).ListeParcoursRestants()).environmentObject(objCourse).environmentObject(listActuelle)  ,
                                    label: {
                                        HStack{
                                            Text(gr.nomGroupe)
                                            Spacer()
                                            Text(String(suiviManager.nbParcoursRealises(groupeId: gr.id)))
                                        }
                                    })
                            }
                        }else{
                            Text("Aucun groupe")
                        }

                    }
                    
                    Section(header: HeaderTermine()){
                        if groupeAyantTermine.count > 0{
                            ForEach(groupeAyantTermine){ gr in
                                NavigationLink(
                                    destination: GroupeDetailsView(objGroupe: gr, detailManager: DetailManager(groupe: gr), parcoursManager: ParcoursManager(courseId: gr.courseId), listeParcoursRestants: DetailManager(groupe: gr).ListeParcoursRestants()).environmentObject(objCourse).environmentObject(listActuelle)   ,
                                    label: {
                                        HStack{
                                            Text(gr.nomGroupe)
                                            Spacer()
                                            Text(String(TempsAffichable().secondsToMinutesSeconds(temps: suiviManager.termineDepuis(groupeId: gr.id))))
                                        }
                                    })
                            }
                        }else{
                            Text("Aucun groupe")
                        }

                    }.onReceive(timer3) { (time) in
                        groupeAyantTermine = suiviManager.groupesAyantTermines()
                    }
                }
        
                .onAppear(perform:{
                    suiviManager = SuiviManager(courseId: objCourse.id!)
                    groupeEnCourse = suiviManager.groupeEnCourseList()
                    groupeEnAttente = suiviManager.groupeEnAttenteList()
                    groupeAyantTermine = suiviManager.groupesAyantTermines()
                })
        }
    }



struct HeaderEnCourse: View {
    var body: some View {
        HStack {
            Text("En course")
            Spacer()
            Text("Depuis")
        }
    }
}

struct HeaderEnAttente: View {
    var body: some View {
        HStack {
            Text("En Attente")
            Spacer()
            Text("Parcours Réalisé")
        }
    }
}

struct HeaderTermine: View {
    var body: some View {
        HStack {
            Text("Terminé")
            Spacer()
            Text("Depuis")
        }
    }
}
