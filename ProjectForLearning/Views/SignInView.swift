//
//  SignInWithGoogle.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 20.01.23.
//

import SwiftUI
import GoogleSignInSwift


struct SignInView: View {
    
    @EnvironmentObject var userAuth: UserAuth
    @EnvironmentObject var viewState: ViewState
    
    @State var message = ""
    @State var alert = false
 
  
    
    var body: some View {
        NavigationView{
            VStack(alignment: .center, spacing: 0) {
                
                LoginHeader()
                    .padding(100)
                Spacer()
                
                GoogleSignInButton{
  
                    Task {
                        do{
                            try await userAuth.signIn(handler: { verified, status in
                                if !verified {
                                    self.message = status
                                    self.alert.toggle()
                                } 

                            })
 
                        } catch{

                        }
                    }
                }
                .padding(20)
                .alert(isPresented: $alert) {
                    Alert(title: Text("Error"), message: Text(self.message), dismissButton: .default(Text("Ok")))
                }
                
 
                Button(action: {
                    Task {
                        
                        do{
                            try await userAuth.signInAnonymously(handler: { verified, status in
                                if !verified {
                                    self.message = status
                                    self.alert.toggle()
                                }
                            })
                        } catch{
                            
                        }
                    }
                }) {
                    HStack {
                        Spacer()
                        Text("Use anonymous account")
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
                .padding()
                .background(.black)
                .padding()
                .alert(isPresented: $alert) {
                    Alert(title: Text("Error"), message: Text(self.message), dismissButton: .default(Text("Ok")))
                    
                }
            }
        }
    }
}

struct LoginHeader: View {
    var body: some View {
        VStack {
            Image(systemName: "bonjour")
                .font(.system(size: 120))
                .foregroundColor(.purple)
            Text("Study App")
                .font(.system(size: 36))
                .foregroundColor(.black.opacity(0.80))
        }
    }
}


struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

