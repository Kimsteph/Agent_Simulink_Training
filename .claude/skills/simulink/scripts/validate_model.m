function report = validate_model(modelName)
%VALIDATE_MODEL Check a Simulink model for common issues
%   report = validate_model(modelName)
%   Returns struct with: valid, warnings, info

    arguments
        modelName (1,1) string
    end

    report = struct();
    report.valid = true;
    report.warnings = {};
    report.info = struct();

    try
        load_system(modelName);

        % Get all blocks
        blocks = find_system(modelName, "Type", "Block");
        report.info.block_count = length(blocks);
        report.info.blocks = blocks;

        % Get all lines
        lines = find_system(modelName, "FindAll", "on", "Type", "Line");
        report.info.line_count = length(lines);

        % Check for unconnected ports
        for i = 1:length(blocks)
            ph = get_param(blocks{i}, "PortHandles");
            for j = 1:length(ph.Inport)
                lineHandle = get_param(ph.Inport(j), "Line");
                if lineHandle == -1
                    report.warnings{end+1} = sprintf( ...
                        "Unconnected input: %s port %d", blocks{i}, j);
                    report.valid = false;
                end
            end
        end

        % Print report
        fprintf("\n=== MODEL VALIDATION ===\n");
        fprintf("Model: %s\n", modelName);
        fprintf("Blocks: %d\n", report.info.block_count);
        fprintf("Lines: %d\n", report.info.line_count);
        fprintf("Valid: %d\n", report.valid);
        if ~isempty(report.warnings)
            fprintf("Warnings:\n");
            for i = 1:length(report.warnings)
                fprintf("  - %s\n", report.warnings{i});
            end
        end
        fprintf("=== END VALIDATION ===\n");

    catch ME
        report.valid = false;
        report.warnings{end+1} = sprintf("Validation error: %s", ME.message);
        fprintf("VALIDATION ERROR: %s\n", ME.message);
    end
end
