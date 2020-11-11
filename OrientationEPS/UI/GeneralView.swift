//
//  GeneralView.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 01/10/2020.
//
import SwiftUI


struct GeneralView: View {
    @State var objCourse : Course
    @State var groupeManager : GroupeManager
    @State var selectedTab: Int = 2
    @State private var accueil: Int? = 1
    @State var timerOn : Bool = false
    @EnvironmentObject var stopwatch : Stopwatch
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {

                Settings(objCourse: $objCourse, groupeManager: groupeManager, timerOn: $timerOn)
                    .environmentObject(stopwatch)
                
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                        Text("Réglages")
                    }.tag(1)
                
                GroupeGeneralView(objCourse: objCourse, groupeManager: groupeManager).environmentObject(stopwatch)
                    .tabItem {
                        Image(systemName: "square.grid.3x2.fill")
                        Text("Général")
                    }.tag(2)
                
                SuiviView(objCourse: objCourse, suiviManager: SuiviManager(courseId: objCourse.id))
                    .tabItem {
                        Image(systemName: "eye.fill")
                        Text("Suivi")
                    }.tag(3)
                
                ClassementView(courseId: objCourse.id, objCourse: objCourse, classementManager: ClassementManager())
                    .tabItem {
                        Image(systemName: "hare.fill")
                        Text("Classement")
                    }.tag(4)
                
                if timerOn {
                   
                    ChronoView().environmentObject(stopwatch)
                        .tabItem {
                        Image(systemName: "stopwatch.fill")
                            Text(String(TempsAffichable().secondsToMinutesSeconds(temps: Int32(stopwatch.restant)) ))
                    }.tag(5)
                       
                }
            }.accentColor(.orange)
            NavigationLink(destination: CourseListView(), tag: 1, selection: $accueil){
                Text("")
            }
        }.navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(){
            timerOn =  UserDefaults.standard.bool(forKey: "timerOn")
        }

    }
}
