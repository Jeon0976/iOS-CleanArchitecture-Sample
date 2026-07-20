//
//  DIContainer.swift
//  DependencyInjection
//
//  Created by 전성훈 on 3/11/25.
//
//  P1-3 (2026-07-13): String 키 → 타입 키 + 스레드 안전 resolve.
//  - 키: String(describing: T.self) → ObjectIdentifier(T.self).
//    문자열 키는 리네임·동명이인(다른 모듈의 같은 이름 타입)에서 조용히 깨진다.
//    메타타입 정체성은 컴파일러가 아는 타입 동일성과 일치한다.
//  - 락: NSRecursiveLock. Domain 팩토리가 resolve 안에서 다시 resolve를 부르는
//    중첩 구조라 재귀 락이 필요하다 — Swinject synchronize()가 RecursiveLock 기반인 것과
//    같은 이유(KIRA e18bd638 크래시의 수정 원리를 그대로 이식).
//  - 실패: miss 시 fatalError → resolve는 DIError를 던지고, 조립 경계 전용 require는
//    진단 메시지를 담아 preconditionFailure(조립 코드의 미등록 = 프로그래머 에러).
//

import Foundation

public enum DIError: Error, CustomStringConvertible {
    case missingRegistration(String)

    public var description: String {
        switch self {
        case let .missingRegistration(service):
            return "미등록 타입 해소: \(service) — 해당 레이어 DIContainer의 register 누락 여부를 확인"
        }
    }
}

public final class DIContainer {
    static public let shared = DIContainer()

    private let lock = NSRecursiveLock()
    private var factories = [ObjectIdentifier: () -> Any]()
    private var instances = [ObjectIdentifier: Any]()

    private init() { }

    /// 해소할 때마다 팩토리를 실행한다(기존 의미론 유지 — 캐싱 없음).
    public func register<T>(_ type: T.Type = T.self, _ factory: @escaping (() -> T)) {
        lock.lock()
        defer { lock.unlock() }

        factories[ObjectIdentifier(type)] = factory
    }

    /// 만들어 둔 인스턴스를 등록한다(싱글톤 의미론). 중복 등록은 크래시 대신 덮어쓰되 디버그에서 알린다.
    public func register<T>(_ type: T.Type = T.self, instance: T) {
        lock.lock()
        defer { lock.unlock() }

        let key = ObjectIdentifier(type)
        if instances[key] != nil {
            assertionFailure("\(String(describing: type))이 이미 인스턴스에 저장되어 있습니다. 덮어씁니다.")
        }

        instances[key] = instance
    }

    /// 실패를 값으로 받는 해소 — 테스트·선택적 의존에 사용.
    public func resolve<T>(_ type: T.Type = T.self) throws -> T {
        lock.lock()
        defer { lock.unlock() }

        let key = ObjectIdentifier(type)

        if let instance = instances[key] as? T { return instance }

        if let factory = factories[key], let instance = factory() as? T {
            return instance
        }

        throw DIError.missingRegistration(String(describing: type))
    }

    /// 조립 경계(Composition Root) 전용 해소 — 미등록은 설정 버그이므로 진단을 담아 즉시 멈춘다.
    public func require<T>(_ type: T.Type = T.self) -> T {
        do {
            return try resolve(type)
        } catch {
            preconditionFailure("\(error)")
        }
    }
}
