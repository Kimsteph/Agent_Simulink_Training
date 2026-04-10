# Simulink Knowledge Base

## API Reference

### Model Management
- `new_system('name')` — 새 모델 생성
- `open_system('name')` — 에디터에서 열기
- `save_system('name')` — 저장
- `save_system('name', 'path/name.slx')` — 경로 지정 저장
- `close_system('name', 0)` — 저장 없이 닫기
- `bdIsLoaded('name')` — 모델 로드 여부 확인
- `load_system('name')` — 에디터 열지 않고 로드
- `bdroot` — 현재 최상위 모델 이름

### Block Operations
- `add_block('lib/Block', 'model/BlockName')` — 블록 추가
- `add_block('lib/Block', 'model/BlockName', 'MakeNameUnique', 'on')` — 이름 충돌 방지
- `delete_block('model/BlockName')` — 블록 삭제
- `set_param('model/BlockName', 'ParamName', 'Value')` — 파라미터 설정
- `get_param('model/BlockName', 'ParamName')` — 파라미터 조회
- Position 파라미터: `[left top right bottom]` 픽셀 좌표

### Connections
- `add_line('model', 'SrcBlock/portN', 'DstBlock/portN')` — 포트 이름 기반 연결
- `add_line('model', srcPortHandle, dstPortHandle)` — 핸들 기반 연결
- `add_line('model', 'Src/1', 'Dst/1', 'autorouting', 'smart')` — 자동 라우팅
- `delete_line('model', 'Src/1', 'Dst/1')` — 연결 삭제
- `get_param('model/Block', 'PortHandles')` — 블록의 포트 핸들 구조체

### Simulation
- `out = sim('model')` — 기본 실행
- `out = sim('model', 'StopTime', '10')` — 파라미터 지정 실행
- `simIn = Simulink.SimulationInput('model')` — 입력 구성 객체
- `simIn = simIn.setVariable('varName', value)` — 변수 설정
- `out = sim(simIn)` — 구성된 입력으로 실행

### Model Query
- `find_system('model', 'Type', 'Block')` — 모든 블록 찾기
- `find_system('model', 'BlockType', 'Gain')` — 특정 타입 블록 찾기
- `find_system('model', 'FindAll', 'on', 'Type', 'Line')` — 모든 라인 찾기
- `get_param('model', 'SimulationStatus')` — 시뮬레이션 상태

### Layout
- `Simulink.BlockDiagram.arrangeSystem('model')` — 자동 레이아웃 정리

## Common Library Paths

| Block | Path |
|-------|------|
| Sine Wave | `simulink/Sources/Sine Wave` |
| Step | `simulink/Sources/Step` |
| Constant | `simulink/Sources/Constant` |
| Clock | `simulink/Sources/Clock` |
| Ramp | `simulink/Sources/Ramp` |
| Scope | `simulink/Sinks/Scope` |
| To Workspace | `simulink/Sinks/To Workspace` |
| Display | `simulink/Sinks/Display` |
| Gain | `simulink/Math Operations/Gain` |
| Sum | `simulink/Math Operations/Sum` |
| Product | `simulink/Math Operations/Product` |
| Abs | `simulink/Math Operations/Abs` |
| Transfer Fcn | `simulink/Continuous/Transfer Fcn` |
| Integrator | `simulink/Continuous/Integrator` |
| Derivative | `simulink/Continuous/Derivative` |
| State-Space | `simulink/Continuous/State-Space` |
| PID Controller | `simulink/Continuous/PID Controller` |
| Mux | `simulink/Signal Routing/Mux` |
| Demux | `simulink/Signal Routing/Demux` |
| Switch | `simulink/Signal Routing/Switch` |
| Subsystem | `simulink/Ports & Subsystems/Subsystem` |
| Inport | `simulink/Sources/In1` |
| Outport | `simulink/Sinks/Out1` |
| Saturation | `simulink/Discontinuities/Saturation` |
| Dead Zone | `simulink/Discontinuities/Dead Zone` |
| Lookup Table | `simulink/Lookup Tables/1-D Lookup Table` |
| Unit Delay | `simulink/Discrete/Unit Delay` |
| Zero-Order Hold | `simulink/Discrete/Zero-Order Hold` |

## Known Gotchas

1. **Position 필수**: 새 블록은 소스 라이브러리 블록과 같은 위치에 생성됨 → Position 반드시 설정
2. **포트 번호**: add_line에서 포트 번호는 1부터 시작
3. **모델 이름**: 공백, 특수문자 불가. 유효한 MATLAB 식별자여야 함
4. **모델 로드**: sim() 전에 모델이 load 되어 있어야 함
5. **close_system**: 두 번째 인자 0 = 저장 안 함, 생략 시 저장 여부 물어봄
6. **Sum 블록 Inputs**: `'+-'` 형식으로 각 입력의 부호 지정, `'|'`로 스페이서 추가
7. **Transfer Fcn**: Numerator/Denominator는 문자열 벡터 `'[1 2]'` 형식
8. **To Workspace**: SaveFormat을 `'Dataset'`으로 설정하면 Simulink.SimulationData.Dataset 반환
9. **autorouting**: add_line에 `'autorouting', 'smart'` 추가하면 라인이 깔끔하게 배치됨
10. **중복 이름**: 같은 모델에 같은 이름 블록 추가 시 에러 → MakeNameUnique 사용

