# CleanArchitecture-Example
> Tuist를 사용한 모듈식 설계와 클린 아키텍처를 준수한 iOS 샘플 애플리케이션입니다. 

<img src="/Images/image.png">

### 주요 기능
- Github 인증을 통한 로그인 기능
- Github 사용자 검색 및 상세 결과 표시
- 개인 정보 및 로그아웃 기능
   
### 개발 환경 
- Tuist 4.43.1 활용하여 모듈화 적용 
- Swift 5.x, iOS 16.0, XCode 14.0
--- 
## 모듈 구조 설명 
<img src="graph.png">

### 핵심 모듈 레이어
- **APP**
    - 다른 모든 모듈을 통합하고 앱 최초 진입점을 제공하는 핵심 모듈입니다. 
    - 의존성: Data, Presentation, Shared
    - 책임
        1. 애플리케이션 생명주기 관리 
        2. 초기 네비게이션 설정
        3. 초기 의존성 등록 
- **Shared**
    - 모든 모듈에서 공유되는 공통 유틸리티, 확장 및 헬퍼 모듈입니다.
    - 의존성: 없음.
    - 책임
        1. 확장 함수
        2. 유틸리티 클래스
- **DependencyInjection**
    - 애플리케이션 전반에 걸친 의존성 주입을 위한 인프라 제공 모듈입니다.
    - 의존성: 없음.
    - 책임: 
        1. 의존성 컨테이너 구현
        2. 서비스 등록
### 클린 아키텍처 레이어
- **Presentation**
    - 프레젠테이션 로직과 사용자 인터페이스 컴포넌트를 구현하는 UI 레이어입니다. 
    - 의존성: DependencyInjection, Domain, Shared
    - 책임
        1. ViewControllers
        2. ViewModels 
        3. UI 컴포넌트
- **Domain**
    - 유스케이스, 엔티티 및 저장소 인터페이스를 포함하는 비즈니스 로직 레이어입니다.
    - 의존성: DependencyInjection, Core, Shared 
    - 책임
        1. 비즈니스 엔티티
        2. 유스케이스
        3. 저장소 인터페이스
- **Data**
    - Domain 레이어에 정의된 저장소 인터페이스를 구현하는 레이어입니다. 
    - 의존성: DependencyInjection, Domain, Shared
    - 책임
        1. 네트워크 통신
        2. 로컬 스토리지 
        3. DTO 및 추상화 
- **Core**
    - 핵심 비즈니스 로직 및 인프라 모듈입니다.
    - 의존성: DependencyInjection, Shared
    - 책임
        1. 키체인 저장소 
        2. 핵심 비즈니스 
--- 
## 아키텍처 설명 
<img src="/Images/Group.png">

### 레이어 분리 및 의존성 규칙 
- 의존성이 안쪽으로만 향하는 클린 아키텍처 의존성 규칙을 따르고 있습니다.
1. **외부 레이어**
    - UI 및 Data (App, Presentation, Data)
    - 중간 레이어를 참조하지만 중간 레이어에서는 참조되지 않음
2. **중간 레이어**
    - 애플리케이션 비즈니스 규칙 (Domain)
    - 유스케이스 및 저장소 인터페이스 
3. **내부 레이어**
    - Keychain Storage, 핵심 공통 비즈니스로직 
    - 다른 레이어에 대한 의존성 없음
### 주요 이점 
- 테스트 용이성
    - 각 레이어를 독립적으로 테스트가 가능하도록 설계되어 있습니다. 
- 유지보수성
    - 한 레이어의 변경이 다른 레이어에 영향을 크게 미치지 않습니다.
- 유연성
    - 외부 레이어의 구현을 쉽게 교체가 가능합니다.
- 확장성
    - Protocol을 통한 통신으로 기존 코드를 수정하지 않고 새로운 기능을 추가할 수 있습니다.
- 관심사 분리 
    - 각 모듈은 자신만의 특정 책임을 갖고 있습니다. 

### 단점 
- 모듈 비대화
    - 서비스가 확장됨에 따라 각 레이어 모듈의 크기가 과도하게 커질 수 있어 코드 관리와 빌드 시간에 부정적 영향을 미칠 수 있습니다. 
- 테스트 세분화 제한
    - 기능이 확장될수록 특정 화면이나 기능 단위로 격리된 테스트를 수행하기 어려워집니다. 


#### 향후 개선 방향 
- TMA(The Modular Architecture) 도입
    - 현재의 레이어를 기반에서 기능 중심 모듈화(Micro Feature Architecture)로 전환하여 독립적인 기능 단위의 모듈을 구성할 계획입니다. 
- 수평적 모듈화 적용 
    - 클린 아키텍처의 수적적인 레이어를 유지하면서 기능별 수평 모듈화를 통해 독립적인 피처, 도메인 모듈을 구성함으로써 모듈 간 의존성을 명확히 하고 테스트 용이성을 향상 시킬 것입니다.
- 업그레이드 버전
    - 개선된 아키텍처 패턴은 아래의 링크에서 확인할 수 있습니다. (구현 x, 예정 사항)
    - https://github.com/Jeon0976/TheModularArchitecture-Example
--- 
## 주요 기능 설명 

### Github 인증 및 토큰 관리 
- Github OAuth 기반 인증 시스템이 레이어별로 구현되어 있습니다.
- Core 레이어에서 TokenStroage 프로토콜을 통해 토큰의 저장/조회/삭제 기능을 제공합니다. 
- Domain 레이어의 GithubTokenUseCase는 이 TokenStorage를 활용해 토큰을 관리하고  리포지토리 인터페이스를 통해 API 통신을 요청합니다.
- Presentation 레이어에서 ViewModel이 사용자 이벤트를 Combine으로 처리하여 UseCase를 호출하고 Coordinator가 인증 완료 후 화면 전환을 담당합니다. 
 
