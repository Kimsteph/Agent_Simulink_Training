# Simulink Learning Curriculum

## Level 1: Basics (모델 생성과 단일 블록)
- [x] L1.1: 빈 모델 생성 → 저장 → 닫기
- [x] L1.2: Sine Wave + Scope 연결 → 시뮬레이션 → 결과 확인
- [x] L1.3: Step → Gain → Scope (파라미터 설정 포함)
- [x] L1.4: Constant → Sum → To Workspace → 결과 추출

## Level 2: Signal Flow (다중 블록 연결)
- [x] L2.1: 두 Sine Wave → Sum → Scope (신호 합성)
- [x] L2.2: Step → Transfer Function → Scope (1차 시스템 응답)
- [x] L2.3: Mux로 여러 신호 묶어서 Scope에 표시
- [x] L2.4: Subsystem 생성 및 내부 블록 구성

## Level 3: Control Systems (피드백 루프)
- [x] L3.1: 단순 비례(P) 제어기 — Step → Sum → Plant → Scope + feedback
- [x] L3.2: PID 제어기 구현
- [x] L3.3: 2차 시스템 step response 분석
- [x] L3.4: 시뮬레이션 결과 plot 생성 및 파일 저장

## Level 4: Advanced (복합 모델)
- [x] L4.1: State-Space 모델 구현
- [x] L4.2: Lookup Table + 비선형 시스템
- [x] L4.3: 파라미터 스윕 (여러 Gain 값으로 반복 시뮬레이션)
- [x] L4.4: 모델 참조 (Model Reference)

## Level 5: Simscape & Domain-Specific
- [x] L5.1: 간단한 Simscape 물리 모델
- [x] L5.2: 전기회로 모델링
- [x] L5.3: 기계 시스템 모델링

## Level 6: Radar & Signal Processing
- [x] L6.1: FMCW 레이더 — Chirp+Delay+Mixer+LPF → 1D FFT 타겟 감지
- [x] L6.2: FMCW 레이더 HDL Coder — fixed-point ROM+Delay+Mixer → Verilog 생성

## Level 7: HDL Coder Fundamentals
- [x] L7.1: 간단한 카운터 HDL 생성 (hdlsetup + makehdl 워크플로우)
- [x] L7.2: FMCW Radar HDL-compatible 모델 (ROM, Delay, Product, fixed-point)
- [x] L7.3: FIR 필터 HDL — Baseline vs Pipelined vs Resource Sharing 비교
- [x] L7.4: HDL Testbench 생성 (makehdltb → DUT_tb.v + stimulus data)

## Level 8: HDL Coder Advanced
- [x] L8.1: Stateflow Chart → HDL (간단한 FSM)
- [x] L8.2: MATLAB Function 블록 → HDL
- [ ] L8.3: Clock Domain Crossing (CDC) — dual-clock 모델

## Level 9: Zynq SoC Workflow
- [x] L9.1: IP Core Generation 워크플로우 — LED Blinker + AXI4-Lite + Vivado IP Packager
- [x] L9.2: AXI4 데이터 인터페이스 — FIR Filter IP Core + FIFO + DualPort RAM
- [x] L9.3: FMCW 레이더를 Zynq IP Core로 패키징

