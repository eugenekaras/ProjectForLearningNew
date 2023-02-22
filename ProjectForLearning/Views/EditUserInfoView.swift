//
//  EditUserInfoView.swift
//  ProjectForLearning
//
//  Created by Евгений Карась on 17.02.23.
//

import SwiftUI
import PhotosUI

enum EditUserInfoError: LocalizedError {
    case unknownError(error: Error)
    
    var errorDescription: String? {
        switch self {
        case .unknownError(let error):
            return error.localizedDescription
        }
    }
}

struct EditUserInfoView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var showError = false
    @State private var error: EditUserInfoError?
    @State private var image: UIImage?
    @State private var showChangePhotoConfirmationDialog = false
    @State private var showPhotosPicker = false
    @State private var showCameraPicker = false
    @State private var selectPhotosPickerItem: PhotosPickerItem?
    @State private var showDialogForSaveUserInfoData = false
    
    @Binding private var user: User
    @State private var tmpUser: User

    init(user: Binding<User>) {
        self._user = user
        self._tmpUser = State(wrappedValue: user.wrappedValue)
    }
        
    var body: some View {
        VStack{
            buttonView
            Form {
                editUserInfoImageView
                
                editUserInfoView
            }
        }
        .alert(isPresented: $showError, error: error, actions: {})
        .onAppear() {
            tmpUser = user
        }
    }
    
    private var buttonView: some View {
        HStack(){
            Button("back") {
                dismiss()
            }
            Spacer()
            
            Button("done") {
                showDialogForSaveUserInfoData.toggle()
            }
            .confirmationDialog("question_user_info_save_data", isPresented: $showDialogForSaveUserInfoData, actions: {
                Button("save", role: .destructive) {
                    saveChangeData()
                    dismiss()
                }
                Button("cancel", role: .cancel) {
                    dismiss()
                }
            })
        }.padding()
    }
    
    private var editUserInfoImageView: some View {
        Section(header: Text("edit_foto")) {
            ZStack(alignment: .topTrailing){
                HStack{
                    UserInfoImageView(user: tmpUser)
                }
                buttonChangePhotoView
            }
            .confirmationDialog(Text(""), isPresented: $showChangePhotoConfirmationDialog, titleVisibility: .hidden) {
                Button("camera") {
                    showCameraPicker = true
                }
                Button("photo_library") {
                    showPhotosPicker = true
                }
                Button("cancel", role: .cancel) {
                    showChangePhotoConfirmationDialog.toggle()
                }
            }
            .sheet(isPresented: $showCameraPicker) {
                ImagePicker(sourceType: .camera, image: $image, isPresented: $showCameraPicker)
            }
            .onChange(of: image) { newValue in
                if let image = newValue {
                    tmpUser.image = image
                }
            }
            .photosPicker(isPresented: $showPhotosPicker, selection: $selectPhotosPickerItem, matching: .any(of: [.images, .screenshots]))
            .onChange(of: selectPhotosPickerItem) { newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            tmpUser.image = image
                        }
                    }
                }
            }
        }
    }
    
    private var buttonChangePhotoView: some View {
        return Image(systemName: "camera.circle.fill")
            .resizable()
            .frame(width: 60, height: 60)
            .background(Color(.white))
            .foregroundColor(Color(.systemIndigo))
            .clipShape(Capsule())
            .padding()
            .onTapGesture {
                showChangePhotoConfirmationDialog.toggle()
            }
    }
    
    private var editUserInfoView: some View {
        Group{
            Section(header: Text("first_name")) {
                TextField("first_name",text: $tmpUser.firstName)
            }
            Section(header: Text("last_name")) {
                TextField("last_name",text: $tmpUser.lastName)
            }
            Section(header: Text("email")) {
                TextField("email",text: $tmpUser.email)
                    .keyboardType(.emailAddress)
            }
            Section(header: Text("phone")) {
                TextField("phone",text: $tmpUser.phoneNumber)
                    .keyboardType(.phonePad)
            }
            Section(header: Text("bio")) {
                TextEditor(text: $tmpUser.bio)
                    .multilineTextAlignment(.leading)
                    .disableAutocorrection(true)
                    .frame(height: 200)
            }
        }
    }
    
    func saveChangeData() {
        user = tmpUser
        
        Task {
            do {
                try await user.saveUserData()
            } catch {
                await showError(error: error)
            }
        }
    }
    
    @MainActor
    func showError(error: Error) {
        guard let error = error as NSError? else {
            fatalError("unknown_error")
        }
        self.error = EditUserInfoError.unknownError(error: error)
        self.showError.toggle()
    }
}

struct EditUserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        EditUserInfoView(user: .constant(.emptyUser))
    }
}