## Learned Lessons

### 2026-04-10: To Workspace SaveFormat과 출력 타입
- `SaveFormat`을 `"Dataset"`으로 설정해도 MATLAB 버전에 따라 `timeseries` 객체가 반환될 수 있음
- `out.simout`이 `timeseries`일 때: `.Time`, `.Data`로 직접 접근
- `out.simout`이 `Dataset`일 때: `.getElement(1).Values`로 접근
- 안전한 방법: `class(out.simout)`으로 타입 확인 후 분기

### 2026-04-10: 기본 모델 생성 패턴
- `bdIsLoaded` → `close_system(name, 0)` → `new_system` → `open_system` 순서가 안전
- `save_system(name)` 호출 시 현재 디렉토리에 .slx 저장됨

### 2026-04-10: Mux 출력 형태
- Mux로 N개 신호를 묶으면 To Workspace 출력이 `[timepoints × N]` 행렬
- 각 열이 개별 신호에 대응: `ts.Data(:,1)`, `ts.Data(:,2)` ...

### 2026-04-10: Subsystem 내부 수정 패턴
- `add_block("simulink/Ports & Subsystems/Subsystem", ...)` 시 기본 In1→Out1 연결이 존재
- 내부 수정: `delete_line([model '/Subsys'], 'In1/1', 'Out1/1')` 로 기본 연결 삭제
- 내부 블록 추가: `add_block(lib, [model '/Subsys/BlockName'], ...)`
- 내부 연결: `add_line([model '/Subsys'], 'In1/1', 'Block/1')`

### 2026-04-10: MaxStep으로 시뮬레이션 해상도 제어
- `set_param(model, "MaxStep", "0.01")` 으로 최대 스텝 크기 제한
- 고주파 신호 캡처 시 필수

### 2026-04-10: 블록 이름 제약
- Simulink 블록 이름에 소수점(`.`) 사용 불가
- 특수문자(`/`, `.`, 줄바꿈) 금지, 유효한 경로 세그먼트여야 함
- 숫자, 문자, 언더스코어 조합 권장

### 2026-04-10: PID Controller 블록
- 경로: `simulink/Continuous/PID Controller`
- 파라미터: `"P"`, `"I"`, `"D"` (문자열 값)
- I 항이 있으면 정상상태 오차 제거
- 오버슈트와 응답속도 간 트레이드오프

### 2026-04-10: 피드백 루프 구성 패턴
- Sum 블록 `Inputs` = `"+-"` → 첫 입력은 +, 두 번째는 - (에러 = ref - feedback)
- Plant 출력을 Sum의 두 번째 포트에 연결
- P 제어: SS error = 1/(1+Kp)

### 2026-04-10: Plot 저장
- `saveas(fig, fullfile(pwd, "name.png"))` 으로 현재 디렉토리에 저장
- `figure("Visible", "on")` 으로 MATLAB GUI에 표시

### 2026-04-10: State-Space 블록 파라미터
- 경로: `simulink/Continuous/State-Space`
- A, B, C, D 모두 `mat2str()` 로 문자열 변환하여 전달
- C 행렬 행 수 = 출력 포트 수 (다중 출력 가능)

### 2026-04-10: 1-D Lookup Table
- 경로: `simulink/Lookup Tables/1-D Lookup Table`
- `"Table"` = 출력값 벡터 문자열, `"BreakpointsForDimension1"` = 입력값 벡터 문자열
- 입력/출력 벡터 길이가 같아야 함

### 2026-04-10: 파라미터 스윕 (SimulationInput)
- `simIn = Simulink.SimulationInput(modelName)`
- `simIn = simIn.setVariable("varName", value)` — 워크스페이스 변수 설정
- Gain 블록의 Gain을 변수 이름(예: `"Kp_val"`)으로 설정 후 스윕
- `sim(simIn)` 으로 실행, 루프로 여러 값 순회

### 2026-04-10: Model Reference
- 서브모델: In1 → 내부로직 → Out1 구조, `.slx`로 저장 필수
- 메인모델: `add_block("simulink/Ports & Subsystems/Model", ...)` 로 참조 블록 추가
- `"ModelName"` 파라미터에 서브모델 이름 지정
- 서브모델 `.slx`가 MATLAB 경로에 있어야 함

