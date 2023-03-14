# 💸　README
## iOS 은행 매니저 프로젝트
Miro & Jenna ― `2023.02.20 ~ 2023.03.10`

　
### `STEP_01`　큐 타입 구현
> 🌱　**은행에 도착한 고객이 임시로 대기할 대기열(큐, Queue) 타입을 구현**
> - [x] Linked-list 자료구조의 이해 및 구현
> - [x] Queue 자료구조의 이해 및 구현
> - [x] Generics 개념이해 및 적용

　
### `STEP_02`　타입 구현 및 콘솔앱 구현
> 🌱　**은행원이 하나인 은행을 관리하기 위한 타입 구현 & 콘솔앱 구현**
> - [x] Queue의 활용
> - [x] 타입 추상화 및 일반화

　
### `STEP_03`　다중 처리
> 🌱　**은행원과 은행업무가 여럿인 은행을 관리하기 위한 타입 구현 & 콘솔앱 구현**
> - [x] 동기 비동기의 활용
> - [x] 동시성 프로그래밍을 위한 기반기술(GCD, Operation) 및 스레드(Thread) 개념에 대한 이해

　
### `STEP_04`　UI 구현하기
> 🌱　**Step 3의 은행을 UI 앱으로 전환**
> - [x] UI구성을 '코드'만 사용하여 구현
> - [x] 화면 구성: 업무중인 고객 리스트, 대기중인 고객 리스트, 업무시간 타이머, 고객 10명 추가 버튼, 초기화 버튼

　

　
***
# 🚀 트러블 슈팅 기록
## `STEP_02` 트러블 슈팅
### 1. 매개변수 개선
함수 명을 읽었을 때 영어 문장을 읽듯이 읽히게 작성하기!
- 이전: `closingMessage(totalNumberOfCustomers: Int, totalTime: Double)`
- 수정: `printClosingMessage(about totalNumberOfCustomers: Int, with totalConsumedTime: Double)`

### 2. 파일 그룹핑
프로젝트 속 모델에 사용되는 기본 데이터 구조인 `Node`, `SinglyLinkedList`, `Queue`
를 `Data Structure` 폴더로 묶어습니다. `Bank`와 관련된 `BankClerk`과 `Bank`파일은 `Bank` 폴더로 묶어주고, 나머지 console창에서 사용되는 파일인 `ConsoleManager`는 `Console` 파일로 묶어주었습니다. 프로젝트의 실행부인 main파일은 어느 폴더에도 속하지 않는다고 판단이 들어 따로 그룹핑을 해주지 않았습니다.

## `STEP_03` 트러블 슈팅
### 1. Bank의 이니셜라이저 매개변수 타입 수정
- **[기존]** Bank생성자가 직접 은행원들(인스턴스 배열)을 받음
    
    ```
    var bank = Bank(clerksForDeposit: [BankClerkForDeposit(), BankClerkForDeposit()], clerksForLoan: [BankClerkForLoan()])
    
    ```
    
- **[수정 A]** 은행원의 인원 수(`Int`)만 받음
    - 요구사항에는 종류별 은행원의 인원 수가 정해져 있지만, 앞으로의 확장성을 고려하여 은행원의 수가 유동적이도록 만듦
    - 인원 수만 입력해 주면 알아서 종류별 은행원 배열에 일정 수의 객체를 생성해 넣어주도록 구현
    
    ```
    var bank = Bank(numberOfClerksForDeposit: 2, numberOfClerksForLoan: 1)
    
    ```
    
- **[수정 B]** BankingService의 case로, 종류별 인원 수를 한번에 받음
    - 은행원의 '인원 수' 확장 가능 ⇒ '종류 및 종류별 인원 수' 확장 가능
    - BankingService의 케이스별 연관값을 이용
        
        
        | (참고) | BankingService 열거형 구현 과정 |
        | --- | --- |
        | 초기구현 | String원시값("예금", "대출")과 Double계산속성(0.7초, 1.1초)을 갖는 열거형 |
        | 변경 후 | Int연관값 하나씩(인원 수)과 String계산속성(업무 명) & Double계산속성(소요시간)을 갖는 열거형 |
    
    ```
    var bank = Bank(clerks: .deposit(2), .loan(1))
    
    ```
    
    ### ✔　DispatchGroup(), DispatchWorkItem, DispatchSemaphore()
    
    - 대출 업무를 담당하는 은행원 1명, 예금 업무를 담당하는 은행원 2명이 비동기적으로 하나의 큐에서 손님을 추출하여 serve()메소드를 호출할 수 있도록 했습니다.
    
    > 사용한 비동기 메소드, 객체들 👇
    -  DispatchGroup()
    -  DispatchSemaphore()
    - DispatchQueue.global().async(group:execute:)
    > 
    
    ### DispatchGroup(),DispatchQueue.global().async()
    
    - 저희는 모든 비동기 작업들이 완료가 되어야지 클로징 메세지를 출력하고, 메뉴 선택 메세지를 출력하고 싶었습니다.
    - 따라서 각각의 task를 하나의 그룹으로 묶어주었고, `wait()`메소드를 통하여 비동기 작업들이 다 끝나기 전까지 기다리도록 해주었습니다.
    
    ### DispatchSemaphore()
    
    - 저희는 아래와 같이 `semaphore`를 활용하여 하나의 스레드만 접근을 할 수 있도록 제한을 하여 race condition이 일어나지 않도록 했습니다.
        
        ```
        let semaphore = DispatchSemaphore(value: 1)
        ...
        semaphore.wait()
        guard let customer = extractCustomerFromQueue() as? Customer else { return }
        semaphore.signal()
        
        ```
