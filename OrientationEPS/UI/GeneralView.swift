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
    @EnvironmentObject var stopwatch : Stopwatch
    @EnvironmentObject var objCourse : CourseActuelle
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {

                Settings(groupeManager: groupeManager, timerOn: $timerOn).environmentObject(objCourse)
                    .environmentObject(stopwatch)
                
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
                        Image(systemName: "eye.fill")
                        Text("Suivi")
                    }.tag(3)
                
              ClassementView(courseId: objCourse.id!).environmentObject(objCourse)
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
            print(self.objCourse.id!)
            timerOn =  UserDefaults.standard.bool(forKey: "timerOn")
        }

    }
}
