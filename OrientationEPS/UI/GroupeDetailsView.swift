//
//  GroupeDetailsView.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 08/10/2020.
//

import SwiftUI

struct GroupeDetailsView: View {
    let objGroupe : Groupe
    @EnvironmentObject var objCourse : CourseActuelle
    @State var detailManager : DetailManager
    @State var parcoursManager : ParcoursManager
    @State var enCourse = false
    @State var listeParcoursRestants : [Parcours] = []
    @State var selectedParcoursIndex : Int = 0
    @State var toutLesParcoursSontTermines = false
    @State private var action: Int? = 0
    @State var listReal : [Detail] = []
    @EnvironmentObject var listActuelle : ListActuelle
    
    
    var body: some View {
        Form {
            
            if !toutLesParcoursSontTermines {
                Section(header: Text("LES PARCOURS")) {
                    
                    Picker(selection: $selectedParcoursIndex, label: HStack{
                        Image(systemName: "star.fill")
                            .foregroundColor(selectedParcoursIndex != 0 ? .black : .red)
                        Text("Choisir parcours")
                            .bold()
                            .foregroundColor(selectedParcoursIndex != 0 ? .black : .red )
                    }
                    ) {
                        let count = listeParcoursRestants.count
                        ForEach (0 ..< count + 1, id: \.self) { num in
                            if num == 0 {
                                Text("Aucun")
                            }else{
                                HStack{
                                    Text(listeParcoursRestants[num - 1].parcoursNom)
                                    if listeParcoursRestants[num - 1].distance > 0{
                                        Text("(\(listeParcoursRestants[num - 1].distance)m)")
                                    }
                                }}
                        }
                    }.disabled(enCourse)
                    
                    if selectedParcoursIndex != 0 {
                        let det = detailManager.recordParcours(parcoursId: detailManager.ListeParcoursRestants()[selectedParcoursIndex - 1].id)
                        if (det.temps == 0 && det.nomGroupe == "Aucun") {
                            Text("Aucun record actuel")
                        }else{
                            HStack{
                                Text("Record actuel ")
                                Spacer()
                                Text("\(TempsAffichable().secondsToMinutesSeconds(temps:TempsAffichable().TempsAvecBonusMalus(detail: detailManager.recordParcours(parcoursId: detailManager.ListeParcoursRestants()[selectedParcoursIndex - 1].id), course: objCourse)))")
                            }
                            HStack{
                                Text("Détenu par ")
                                Spacer()
                                Text("\(detailManager.recordParcours(parcoursId: detailManager.ListeParcoursRestants()[selectedParcoursIndex - 1].id).nomGroupe)")
                            }}
                        Button(
                            action: {
                                if enCourse{
                                    arrivee()
                                    self.action = 2
                                }else{
                                    depart()
                                    self.action = 1
                                }
                            }, label: {
                                if enCourse{
                                    Text("Arrivée")
                                }else{
                                    Text("Départ")
                                }
                            }).disabled(selectedParcoursIndex == 0)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.orange)
                            .font(.largeTitle)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.orange, lineWidth: 2)
                            )}
                }
            }else{
                Text("Tous les parcours ont été réalisés")
            }
            Section(header: Header1()){
                if listReal.count > 0{
                    List {
                        ForEach(0 ..< listReal.count, id:\.self){ index in
                            ElementList(parcoursManager: parcoursManager, listReal: listReal, index: index, objGroupe: objGroupe)
                                .environmentObject(objCourse)
                                .environmentObject(listActuelle)
                        }
                        HStack{
                            VStack{
                                HStack{
                                    let place = funcPlace(parcours: 0)
                                    Text("Classement général :")
                                    Image(systemName: "\(place).circle")
                                    if place < 4{
                                        let color = [Color.yellow, Color.gray, Color.orange]
                                        Image(systemName: "bolt.heart.fill")
                                            .foregroundColor(color[place-1])
                                    }
                                    Spacer()
                                }
                                HStack{
                                    Text("Classé par rapport au temps moyen")
                                    Spacer()
                                }.font(.subheadline).foregroundColor(.gray)
                            }
                            
                            
                            
                        }
                    }
                }else{
                    Text("Pas encore de résultat")
                }
                
            }
        }
        .navigationTitle(objGroupe.nomGroupe)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
                                HStack {
                                    Image(systemName: "rectangle.and.pencil.and.ellipsis")
                                        .foregroundColor(.orange)
                                        .onTapGesture {
                                            self.action = 3
                                        }.padding()
                                    Spacer()
                                    Image(systemName: "cursorarrow.click.badge.clock")
                                        .foregroundColor(.orange)
                                        .onTapGesture {
                                            self.action = 4
                                        }}
        )
        .onAppear(perform: {
            parcoursManager = ParcoursManager(courseId: objGroupe.courseId)
            detailManager = DetailManager(groupe: objGroupe)
            listReal = detailManager.parcoursRealiseList
            errValList.arrayValid = ErreurManager().ArrayNbValid(parcoursRealiseList: listReal)
            errValList.arrayErr = ErreurManager().ArrayNbErreur(parcoursRealiseList: listReal)
            listeParcoursRestants = detailManager.ListeParcoursRestants()
            if detailManager.enCourseList.count > 0{
                let indProv = detailManager.ListeParcoursRestants().firstIndex(where: { $0.id == detailManager.enCourseList[0].parcoursId }) ?? -1
                selectedParcoursIndex = indProv + 1
                enCourse = true
            }
            toutLesParcoursSontTermines = detailManager.aTermine(groupeId: objGroupe.id, suiviManager: SuiviManager(courseId: objGroupe.courseId))
        })
        NavigationLink(destination: CestPartiView(), tag: 1, selection: $action){}
        NavigationLink(destination: FinParcoursView(objGroupe: objGroupe).environmentObject(objCourse), tag: 2, selection: $action){}
        NavigationLink(destination: ErreursView(objGroupe: objGroupe, parcoursManager: ParcoursManager(courseId: objCourse.id!), erreurManager: ErreurManager(), listReal: listReal).environmentObject(listActuelle), tag: 3, selection: $action){}
        NavigationLink(destination: ModificationTempsView(objGroupe: objGroupe, detailManager: DetailManager(groupe: objGroupe), listParcours: ModificationTempsManager().getModificationTempsList(crsId: objCourse.id!, grId: objGroupe.id), listReal: $listReal).environmentObject(listActuelle), tag: 4, selection: $action){}
    }
    
    func depart() {
        detailManager.depart(courseId: objGroupe.courseId, groupeId: objGroupe.id, parcoursId: detailManager.ListeParcoursRestants()[selectedParcoursIndex - 1].id, nomGroupe: objGroupe.nomGroupe, nomParcours: detailManager.ListeParcoursRestants()[selectedParcoursIndex - 1].parcoursNom)
        enCourse.toggle()
    }
    
    func arrivee() {
        detailManager.arrivee()
        listeParcoursRestants = detailManager.ListeParcoursRestants()
        enCourse.toggle()
        selectedParcoursIndex = 0
        
    }
    func funcPlace(parcours: Int) -> Int {
        let classement = ClassementManager().afficherClassement(course: objCourse, type: 4, parcours: parcours)
        let ind = classement.firstIndex(where: { $0.groupe.id == objGroupe.id }) ?? classement.count
        let tpsMoy = classement[ind].tempsMoy
        var numPlac = 0
        if classement[ind].tempsMoy == 0 {
            numPlac = classement.count - classement.filter { $0.tempsMoy == 0 }.count
        }else{
            numPlac = classement.filter { $0.tempsMoy < tpsMoy && $0.tempsMoy != 0 }.count
        }
        numPlac += 1
        return numPlac
    }
}


