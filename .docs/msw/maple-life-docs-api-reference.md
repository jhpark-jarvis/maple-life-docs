# maple-life-docs API Reference

> 운영 기준
> 이 문서는 MSW 개발용 에이전트가 `maple-life-docs` 운영 앱에서 어떤 API를 조회할 수 있는지 빠르게 파악하기 위한 참조 문서다.
> 기본 base URL은 `<MAPLE_LIFE_DOCS_BASE_URL>`이며, 다른 환경이 명시되지 않으면 이 값을 기준으로 조회한다.

## 1. 기본 정보

- base URL: `<MAPLE_LIFE_DOCS_BASE_URL>`
- 주요 API prefix: `/api`
- 문서 보조 기능 prefix: `/documents`

에이전트는 기본적으로 아래 순서로 조회한다.

1. `.docs/msw/` 정적 가이드
2. `maple-life-docs` 운영 API
3. 숨김 문서 또는 최신 원문 검증이 필요하면 D1/repository 직접 조회

## 1-1. 빠른 호출 예시

운영 API 확인용 기본 예시는 아래처럼 사용한다.

```bash
curl "<MAPLE_LIFE_DOCS_BASE_URL>/api/dashboard"
```

```bash
curl "<MAPLE_LIFE_DOCS_BASE_URL>/api/documents?q=%EC%9E%A1%ED%99%94%EC%83%81%EC%A0%90&include_hidden=1"
```

```bash
curl "<MAPLE_LIFE_DOCS_BASE_URL>/api/documents/22"
```

```bash
curl "<MAPLE_LIFE_DOCS_BASE_URL>/documents/search-links?q=%EC%A3%BC%EB%AF%BC%EC%84%BC%ED%84%B0"
```

## 1-2. 숨김 문서 검증 기준

숨김 문서 관련해서는 아래처럼 구분한다.

- 공개 API 목록 확인:
  - `GET /api/documents?include_hidden=1`
- 공개 문서/개별 문서 상세 확인:
  - `GET /api/documents/{document_id}`
- 제목/링크 후보 탐색:
  - `GET /documents/search-links?q=...`

단, 아래 경우에는 공개 API만으로 부족할 수 있다.

- 숨김 문서 전체를 빠짐없이 검증해야 하는 경우
- 최근 수정분이 운영 API에 아직 완전히 반영되었는지 확인해야 하는 경우
- 문서 목록 응답이 아니라 원문 기준으로 정합성 검증을 해야 하는 경우
- 초안/숨김/비공개 성격 문서를 포함해 근거를 다시 잡아야 하는 경우

이 경우에는 반드시 아래 단계로 올린다.

1. 운영 API로 먼저 후보를 좁힌다.
2. 부족하면 repository 접근 또는 D1 direct query로 원문을 다시 확인한다.

## 2. 대시보드

### `GET /api/dashboard`

- 용도: 대시보드 요약 정보 조회
- 주요 응답:
  - `summary`
  - `week_due_tasks`
  - `recent_documents`
  - `recent_tasks`
  - `pinned_notice`
  - `upcoming_schedules`
  - `today`
  - `week_start`
  - `week_end`

## 3. 문서 API

### `GET /api/documents`

- 용도: 문서 목록/필터 조회
- 주요 query:
  - `q`
  - `doc_type`
  - `tag`
  - `folder_id`
  - `include_hidden`
  - `page`
  - `per_page`
- 주요 응답:
  - `documents`
  - `document_types`
  - `folder_options`
  - `tag_options`
  - `pagination`
  - `filters`

### `GET /api/documents/{document_id}`

- 용도: 문서 상세 조회
- 주요 응답:
  - `document`
  - `related_tasks`
  - `tags`
  - `assets`
  - `rendered_content`
  - `word_count`
  - `heading_count`

### `GET /api/documents/editor`

- 용도: 문서 작성/수정 화면 bootstrap 데이터 조회
- 주요 query:
  - `document_id`
- 주요 응답:
  - `document`
  - `document_types`
  - `document_folders`
  - `members`
  - `tasks`
  - `related_task_ids`
  - `tags`
  - `assets`
  - `selected_type`
  - `asset_draft_key`

### `POST /api/documents`

- 용도: 문서 생성

### `POST /api/documents/{document_id}`

- 용도: 문서 수정

### `DELETE /api/documents/{document_id}`

- 용도: 문서 삭제

## 4. 문서 보조 API

### `GET /documents/search-links`

- 용도: 문서 링크 검색
- 주요 query:
  - `q`
  - `limit`
- 주요 응답:
  - `items[]`
    - `id`
    - `title`
    - `doc_type`
    - `is_hidden`
    - `folder_name`
    - `updated_at`
    - `path`

### `POST /documents/preview-markdown`

- 용도: Markdown 미리보기 HTML 변환
- form field:
  - `content`

### `POST /documents/format-markdown`

- 용도: Markdown 코드블록 포맷 정리
- form field:
  - `content`

### `POST /documents/upload-image`

- 용도: 문서 이미지 업로드
- form field:
  - `image`
  - `document_id`
  - `draft_key`
  - `alt`
- 주요 응답:
  - `asset_id`
  - `url`
  - `object_key`
  - `markdown`

## 5. WBS API

### `GET /api/wbs`

