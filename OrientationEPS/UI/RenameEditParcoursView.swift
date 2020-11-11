//
//  RenameEditView.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 24/10/2020.
//

import SwiftUI

struct RenameEditParcoursView: View {
    let objParcours : Parcours
    @Binding var list: [Parcours]
    @State var nouveauNom : String = ""
    @State var parcoursManager : ParcoursManager
    @Environment(\.presentationMode) var presentationMode
    @State var ancienNom = ""
    @State var distance = ""
    @State private var bonFormatDistance = true
    
    var body: some View {
        NavigationView {
            VStack{
                VStack{
                Text("\(objParcours.parcoursNom)")
                    .multilineTextAlignment(.center)
                Text("Distance : \(objParcours.distance)m")
                        .multilineTextAlignment(.center)
                }.padding()
                HStack{
                    VStack{
                        HStack{
                            TextField("Nouveau nom", text: $nouveauNom)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        if nouveauNom == ancienNom {
                            HStack{
                                Image(systemName: "exclamationmark.circle.fill")
                                Text("Ce parcours s'appelle déjà \(nouveauNom)")
                            }.foregroundColor(.orange)
                        }else{
                            if list.filter( { return $0.parcoursNom == nouveauNom } ).count > 0 {
                                HStack{
                                    Image(systemName: "exclamationmark.circle.fill")
                                    Text(" Un parcours avec ce nom existe déjà")
                                }.foregroundColor(.orange)
                            }
                        }
                        TextField("Distance (en m)", text: Binding(
                                    get: { self.distance },
                                    set: { (newValue) in
                                        self.distance = newValue
                                        let distanceInt = Int(self.distance) ?? -1
                                        if distanceInt == -1 {
                                            bonFormatDistance = false
                                        }else{
                                            bonFormatDistance = true
                                        }
                                        if distance == ""{
                                            bonFormatDistance = true
                                        }
                                        
                                    }))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }.padding()
                    Button(action: {
                        renameParcours()
                    }, label: {
                        Image(systemName: "checkmark")
                            .font(Font.title.weight(.bold))
                    }).disabled((nouveauNom == "" && distance == "") || nouveauNom == ancienNom || !bonFormatDistance)
                }.padding()
                
                VStack{
                    HStack{
                        Image(systemName: "info.circle")
                        Text(" Info ")
                        Image(systemName: "info.circle")
                    }.padding()
                        Text("- La distance n'est pas obligatoire, elle permet le calcul de la RK théorique (réduction kilométrique en min/km)\n\n- Pour supprimer un parcours, glisser le parcours concerné vers la gauche dans la liste")
                }.padding()
                
                
                
                Spacer()
                    .navigationBarTitle(Text("Renommer le parcours"), displayMode: .inline)
                    .navigationBarItems(trailing: Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Fermer ")
                        Image(systemName: "xmark")
                    }))
            }
        }
        .onAppear(){
            ancienNom = objParcours.parcoursNom
            parcoursManager = ParcoursManager(courseId: objParcours.courseId)
        }
    }
    
    func renameParcours() {
        if distance == "" {
            distance = "0"
        }
        let distanceInt = Int16(distance) ?? 0
        var nom = ""
        if nouveauNom == "" {
           nom = ancienNom
        }else{
        nom = nouveauNom
        var count = 0
        while list.filter( { return $0.parcoursNom == nom } ).count > 0 {
            count += 1
            nom = nouveauNom + "(" + String(count) + ")"
        }
        }
        parcoursManager.updateNomParcours(parcours: objParcours, nouveauNom: nom, distance: distanceInt)
        list = parcoursManager.parcoursList
        self.presentationMode.wrappedValue.dismiss()
    }
}
