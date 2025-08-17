//
//  MockInterviewPrepareView.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/18.
//

import SwiftUI

struct MockInterviewPrepareView: View {
    // MARK: - Variables
    @ObservedObject var interviewVM: InterviewViewModel
    @EnvironmentObject private var nc: NavigationController
    
    // MARK: - UI
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            Text("MockInterviewPrepareView")
        }
        .navigationBarBackButtonHidden(true) // FIXME: - 스와이프로 디스미스가 안됌
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(
                    action: {
                        nc.pagePath.removeAll()
                    },
                    label: {
                        Image(systemName: AppConstants.chevronLeft)
                            .font(.custom(Font.appSemiBold, size: 16, relativeTo: .subheadline))
                            .foregroundStyle(.black)
                    }
                )
            }
        }
        .onDisappear {
            nc.pagePath.removeAll()
        }
    }
}

#Preview {
    MockInterviewPrepareView(interviewVM: InterviewViewModel())
}
