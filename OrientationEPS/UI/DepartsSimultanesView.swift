//
//  DepartsSimultanesView.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 03/11/2020.
//

import SwiftUI

struct DepartsSimultanesView: View {
    let objCourse : Course
    @State var selectedParcoursIndexArray : [Int] = []
    @State var peutSauvegarder = false
    @State var groupeManager : GroupeManager
    var listeParcoursRestants : [String] = []
    @State private var action: Int? = 0
    
    var body: some View {
        HStack{
        Text("Après avoir sélectionner les parcours, appuyer sur le drapeau pour faire partir les coureurs")
            .padding()
            Image(systemName: "arrow.right")
            Button(action: {departColl()}, label: {
                Image(systemName: "flag.badge.ellipsis.fill")
            }).disabled(!peutSauvegarder)
                .padding()
                .font(.largeTitle)

    
            
        }
        Form{
            Section(header: Text("Coureurs/Choix parcours")){
                ForEach(0 ..< groupeManager.groupeList.count, id:\.self){ num in
                    let detailManager = DetailManager(groupe: groupeManager.groupeList[num])
                    let listeParcoursRestants = listRestants(detailManager: detailManager)
                    let enCourse = detailManager.enCourseList.filter { $0.groupeId == groupeManager.groupeList[num].id }
                    Picker(selection: Binding(
                            get: { self.selectedParcoursIndexArray[num] },
                            set: { (newValue) in
                                self.selectedParcoursIndexArray[num] = newValue
                                peutSauvegarder = true
                            }), label: HStack{
                        Image(systemName: "person.fill")
                        Text("\(groupeManager.groupeList[num].nomGroupe)")
                            }.foregroundColor(selectedParcoursIndexArray[num] != 0 ? .orange : Color("ColorDarkLight"))
                    ) {
                        
                        if enCourse.count != 0 {
                            ForEach (0 ..< 1) { ind in
                                Text("\(enCourse[0].nomParcours)")
                            }
                        }else if listeParcoursRestants.count != 1 {
                        let count = listeParcoursRestants.count
                        ForEach (0 ..< count) { ind in
                            Text(listeParcoursRestants[ind])
                        }
                        }else{
                            ForEach (0 ..< 1) { ind in
                            Text("Terminé")
                            }
                        }
                    }.disabled(listeParcoursRestants.count == 1 || enCourse.count != 0)

                }
            }
        }.onAppear(){
            groupeManager = GroupeManager(courseId: objCourse.id)
            for _ in (0 ..< groupeManager.groupeList.count) {
                selectedParcoursIndexArray.append(0)

            }

           
            

        }
            
            .navigationBarTitle(Text("Départs simultanés"), displayMode: .inline)
        NavigationLink(destination: CestPartiView(objCourse: objCourse), tag: 1, selection: $action){}
    }
    func departColl(){
        for ind in (0 ..< groupeManager.groupeList.count) {
            var detailManager = DetailManager(groupe: groupeManager.groupeList[ind])
            let parcSel = selectedParcoursIndexArray[ind]
            if parcSel > 0 {
                detailManager.depart(courseId: objCourse.id, groupeId: groupeManager.groupeList[ind].id, parcoursId: detailManager.ListeParcoursRestants()[parcSel - 1].id, nomGroupe: groupeManager.groupeList[ind].nomGroupe, nomParcours: detailManager.ListeParcoursRestants()[parcSel - 1].parcoursNom)
            }
        }
        self.action = 1
    }
   
    func listRestants(detailManager: DetailManager) -> [String] {
        var listeParcoursRestants = ["Aucun"]
        for cr in detailManager.ListeParcoursRestants() {
            listeParcoursRestants.append(cr.parcoursNom)
        }
        return listeParcoursRestants
        
    }
}
