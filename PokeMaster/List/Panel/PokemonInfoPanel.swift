//
//  PokemonInfoPanel.swift
//  PokeMaster
//
//  Created by sungrow on 2019/12/17.
//  Copyright © 2019 sungrow. All rights reserved.
//

import SwiftUI

struct PokemonInfoPanel: View {
    let model: PokemonViewModel
    var abilities: [AbilityViewModel] {
        AbilityViewModel.sample(pokemonID: model.id)
    }

    @State var darkBlur = false

    var topIndicator: some View {
        RoundedRectangle(cornerRadius: 3)
            .frame(width: 40, height: 6)
            .opacity(0.2)
    }

    var pokemonDescription: some View {
        Text(model.descriptionText)
            .font(.callout)
            .foregroundColor(Color(hex: 0x666666))
            .fixedSize(horizontal: false, vertical: true)
    }

    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                self.darkBlur.toggle()
            }) {
                Text("切换模糊效果")
            }
            topIndicator
            HeaderView(model: model)
            pokemonDescription
            Line(direction: .horizont)
            AbilityList(
                model: model,
                abilityModels: abilities
            )
        }
        .padding(
            EdgeInsets(
                top: 12,
                leading: 30,
                bottom: 30,
                trailing: 30
            )
        )
        .blurBackground(style: self.darkBlur ? .systemMaterialDark : .systemMaterial)
        .cornerRadius(20)
        .fixedSize(horizontal: false, vertical: true)
    }
}

extension PokemonInfoPanel {
    struct HeaderView: View {
        let model: PokemonViewModel

        var body: some View {
            HStack(spacing: 18) {
                pokemonIcon
                nameSpecies
                verticalDivider
                VStack {
                    bodyStatus
                    typeInfo
                        .padding(.top, 12)
                }
            }
        }

        var pokemonIcon: some View {
            Image("Pokemon-\(model.id)")
                .resizable()
                .frame(width: 68, height: 68)
        }

        var nameSpecies: some View {
            VStack {
                Text(model.name)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(model.color)
                Text(model.nameEN)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(model.color)
                Text(model.genus)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.gray)
                    .padding(.top, 10)
            }
        }

        var verticalDivider: some View {
            Line(direction: .vertical)
            .frame(height: 44)
        }

        var bodyStatus: some View {
            VStack {
                BodyInfoRow(title: "身高", data: model.height, dataColor: model.color)
                BodyInfoRow(title: "体重", data: model.weight, dataColor: model.color)
            }
        }

        var typeInfo: some View {
            HStack {
                ForEach(model.types) { (info) in
                    ZStack {
                        RoundedRectangle(cornerRadius: 7)
                            .fill(info.color)
                            .frame(width: 36, height: 14)
                        Text(info.name)
                            .foregroundColor(.white)
                            .font(.system(size: 10))
                    }
                }
            }
        }
    }
}

struct Line: View {
    enum Direction {
        case horizont, vertical
    }

    let direction: Direction

    var isH: Bool {
        return direction == .horizont
    }

    var isV: Bool {
        return !isH
    }

    var body: some View {
        Rectangle()
        .fill(
            Color(hex: 0x000000, alpha: 0.1)
        )
        .frame(
            minWidth: isV ? 1.0 : 0,
            maxWidth: isV ? 1.0 : .infinity,
            minHeight: isV ? 0 : 1.0,
            maxHeight: isV ? .infinity : 1.0)
    }
}

struct BodyInfoRow: View {
    let title: String
    let titleColor: Color = .gray
    let data: String
    let dataColor: Color

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 11))
                .foregroundColor(titleColor)
            Text(data)
                .font(.system(size: 11))
                .foregroundColor(dataColor)
        }
    }
}

struct PokemonInfoPanel_Previews: PreviewProvider {
    static var previews: some View {
        PokemonInfoPanel(model: .sample(id: 1))
    }
}