### 2026-04-10: Simscape 라이브러리 경로 (핵심)
- Solver Configuration: `nesl_utility/Solver<newline>Configuration`
- Simulink-PS Converter: `nesl_utility/Simulink-PS<newline>Converter`
- PS-Simulink Converter: `nesl_utility/PS-Simulink<newline>Converter`
- Mass: `fl_lib/Mechanical/Translational<newline>Elements/Mass`
- Translational Spring: `fl_lib/Mechanical/Translational<newline>Elements/Translational Spring`
- Translational Damper: `fl_lib/Mechanical/Translational<newline>Elements/Translational Damper`
- Mechanical Translational Reference: `fl_lib/Mechanical/Translational<newline>Elements/Mechanical<newline>Translational<newline>Reference`
- Ideal Force Source: `fl_lib/Mechanical/Mechanical Sources/Ideal Force Source`
- Ideal Translational Motion Sensor: `fl_lib/Mechanical/Mechanical Sensors/Ideal Translational<newline>Motion Sensor`
- **주의**: `<newline>`은 MATLAB `newline` 함수 값 (char(10))이며, 문자열 리터럴 `\n`이 아님
- `simscape/` 가 아니라 `fl_lib/`과 `nesl_utility/`가 실제 라이브러리 경로

### 2026-04-10: Simscape Ideal Force Source 포트 매핑 (중요!)
- **LConn(1)** = C (mechanical translational conserving port — case/body)
- **RConn(1)** = S (physical signal input — force magnitude)
- **RConn(2)** = R (mechanical translational conserving port — rod/reference)
- 포트 이름(S/C/R)과 LConn/RConn 인덱스가 직관과 다름!
- S2P converter는 RConn(1) (S port)에 연결해야 함

### 2026-04-10: Simscape Ideal Translational Motion Sensor 포트 매핑
- **LConn(1)** = C (mechanical conserving port — 측정 지점)
- **RConn(1)** = R (mechanical conserving port — 기준점, Ground에 연결)
- **RConn(2)** = 속도 또는 위치 출력 (physical signal → P2S에 연결)
- **RConn(3)** = 나머지 출력
- RConn(2)가 velocity일 가능성 높음 (정상상태에서 0 수렴 관찰)

### 2026-04-10: Simscape 모델 필수 요소
1. `Solver Configuration` 블록 필수 — 물리 네트워크에 연결
2. `Mechanical Translational Reference` (Ground) 필수 — 기준점
3. Simulink↔Simscape 변환: `Simulink-PS Converter`, `PS-Simulink Converter`
4. 모든 conserving port network에 최소 1개 reference 필요

### 2026-04-10: Simscape 포트 연결 디버깅 팁
- `add_line`이 "물리 모델링 영역 연결 규칙" 에러 시: 포트 도메인 불일치
- 블록별 어떤 포트가 어떤 도메인인지 반드시 탐색 후 연결
- 탐색 방법: 단일 블록 쌍으로 최소 테스트 모델 만들어서 각 포트 조합 시도
- conserving port(mechanical)끼리, physical signal port끼리만 연결 가능

### 2026-04-10: Simscape Electrical 블록 포트 매핑
- **Resistor/Capacitor/Inductor**: LConn(1)=left, RConn(1)=right (2-port 소자)
- **DC Voltage Source**: LConn(1)=+(top), RConn(1)=-(bottom)
- **Electrical Reference** (Ground): LConn(1) only
- **Voltage Sensor**: LConn(1)=+(측정 양극), RConn(1)=physical signal output, RConn(2)=-(측정 음극)
- Solver Configuration과 Electrical Reference를 같은 노드에 연결 필수

### 2026-04-10: Simscape Rotational 블록
- Inertia: `fl_lib/Mechanical/Rotational Elements/Inertia` (파라미터: `"inertia"`)
- Rotational Damper: `fl_lib/Mechanical/Rotational Elements/Rotational Damper` (파라미터: `"D"`)
- Rotational Spring: `fl_lib/Mechanical/Rotational Elements/Rotational Spring` (파라미터: `"spr_rate"`)
- Mechanical Rotational Reference: `fl_lib/Mechanical/Rotational Elements/Mechanical<NL>Rotational Reference`
- Ideal Torque Source: `fl_lib/Mechanical/Mechanical Sources/Ideal Torque Source`
  - 포트 매핑 = Force Source와 동일: LConn(1)=C, RConn(1)=S, RConn(2)=R
- Ideal Rotational Motion Sensor: `fl_lib/Mechanical/Mechanical Sensors/Ideal Rotational<NL>Motion Sensor`
  - LConn(1)=C(측정지점), RConn(1)=R(기준), RConn(2)=velocity출력, RConn(3)=position출력

### 2026-04-10: Simscape Sensor RConn 매핑 결론
- Translational Motion Sensor: RConn(1)=R(ref), RConn(2)=velocity, RConn(3)=?
- Rotational Motion Sensor: RConn(1)=R(ref), RConn(2)=velocity, RConn(3)=position
- 패턴: RConn(1)은 항상 기준점(Reference), 나머지는 물리 신호 출력

