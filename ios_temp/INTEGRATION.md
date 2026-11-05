# Xcode 프로젝트로 소스 옮기기

`ios_temp/`는 사용자가 Xcode 프로젝트를 만들기 전 소스와 시험을 보관하는 임시 폴더다. Xcode 프로젝트·앱 시작점(`@main`)·화면은 포함하지 않는다.

## 폴더 구성

- `Sources/Core/`: 앱에 넣을 Swift 소스. 외부 라이브러리나 별도 패키지에 의존하지 않는다.
- `Tests/Core/`: Swift Testing 단위·연결 시험. 앱 소스와 다른 시험 대상에 넣는다.
- `Scripts/verify.sh`: Xcode 프로젝트 생성 전 Mac에서 같은 소스를 시험하는 개발용 도구.

## 옮기는 순서

1. 사용자가 저장소 루트의 `FirstStepToCareer/`에 Swift·SwiftUI iOS 프로젝트를 만든다. 최소 iOS 버전은 승인된 26.0으로 설정하고 단위 시험 대상을 포함한다. 앱 식별자·서명 등은 사용자 설정을 따른다.
2. 계획한 대로 바깥쪽 `FirstStepToCareer/` 폴더 이름을 `ios/`로 바꾼다. 안의 앱 소스 폴더와 앱 대상 이름은 Xcode에서 생성한 것을 사용한다. 이름 변경 후 `.xcodeproj`를 다시 열어 경로를 확인한다.
3. `Sources/Core/`를 `ios/` 안의 **앱 소스 폴더**로 복사하고, 그 Swift 파일들이 앱 대상에 포함됐는지 Xcode에서 확인한다. `Core/` 안에 시작점은 없으므로 Xcode가 만든 앱 시작 파일을 그대로 사용한다.
4. `Tests/Core/`의 Swift 파일들을 **단위 시험 폴더**로 복사한다. 앱 대상에는 넣지 않는다. 시험 파일의 `@testable import FirstStepToCareer`는 앱의 모듈 이름을 뜻한다. 이름이 다르면 이 부분만 실제 이름으로 바꾼다.
5. 앱 대상과 시험 대상에 사용한 Swift 소스는 Swift 6 언어 모드로 검증했다. Xcode 설정의 언어 모드를 확인하고 단위 시험을 실행한다. 이 시험에는 마이크·카메라·AI 모델 설치가 필요하지 않다.
6. Xcode에서의 빌드·시험 확인 후 임시 폴더 정리는 별도로 진행한다. 현재 작업에서는 사용자 프로젝트 생성·이름 변경·기존 파일 삭제를 수행하지 않는다.

앱 소스 폴더에 임시 폴더 전체를 넣으면 시험·스크립트·안내 문서까지 앱 대상으로 들어갈 수 있다. `Sources/Core/`와 `Tests/Core/`를 각 대상에 나누어 넣는다. 대상은 Xcode가 함께 빌드할 파일을 묶는 단위다.

## 프로젝트 생성 전 검증

저장소 루트에서 다음 명령을 실행한다.

```bash
bash ios_temp/Scripts/verify.sh
```

스크립트는 임시 디렉터리에 소스·시험을 복사하고, 그곳에서만 검증용 Swift 패키지를 만들어 시험한다. 저장소에는 `Package.swift`나 빌드 결과를 만들지 않고 외부 패키지도 받지 않는다. 임시 경로는 실행할 때 출력하며 자동 삭제하지 않는다. `--disable-sandbox`는 Swift 패키지 빌드 도구의 중첩 격리를 끄는 옵션이며 앱의 보안 설정을 바꾸지 않는다.

Mac에서의 핵심 규칙 검증은 실제 iOS 앱·기기 검증과 구분한다. 화면, SwiftData 저장, LLM·음성·ARKit 연결과 미정인 정책은 포함하지 않는다.

참고: [Xcode의 파일·폴더 관리](https://developer.apple.com/documentation/xcode/managing-files-and-folders-in-your-xcode-project), [시험 추가](https://developer.apple.com/documentation/xcode/adding-tests-to-your-xcode-project), [Swift Testing](https://developer.apple.com/documentation/testing).