- 용도: WBS 목록/필터 조회
- 주요 query:
  - `status`
  - `assignee_id`
  - `priority`
  - `platform`
- 주요 응답:
  - `task_rows`
  - `members`
  - `statuses`
  - `priorities`
  - `platforms`
  - `filters`

### `GET /api/wbs/{task_id}`

- 용도: WBS 상세 조회
- 주요 응답:
  - `task`
  - `linked_documents`
  - `document_ids`
  - `is_completed`

### `GET /api/wbs/editor`

- 용도: WBS 작성/수정 bootstrap 데이터 조회
- 주요 query:
  - `task_id`
- 주요 응답:
  - `task`
  - `selected_document_ids`
  - `members`
  - `parent_tasks`
  - `documents`
  - `statuses`
  - `priorities`
  - `platforms`

### `POST /api/wbs`

- 용도: WBS 작업 생성

### `POST /api/wbs/{task_id}`

- 용도: WBS 작업 수정

### `DELETE /api/wbs/{task_id}`

- 용도: WBS 작업 삭제

## 6. 에셋 API

### `GET /api/assets`

- 용도: 에셋 목록, 검색, 증분 동기화 조회
- 주요 query:
  - `q`
  - `asset_type`
  - `status`
  - `tag`
  - `updated_since`
  - `include_hidden`
  - `page`
  - `per_page`

### `GET /api/assets/{asset_id}`

- 용도: 에셋 상세 조회

### `GET /api/assets/editor`

- 용도: 에셋 등록/수정 bootstrap 데이터 조회
- 주요 query:
  - `asset_id`

### `POST /api/assets`

- 용도: 에셋 생성
- 전송 방식:
  - `multipart/form-data`
- 주요 field:
  - `file`
  - `title`
  - `asset_type`
  - `category`
  - `tags`
  - `status`
  - `is_hidden`
  - `created_by`
  - `notes`

### `POST /api/assets/{asset_id}`

- 용도: 에셋 메타데이터 수정 또는 파일 교체
- 전송 방식:
  - `multipart/form-data`

### `DELETE /api/assets/{asset_id}`

- 용도: 에셋 삭제

## 7. 일정 API

### `GET /api/schedules`

- 용도: 일정 목록, 주간/월간 캘린더 데이터 조회
- 주요 query:
  - `month`
- 주요 응답:
  - `month_query`
  - `week_range`
  - `month_range`
  - `week_items`
  - `month_days`
  - `schedules`

### `GET /api/schedules/editor`

- 용도: 일정 작성/수정 bootstrap 데이터 조회
- 주요 query:
  - `schedule_id`
- 주요 응답:
  - `schedule`
  - `schedule_types`
  - `members`
  - `tasks`

### `POST /api/schedules`

- 용도: 일정 생성

### `POST /api/schedules/{schedule_id}`

- 용도: 일정 수정

### `DELETE /api/schedules/{schedule_id}`

- 용도: 일정 삭제

## 8. 멤버 API

### `GET /api/members`

- 용도: 멤버 목록 조회
- 주요 응답:
  - `members`

### `GET /api/members/editor`

- 용도: 멤버 작성/수정 bootstrap 데이터 조회
- 주요 query:
  - `member_id`
- 주요 응답:
  - `member`

### `POST /api/members`

- 용도: 멤버 생성

### `POST /api/members/{member_id}`

- 용도: 멤버 수정

### `DELETE /api/members/{member_id}`

- 용도: 멤버 삭제

## 9. 로그/텔레메트리 API

### `POST /api/telemetry/page-view`

- 용도: 페이지 접속 로그 기록
- 주요 body:
  - `path`
  - `referrer`
  - `visitor_id`
  - `session_id`
  - `identity_type`

### `GET /api/logs/page-views`

- 용도: 페이지 접속 로그 조회
- 주요 query:
  - `limit`
  - `q`
  - `visitor_id`
- 주요 응답:
  - `logs`
  - `summary`
  - `filters`

## 10. 에이전트 사용 시 주의

- 공개 API만으로 숨김 문서 전체를 항상 완전하게 복원할 수 있는 것은 아니다.
- 문서 최신성, 숨김 문서, 초안 문서까지 포함한 검증이 필요하면 D1 direct query 또는 repository 접근을 같이 사용한다.
- API 응답은 화면용 구조가 섞여 있으므로, 에이전트는 `목록용 API`와 `원문 검증용 데이터 소스`를 구분해서 사용해야 한다.
- 구현 선택지가 `MSW 기본 방식`과 `커스텀 방식`으로 나뉘면, API를 확인한 뒤에도 최종 선택은 반드시 사용자에게 먼저 질문해야 한다.

## 11. 에이전트용 최소 조회 루틴

새 작업을 시작하는 에이전트는 최소한 아래 순서로 움직이는 것을 권장한다.

1. `.docs/msw/README.md` 확인
2. `.docs/msw/msw-project-overview.md` 확인
3. `.docs/msw/codex-working-guide.md`와 `.docs/msw/msw-agent-optimization-rules.md` 확인
4. `.docs/msw/maple-life-docs-api-reference.md`로 사용할 API 확인
5. `<MAPLE_LIFE_DOCS_BASE_URL>` 운영 API로 관련 문서/데이터 1차 조회
6. 모호하거나 숨김 문서 검증이 필요하면 D1/repository direct query로 보강
