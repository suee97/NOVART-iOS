//
//  SearchView.swift
//  Novart
//
//  Created by Jinwook Huh on 2023/06/11.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel = SearchViewModel()
    @Binding var isShowing: Bool
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    let history: [String] = ["트렌디한", "트렌디한", "힙한 가구", "힙한 가구", "힙한 가구", "힙한 가구", "힙한 가구", "힙한 가구", "힙한 가구", "힙한 가구", ]
    let artists: [Int] = [1, 2, 3, 4]
    
    init(isShowing: Binding<Bool>) {
        self._isShowing = isShowing
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Spacer()
                    .frame(height: 63)
                mainView
                    .padding([.leading, .trailing], 24)
            }
            
            VStack {
                searchNavigationBar
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

extension SearchView {
    
    var mainView: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 16)
                
                // 최근 검색
                Group {
                    HStack {
                        Text("최근 검색")
                            .foregroundColor(Color.Common.primaryDarkTextColor)
                            .font(.system(size: 16, weight: .bold))
                        Spacer()
                            
                        Button {
                            print("delete")
                        } label: {
                            Text("모두 삭제")
                                .foregroundColor(Color.Common.gray02)
                                .font(.system(size: 12, weight: .regular))
                        }
                    }
                    
                    Spacer()
                        .frame(height: 16)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(["힙한 가구", "트렌디한 가구", "세련된", "힙한 공예품"], id: \.self) { data in
                                
                                HStack(spacing: 8) {
                                    Button {
                                        print("search")
                                    } label: {
                                        Text(data)
                                            .foregroundColor(Color.Common.subtextDarkColor)
                                            .font(.system(size: 14, weight: .regular))
                                    }
                                    .buttonStyle(NoHighlightButtonStyle())
                                    
                                    Button {
                                        print("delete")
                                    } label: {
                                        Image("small_close")
                                    }
                                }
                                .padding(.leading, 8)
                                .padding(.trailing, 4)
                                .padding([.top, .bottom], 4)
                                .background(Color.Common.primaryTextColor)
                                .cornerRadius(4)
                            }
                        }
                    }
                    
                    Spacer()
                        .frame(height: 24)
                    
                    Rectangle()
                        .foregroundColor(Color.Common.gray01)
                        .frame(height: 1)
                }
                
                Spacer()
                    .frame(height: 24)
                
                // 인기 검색
                Group {
                    HStack {
                        Text("인기 검색")
                            .foregroundColor(Color.Common.primaryDarkTextColor)
                            .font(.system(size: 16, weight: .bold))
                        Spacer()
                            
                        Text("2023.07.20 기준")
                            .foregroundColor(Color.Common.gray02)
                            .font(.system(size: 12, weight: .regular))
                    }
                    
                    Spacer()
                        .frame(height: 16)
                    
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 14) {
                        ForEach(history.indices, id: \.self) { index in
                            let item = history[index]
                            HStack(spacing: 11) {
                                
                                if index < 2 {
                                    Text("\(index + 1)")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(Color.Common.sub)
                                } else {
                                    Text("\(index + 1)")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(Color.Common.primaryDarkTextColor)
                                }
                                Text(item)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(Color.Common.primaryDarkTextColor)
                            }
                        }
                    }
                    
                    Spacer()
                        .frame(height: 24)
                    
                    Rectangle()
                        .foregroundColor(Color.Common.gray01)
                        .frame(height: 1)
                }
                
                Spacer()
                    .frame(height: 24)
                
                // 관심 작가
                
                Group {
                    
                    HStack {
                        Text("가장 관심 받는 작가")
                            .foregroundColor(Color.Common.primaryDarkTextColor)
                            .font(.system(size: 16, weight: .bold))
                        Spacer()
                            
                        Text("2023.07.20 기준")
                            .foregroundColor(Color.Common.gray02)
                            .font(.system(size: 12, weight: .regular))
                    }
                    
                    Spacer()
                        .frame(height: 16)
                    
                    GeometryReader { geometry in
                        HStack(spacing: 18) {
                            ForEach(artists, id: \.self) { item in
                                VStack(alignment: .center, spacing: 10) {
                                    Image("mock_artist_square")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: (geometry.size.width - 54) / 4, height: (geometry.size.width - 54) / 4)
                                        .cornerRadius((geometry.size.width - 54) / 8)
                                    Text("작가이름")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(Color.Common.primaryDarkTextColor)
                                }
                                .frame(maxWidth: (geometry.size.width - 54) / 4)
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    var searchNavigationBar: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack(alignment: .center, spacing: 16) {
                Button {
                    isShowing = false
                } label: {
                    Image("icon_back")
                }
                
                TextField("", text: $viewModel.searchText)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color.Common.primaryDarkTextColor)
                    .cornerRadius(4)
                    .padding([.top, .bottom], 10)
                    .padding([.leading, .trailing], 12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.Common.gray02, lineWidth: 1)
                    )
                    .background(Color.Common.white)

                    .onChange(of: viewModel.searchText) { newValue in
                        print(newValue)
                    }
                
                
            }
            .padding([.leading, .trailing], 24)
            Spacer()
                .frame(height: 10)
        }
        .frame(height: 63)
        
    }
}

//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView(isShowing: t)
//    }
//}
