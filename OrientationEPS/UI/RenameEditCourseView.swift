//
//  RenameEditView.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 24/10/2020.
//

import SwiftUI

struct RenameEditCourseView: View {
    let objCourse : Course
    @Binding var list: [Course]
    @State var nouveauNom : String = ""
    @State var courseManager = CourseManager()
    @Environment(\.presentationMode) var presentationMode
    @State var ancienNom = ""
    
    var body: some View {
        NavigationView {
            VStack{
                Text("\(objCourse.nomCourse)")
                    .multilineTextAlignment(.center)
                    .padding()
                VStack{
                    HStack{
                        TextField("Nouveau nom", text: $nouveauNom)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button(action: {
                            renameCourse()
                        }, label: {
                            Image(systemName: "checkmark")
                                .font(Font.title.weight(.bold))
                        }).disabled(nouveauNom == "" || nouveauNom == ancienNom)
                    }.padding()
                    if nouveauNom == ancienNom {
                        HStack{
                            Image(systemName: "exclamationmark.circle.fill")
                            Text("Cette course s'appelle déjà \(nouveauNom)")
                        }.foregroundColor(.orange)
                    }else{
                    if list.filter( { return $0.nomCourse == nouveauNom } ).count > 0 {
                        HStack{
                            Image(systemName: "exclamationmark.circle.fill")
                            Text(" Une course avec ce nom existe déjà")
                        }.foregroundColor(.orange)
                    }
                    }
                }
                HStack{
                    Image(systemName: "info.circle")
                    Text("Pour supprimer une course, glisser la course concernée vers la gauche dans la liste")
                }.padding()
                
                Spacer()
                    .onAppear(){
                        ancienNom = objCourse.nomCourse
                    }
                    .navigationBarTitle(Text("Renommer la course"), displayMode: .inline)
                    .navigationBarItems(trailing: Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Fermer ")
                        Image(systemName: "xmark")
                    }))
            }
        }
    }
    func renameCourse() {
        var nom = nouveauNom
        var count = 0
        while list.filter( { return $0.nomCourse == nom } ).count > 0 {
            count += 1
            nom = nouveauNom + "(" + String(count) + ")"
        }
        CourseActuelle().nomCourse = nom
        courseManager.updateNomCourse(courseId: objCourse.id, nouveauNom: nom)
        list = courseManager.recupListe()
        self.presentationMode.wrappedValue.dismiss()
    }
}
