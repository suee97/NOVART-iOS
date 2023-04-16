//
//  MainTabView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/04/09.
//

import SwiftUI

struct MainTabView: View {
    @State private var selection = 0
    @State private var hasNewNotification = true
    
    var body: some View {
        TabView(selection: $selection) {

            
            
            
            NavigationView {
                
                ZStack(alignment: .top) {
                    VStack {
                        Spacer()
                            .frame(height: 63)
                        HomeView()
                    }
                    
                    VStack {
                        customNavigationBar
                        Spacer()
                    }
                }
                .navigationBarHidden(true)
                
        
//                    .toolbar {
//                        ToolbarItemGroup(placement: .navigationBarTrailing) {
//                            notiItem
//                            searchItem
//
//                        }
//                        ToolbarItem(placement: .navigationBarLeading) {
//                            titleImage
//                        }
//                    }
            }
            .tabItem {
                Image(selection == 0 ? "home_icon_selected" : "home_icon_deselected")
            }
            .tag(0)
            
            DiscoverView()
                .tabItem {
                    Image(selection == 1 ? "discover_icon_selected" : "discover_icon_deselected")
                }
                .tag(1)
            
            MyPageView()
                .tabItem {
                    Image(selection == 2 ? "mypage_icon_selected" : "mypage_icon_deselected")
                }
                .tag(2)
        }
    }
    
    var customNavigationBar: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack(spacing: 0) {
                Spacer()
                    .frame(width: 24)
                titleImage
                Spacer()
                notiItem
                searchItem
                
                Spacer()
                    .frame(width: 24)
            }
            .background(Color.white)
            Spacer()
                .frame(height: 20)
        }
        .frame(height: 63) // Adjust the height of the custom navigation bar
        
    }
    
    var titleImage: some View {
        Image("novart_title_logo")
    }
    
    
    var searchItem: some View {
        Button {
            print("search")
        } label: {
            Image("icon_search")
        }
            .buttonStyle(NoHighlightButtonStyle())
            .padding(.top, 2)
    }
    
    var notiItem: some View {
        Button(action: {
            print("noti")
        }) {
            ZStack {
                Image("icon_noti")
                
                if hasNewNotification {
                    Circle()
                        .frame(width: 6, height: 6)
                        .foregroundColor(Color.Common.primaryTintColor)
                        .offset(x: 13, y: -10)
                }
            }
        }
            .buttonStyle(NoHighlightButtonStyle())
            .padding(.trailing, 20)
    }
}
