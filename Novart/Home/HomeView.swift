//
//  HomeView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/09.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    CatalogView()
                        .frame(width: geometry.size.width, height: 590)
                    
                    SectionHeaderView(title: "인기 예술품", isLogoEnabled: true)
                        .frame(height: 54)
                    
                    PopularProductView()
                        .padding(.bottom, 32)
                    SectionHeaderView(title: "최근 등록된 예술품", isLogoEnabled: false)
                        .frame(height: 54)
                    
                    RecentProductView()
                        .frame(height: geometry.size.width + 74)
                        .padding(.bottom, 32)
                    
                    SectionHeaderView(title: "작가 소개", isLogoEnabled: true)
                        .frame(height: 54)
                    
                    ArtistIntroView()
                        .frame(height: 645)
                }
                .navigationBarTitleDisplayMode(.inline)
            }

        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
