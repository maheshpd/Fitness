//
//  ContentView.swift
//  Fitness
//
//  Created by Mahesh Prasad on 09/08/20.
//  Copyright © 2020 CreatesApp. All rights reserved.
//

import SwiftUI
import Firebase

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    
    @ObservedObject var data = getData()
    
    var body: some View {
        ZStack {
            Color("Color")
                .edgesIgnoringSafeArea(.all)
            
            if self.data.data != nil {
                
                VStack{
                    HStack{
                        Text("Fitness")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {
                            self.data.data = nil
                            self.data.updateData()
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    }
                    
                    Spacer()
                    
                    ZStack{
                        ProgressBar(height: 300, to: CGFloat(CGFloat(truncating: self.data.data.steps)/10000), color: .red)
                        ProgressBar(height: 230, to: CGFloat(CGFloat(truncating: self.data.data.calories)/1500) , color: .yellow)
                        ProgressBar(height: 160, to: CGFloat(CGFloat(truncating: self.data.data.cycling) / 5) , color: Color("Color1"))
                    }
                    
                    HStack(spacing: 20) {
                        HStack{
                            Image("foot")
                                .resizable()
                                .frame(width: 55, height: 55)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Steps")
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                                
                                Text("\(self.data.data.steps)/10000")
                                    .foregroundColor(.white)
                            }
                        }
                        
                        HStack{
                            Image("cal")
                                .resizable()
                                .frame(width: 55, height: 55)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Calories")
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                                
                                Text("\(self.data.data.calories)/1500")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.top, 45)
                    
                    HStack(spacing: 20) {
                        HStack{
                            Image("cycle")
                                .resizable()
                                .frame(width: 55, height: 55)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Cycling")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("Color1"))
                                
                                Text("\(self.data.data.cycling)/5 KM")
                                    .foregroundColor(.white)
                            }
                        }.offset(x: -20)
                        HStack{
                            Image("heart")
                                .resizable()
                                .frame(width: 55, height: 55)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Heart")
                                    .fontWeight(.bold)
                                    .foregroundColor(.yellow)
                                
                                Text("\(self.data.data.heart) BPM")
                                    .foregroundColor(.white)
                            }
                        }
                        .offset(x: 5)
                    }.padding(.top, 20)
                    
                    Spacer()
                }.padding()
                
                
            }
             
            else {
                Indicator()
            }
        }
    }
}

struct ProgressBar : View {
    
    var height : CGFloat
    var to : CGFloat
    var color : Color
    var body : some View {
        ZStack{
            Circle()
                .trim(from: 0, to: 1)
                .stroke(Color.black.opacity(0.25), style: StrokeStyle(lineWidth: 30, lineCap: .round))
                .frame(height: height)
            
            Circle()
                .trim(from: 0, to: to)
                .stroke(color, style: StrokeStyle(lineWidth: 30, lineCap: .round))
                .frame(height: height)
        }
        .rotationEffect(.init(degrees: 270))
    }
}

class Host : UIHostingController<ContentView> {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

struct Datas {
    var steps : NSNumber
    var calories : NSNumber
    var cycling : NSNumber
    var heart : NSNumber
}

class getData : ObservableObject {
    @Published var data : Datas!
    
    init() {
        updateData()
    }
    
    func updateData() {
        let db = Firestore.firestore()
        db.collection("Data").document("Home").getDocument { (snap, err) in
            
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            let steps = snap?.get("steps") as! NSNumber
            let calories = snap?.get("calories") as! NSNumber
            let cycling = snap?.get("cycling") as! NSNumber
            let heart = snap?.get("heart") as! NSNumber
            
            DispatchQueue.main.async {
                self.data = Datas(steps: steps, calories: calories, cycling: cycling, heart: heart)
            }
        }
    }
}

struct Indicator : UIViewRepresentable {
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        
    }
    

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        
        let view = UIActivityIndicatorView(style: .large)
        view.color = .white
        view.startAnimating()
        return view
    }
}