### 2026-04-10: FMCW 레이더 시뮬레이션 패턴
- **Chirp Signal 블록**: `simulink/Sources/Chirp Signal`, 파라미터 `f1`, `f2`, `T`
- **Transport Delay**: `simulink/Continuous/Transport Delay`, 타겟 반사 지연 시뮬레이션
- **Product 블록**: Mixer 역할 (TX × RX → beat signal)
- **Transfer Fcn으로 LPF**: 2차 Butterworth `wc^2 / [1, sqrt(2)*wc, wc^2]`
- **솔버**: continuous 블록(Transport Delay, Transfer Fcn) 포함 시 `ode4` 사용 (FixedStepDiscrete 불가)
- **1D FFT**: beat signal에 Hann window 적용 후 FFT → 피크 = 타겟 거리
- **FMCW 공식**: f_beat = 2*R*B/(c*Tsweep), R = f_beat*c*Tsweep/(2*B)
- **스케일링**: 실제 레이더 주파수(GHz)는 시뮬 불가 → 저주파로 스케일 후 range axis 매핑
- **LPF transient**: 초기 10~15% 데이터 버리고 FFT 수행

### 2026-04-11: HDL Coder 기본 워크플로우
- `hdlsetup(modelName)` — HDL 호환 모델 설정 자동 적용 (솔버, 데이터타입 등)
- `makehdl([model '/DUT'], 'TargetDirectory', dir, 'TargetLanguage', 'Verilog')` — HDL 코드 생성
- `makehdltb(...)` — HDL 테스트벤치 생성
- `checkhdl(...)` — HDL 호환성 검사
- DUT subsystem 패턴: HDL 대상은 반드시 서브시스템으로 분리
- 외부 블록(Scope, To Workspace)은 HDL 생성 대상에서 자동 제외

### 2026-04-11: HDL 호환 블록 규칙
- **필수**: Fixed-step 솔버, FixedStepDiscrete
- **HDL 호환 블록**: Sum, Product, Gain, Unit Delay, Delay, Constant, Switch, Compare To Constant, 1-D Lookup Table
- **비호환**: Scope, To Workspace, Transport Delay, Transfer Fcn, Chirp Signal
- **데이터 타입**: fixed-point 필수 (`fixdt(1,16,14)`, `uint8`, `uint16` 등)
- **1-D Lookup Table**: ROM으로 합성, `InterpMethod`="Flat" 필수
- **Delay 블록**: `DelayLength` 파라미터로 다중 클럭 지연, shift register로 합성

### 2026-04-11: HDL용 FMCW 레이더 설계 패턴
- Continuous chirp → ROM (1-D LUT) + 카운터 주소 생성기
- Transport Delay → Delay 블록 (정수 샘플 지연)
- 카운터 mod N: Sum + Unit Delay + Compare To Constant + Switch 조합
- 생성 Verilog: `module DUT(clk, reset, clk_enable, ce_out, Out1)` 인터페이스

### 2026-04-11: hdlsetup 주요 변경 사항
- Solver → FixedStepDiscrete, ProdHWDeviceType → ASIC/FPGA
- DefaultParameterBehavior → Inlined, BlockReduction → off

### 2026-04-11: HDL 최적화 기법
- **Pipelining**: `hdlset_param(block, 'OutputPipeline', N)` → N 클럭 레이턴시 추가, 최대 클럭 주파수 향상
  - 자동 delay balancing: HDL Coder가 다른 경로에 matching delay 삽입
- **Distributed Pipelining**: `hdlset_param(block, 'DistributedPipelining', 'on')` → 자동 레지스터 분배
- **Resource Sharing**: `hdlset_param(block, 'SharingFactor', N)` → N개 연산을 시분할 공유, 면적 절약
- **Flatten Hierarchy**: `hdlset_param(block, 'FlattenHierarchy', 'on')` → 서브시스템 경계 제거, 더 넓은 최적화 범위
- **CSD (Canonical Signed Digit)**: 상수 곱셈을 shift+add로 대체, 곱셈기 제거

### 2026-04-11: FIR 필터 HDL 생성 비교
| 변형 | DUT.v | FIR.v | 레이턴시 | 특징 |
|------|-------|-------|---------|------|
| Baseline | 1.9KB | 4.3KB | 0 cyc | 기본, 최적화 없음 |
| Pipelined (OutputPipeline=3) | 3.2KB | 4.3KB | +3 cyc | 레지스터 삽입, 클럭↑ |
| Shared (SharingFactor=4) | 1.9KB | 4.3KB | 0 cyc | 연산 시분할 공유, 면적↓ |

### 2026-04-11: makehdltb 테스트벤치 워크플로우
- `makehdltb([model '/DUT'], 'TargetDirectory', dir, 'TargetLanguage', 'Verilog')`
- 생성 파일: `DUT_tb.v` (테스트벤치 모듈) + `In1.dat` (입력 자극) + `Out1_expected.dat` (기대 출력)
- 자동으로 Simulink 시뮬레이션을 실행하여 golden reference 데이터 생성
- HDL 시뮬레이터(ModelSim/Questa/Vivado)에서 직접 실행 가능

### 2026-04-11: hdlset_param vs set_param
- `set_param`: Simulink 블록 파라미터 설정 (범용)
- `hdlset_param`: HDL Coder 전용 파라미터 설정 (파이프라이닝, 쉐어링 등)
- `hdlget_param`: HDL 파라미터 조회
- `hdlrestoreparams`: HDL 파라미터 초기화

