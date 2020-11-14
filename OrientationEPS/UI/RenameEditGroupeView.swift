//
//  RenameEditView.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 24/10/2020.
//

import SwiftUI

struct RenameEditGroupeView: View {
    let objGroupe : Groupe
    @Binding var list: [Groupe]
    @State var nouveauNom : String = ""
    @State var groupeManager : GroupeManager
    @Environment(\.presentationMode) var presentationMode
    @State var ancienNom = ""
    
    var body: some View {
            VStack{
        Text("\(objGroupe.nomGroupe)")
            .multilineTextAlignment(.center)
            .padding()
        
        VStack{
            HStack{
                TextField("Nouveau nom", text: Binding(
                            get: { self.nouveauNom },
                            set: { (newValue) in
                                if newValue.last! == " " {
                                    self.nouveauNom = String(newValue.dropLast())
                                }else{
                                    self.nouveauNom = newValue
                                }
                               
                            }))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    renameGroupe()
                }, label: {
                    Image(systemName: "checkmark")
                        .font(Font.title.weight(.bold))
                }).disabled(nouveauNom == "" || nouveauNom == ancienNom)
            }.padding()
            if nouveauNom == ancienNom {
                HStack{
                    Image(systemName: "exclamationmark.circle.fill")
                    Text("Ce groupe s'appelle déjà \(nouveauNom)")
                }.foregroundColor(.orange)
            }else{
            if list.filter( { return $0.nomGroupe == nouveauNom } ).count > 0 {
                HStack{
                    Image(systemName: "exclamationmark.circle.fill")
                    Text(" Un groupe avec ce nom existe déjà")
                }.foregroundColor(.orange)
            }
            }
        }
        HStack{
            Image(systemName: "info.circle")
            Text("Pour supprimer une course, glisser la course concernée vers la gauche dans la liste")
        }.padding()
        
        Spacer()
            .navigationBarTitle(Text("Renommer le groupe"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Fermer ")
                Image(systemName: "xmark")
            }))
    }

            .onAppear(){
                ancienNom = objGroupe.nomGroupe
                groupeManager = GroupeManager(courseId: objGroupe.courseId)
            }
    }
    
    func renameGroupe() {
        var nom = nouveauNom
        var count = 0
        while list.filter( { return $0.nomGroupe == nom } ).count > 0 {
            count += 1
            nom = nouveauNom + "(" + String(count) + ")"
        }
        groupeManager.updateNomGroupe(groupe: objGroupe, nouveauNom: nom)
        list = groupeManager.groupeList
        self.presentationMode.wrappedValue.dismiss()
    }
}
