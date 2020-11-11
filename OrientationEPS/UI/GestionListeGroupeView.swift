//
//  GestionListeGroupeView.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 26/10/2020.
//

import SwiftUI

struct GestionListeGroupeView: View {
    @State var groupeManager : GroupeManager
    let objCourse : Course
    @State var newGroupeName:String = ""
    @State var list : [Groupe] = []
    @State var selectedGroupe: Groupe?
    @State var showingAlert2 = false
    @State private var action: Int? = 0
    @EnvironmentObject var stopwatch : Stopwatch
    
    var body: some View {
        NavigationLink(destination: GeneralView(objCourse: objCourse, groupeManager: GroupeManager(courseId: objCourse.id), selectedTab: 2).environmentObject(stopwatch), tag: 1, selection: $action) {}
        Form{
            Section(header: Text("Créer des coureurs")){
                NavigationLink(destination: SheetMaquetteGroupeView(objCourse: objCourse, list: $list, groupeManager: GroupeManager(courseId: objCourse.id), listeMaquette: MaquetteManager().MaquetteDistinctGroupeList)) {
                    Text("Par import d'une maquette")
                }
                Text("Par création manuelle :")
                HStack {
                    TextField("Nom du coureur", text: Binding(
                                get: { self.newGroupeName },
                                set: { (newValue) in
                                    if newValue.last! == " " {
                                        self.newGroupeName = String(newValue.dropLast())
                                    }else{
                                        self.newGroupeName = newValue
                                    }
                                   
                                }))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {createNewGroupe()}, label: {
                        Image(systemName: "plus")
                            .font(.title)
                    })
                }
                if list.filter( { return $0.nomGroupe == newGroupeName } ).count > 0 {
                    HStack{
                        Image(systemName: "exclamationmark.circle.fill")
                        Text(" Un coureur avec ce nom existe déjà")
                    }.foregroundColor(.orange)}
            }
        
            Section(footer: FooterSupp(nb: groupeManager.groupeList.count, str: "renommer")){
                HStack{
            Text("Liste des coureurs : ")
                .bold()
                    Spacer()
                    Text("\(String.localizedStringWithFormat(NSLocalizedString("%d coureurs", comment: ""), groupeManager.groupeList.count))")

                }
                    let count = list.count
                    if count == 0 {
                        Text("Aucun coureur dans cette course. Cliquer sur le + orange pour ajouter un coureur")
                    }else{
                        NavigationLink(destination: SheetSauvGroupeMaquetteView(courseId: objCourse.id)) {
                            Text("Sauv. liste comme maquette")
                        }
        List {
            let count = list.count
            if count == 0 {
                Text("Aucun coureur dans cette course")
            }else {
            ForEach(list){ gr in
                HStack {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title)
                        .onTapGesture {
                            self.selectedGroupe = gr
                        }
                    Text("\(gr.nomGroupe)")
                }
            }.onDelete(perform: { indexSet in
                DeleteGroupe(ind: indexSet)
            })
        }
        }}
            }
            
        }        .sheet(item: self.$selectedGroupe, content: { sel in
            RenameEditGroupeView(objGroupe: sel, list: $list, groupeManager: groupeManager)
        })


            .navigationTitle("\(objCourse.nomCourse)/Coureurs")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:
                                    Image(systemName: "checkmark.circle.fill")
                                    .font(.title)
                                    .foregroundColor(list.count > 0 ? .orange : Color("ColorDarkLight"))
                                    .onTapGesture {
                                        if list.count > 0 {
                                            self.action = 1
                                        }else{
                                self.showingAlert2 = true
                                        }}
            )
        .alert(isPresented: $showingAlert2) {
            Alert(title: Text("Liste vide"), message: Text("Ajouter au minimum un groupe à la liste, en appuyant sur le + orange"), dismissButton: .default(Text("Compris")))
        }
            .onAppear(){
                list = groupeManager.groupeList
                afficherListe()
        }
    }
    func afficherListe(){
        groupeManager.affListe()
    }
    
    func createNewGroupe() {
        var nom = newGroupeName
        var count = 0
        while list.filter( { return $0.nomGroupe == nom } ).count > 0 {
            count += 1
            nom = newGroupeName + "(" + String(count) + ")"
        }
        groupeManager.addGroupe(withName: nom, inCourse: objCourse.id)
        newGroupeName = ""
        list = groupeManager.groupeList
        afficherListe()
    }
    func DeleteGroupe(ind: IndexSet) {
        for i in ind {
            groupeManager.removeGroupe(groupe: groupeManager.groupeList[i])
        }
        list = groupeManager.groupeList
        afficherListe()
    }
}
