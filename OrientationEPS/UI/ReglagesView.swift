//
//  ReglagesView.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 30/09/2020.
//

import SwiftUI

struct ReglagesView: View {
    @State var ReprendreLaCourse: Bool
    @EnvironmentObject var objCourse : CourseActuelle
    @State var groupeManager : GroupeManager
    @State var parcoursManager : ParcoursManager
    @State var nbParc : Int16 = 0
    @State var courseManager = CourseManager()
    @State var list : [Parcours] = []
    @State var selectedParcours: Parcours?
    @State var sheet = false
    @State var sheet2 = false
    @State var showingAlert = false
    @State var showingAlert2 = false
    @State var newParcoursName: String = ""
    @State private var action: Int? = 0
    
    
    
    var body: some View {
        NavigationLink(destination: GeneralView(groupeManager: GroupeManager(courseId: objCourse.id!), selectedTab: 2).environmentObject(objCourse), tag: 1, selection: $action){}
        NavigationLink(destination: GestionListeGroupeView(groupeManager: GroupeManager(courseId: objCourse.id!)).environmentObject(objCourse), tag: 2, selection: $action){}
        Form{
            
            Section(header: Text("Créer des parcours")){
                HStack{
                    NavigationLink(destination: SheetMaquetteParcoursView(nbParc: $nbParc, list: $list, parcoursManager: ParcoursManager(courseId: objCourse.id!), listeMaquette: MaquetteManager().MaquetteDistinctParcoursList)) {
                        Text("Par import d'une maquette")
                    }
                }
                .sheet(isPresented: $sheet, content: { SheetMaquetteParcoursView(nbParc: $nbParc, list: $list, parcoursManager: ParcoursManager(courseId: objCourse.id!), listeMaquette: MaquetteManager().MaquetteDistinctParcoursList)
                })
                
                Text("Par création manuelle : ")
                HStack {
                    TextField("Nom nouveau parcours", text: $newParcoursName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {createNewParcours()}, label: {
                        Image(systemName: "plus")
                            .font(.title)
                    })
                }.sheet(item: self.$selectedParcours, content: { sel in
                    RenameEditParcoursView(objParcours: sel, list: $list, parcoursManager: parcoursManager)
                })
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Information"), message: Text("En diminuant le nombre de parcours, les résultats éventuels sur ces parcours seront supprimés"), dismissButton: .default(Text("Compris")))
                }
                
                if list.filter( { return $0.parcoursNom == newParcoursName } ).count > 0 {
                    HStack{
                        Image(systemName: "exclamationmark.circle.fill")
                        Text(" Un parcours avec ce nom existe déjà")
                    }.foregroundColor(.orange)
                }
            }
            
            Section(footer: FooterSupp(nb: Int(nbParc), str: "modifier")){
                HStack{
                    Text("Liste des parcours :").bold()
                    Spacer()
                    Text("\(nbParc) parcours")
                }
                
                
                let count = list.count
                if count == 0 {
                    Text("Aucun parcours dans cette course. Cliquer sur le + orange pour ajouter un parcours")
                }else{
                    NavigationLink(destination: SheetSauvParcoursMaquetteView(courseId: objCourse.id!)) {
                        Text("Ajouter cette liste à mes maquettes")
                    }
                    List {
                        ForEach(list){ parc in
                            HStack {
                                Image(systemName: "pencil.circle.fill")
                                    .font(.title)
                                    .onTapGesture {
                                        self.selectedParcours = parc
                                    }
                                Text("\(parc.parcoursNom)")
                                Spacer()
                                if parc.distance > 0 {
                                    Text("\(parc.distance) m")
                                    
                                }}
                        }.onDelete(perform: { indexSet in
                            DeleteParcours(ind: indexSet)
                        })
                    }
                }
            }
        }
        .alert(isPresented: $showingAlert2) {
            Alert(title: Text("Liste vide"), message: Text("Ajouter au minimum un parcours à la liste, en appuyant sur le + orange"), dismissButton: .default(Text("Compris")))
        }
        .onAppear(perform: {
            groupeManager = GroupeManager(courseId: objCourse.id!)
            parcoursManager = ParcoursManager(courseId: objCourse.id!)
            list = parcoursManager.parcoursList
            nbParc = Int16(list.count)
        })
        .navigationTitle("\(objCourse.nomCourse)/Parcours")
        .navigationBarItems(trailing:
                                Image(systemName: "checkmark.circle.fill")
                                .font(.title)
                                .foregroundColor(list.count > 0 ? .orange : Color("ColorDarkLight"))
                                .onTapGesture {
                                    if list.count > 0 {
                                    if ReprendreLaCourse{
                                        self.action = 1
                                    }else{
                                        self.action = 2
                                    }}else{
                            self.showingAlert2 = true
                                    }}
        )
        }
    func DeleteParcours(ind: IndexSet) {
        for i in ind {
            parcoursManager.removeParcoursFromStepper(parcours: parcoursManager.parcoursList[i])
        }
        list = parcoursManager.parcoursList
        nbParc = Int16(list.count)
    }
    
    func createNewParcours() {
        nbParc += 1
        if newParcoursName == "" {
            parcoursManager.addParcours(courseId: objCourse.id!, parcoursNum: nbParc, distance: 0)
        }else{
            var nom : String = newParcoursName
            var count = 0
            while parcoursManager.parcoursList.filter( { return $0.parcoursNom == nom } ).count > 0 {
                count += 1
                nom = newParcoursName + "(" + String(count) + ")"
            }
            let newParcours = Parcours(courseId: objCourse.id!, parcoursNum: nbParc, parcoursNom: nom, distance: 0)
            parcoursManager.addParcoursAvecNom(parc: newParcours, distance: 0)
            newParcoursName = ""
        }
        parcoursManager.affListe()
        list = parcoursManager.parcoursList
    }
}



