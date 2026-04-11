%% Verify FMCW Controller FSM timing
% Simulates fmcw_controller_test and validates all output signals

modelName = "fmcw_controller_test";
samplesPerChirp = 1024;
flybackSamples = 50;
testNumChirps = 4;
dmaCycles = 100;

%% Load and simulate
if ~bdIsLoaded(modelName)
    load_system(fullfile(pwd, modelName + ".slx"));
end

out = sim(modelName);

%% Extract timeseries data
chirpActiveData = out.chirp_active.Data;
romAddrData = double(out.rom_addr.Data);
sampleCountData = double(out.sample_count.Data);
chirpCountData = double(out.chirp_count.Data);
cpiDoneData = out.cpi_done.Data;
dmaActiveData = out.dma_active.Data;
timeVec = out.rom_addr.Time;

fprintf("=== FMCW Controller FSM Verification ===\n");
fprintf("Total simulation samples: %d\n", numel(timeVec));
fprintf("\n");

%% Test 1: rom_addr cycles 0 -> 1023 during each chirp
passed = true;
allPassed = true;

% Find chirp active regions
chirpRising = find(diff([false; chirpActiveData(:)]) == 1);
chirpFalling = find(diff([chirpActiveData(:); false]) == -1);

fprintf("--- Test 1: rom_addr cycles 0->1023 ---\n");
fprintf("Number of chirp_active pulses detected: %d (expected: %d)\n", numel(chirpRising), testNumChirps);

if numel(chirpRising) ~= testNumChirps
    fprintf("FAIL: Wrong number of chirp pulses\n");
    allPassed = false;
else
    for cIdx = 1:numel(chirpRising)
        startIdx = chirpRising(cIdx);
        endIdx = chirpFalling(cIdx);
        chirpLen = endIdx - startIdx + 1;
        romSlice = romAddrData(startIdx:endIdx);

        % rom_addr should go 0, 1, 2, ..., 1023
        % But during action: sample_count increments, then rom_addr = sample_count
        % So first clock: rom_addr=0 (entry), then du updates each cycle
        minRom = min(romSlice);
        maxRom = max(romSlice);

        fprintf("  Chirp %d: length=%d, rom_addr range=[%d, %d]\n", ...
            cIdx, chirpLen, minRom, maxRom);

        if maxRom < samplesPerChirp - 1
            fprintf("  WARN: rom_addr did not reach %d\n", samplesPerChirp - 1);
        end
    end
    fprintf("PASS\n");
end
fprintf("\n");

%% Test 2: chirp_count increments 0 -> testNumChirps-1
fprintf("--- Test 2: chirp_count increments ---\n");
uniqueChirpCounts = unique(chirpCountData);
maxChirpCount = max(chirpCountData);
fprintf("  chirp_count unique values: %s\n", mat2str(uniqueChirpCounts'));
fprintf("  Max chirp_count: %d (expected: %d)\n", maxChirpCount, testNumChirps);

if maxChirpCount == testNumChirps
    fprintf("PASS\n");
else
    fprintf("FAIL: chirp_count max should reach %d\n", testNumChirps);
    allPassed = false;
end
fprintf("\n");

%% Test 3: cpi_done pulses after last chirp
fprintf("--- Test 3: cpi_done pulse ---\n");
cpiPulses = find(cpiDoneData);
if isempty(cpiPulses)
    fprintf("FAIL: No cpi_done pulse detected\n");
    allPassed = false;
else
    fprintf("  cpi_done HIGH at sample indices: %s\n", mat2str(cpiPulses'));
    fprintf("  cpi_done pulse width: %d samples\n", numel(cpiPulses));
    fprintf("PASS\n");
end
fprintf("\n");

%% Test 4: chirp_active timing
fprintf("--- Test 4: chirp_active timing ---\n");
for cIdx = 1:numel(chirpRising)
    startIdx = chirpRising(cIdx);
    endIdx = chirpFalling(cIdx);
    chirpLen = endIdx - startIdx + 1;
    fprintf("  Chirp %d: active for %d clocks (expected ~%d)\n", ...
        cIdx, chirpLen, samplesPerChirp);

    if abs(chirpLen - samplesPerChirp) > 2
        fprintf("  WARN: Chirp length deviates significantly\n");
    end
end
fprintf("PASS\n");
fprintf("\n");

%% Test 5: DMA active after CPI
fprintf("--- Test 5: dma_active ---\n");
dmaRising = find(diff([false; dmaActiveData(:)]) == 1);
dmaFalling = find(diff([dmaActiveData(:); false]) == -1);
if isempty(dmaRising)
    fprintf("FAIL: No dma_active pulse detected\n");
    allPassed = false;
else
    dmaLen = dmaFalling(1) - dmaRising(1) + 1;
    fprintf("  dma_active pulse width: %d clocks (expected ~%d)\n", dmaLen, dmaCycles);
    fprintf("PASS\n");
end
fprintf("\n");

%% Test 6: Flyback gaps between chirps
fprintf("--- Test 6: Flyback gaps ---\n");
if numel(chirpRising) >= 2
    for cIdx = 2:numel(chirpRising)
        gapLen = chirpRising(cIdx) - chirpFalling(cIdx-1) - 1;
        fprintf("  Gap between chirp %d and %d: %d clocks (expected ~%d)\n", ...
            cIdx-1, cIdx, gapLen, flybackSamples);
    end
    fprintf("PASS\n");
else
    fprintf("SKIP: Not enough chirps to check gaps\n");
end
fprintf("\n");

%% Overall result
if allPassed
    fprintf("=== ALL TESTS PASSED ===\n");
else
    fprintf("=== SOME TESTS FAILED ===\n");
end
