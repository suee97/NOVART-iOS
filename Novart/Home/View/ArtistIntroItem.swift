//
//  ArtistIntroItem.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/16.
//

import SwiftUI

struct ArtistIntroItem: View {
    var body: some View {
        HStack(alignment: .center, spacing: 40) {
            Image("mock_artist")
                .resizable()
                .frame(width: 80, height: 80)
                .aspectRatio(contentMode: .fill)
                .cornerRadius(40)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("김민지")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color.Common.primaryDarkTextColor)
                
                Text("안녕하세요 가치있는 가구를 만들기\n위해 노력하는 디자이너입니다.")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color.Common.subtextDarkColor)

            }
            Spacer()
        }
    }
}

struct ArtistIntroItem_Previews: PreviewProvider {
    static var previews: some View {
        ArtistIntroItem()
    }
}
