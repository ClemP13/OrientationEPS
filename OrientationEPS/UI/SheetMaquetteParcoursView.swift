//
//  SheetMaquetteParcoursView.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 26/10/2020.
//

import SwiftUI

struct SheetMaquetteParcoursView: View {
    @State var objCourse : Course
    @Binding var nbParc : Int16
    @Binding var list: [Parcours]
    @State var maquetteManager = MaquetteManager()
    @State var parcoursManager : ParcoursManager
    @State var courseManager = CourseManager()
    @State var listeMaquette : [MaquetteParcours]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
            VStack{
                Text("Une maquette est une liste de parcours qui peut être importée dans une course")
                    .padding()
                Form{
                    List{
                        if listeMaquette.count > 0{
                            ForEach (listeMaquette) { maq in
                                let nom = maq.nomMaquette
                                HStack{
                                    Image(systemName: "plus.circle")
                                    Text(nom)
                                    Spacer()
                                    Text("\(String(maquetteManager.nbParcoursInMaquette(nomMaquette: nom))) parcours")
                                }.onTapGesture {
                                    AjoutMaquette(nomMaquette: nom)
                                }
                                
                            }.onDelete(perform: { indexSet in
                                DeleteMaquette(ind: indexSet)
                                maquetteManager.affListeParcours()
                            })
                            
                        }else{
                            Text("Aucune Maquette")
                        }
                    }
                }.navigationBarTitle(Text("Utiliser une maquette de parcours"), displayMode: .inline)
                
            }
        .onAppear(){
            parcoursManager = ParcoursManager(courseId: objCourse.id)
            listeMaquette = maquetteManager.MaquetteDistinctParcoursList
        }
    }
    func AjoutMaquette(nomMaquette: String){
        let listP = maquetteManager.getListDetailMaquetteParcours(nomMaquette: nomMaquette)
        for parc in listP {
            var nom : String = parc.nomParcours
            var count = 0
            while parcoursManager.parcoursList.filter( { return $0.parcoursNom == nom } ).count > 0 {
                count += 1
                nom = parc.nomParcours + "(" + String(count) + ")"
            }
            nbParc = Int16(parcoursManager.parcoursList.count + 1)
            let newParc = Parcours(courseId: objCourse.id, parcoursNum: nbParc, parcoursNom: nom, distance: parc.distance)
            parcoursManager.addParcoursAvecNom(parc: newParc, distance: parc.distance)
            
        }
        list = parcoursManager.parcoursList
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func DeleteMaquette(ind: IndexSet) {
        for i in ind {
            maquetteManager.removeMaquetteParcours(maquetteParcours: maquetteManager.MaquetteDistinctParcoursList[i])
        }
        listeMaquette = maquetteManager.MaquetteDistinctParcoursList
    }
    
}