### 2026-04-11: hdlcoder.WorkflowConfig (고급)
- Vivado/Quartus 통합 자동화: 프로젝트 생성 → 합성 → 구현 → 타이밍 분석
- `hWC.Objective`: `hdlcoder.Objective.SpeedOptimized` / `AreaOptimized` / `None`
- `hWC.RunTaskRunSynthesis = true` → FPGA 합성 자동 실행
- `hWC.CriticalPathSource = 'post-route'` → 실제 라우팅 후 타이밍 분석

### 2026-04-11: Fixed-Point 최적화 (fxpopt)
- `options = fxpOptimizationOptions()` → 최적화 옵션 생성
- `options.AllowableWordLengths = 17:22` → 허용 워드 길이 범위
- `addTolerance(options, block, port, 'AbsTol', 1e-4)` → 허용 오차
- `result = fxpopt(model, sudPath, options)` → 자동 fixed-point 최적화
- Multi-scenario: `options.AdvancedOptions.SimulationScenarios = si` → 다양한 입력에서 검증

### 2026-04-11: Discrete FIR Filter 블록 HDL 파라미터
- 경로: `simulink/Discrete/Discrete FIR Filter`
- `Coefficients`: 필터 계수 벡터
- `CoefDataTypeStr`: 계수 데이터 타입 (예: `fixdt(1,16,14)`)
- `ProductDataTypeStr`: 곱셈 결과 타입 (비트 성장 고려, 예: `fixdt(1,32,28)`)
- `AccumDataTypeStr`: 누적기 타입
- `OutDataTypeStr`: 출력 타입 (truncation/saturation 적용)
- HDL Coder에서 자동으로 multiply-accumulate 구조로 합성

### 2026-04-11: Stateflow → HDL
- `sflib/Chart` 블록으로 FSM 생성, HDL Coder가 RTL로 변환
- Stateflow API: `sfroot` → `find('-isa', 'Stateflow.Chart')` 로 Chart 객체 접근
- `Stateflow.State(chart)`, `Stateflow.Transition(chart)`, `Stateflow.Data(chart)` 로 프로그래밍
- `chart.ActionLanguage = 'MATLAB'` → HDL 호환 MATLAB 구문 사용
- Data scope: `'Input'`, `'Output'`, `'Local'` + 명시적 DataType 지정 필수

### 2026-04-11: MATLAB Function 블록 → HDL
- `persistent` 변수 → HDL 레지스터로 변환
- `fi(value, signed, wordLen, fracLen)` → fixed-point 연산
- `bitsra(x, n)` → 산술 우시프트 (÷2^n), 곱셈기 없이 나눗셈
- `isempty(persistent_var)` → 리셋 로직으로 변환
- EML 블록 코드 설정: `sfroot` → `find('-isa', 'Stateflow.EMChart')` → `.Script` 속성

### 2026-04-11: Zynq IP Core Generation 워크플로우 (핵심!)
- **필수 조건**: DUT subsystem에 `TreatAsAtomicUnit = 'on'` 설정
- **워크플로우 API**:
  ```
  hWC = hdlcoder.WorkflowConfig('SynthesisTool','Xilinx Vivado','TargetWorkflow','IP Core Generation')
  hWC.RunTaskGenerateRTLCodeAndIPCore = true
  hWC.RunTaskCreateProject = false  % Vivado 프로젝트 (선택)
  hWC.RunTaskBuildFPGABitstream = false  % 비트스트림 (선택)
  hdlcoder.runWorkflow([model '/DUT'], hWC)
  ```
- **자동 생성물**: VHDL IP Core + AXI4-Lite wrapper + Device Tree (.dtsi) + SW Interface Model + Host Script

### 2026-04-11: Zynq 포트 인터페이스 매핑
- **AXI4-Lite** (PS↔PL 레지스터 제어):
  ```
  hdlset_param([dut '/PortName'], 'IOInterface', 'AXI4-Lite')
  hdlset_param([dut '/PortName'], 'IOInterfaceMapping', 'x"100"')
  ```
- **GPIO** (외부 핀):
  ```
  hdlset_param([dut '/LED'], 'IOInterface', 'LEDs General Purpose [0:7]')
  hdlset_param([dut '/LED'], 'IOInterfaceMapping', '[0]')
  ```
- **AXI4-Stream** (고속 데이터 스트리밍):
  ```
  hdlset_param([dut '/DataIn'], 'IOInterface', 'AXI4-Stream Slave')
  hdlset_param([dut '/DataOut'], 'IOInterface', 'AXI4-Stream Master')
  ```

### 2026-04-11: Zynq 타겟 디바이스 설정
- `hdlset_param(model, 'TargetPlatform', 'ZedBoard')` — 보드 선택
- `hdlset_param(model, 'Workflow', 'IP Core Generation')` — 워크플로우 모드
- `hdlset_param(model, 'SynthesisToolChipFamily', 'Zynq')` — Zynq 패밀리
- `hdlset_param(model, 'SynthesisToolDeviceName', 'xc7z020')` — 디바이스
- `hdlset_param(model, 'TargetFrequency', 50)` — 50 MHz 타겟 클럭

