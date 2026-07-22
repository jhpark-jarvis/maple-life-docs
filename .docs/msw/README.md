# MSW 기획 문서 작업 가이드

> 운영 원칙
> 이 디렉터리 문서는 에이전트 작업의 기준축을 제공하는 정적 가이드이며, 최신 원문 전체를 대체하지 않습니다.
> 새로운 작업을 시작하거나 요구사항이 모호하거나 최신성이 중요하면, 반드시 `<MAPLE_LIFE_DOCS_BASE_URL>`의 관련 API 또는 D1 원문을 다시 조회해 보조 확인해야 합니다.

이 디렉터리는 `MAPLE LIFE DEV Docs`의 D1 기준 기획 문서를 바탕으로, 에이전트가 메이플스토리 월드(MSW) 개발 배경을 빠르게 이해하고 일관된 방향으로 작업할 수 있도록 정리한 내부 작업 문서 모음입니다.

## 목적

- 최신 원본 문서 저장소는 `Cloudflare D1`로 유지한다.
- 프로젝트의 기획 방향과 구현 포인트는 `maple-life-docs` 문서를 기준으로 해석한다.
- 실제 개발 실행 방식은 `MSW MCP`가 제공하는 공식 skills, 공식 문서, 기능, 제약을 우선 기준으로 삼는다.
- 에이전트는 매 작업마다 D1 원문 전체를 다시 읽지 않고, 압축된 가이드 문서를 우선 참조한다.
- 실제 구현 전후로 최신성 검증이 필요할 때만 D1 API 또는 D1 repository를 통해 원문을 다시 확인한다.

## 현재 기준

- 정리 기준일: `2026-07-09`
- 기준 데이터 소스: `Cloudflare D1 documents`
- 확인된 문서 수: `54`
- 공개 문서 수: `4`
- 숨김 문서 수: `50`

## 문서 구성

- `msw-project-overview.md`
  - 프로젝트 배경, 세계관, 핵심 시스템, 주요 콘텐츠 축 요약
- `codex-working-guide.md`
  - Codex가 실제 구현/기획 작업 시 어떤 우선순위와 규칙으로 문서를 참조해야 하는지 정리
- `msw-agent-optimization-rules.md`
  - MSW MCP 에이전트가 문서, 코드, 기존 구현 자산을 함께 활용해 최적 결과를 내기 위한 공용 운영 규칙과 프롬프트 템플릿
- `maple-life-docs-api-reference.md`
  - `<MAPLE_LIFE_DOCS_BASE_URL>` 운영 앱에서 조회 가능한 API 목록과 용도 정리

## 권장 읽기 순서

에이전트가 이 디렉터리만 전달받은 상태라면 아래 순서로 읽고 작업을 시작한다.

1. `msw-project-overview.md`
   - 프로젝트를 어떤 게임으로 이해해야 하는지 먼저 잡는다.
2. `codex-working-guide.md`
   - 어떤 문서를 어떤 순서로 참고할지와 작업 흐름을 잡는다.
3. `msw-agent-optimization-rules.md`
   - 실제 작업 규칙, API 보조 조회 규칙, 산출물 형식을 적용한다.
4. `maple-life-docs-api-reference.md`
   - 어떤 API를 어디에 써야 하는지 빠르게 확인한다.

즉, `개요 이해 -> 작업 흐름 이해 -> 실행 규칙 적용 -> 실제 API 확인` 순서로 진행한다.

## API 기준

이 디렉터리 문서에서 말하는 `API 조회`는 기본적으로 이 프로젝트가 제공하는 HTTP API를 뜻한다.

- 기본 운영 API base URL: `<MAPLE_LIFE_DOCS_BASE_URL>`
- Flask 앱 기준 API prefix: `/api`
- 문서 보조 기능 prefix: `/documents`

기본 원칙은 아래와 같다.

- 별도 지시가 없으면 `<MAPLE_LIFE_DOCS_BASE_URL>`를 기본 조회 대상 앱으로 사용한다.
- 즉, MSW 개발용 에이전트도 우선 이 운영 프론트가 실제로 호출하는 API를 기준으로 문서/데이터를 확인한다.
- 다른 환경이 명시적으로 주어진 경우에만 그 base URL로 바꾼다.

예:

- `<MAPLE_LIFE_DOCS_BASE_URL>/api/documents`
- `<MAPLE_LIFE_DOCS_BASE_URL>/api/documents/22`
- `<MAPLE_LIFE_DOCS_BASE_URL>/documents/search-links?q=잡화상점`

## 원칙

- D1이 최신 원본이다.
- 개발 방향의 실행 최우선 기준은 `MSW MCP`가 제공하는 공식 skills와 공식 문서다.
- 개발 방향의 실행 기준은 MSW MCP다.
- 무엇을 만들어야 하는지와 왜 그렇게 만들어야 하는지는 우리 문서가 정한다.
- `MSW` 기본 기능/기본 자산으로도 가능하고 `커스텀 구현` 또는 `커스텀 자산`으로도 가능한 선택지라면, 에이전트가 임의 결정하지 말고 반드시 사용자에게 먼저 확인을 받아야 한다.
- 이 디렉터리 문서는 “작업용 압축본”이다.
- 기본 작업은 이 정적 문서를 먼저 읽고 시작한다.
- 모호한 부분이 있거나, 새로운 작업을 시작하거나, 최신성 검증이 중요하면 관련 D1 원문 문서를 API 또는 repository 경로로 다시 조회한다.
- 원문과 가이드 문서가 충돌하면 D1 원문을 우선한다.
- 큰 기획 변경이 생기면 이 디렉터리 문서도 같이 갱신한다.
