//
//  SettingView.swift
//  PokeMaster
//
//  Created by sungrow on 2019/12/18.
//  Copyright © 2019 sungrow. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var store: Store
    var settingsBinding: Binding<AppState.Settings> {
        $store.appState.settings
    }
    var settings: AppState.Settings {
        store.appState.settings
    }

    var body: some View {
        Form {
            accountSection
            optionSection
            actionSection
        }
        .alert(item: settingsBinding.loginError) { (error) -> Alert in
            Alert(title: Text(error.localizedDescription))
        }
        .alert(isPresented: settingsBinding.clearCacheSuccess) { () -> Alert in
            Alert(title: Text("清空缓存成功!"))
        }
    }

    var accountSection: some View {
        Section(header: Text("账户")) {
            if settings.loginUser == nil {
                Picker(selection: settingsBinding.checker.accountBehavior, label: Text("")) {
                    ForEach(AppState.Settings.AccountBehavior.allCases, id: \.self) {
                        Text($0.text)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                TextField("电子邮箱", text: settingsBinding.checker.email)
                    .foregroundColor(settings.isEmailValid ? .green : .red)
                SecureField("密码", text: settingsBinding.checker.password)

                if settings.checker.accountBehavior == .register {
                    SecureField("确认密码", text: settingsBinding.checker.verifyPassword)
                }
                if settings.loginRequesting {
                    ActivityIndicatorView(style: .medium)
                } else {
                    Button(settings.checker.accountBehavior.text) {
                        switch self.settings.checker.accountBehavior {
                        case .login:
                            self.store.dispatch(
                                .login(
                                    email: self.settings.checker.email,
                                    password: self.settings.checker.password
                                )
                            )
                        case .register:
                            self.store.dispatch(
                                .register(
                                    email: self.settings.checker.email,
                                    password: self.settings.checker.password
                                )
                            )
                        }
                    }
                    .disabled(!settings.isEmailPasswordValid)
                }
            } else {
                Text(settings.loginUser!.email)
                Button("注销") {
                    self.store.dispatch(
                        .logout
                    )
                }
            }
        }
    }

    var optionSection: some View {
        Section(header: Text("选项")) {
            Toggle(isOn: settingsBinding.showEnglishName) {
                Text("显示英文名")
            }
            Picker(selection: settingsBinding.sorting, label: Text("排序方式")) {
                ForEach(AppState.Settings.Sorting.allCases, id: \.self) {
                    Text($0.text)
                }
            }
            Toggle(isOn: settingsBinding.showFavoriteOnly) {
                Text("只显示收藏")
            }
        }
    }

    var actionSection: some View {
        Section {
            Button("清空缓存") {
                self.store.dispatch(.clearCache)
            }
            .foregroundColor(.red)
        }
    }
}