### 2026-04-11: ZedBoard AXI 인터페이스 제약 (중요!)
- ZedBoard Default Reference Design에서 **AXI4-Stream은 지원하지 않음**
- 유효한 인터페이스: `AXI4-Lite`, `AXI4`, `External Port`, `LEDs General Purpose [0:7]`, `Push Buttons`, `Pmod Connector JA1~JD1`
- AXI4-Stream 사용 시 Custom Reference Design 필요 (트레이닝 Ch5 참고)
- **AXI4 (memory-mapped)**: 데이터 전송용, 자동으로 FIFO + Dual Port RAM 생성
- **AXI4-Lite**: 레지스터 제어용 (파라미터 튜닝)

### 2026-04-11: AXI4 vs AXI4-Lite vs AXI4-Stream
| 인터페이스 | 용도 | 대역폭 | 자동 생성 |
|-----------|------|--------|----------|
| AXI4-Lite | 레지스터 R/W (파라미터) | 낮음 | addr_decoder + axi_lite_module |
| AXI4 | 메모리 매핑 데이터 | 중간 | FIFO + DualPort RAM + axi4_module |
| AXI4-Stream | 스트리밍 데이터 | 높음 | Custom RD 필요 |

### 2026-04-11: SoC Blockset 핵심 블록 경로
| 블록 | 라이브러리 경로 | 용도 |
|------|---------------|------|
| Stream FIFO | `hwlogicconnlib/Stream FIFO` | PL 도메인 FIFO 버퍼 |
| Memory Channel | `socmemlib/Memory Channel` | PL↔PS DMA (HW 보드 설정 필수) |
| Register Channel | `socmemlib/Register Channel` | AXI4-Lite 레지스터 |
| Memory Controller | `socmemlib/Memory Controller` | DDR4 컨트롤러 |
| Stream Read | `prociolib/Stream Read` | PS에서 DMA 읽기 |
| Stream Write | `prociolib/Stream Write` | PS에서 DMA 쓰기 |
| Task Manager | `proctasklib/Task Manager` | PS 태스크 스케줄링 |
| UDP Read/Write | `prociolib/UDP Read`, `prociolib/UDP Write` | 호스트 통신 |
| AXI4 Master Source/Sink | `hwlogictestlib/AXI4 Master Source/Sink` | 테스트벤치 |
| Stream Data Source/Sink | `hwlogictestlib/Stream Data Source/Sink` | 테스트벤치 |

### 2026-04-11: SoC 3-File 모델 구조
- **soc_*_fpga.slx** — PL (FPGA): DUT + Stream FIFO + Memory Channel, `HardwareBoard` 설정 + `ProcessingUnit=FPGA`
- **soc_*_proc.slx** — PS (ARM): Task Manager + Stream Read/Write + UDP + 알고리즘
- **soc_*_top.slx** — 통합: RFDC 설정 + Memory Controller + FPGA↔Processor 연결
- **필수 조건**: `HardwareBoard` 반드시 설정 (Memory Channel이 InitFcn에서 보드 확인)
- **권장**: `socModelCreator` GUI로 기본 3-file 생성 후 DUT만 교체

### 2026-04-11: soc.RFDataConverter API 핵심
```
rfobj = soc.RFDataConverter('ZU28DR', IPAddr)
rfobj.FPGASamplesPerClock = 2
rfobj.configureADCTile(TileId, PLLSrc, RefClk, SampRate)
rfobj.configureADCChannel(TileId, ChId, DecimFactor)
rfobj.configureADCMixer(TileId, ChId, 'Fine', LO_MHz, EventMode, Phase, Scale)
rfobj.configureDACTile/Channel/Mixer (동일 패턴)
rfobj.applyConfiguration()
rfobj.applyNyquistZone()
rfobj.configureADCTileClock(0, DecimFactor)
```

### 2026-04-11: RFSoC vs 일반 Zynq 핵심 차이
| 특성 | Zynq-7000 | RFSoC (ZU28DR) |
|------|-----------|----------------|
| ADC/DAC | 외부 | 내장 (8ch, 최대 4 GSPS) |
| DDC/DUC | SW | HW (NCO + 데시메이션) |
| Nyquist Zone | 1만 | 1/2/3 (서브샘플링) |
| SPC | N/A | 1/2/4/8 (FPGA 클럭 = ADC/(Decim×SPC)) |
| MTS | N/A | 다중 타일 동기화 (Sysref) |

### 2026-04-11: Memory Channel 핵심 파라미터
- `ChannelType`: `'AXI4-Stream FIFO'` (기본값, DMA 전송)
- `ChDimensionsWriterChIf`: 프레임당 샘플 수 (예: `1024`)
- `ChTypeWriterChIf`: 데이터 타입 (예: `'uint32'`, `'uint64'`)
- `ChFrameSampleTimeWriterChIf`: 프레임 샘플 타임
- `MRBufferSize`: 메모리 영역 버퍼 크기 (바이트)
- `MRNumBuffers`: 순환 버퍼 수 (예: `8` 또는 `16`)
- `ProtocolWriter/Reader`: `'AXI4-Stream'` (기본)
- `BurstLengthWriterChIf`: DMA 버스트 길이 (예: `256`)
- `FIFODepthWriter/Reader`: 내부 FIFO 깊이 (예: `8`)
- **DMA 프레임 계산**: FrameLength = RangeBins × DopplerBins / SamplesPerClock

