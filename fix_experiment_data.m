function fix_experiment_data(experiment_id)
% usage: fix_experiment_data("0286000004301642")
% experiment id must be given as a string (double quotes)

if ~isstring(experiment_id)
    error('experiment_id must be provided as a string (use double quotes)')
end

pez_directory= '/Volumes/card-locker/hhmiData/dm11/cardlab/Data_pez3000_analyzed';
datapath = fullfile(pez_directory, experiment_id);

load(fullfile(datapath,strcat(experiment_id, '_rawDataAssessment.mat')));
load(fullfile(datapath,strcat(experiment_id, '_automatedAnnotations.mat')));
load(fullfile(datapath,strcat(experiment_id, '_manualAnnotations.mat')));
load(fullfile(datapath,strcat(experiment_id, '_videoStatisticsMerged.mat')));

% check if table dimensions are compatible
table_lengths = [size(assessTable,1), size(automatedAnnotations,1), size(manualAnnotations,1), size(videoStatisticsMerged,1)];
if range(table_lengths) ~= 0
    error('Table dimensions are not compatible')
end

% find empty visStim rows
idx = find(cellfun(@isempty,automatedAnnotations.visStimProtocol));
if isempty(idx)
    fprintf('No empty rows found\n')
    return
else
    fprintf('Found %i missing rows\n',length(idx))
    for i = 1:length(idx)
        row_name = automatedAnnotations.Properties.RowNames{idx(i)};
        assessTable(row_name,:) = [];
        manualAnnotations(row_name,:) = [];
        videoStatisticsMerged(row_name,:) = [];
    end
    automatedAnnotations(idx,:) = [];
    save(fullfile(datapath,strcat(experiment_id, '_rawDataAssessment.mat')), 'assessTable')
    save(fullfile(datapath,strcat(experiment_id, '_automatedAnnotations.mat')), 'automatedAnnotations')
    save(fullfile(datapath,strcat(experiment_id, '_manualAnnotations.mat')), 'manualAnnotations')
    save(fullfile(datapath,strcat(experiment_id, '_videoStatisticsMerged.mat')), 'videoStatisticsMerged')
end