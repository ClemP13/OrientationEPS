//
//  GeneralView.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 01/10/2020.
//
import SwiftUI


struct GeneralView: View {
    @State var groupeManager : GroupeManager
    @State var selectedTab: Int = 2
    @State private var accueil: Int? = 1
    @State var timerOn : Bool = false
    let title = ["","Réglages","Général","Suivi","Classement"]
    let icon = ["","gearshape.fill","square.grid.3x2.fill","figure.walk.diamond.fill","hare.fill"]
    @EnvironmentObject var objCourse : CourseActuelle
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            Settings(groupeManager: groupeManager, timerOn: $timerOn).environmentObject(objCourse)
                
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Réglages")
                }.tag(1)
            
            GroupeGeneralView(groupeManager: groupeManager).environmentObject(objCourse)
                .tabItem {
                    Image(systemName: "square.grid.3x2.fill")
                    Text("Général")
                }.tag(2)
            
            SuiviView(suiviManager: SuiviManager(courseId: objCourse.id!)).environmentObject(objCourse)
                .tabItem {
                    Image(systemName: "figure.walk.diamond.fill")
                    Text("Suivi")
                }.tag(3)
            
            ClassementView(courseId: objCourse.id!).environmentObject(objCourse)
                .tabItem {
                    Image(systemName: "hare.fill")
                    Text("Classement")
                }.tag(4)
            
        }.accentColor(.orange)
        .navigationTitle("Back")
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Image(systemName: icon[selectedTab])
                        .foregroundColor(Color("ColorDarkLight"))
                    Text(" \(title[selectedTab]) ")
                        .bold()
                        .foregroundColor(.orange)
                        .font(.title)
                    Image(systemName: icon[selectedTab])
                        .foregroundColor(Color("ColorDarkLight"))
                }
            }}
        .navigationBarItems(leading: EmptyView(), trailing: EmptyView())
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(){
            timerOn =  UserDefaults.standard.bool(forKey: "timerOn")
        }
    }
}
