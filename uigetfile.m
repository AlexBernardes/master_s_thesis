% shadowing uigetfile

function [patientFile, filePath] = uigetfile(~,~, arquivo)

    disp(arquivo);
    
    index = find(arquivo == '\', 1, 'last');
    patientFile = extractAfter(arquivo,index);
    filePath = extractBefore(arquivo,index);