## Level 10: RFSoC & SoC Blockset
- [x] L10.1: SoC Blockset 기초 — soclib 블록 탐색, 3-file 모델 구조 이해
- [x] L10.2: RFDC API — soc.RFDataConverter 설정, ADC/DAC Tile 구성
- [x] L10.3: SoC 모델 생성 — 3-file 패턴 학습, HW 보드 설정, 블록 경로 매핑
- [x] L10.4: AXI4-Stream + DMA — Memory Channel 파라미터, Stream FIFO, 프레임 크기 계산
- [x] L10.5: SoC 호스트 인터페이스 — fpga(), addAXI4SlaveInterface, addAXI4StreamInterface, DUTPort, mapPort
- [x] L10.6: RF Data Converter 블록 — 428 파라미터 전수 조사, Tile/Channel/NCO/SPC 설정
- [x] L10.7: SoC 예제 분석 — hwsw_stream, ddr4datacapture, rfcapture, rf_playback 구조 파악
- [x] L10.8: ZCU111 Template 생성 — 예제 복사 시뮬(175초 PASS) + NCO FPGA 모델 자작 시뮬 PASS
- [x] L10.9: Template 완전 해부 — 254블록 FPGA + 157블록 Proc + Top 전체 연결맵/Bus/Goto 분석
- [x] L10.10: Vivado Reference Design — 4종 RD, system.tcl, IP구성(RFDC+DMA+DDR4+PS), Pin제약
- [x] L10.11: PDR vs DDR4 비교 — PDR 추가블록(TargetEmu+MatchedFilter), AXI레지스터맵, FMCW변환포인트
- [x] L10.12: ZCU_PDR 프로젝트 완전 분석 — FPGA 218블록(depth5), Proc 3 Task, Top 연결맵, 배포 워크플로우

## Progress Log