struct Header1: View {
    var body: some View {
        HStack {
            Text("Bilan actuel")
            Spacer()
            Text("temps")
        }
    }
}

struct ElementList: View {
    @State var parcoursManager : ParcoursManager
    @State var listReal : [Detail]
    @EnvironmentObject var listActuelle : ListActuelle
    @State var index : Int
    @EnvironmentObject var objCourse : CourseActuelle
    @State var objGroupe: Groupe
    
    var body: some View {
    HStack{
        VStack{
            HStack{
                Text("\(listReal[index].nomParcours)")
                Spacer()
            }
            let indParc = (parcoursManager.parcoursList.firstIndex(where: { $0.id == listReal[index].parcoursId }) ?? 0) + 1
            let place = funcPlace(parcours: indParc)
            HStack{
                Text("Classement :").foregroundColor(.gray)
                Image(systemName: "\(place).circle").foregroundColor(.gray)
                if place < 4{
                    let color = [Color.yellow, Color.gray, Color.orange]
                    Image(systemName: "bolt.heart.fill")
                        .foregroundColor(color[place-1])
                }
                Spacer()
                
            }.font(.subheadline)
        }
        Spacer()
        VStack{
            HStack{
                Spacer()
                Text("\(TempsAffichable().secondsToMinutesSeconds(temps: TempsAffichable().TempsAvecBonusMalus(detail: listReal[index], course: objCourse)))")}
            if errValList.arrayValid[index] > 0 || errValList.arrayErr[index] > 0{
                HStack{
                    Spacer()
                    if errValList.arrayValid[index] > 0{
                            Text("\(errValList.arrayValid[index])").foregroundColor(.green)
                            Image(systemName: "checkmark").foregroundColor(.green)
                        }
                    if errValList.arrayErr[index] > 0{
                            Text("\(errValList.arrayErr[index])").foregroundColor(.red)
                            Image(systemName: "xmark").foregroundColor(.red)
                        }
                }.font(.subheadline)
            }
            
        }
    }
}
    func funcPlace(parcours: Int) -> Int {
        let classement = ClassementManager().afficherClassement(course: objCourse, type: 4, parcours: parcours)
        let ind = classement.firstIndex(where: { $0.groupe.id == objGroupe.id }) ?? classement.count
        let tpsMoy = classement[ind].tempsMoy
        var numPlac = 0
        if classement[ind].tempsMoy == 0 {
            numPlac = classement.count - classement.filter { $0.tempsMoy == 0 }.count
        }else{
            numPlac = classement.filter { $0.tempsMoy < tpsMoy && $0.tempsMoy != 0 }.count
        }
        numPlac += 1
        return numPlac
    }
}
