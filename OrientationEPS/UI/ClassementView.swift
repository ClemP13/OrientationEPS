//
//  ClassementView.swift
//  OrientationEPS
//
//  Created by Clement Pignet on 18/10/2020.
//

import SwiftUI

struct ClassementView: View {
    let courseId : UUID
    @EnvironmentObject var objCourse : CourseActuelle
    @State var classementManager = ClassementManager()
    @State var listeClassement : [DetailClassement] = []
    @State var listeParcours : [Parcours] = []
    @State var choixClassement : [String] = []
    let data = [\DetailClassement.nbParcoursRealises,\DetailClassement.nbErreur,\DetailClassement.nbValid,\DetailClassement.rkMoyen,\DetailClassement.tempsMoy,\DetailClassement.tempsTotal]
    @State var selectedIndex = UserDefaults.standard.integer(forKey: "indexClassement")
    @State var selectedIndexParcours = UserDefaults.standard.integer(forKey: "parcoursClassement")
    let listActuelle = ListActuelle()
    
    var body: some View {
        Form{
            Section(header: Text("Gestion du classement")){
                Picker(selection: Binding(
                        get: { self.selectedIndexParcours },
                        set: { (newValue) in
                            self.selectedIndexParcours = newValue
                            if selectedIndexParcours != 0 {
                                choixClassement = ["Parcours réalisé","Nombre de balises fausses","Nombre de balises validées","Réduction kilométrique","Temps sur parcours"]
                                if selectedIndex == 5 {
                                    selectedIndex = 4
                                }
                            }else{
                                choixClassement = ["Nombre de parcours réalisés","Nombre de balises fausses","Nombre de balises validées","RK moyenne","Temps moyen","Temps total"]
                            }
                            UserDefaults.standard.set(selectedIndexParcours, forKey:"parcoursClassement")
                            UserDefaults.standard.set(selectedIndex, forKey:"indexClassement")
                        }), label: Text("Parcours ")) {
                    ForEach (0 ..< listeParcours.count + 1, id: \.self) { num in
                        if num == 0 {
                            Text("Tous")
                        }else{
                            HStack{
                                Text(listeParcours[num - 1].parcoursNom)
                            }}
                    }
                }
                Picker(selection: Binding(
                        get: { self.selectedIndex },
                        set: { (newValue) in
                            self.selectedIndex = newValue
                            UserDefaults.standard.set(selectedIndex, forKey:"indexClassement")
                        }), label: Text("Classé par ")) {
                    
                    ForEach (0 ..< choixClassement.count, id: \.self) {
                        Text(choixClassement[$0])
                    }
                }
            }
              
            
            Section(header: HeaderClassement(type: selectedIndex)){
                List{
                    ForEach(0 ..< listeClassement.count, id: \.self) { gr in
                        let place = funcPlace(gr: gr)
                        let objGroupe = listeClassement[gr].groupe
                        NavigationLink( destination: GroupeDetailsView(objGroupe: objGroupe, detailManager: DetailManager(groupe: objGroupe), parcoursManager: ParcoursManager(courseId: objCourse.id!)).environmentObject(objCourse).environmentObject(listActuelle),
                            label: {
                                HStack{
                                    Image(systemName: "\(place).circle")
                                    if place < 4{
                                        let color = [Color.yellow, Color.gray, Color.orange]
                                        Image(systemName: "bolt.heart.fill")
                                            .foregroundColor(color[place-1])
                                    }
                                    if place < 4 {
                                        Text("\(listeClassement[gr].groupe.nomGroupe)").bold()
                                    }else{
                                        Text("\(listeClassement[gr].groupe.nomGroupe)")
                                    }
                                    
                                    Spacer()
                                    VStack{
                                        if selectedIndex >= 3 {
                                            Text(String(TempsAffichable().secondsToMinutesSeconds(temps: listeClassement[gr][keyPath: data[selectedIndex]]) ))
                                            if listeClassement[gr].nbValid > 0 || listeClassement[gr].nbErreur  > 0{
                                                HStack{
                                                    if listeClassement[gr].nbValid > 0 {
                                                        Text("\(listeClassement[gr].nbValid)").foregroundColor(.green)
                                                        Image(systemName: "checkmark").foregroundColor(.green)
                                                    }
                                                    if listeClassement[gr].nbErreur  > 0{
                                                        
                                                        Text("\(listeClassement[gr].nbErreur)").foregroundColor(.red)
                                                        Image(systemName: "xmark").foregroundColor(.red)
                                                    }
                                                }.font(.subheadline)
                                            }
                                        }else{
                                            Text(String(listeClassement[gr][keyPath: data[selectedIndex]]))
                                        }
                                    }
                                }
                            }
                        )
                        
                    }
                    
                }
            }
        }
        .onAppear(perform: {
            
            if selectedIndexParcours != 0 {
                choixClassement = ["Parcours réalisé","Nombre de balises fausses","Nombre de balises validées","Réduction kilométrique","Temps sur parcours"]
            }else{
                choixClassement = ["Nombre de parcours réalisés","Nombre de balises fausses","Nombre de balises validées","RK moyenne","Temps moyen","Temps total"]
            }
            listeParcours = ParcoursManager(courseId: courseId).parcoursList
            listeClassement = classementManager.afficherClassement(course: objCourse, type: selectedIndex, parcours: selectedIndexParcours)
        })
    }
    func funcPlace(gr: Int) -> Int {
        let compare = listeClassement[gr][keyPath: data[selectedIndex]]
        var numPlac = 0
        if selectedIndex == 0 || selectedIndex == 2 {
            numPlac = listeClassement.filter { $0[keyPath: data[selectedIndex]] > compare }.count
        }else if selectedIndex >= 3 {
            if listeClassement[gr][keyPath: data[selectedIndex]] == 0 {
                numPlac = listeClassement.count - listeClassement.filter { $0[keyPath: data[selectedIndex]] == 0 }.count
            }else{
                numPlac = listeClassement.filter { $0[keyPath: data[selectedIndex]] < compare && $0[keyPath: data[selectedIndex]] != 0 }.count
            }
        }else{
            numPlac = listeClassement.filter { $0[keyPath: data[selectedIndex]] < compare }.count
        }
        
        numPlac += 1
        return numPlac
    }
}

struct HeaderClassement: View {
    let type : Int
    let list = ["Nb Parcours","Erreurs","Validations","RK","Temps","Temps",]
    
    var body: some View {
        HStack{
            Text("Classement")
            Spacer()
            Text("\(list[type])")
            }
    }
}