### 사용자 검색 기능 
- Domain 레이어는 사용자 검색에 대한 페이지 기능을 담당하고 있습니다. 
- Data 레이어의 SearchUserRepository는 Github API와 통신하여 검색 결과를 가져오고 PosterImageRepository는 사용자 아바타 이미지를 처리하고 있습니다. 
- 이미지는 PosterLRUCacheStorage를 통해 캐시되고 있습니다. 
- Presentation 레이어에서는 SearchUserViewModel이 SearchUserUseCase의 페이징된 Entity를 불러와 해당 결과를 Combine을 활용해 표시하고 있습니다. 

### 프로필 관리 
- 주요 핵심 기능은 사용자 검색 기능과 동일하게 수행되고 있습니다. 

### DI Container
- DI Container는 인터페이스 이름을 키로 사용하여 의존성을 등록하고 해결하는 방식으로 설계되었습니다.
- 호출하는 쪽에서 구체적인 구현체가 아닌 인터페이스에 의존하기 때문에 모든 컴포넌트는 의존성을 등록할 때 인터페이스 타입으로 컨테이너에 저장해야 합니다. 
- Repository는 싱글톤 패턴처럼 한 번 생성된 인스턴스를 공유하도록 instance로 등록합니다.
- UseCase는 클로저 기반 팩토리 메서드로 등록하여 호출할 때마다 새로운 인스턴스를 생성합니다.
- 이러한 방식은 타입 안전성이 좋지 않아서 런타임 오류 가능성이 있습니다. 실제 프로젝트 환경에서는 SwinJect를 사용하거나 위와 같은 문제를 해결해서 사용해야 더 안전할 수 있습니다. 

### Coordinator
- **AppCoordinator - 구현체**
    - 앱의 진입점에서 최상위 네비게이션 흐름을 관리하는 Coordinator입니다.
    - RootCoordinator 인스턴스들의 생명주기를 관리합니다.
    - 로그인, 로그아웃시 화면 전환을 관리합니다.
- **RootCoordinator - 인터페이스**
    - BaseCoordinator를 확장하여 앱 수준의 화면 흐름을 시작할 수 있는 최상위 Coordinator 프로토콜입니다.
    - 전체 앱 윈도우를 초기화하고 루트 화면을 설정할 수 있는 권한이 있습니다.
    - RootFinishDelegate를 통해 AppCoordinator로 종료를 알려줍니다.
- **BaseCoordinator - 인터페이스**
    - 각 코디네이터는 자신의 내비게이션 스택을 가지며 관리합니다
    - childCoordinators 배열을 통해 하위 코디네이터들을 관리하는 구조
    - viewControllerFactory를 통해 뷰 컨트롤러 생성 및 의존성 주입
    - finishDelegate를 통해 코디네이터 완료 시 부모에게 알림
    - attachChild와 detachChild 메서드로 하위 코디네이터 등록 및 해제 간소화

### Network 
- 외부 라이브러리 의존성 없이 자체 구현한 네트워크 계층을 사용합니다. 
- 프로토콜 지향 설계로 유연성을 높였습니다. 
- Stub 모드를 지원하며 네트워크 없이 테스트가 가능합니다. 
- 콜백 기반 방식 대신 Swift Concurrency를 활용한 비동기 네트워킹을 구현했습니다. 
- 주요 컴포넌트
    - Network Endpoint 
        - 네트워크 요청의 기본 정보를 캡슐화하는 프로토콜
    - Network Task
        - 네트워크 요청 데이터 형식을 정의 (Plain, Json, Parameter 등)
    - Parameter Encoding
        - URL 또는 JSON 형식으로 매개변수 인코딩 처리
    - NetworkSession
        - 실제 네트워크 요청 수행 및 응답 처리 
    - NetworkLogger
        - 디버깅을 위한 네트워크 요청/응답 정보 로깅
    - NetworkError
        - 발생 가능한 네트워크 관련 오류 열거형으로 정의 

### Storage
- 추상화된 스토리지 인터페이스
    - 각 스토리지 계층은 인터페이스로 추상화되어 구현체 교체가 용이합니다.
    - 의존성 주입을 통해 테스트 시 Mock 구현체 활용이 가능합니다. 
- 토큰 스토리지
    - 토큰 관리를 위한 핵심 프로토콜이며, 해당 스토리지는 Core 계층에 있습니다.
- 이미지 캐싱 스토리지
    - LRU(Least Recently Used)알고리즘 기반으로 구현했으며, Actor 활용으로 동시성 문제를 해결했습니다.
    - 더블 링크드 리스트와 딕셔너리 조합으로 O(1) 접근 시간을 보장하고 있습니다. 
- 사용자 데이터 스토리지 
    - 앱이 실행 중일 때만 유지되는 휘발성 스토리지 입니다. 
    
### Data / Domain 
- 프로토콜 기반 통신
    - 인터페이스 정의 및 구현체 제공 
- Swift Concurrency 활용 
- 의존성 주입 

### Presentation
- Combine을 활용한 MVVM 패턴 
- MainActor 활용으로 UI 업데이트 관련 메인 스레드 안정성 보장 
- Coordinator 패턴 활용

## 기술 스택 및 라이브러리 
- 비동기 처리: SwiftConcurrency (Data & Domain)
- 데이터 흐름 관리: Combine (Presentation)
- 사용 패턴: MVVM, Coordinator, DIContainer 
- 네트워크: URLSession
- 이미지 캐싱: LRU Cache 구현 
- 모듈 관리: Tuist