### 2026-04-11: Register Channel 설정
- `RegTableNames`: 레지스터 이름 셀 배열 (예: `{'gain', 'enable', 'delay'}`)
- `RegTableRW`: 각 레지스터 읽기/쓰기 방향 (`'Read'` 또는 `'Write'`)
- `RegTableDataTypes`: 데이터 타입 (예: `{'uint32', 'int16', 'boolean'}`)
- `RegTableVectorSizes`: 벡터 크기 (예: `{'1', '4', '1'}`)
- `NumRegisters`: 총 레지스터 수
- `RegTableInitialValues`: 초기값

### 2026-04-11: Stream FIFO 설정
- `FIFO_DEPTH`: FIFO 깊이 (2의 거듭제곱, 예: `16`)
- `AFULL_THRESH`: Almost Full 임계값 (백프레셔용, 예: `8`)

### 2026-04-11: PDR SoC 데이터 경로 (전체 파이프라인)
```
RF(30GHz) → RFDC ADC(2GHz,12b) → DDC÷8(250MHz) → ADC Demuxer
  → [Loopback: Target Emulator]
  → Range-Doppler Processor (Matched Filter → Range FFT → CPI → Vel FFT)
  → AXI4-Stream (1024×64 complex) → S2MM DMA → DDR (16×256KB 버퍼)
  → PS reads → UDP(port 25000) → Host MATLAB (CFAR, display)
```

### 2026-04-11: PDR SoC AXI 주소 맵
| IP Core | Base Address | 인터페이스 | 내용 |
|---------|-------------|-----------|------|
| Target Emulator | 0xA0000000 | AXI4-Lite | Doppler_Inc, Range_Delay, Gain, Enable (4채널) |
| Range-Doppler TxRx | 0xA0010000 | AXI4-Lite | Tx_Gain, CPI_Start, CPI_Length, Rx_Delay_Cycles |
| Range-Doppler TxRx | AXI4-Stream | S2MM DMA | 32768 × uint64 per CPI frame |

### 2026-04-11: SoC 모델 클럭/타이밍 계산
- FPGA 클럭 = ADCSamplingRate / DecimFactor / SPC = 2000/8/2 = **125 MHz**
- DMA 프레임 = RngBins × VelBins / SPC = 1024×64/2 = **32,768 words**
- DMA 프레임 크기 = 32768 × 8B = **256 KB**
- CPI 시간 = CPILength × pulsePeriod = 64 × 7.808μs = **500 μs**

### 2026-04-11: RF Data Converter Simulink 블록 (428 파라미터, 핵심만)
- **위치**: Top 모델에 배치 (PL→RFDC→RF 경로)
- **시뮬레이션 모드**: `RFDCSim` = `'Pass-through'` (시뮬에서는 바이패스)
- **채널 Enable**: `adc11Enable`~`adc44Enable`, `dac11Enable`~`dac44Enable` (개별 on/off)
- **타일별 샘플레이트**: `adcTile1SampleRate`~`adcTile4SampleRate` (MHz)
- **채널별 데시메이션**: `adc11DecimationMode` = `2`/`4`/`8` 등
- **채널별 SPC**: `adc11SamplesPerCycle` = `2`/`4`/`8`
- **믹서 설정**: `adc11MixerType` = `'Bypassed'`/`'Fine'`/`'Coarse'`
  - `adc11MixerMode` = `'Real->Real'` / `'Real->IQ'` / `'IQ->IQ'`
  - `adc11NCOFrequency` = NCO 주파수 (MHz)
  - `adc11NCOPhase` = NCO 위상 (도)
- **글로벌 파라미터 매칭**: `matchADCParam`=`'on'` → 모든 ADC 채널 동일 설정
- **MTS**: `multiTileSync` = `'on'`/`'off'`
- **Threshold**: `adc11ThresholdMode`, `adc11Threshold1` (ADC 과부하 감지)
- **실시간 NCO 포트**: `adcRealTimeNCOPortsEnable` = `'on'` → 런타임 NCO 주파수 변경

### 2026-04-11: AXI4 Random Access Memory 블록
- **용도**: DDR4 메모리 모델링 (PL에서 직접 읽기/쓰기)
- `MemorySelection`: `'PL memory'` (DDR4 on PL side)
- `MemorySimulation`: `'Burst accurate'` (버스트 단위 시뮬레이션)
- `ChannelType`: `'AXI4 Random Access'`
- `MRBufferSize`: 메모리 영역 크기 (바이트)
- `DiagnosticLevel`: `'Basic diagnostic signals'`

