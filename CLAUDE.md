# Agent Simulink Training

Simulink 프로그래밍 API를 자기학습하는 Claude 에이전트 프로젝트.

## 프로젝트 구조

- `.claude/skills/simulink/` — Simulink 자기학습 스킬
  - `SKILL.md` — 스킬 진입점 (`/simulink`)
  - `knowledge-base.md` — 축적된 API 지식 + 학습 내용
  - `curriculum.md` — 단계별 학습 과제 + 진행 상태
  - `templates/` — 재사용 가능한 .m 템플릿
  - `scripts/` — 실행/검증 헬퍼 스크립트

## 사용법

- `/simulink` — Simulink 모델 생성/수정 요청
- `/simulink learn` 또는 "스스로 배워" — 자율 학습 모드 시작
- 사용자 피드백을 주면 knowledge-base에 반영

## MATLAB MCP 연동

이 프로젝트는 MATLAB MCP Server를 통해 MATLAB과 연동됩니다.
`evaluate_matlab_code`, `run_matlab_file` 도구로 Simulink API를 실행합니다.
