//
//  SheetMaquetteGroupeView.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 26/10/2020.
//

import SwiftUI

struct SheetMaquetteGroupeView: View {
    @EnvironmentObject var objCourse : CourseActuelle
    @Binding var list: [Groupe]
    @State var maquetteManager = MaquetteManager()
    @State var groupeManager : GroupeManager
    @State var courseManager = CourseManager()
    @State var listeMaquette : [MaquetteGroupe]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
            VStack{
                Text("Une maquette est une liste de courreurrs qui peut être importée dans une course")
                    .padding()
                Form{
                List{
                    if listeMaquette.count > 0{
                    ForEach (listeMaquette) { maq in
                        let nom = maq.nomMaquette
                        HStack{
                            Image(systemName: "plus.circle")
                                .onTapGesture {
                                    AjoutMaquette(nomMaquette: nom)
                                }
                        Text(nom)
                        Spacer()
                            Text("\(String.localizedStringWithFormat(NSLocalizedString("%d coureurs", comment: ""), maquetteManager.nbGroupeInMaquette(nomMaquette: nom)))")
                        }}
                        .onDelete(perform: { indexSet in
                            DeleteMaquette(ind: indexSet)
                            maquetteManager.affListeParcours()
                        })
                        
                    }else{
                        Text("Aucune Maquette")
                    }
                }}.navigationBarTitle(Text("Utiliser une maquette de coureurs"), displayMode: .inline)
                
            }
        .onAppear(){
            groupeManager = GroupeManager(courseId: objCourse.id!)
            listeMaquette = maquetteManager.MaquetteDistinctGroupeList
        }
    }
    func AjoutMaquette(nomMaquette: String){
        let listG = maquetteManager.getListDetailMaquetteGroupe(nomMaquette: nomMaquette)
        for groupe in listG {
            var nom : String = groupe.nomGroupe
            var count = 0
            while groupeManager.groupeList.filter( { return $0.nomGroupe == nom } ).count > 0 {
                count += 1
                nom = groupe.nomGroupe + "(" + String(count) + ")"
            }
            let newGroupe = Groupe(courseId: objCourse.id!, nomGroupe: nom)
            groupeManager.addGroupeAvecNom(gr: newGroupe)
        }
        list = groupeManager.groupeList
        self.presentationMode.wrappedValue.dismiss()
    }
    func DeleteMaquette(ind: IndexSet) {
        for i in ind {
        maquetteManager.removeMaquetteGroupe(maquetteGroupe: maquetteManager.MaquetteDistinctGroupeList[i])
        }
        listeMaquette = maquetteManager.MaquetteDistinctGroupeList
    }

}

