function results = run_and_capture(scriptPath)
%RUN_AND_CAPTURE Execute a Simulink script and capture all output
%   results = run_and_capture(scriptPath)
%   Returns struct with: success, output, errors, elapsed_time

    arguments
        scriptPath (1,1) string
    end

    results = struct();
    results.success = false;
    results.output = "";
    results.errors = "";
    results.elapsed_time = 0;

    diaryFile = tempname + ".txt";

    tic;
    try
        diary(diaryFile);
        run(scriptPath);
        diary("off");

        results.output = string(fileread(diaryFile));
        results.success = true;
        delete(diaryFile);
    catch ME
        diary("off");

        errMsg = sprintf("Error: %s\nIdentifier: %s\nStack:\n", ...
            ME.message, ME.identifier);
        for k = 1:length(ME.stack)
            errMsg = errMsg + sprintf("  File: %s, Line: %d, Function: %s\n", ...
                ME.stack(k).file, ME.stack(k).line, ME.stack(k).name);
        end
        results.errors = string(errMsg);

        if isfile(diaryFile)
            results.output = string(fileread(diaryFile));
            delete(diaryFile);
        end
    end
    results.elapsed_time = toc;

    % Structured output for Claude to parse
    fprintf("\n=== SIMULATION RESULT ===\n");
    fprintf("SUCCESS: %d\n", results.success);
    fprintf("ELAPSED: %.3f seconds\n", results.elapsed_time);
    if results.success
        fprintf("OUTPUT:\n%s\n", results.output);
    else
        fprintf("ERRORS:\n%s\n", results.errors);
    end
    fprintf("=== END RESULT ===\n");
end
