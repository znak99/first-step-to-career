//
//  InterviewState.swift
//  FirstStepToCareer
//
//  Created by seungwoo on 2025/08/30.
//

// Path: Domain/ValueObjects/InterviewState.swift
/// 인터뷰 전체 생명주기(프리체크 반영)
enum InterviewState: Sendable {
    case idle
    case preparing                // 리소스 준비/권한 프리플라이트
    case precheck                 // 카메라 미리보기/시선/표정/마이크 테스트 가능
    case running(Phase)           // 본 인터뷰 진행
    case paused
    case finishing
    case evaluating               // 점수 계산
    case finished
    case failed(String)

    enum Phase: Sendable { case asking, listening, speaking }
}
