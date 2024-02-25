//
//  ContentView.swift
//  Pace
//
//  Created by Carter Schafer on 2/23/24.
//

import SwiftUI

struct ContentView: View {
  @StateObject var pageContent = PageContent()
  
  @State var showSettings : Bool = false
  @State private var selectedPage: Int = 0
  
  // User Settings
  @State private var textSize: CGFloat = 24
  
  private var welcomeText: String {
    let calendar = Calendar.current
    let hour = calendar.component(.hour, from: Date())
    switch hour {
    case 0..<12:
      return "Good Morning"
    case 12..<15:
      return "Good Afternoon"
    default:
      return "Good Evening"
    }
  }
  
  var body: some View {
    NavigationStack {
      VStack {
        TabView (selection: $selectedPage) {
          // Swipe right between each educational item
          ForEach (pageContent.items, id: \.self) { item in
            VStack (spacing: 20) {
              HStack {
                Capsule()
                  .fill(Color(red: 77/255, green: 146/255, blue: 161/255))
                  .frame(width: 180, height: 50)
                  .overlay(
                    Text (item.category.uppercased())
                      .foregroundStyle(.white)
                      .font(.title2)
                  )
                Spacer()
                Button (action: {
//                  withAnimation {
//                    if selectedPage < pageContent.items.count {
//                      selectedPage = selectedPage + 1
//                    }
//                  }
                }, label: {
                  Image(systemName: "arrow.right")
                    .font(.system(size: 40))
                    .foregroundColor(.primary)
                })
              }

              
              ScrollView (.vertical, showsIndicators: false) {
                ForEach (item.facts, id: \.self) { f in
                  Text (f)
                    .font(.system(size: textSize))
                    .padding(10)
                }
              }
            }
            .padding(20)
          }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .indexViewStyle(.page(backgroundDisplayMode: .never))
      }
      .navigationTitle(welcomeText)
      .toolbar {
        Button (action: {
          showSettings.toggle()
        }, label: {
          Image("paceIcon")
            .resizable()
            .frame(width: 40, height: 40)
            .clipShape(.rect(cornerRadius: 10))
            .shadow(radius: 10)
        })
//        Capsule()
//          .fill(.black)
//          .frame(width: 50, height: 50)
//          .overlay(
//            Button (action: {
//              showSettings.toggle()
//            }, label: {
//              Text("P")
//                .font(.custom("Rockwell", size: 40))
//                .foregroundStyle(.white)
//                .offset(y: 5)
//            })
//          )
          .offset(y: 14)
        Spacer()
          .sheet(isPresented: $showSettings, content: {
            SettingsView(textSize: $textSize)
          })
          .onAppear {
            pageContent.fetch()
          }
      }
    }
  }
}


struct SettingsView: View {
  
  // User settings
  @Binding var textSize: CGFloat
  @Environment(\.presentationMode) var presentationMode
  
  @AppStorage("active_icon") var activeAppIcon: String = "AppIcon 1"
  let customIcons: [String] = ["AppIcon 1", "AppIcon 2", "AppIcon 3"]
  
  var body: some View {
    NavigationStack {
      Form(content: {
        Section {
          Picker("Choose one of the following:", selection: $activeAppIcon) {
            ForEach (customIcons, id: \.self) {icon in
              Image(uiImage: UIImage(named: icon) ?? UIImage())
                .resizable()
                .frame(width: 50, height: 50)
//                .tag(icon)
//              Text(icon)
            }
          }
          .pickerStyle(.inline)
        }
      header: {
        Text("Change app icon")
      }
        Section {
          Text("Adjust the slider to your preferred text size.")
            .font(.system(size: textSize))
          Slider(value: $textSize, in: 18...32)
        } header: {
          Text("Change text size")
        }
        Section {
          Text("Designed by Carter Schafer & Coleen Connaughton")
            .font(.system(size: 18))
        }
        
      })
      
        .navigationTitle("Settings")
        .padding(20)
        .toolbar {
          Button(action: {
            presentationMode.wrappedValue.dismiss()
          }, label: {
            Image(systemName: "xmark")
              .foregroundColor(.primary)
//              .font(.largeTitle)
          })
          .offset(y: 10)
          .padding()
        }
    }
    
    .onChange(of: activeAppIcon) {
      UIApplication.shared.setAlternateIconName (activeAppIcon)
    }
  }
}


#Preview {
    ContentView()
//  SettingsView(textSize: .constant(24))
}
