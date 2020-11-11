//
//  SheetSauvGroupeMaquetteView.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 28/10/2020.
//

import SwiftUI

struct SheetSauvGroupeMaquetteView: View {
    let courseId : UUID
    @State var nomMaquette : String = ""
    @State var maquetteManager = MaquetteManager()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
            VStack{
                Text("Sauvegarder la liste actuelle comme maquette de coureurs")
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
                    if maquetteManager.MaquetteDistinctGroupeList.filter( { return $0.nomMaquette == nomMaquette } ).count > 0 {
                        Image(systemName: "exclamationmark.circle.fill")
                        Text(" Une maquette avec ce nom existe déjà")
                    }
                }.foregroundColor(.orange)
                .padding()

                Spacer()
                    .navigationBarTitle(Text("Maquette de groupe"), displayMode: .inline)
            }
        
    }
    func sauvMaquette() {
        if maquetteManager.MaquetteDistinctGroupeList.filter( { return $0.nomMaquette == nomMaquette } ).count > 0 {
            nomMaquette += "(1)"
        }
        let groupeList = GroupeManager(courseId: courseId).groupeList
        for groupe in groupeList {
            let mq = MaquetteGroupe(nomGroupe: groupe.nomGroupe, nomMaquette: nomMaquette)
            maquetteManager.addMaquetteGroupe(maquetteGroupe: mq)
        }
        self.presentationMode.wrappedValue.dismiss()
    }
}
