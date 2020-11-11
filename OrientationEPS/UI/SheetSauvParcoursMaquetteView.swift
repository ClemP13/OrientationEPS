//
//  SheetSauvParcoursMaquetteView.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 26/10/2020.
//

import SwiftUI

struct SheetSauvParcoursMaquetteView: View {
    let courseId : UUID
    @State var nomMaquette : String = ""
    @State var maquetteManager = MaquetteManager()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
            VStack{
                Text("Sauvegarder la liste actuelle comme maquette de parcours")
                    .multilineTextAlignment(.center)
                    .padding()
                HStack{
                    TextField("Nom de la maquette", text: $nomMaquette)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        sauvMaquette()
                    }, label: {
                        Image(systemName: "checkmark")
                            .font(Font.title.weight(.bold))
                    }).disabled(nomMaquette == "")
                }.padding()
                HStack{
                        if maquetteManager.MaquetteDistinctParcoursList.filter( { return $0.nomMaquette == nomMaquette } ).count > 0 {
                            
                            Image(systemName: "exclamationmark.circle.fill")
                            Text(" Une maquette avec ce nom existe déjà")
                        }
                }.foregroundColor(.orange)
                
                Spacer()
                    
                    .navigationBarTitle(Text("Maquette de parcours"), displayMode: .inline)
            }
        
    }
    func sauvMaquette() {
        if maquetteManager.MaquetteDistinctParcoursList.filter( { return $0.nomMaquette == nomMaquette } ).count > 0 {
            nomMaquette += "(1)"
        }
        let parcoursList = ParcoursManager(courseId: courseId).parcoursList
        for parcours in parcoursList {
            let mq = MaquetteParcours(nomParcours: parcours.parcoursNom, nomMaquette: nomMaquette, distance: parcours.distance)
            maquetteManager.addMaquetteParcours(maquetteParcours: mq)
        }
        self.presentationMode.wrappedValue.dismiss()
    }
}