| Date | Challenge | Result | Lessons Learned |
|------|-----------|--------|-----------------|
| 2026-04-10 | L1.1 빈 모델 | PASS | bdIsLoaded→close→new→open 패턴 확인 |
| 2026-04-10 | L1.2 Sine+Scope | PASS (2회) | SaveFormat Dataset→timeseries 반환됨, .Time/.Data 직접접근 |
| 2026-04-10 | L1.3 Step+Gain | PASS | Step Before/After, Gain 파라미터 정상 동작 확인 |
| 2026-04-10 | L1.4 Const+Sum | PASS | Sum Inputs "++" 문법, 두 입력 합산 확인 |
| 2026-04-10 | L2.1 Sine합성 | PASS | MaxStep으로 해상도 제어, 두 주파수 합성 확인 |
| 2026-04-10 | L2.2 TransferFcn | PASS | 1차 시스템 시정수 τ=1초 정확히 검증 |
| 2026-04-10 | L2.3 Mux | PASS | Mux Inputs="3", 출력 [N×3] timeseries |
| 2026-04-10 | L2.4 Subsystem | PASS | delete_line→add_block→add_line으로 내부 수정, 기본 In1/Out1 활용 |
| 2026-04-10 | L3.1 P제어기 | PASS | 피드백 루프 Sum "+-", SS error=1/(1+Kp) 검증 |
| 2026-04-10 | L3.2 PID제어기 | PASS | PID Controller 블록, I항으로 SS error≈0, OS=24.79% |
| 2026-04-10 | L3.3 2차시스템 | PASS | wn=5,zeta=0.3, 이론값과 시뮬 일치 (OS=37.23%) |
| 2026-04-10 | L3.4 Plot저장 | PASS (2회) | 블록이름에 소수점 불가, saveas로 png 저장 |
| 2026-04-10 | L4.1 State-Space | PASS | A/B/C/D mat2str로 전달, 다중출력(position+velocity) |
| 2026-04-10 | L4.2 LookupTable | PASS | Table/BreakpointsForDimension1 파라미터, 비선형 포화 |
| 2026-04-10 | L4.3 ParamSweep | PASS | SimulationInput.setVariable로 배치실행 |
| 2026-04-10 | L4.4 ModelRef | PASS | 서브모델(In1→Plant→Out1) + Model블록 참조 |
| 2026-04-10 | L5.1 Simscape MSD | PASS (5회) | fl_lib/nesl_utility 경로, FS 포트매핑(LConn=C,RConn1=S,RConn2=R), newline 처리 |
| 2026-04-10 | L5.2 RC회로 | PASS | Electrical블록 2포트, VSns(LConn=+,RConn1=sig,RConn2=-), τ=RC 검증 |
| 2026-04-10 | L5.3 Rotational | PASS | Inertia+RotDamper+RotSpring, TS포트=FS와 동일, SS angle=T/K 정확 |
| 2026-04-10 | L6.1 FMCW Radar | PASS (2회) | Chirp+Delay+Mixer+LPF+FFT, ode4 솔버, 2타겟(44m,117m) 감지 |
| 2026-04-11 | L7.1 Counter HDL | PASS | hdlsetup→makehdl 워크플로우, DUT subsystem 패턴, uint8 카운터→Verilog |
| 2026-04-11 | L7.2 FMCW HDL | PASS (2회) | ROM(1-D LUT)+Delay+Product→930KB Verilog, fixdt(1,16,14), 2타겟 감지 |
| 2026-04-11 | L7.3 FIR HDL | PASS | Baseline(4.3KB), Pipelined(+3cyc latency), Shared(SharingFactor=4) |
| 2026-04-11 | L7.4 Testbench | PASS | makehdltb→DUT_tb.v(7KB)+In1.dat+Out1_expected.dat |
| 2026-04-11 | L8.1 Stateflow HDL | PASS | sfroot API로 Chart 프로그래밍, FSM→Verilog(FSM.v 4.4KB) |
| 2026-04-11 | L8.2 MATLAB Fcn HDL | PASS | persistent 변수=레지스터, fi()=fixed-point, bitsra=시프트 |
| 2026-04-11 | L9.1 Zynq IP Core | PASS (2회) | TreatAsAtomicUnit 필수, AXI4-Lite+GPIO매핑, Vivado IP Packager+DeviceTree 자동생성 |
| 2026-04-11 | L9.2 AXI4 IP Core | PASS (2회) | AXI4-Stream은 Default RD 미지원→AXI4사용, 30개 VHDL+FIFO+RAM 자동생성 |
| 2026-04-11 | L9.3 FMCW Zynq IP | PASS | FMCW Radar→AXI4 IP Core, 28 VHDL+DeviceTree+SW Interface 자동생성 |
| 2026-04-11 | L10.1 SoC Blockset | PASS | 8개 핵심 라이브러리(hwlogicconnlib~proctasklib) 52블록 매핑 |
| 2026-04-11 | L10.2 RFDC API | PASS | soc.RFDataConverter 전체 API, PDR RFDC 설정 스크립트 분석 |
| 2026-04-11 | L10.3 SoC 3-File | PASS | 3-file 구조, HW Board 설정 필수, Memory Channel+Stream FIFO 조건 |
| 2026-04-11 | L10.4 DMA+Stream | PASS | MemCh 파라미터 전수 조사, 프레임계산(Rng×Vel/SPC), FIFO Depth/AFullThresh |
| 2026-04-11 | L10.5 Host Interface | PASS | fpga()+addAXI4Slave/Stream+DUTPort+mapPort+writePort/readPort 완전 학습 |
| 2026-04-11 | L10.6 RFDC Block | PASS | 428파라미터, Tile/Ch Enable, SampleRate, Decim, SPC, NCO Mixer, MTS, Threshold |
| 2026-04-11 | L10.7 SoC Examples | PASS | 44예제 분류, hwsw_stream/ddr4/rfcapture/rf_playback 구조 분석 |
| 2026-04-11 | L10.8 ZCU111 Template | PASS | ddr4datacapture 기반 템플릿 시뮬 + NCO FPGA 자작 모델 시뮬 |
| 2026-04-11 | L10.9 Template해부 | PASS | FPGA(254b)+Proc(157b)+Top 전체구조, AXI Bus/Goto/FIFO/DDR4/DMA 완전분석 |
| 2026-04-11 | L10.10 Vivado RD | PASS | 4종RD, system.tcl(RFDC+DMA+DDR4+PS+ClkWiz), xczu28dr, Vivado2024.1 |
| 2026-04-11 | L10.11 PDR비교 | PASS | TargetEmu+MatchedFilter 추가, 8 AXI regs, pulse timing, DMA 262KB/CPI |
| 2026-04-11 | L10.12 ZCU_PDR분석 | PASS | FPGA(218b/48sub), SystemController FSM, TX ROM[17], MF polyphase, NCO 3M5A |
