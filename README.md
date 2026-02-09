# DMK Tech Blog

데이터마케팅코리아 개발팀 기술 블로그 — Hugo 정적 사이트

## 실행 방법

```bash
# 로컬 개발 서버 실행 (draft 포스트 포함)
hugo server -D

# 빌드 (public/ 폴더에 출력)
hugo
```

## 새 포스트 작성

```bash
hugo new posts/포스트-이름.md
```

또는 `content/posts/` 에 `.md` 파일을 직접 생성합니다. front matter 형식:

```toml
+++
title = '포스트 제목'
date = 2025-03-01
draft = false
tags = ['RAG', 'LLM']
image = 'https://example.com/thumbnail.png'
+++
```

- `draft = true`이면 `hugo server -D` 로만 확인 가능
- `tags`는 홈 화면 필터바에 자동 반영
- `image`는 카드 썸네일 및 포스트 상단 이미지로 사용

## 프로젝트 구조

```
dmk-hugo/
├── hugo.toml                        # Hugo 설정 파일
├── content/
│   └── posts/                       # 블로그 포스트 (마크다운)
│       └── rag-llm.md               # 포스트 예시
├── layouts/
│   ├── _default/
│   │   ├── baseof.html              # 기본 HTML 레이아웃 (head, body, footer)
│   │   ├── list.html                # 목록 페이지 템플릿 (태그별 목록 등)
│   │   └── single.html              # 개별 포스트 페이지 템플릿
│   ├── _markup/
│   │   └── render-codeblock-mermaid.html  # Mermaid 다이어그램 렌더링
│   ├── partials/
│   │   ├── header.html              # 상단 헤더 (로고, 검색, 다크모드 토글)
│   │   ├── hero.html                # 메인 타이틀 섹션
│   │   ├── filterbar.html           # 태그 필터 바
│   │   └── blogcard.html            # 블로그 카드 컴포넌트
│   └── index.html                   # 홈페이지 (필터링/검색 JS 포함)
├── archetypes/
│   └── default.md                   # 새 포스트 생성 시 기본 템플릿
├── static/
│   └── images/
│       └── dmk-logo.png             # 사이트 로고
└── public/                          # 빌드 출력 (gitignore 대상)
```

## 각 파일 설명

### 설정

| 파일 | 설명 |
|------|------|
| `hugo.toml` | 사이트 제목, 언어, 서브타이틀, 로고 경로, taxonomy 설정 |
| `.gitignore` | Git 추적 제외 파일 목록 (`public/`, `.hugo_build.lock` 등) |

### 레이아웃 (`layouts/`)

| 파일 | 설명 |
|------|------|
| `_default/baseof.html` | 모든 페이지의 기본 골격. Tailwind CSS CDN, Noto Sans KR 폰트, 다크모드 설정, Mermaid 스크립트를 포함 |
| `_default/single.html` | 개별 포스트 상세 페이지. 뒤로가기 버튼, 태그 배지, 본문 렌더링, `<aside>` 스타일, Mermaid 다이어그램 지원 |
| `_default/list.html` | 태그별 포스트 목록 페이지 |
| `index.html` | 홈페이지. Hero, FilterBar, BlogCard를 조합하고 태그 필터링/검색 기능의 JavaScript 포함 |
| `_markup/render-codeblock-mermaid.html` | 마크다운의 mermaid 코드블록을 다이어그램으로 변환 |

### 파셜 (`layouts/partials/`)

| 파일 | 설명 |
|------|------|
| `header.html` | 상단 고정 헤더. 로고, 사이트명, 다크모드 토글(해/달 아이콘), 검색 토글 포함 |
| `hero.html` | 사이트 제목과 서브타이틀을 표시하는 히어로 섹션 |
| `filterbar.html` | 태그 기반 필터 버튼을 가로 스크롤로 표시. Hugo taxonomy에서 자동 생성 |
| `blogcard.html` | 개별 포스트를 카드 형태로 표시. 썸네일, 태그 배지, 제목, 날짜 포함 |

### 콘텐츠 (`content/`)

| 파일 | 설명 |
|------|------|
| `posts/*.md` | 블로그 포스트. TOML front matter(`title`, `date`, `tags`, `image`) + 마크다운 본문 |

### 정적 파일 (`static/`)

| 파일 | 설명 |
|------|------|
| `images/dmk-logo.png` | 헤더에 표시되는 사이트 로고 |

## 기능

- **태그 필터링** — 포스트의 `tags`를 기준으로 홈 화면에서 필터링
- **검색** — 제목/본문 기반 실시간 검색
- **다크모드** — 헤더의 토글 버튼으로 전환, `localStorage`에 저장되어 유지
- **Mermaid 다이어그램** — 마크다운에서 mermaid 코드블록 사용 시 자동 렌더링
- **반응형 디자인** — 모바일 1열, 태블릿 2열, 데스크톱 3열 그리드