### 2026-04-11: SoC Blockset 예제 모델 44개 — 핵심 카테고리
| 카테고리 | 예제 | 핵심 패턴 |
|---------|------|----------|
| HW↔SW Stream | `soc_hwsw_stream_*` | 기본 3-file, Memory Channel, Stream Read/Write |
| DDR4 Capture | `soc_ddr4datacapture_*` | **ZCU111**, RF Data Converter, AXI4 RAM |
| RF Capture | `soc_rfcapture*` | AD9361 RF front-end + DMA |
| RF Playback | `soc_rf_playback*` | DAC 출력, Task Manager |
| Motor Control | `soc_motor_*` | 3-file, PWM, ADC |
| Video | `soc_video_flipping_*` | Video Stream FIFO |
| Task Execution | `soc_task_execution*` | Task Manager 스케줄링 패턴 |
| Interrupt | `soc_hwsw_interrupt_*` | HW→SW 인터럽트, Interrupt Channel |
| ADS-B | `soc_ADSB_*` | 실시간 신호 처리 + UDP |

### 2026-04-11: socBuilder / socModelBuilder API
- `socBuilder('modelname')` — SoC Builder GUI 실행 (빌드/로드/실행)
- `socModelBuilder` — 프로그래밍 방식 SoC 빌드
- `socModelCreator` — Reference Design 기반 3-file 모델 자동 생성 (GUI)

### 2026-04-11: ZCU111 SoC Template 생성 패턴
- **예제 기반**: `soc_ddr4datacapture_top.slx` 복사 → 커스터마이즈 (가장 빠른 방법)
- **직접 구축**: FPGA 모델부터 프로그래밍으로 생성 (학습용)
- **Init 콜백 구조**:
  - `PreLoadFcn`: base workspace 변수 설정 (`FrameSize`, `NumBuffers`)
  - `PostLoadFcn`: RFDC 의존 초기화 (`soc_rfsoc_datacapture_init`)
  - `InitFcn`: 모델별 파라미터 계산 (`SampleTime`, `TaskDuration`)
- **SampleTime 계산**: `SampleTime = 1 / (dacSampleRate / dacSamplesPerCycle / dacInterpolationMode)`
- **NCO Phase Increment**: `phaseIncr = freq * 2^16 / Fs_fpga` (16-bit accumulator)
- **Sine ROM**: `round(32767 * sin(2*pi*(0:N-1)/N))` → 1-D LUT, `InterpMethod="Flat"`
- **Wrap-on-overflow 경고**: Phase Accumulator의 `SaturateOnIntegerOverflow="off"` 정상 (의도적 wrap)

### 2026-04-11: ZCU111 Vivado Reference Design 구조
- **4종 RD**: `plugin_rd_real`, `plugin_rd_IQ`, `plugin_rd_DL_real`, `plugin_rd_DL_IQ`
- **FPGA Part**: `xczu28dr-ffvg1517-2-e`, Vivado 2024.1
- **RFDC IP**: `usp_rf_data_converter:2.6`, ADC DUAL(4tile×2ch), DAC QUAD(2tile×4ch)
- **DMA IP**: ADI `axi_dmac:1.0`, 1024-bit source, 8-deep FIFO, 2048B/burst
- **DDR4**: PL DDR4 512-bit @300MHz, Pin: J19/J18 DIFF_SSTL12
- **PS**: `zynq_ultra_ps_e:3.5`, DDR 0x80000000~0xFFFFFFFF
- **Clock**: DUT 128MHz, DDR 300MHz, PLL Ref 245.76MHz
- **AXI Interconnect**: reg(32b), hp0(128b), pl_mem(512b), jtag(32b)
- **RD 위치**: `C:\ProgramData\MATLAB\SupportPackages\R2025b\toolbox\soc\supportpackages\xilinxsoc\referencedesign\boards\zcu111\`

### 2026-04-11: PDR vs DDR4 Template 차이 (FMCW 변환 핵심)
| 구성요소 | DDR4 Capture | PDR |
|---------|-------------|-----|
| FPGA DUT | Auto-trigger → DDR4 캡처 | Target Emulator + Matched Filter + TxRx |
| DAC | NCO Tone Gen ×4 | LUT 기반 TX 신호 생성 |
| Processor | Extract+Reshape (단순) | Doppler FFT + 2D CFAR + DBSCAN |
| AXI Regs | 없음 | 8개 (TargetEmu 4 + TxRx 4) |
| 타이밍 | 연속 스트리밍 | 펄스 기반 (32samp pulse, 7.8µs period) |
| DMA Frame | FrameSize raw samples | RngBins×VelBins/SPC = 32768 |

### 2026-04-11: FMCW 변환 시 PDR에서 변경할 핵심 포인트
1. **TX**: 32-sample pulse → 1024-sample continuous chirp (ROM 교체)
2. **Range Processing**: Matched Filter → De-chirp(×conj) + Windowing + FFT
3. **System Controller**: Pulse-gated FSM → Continuous chirp timing
4. **Rx Delay**: 펄스 기반 RxDelayCycles → 불필요 (full-duplex)
5. **Doppler FFT**: 64-pt → 256-pt (더 긴 CPI)
6. **Target Emulator**: Pulse echo → Beat-frequency Doppler sim
7. **RFDC**: 2GHz→3.2GHz, NCO -500→-1000MHz
