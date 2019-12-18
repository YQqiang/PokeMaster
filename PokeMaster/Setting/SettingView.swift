//
//  SettingView.swift
//  PokeMaster
//
//  Created by sungrow on 2019/12/18.
//  Copyright © 2019 sungrow. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject var settings: Settings = Settings()

    var body: some View {
        Form {
            accountSection
            optionSection
            actionSection
        }
    }

    var accountSection: some View {
        Section(header: Text("账户")) {
            Picker(selection: $settings.accountBehavior, label: Text("")) {
                ForEach(Settings.AccountBehavior.allCases, id: \.self) {
                    Text($0.text)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            TextField("电子邮箱", text: $settings.email)
            SecureField("密码", text: $settings.password)

            if settings.accountBehavior == .register {
                SecureField("确认密码", text: $settings.verifyPassword)
            }

            Button(settings.accountBehavior.text) {
                print(self.settings.accountBehavior.text)
            }
        }
    }

    var optionSection: some View {
        Section(header: Text("选项")) {
            Toggle(isOn: $settings.showEnglishName) {
                Text("显示英文名")
            }
            Picker(selection: $settings.sorting, label: Text("排序方式")) {
                ForEach(Settings.Sorting.allCases, id: \.self) {
                    Text($0.text)
                }
            }
            Toggle(isOn: $settings.showFavoriteOnly) {
                Text("只显示收藏")
            }
        }
    }

    var actionSection: some View {
        Section {
            Button("清空缓存") {
                print("")
            }
            .foregroundColor(.red)
        }
    }
}

