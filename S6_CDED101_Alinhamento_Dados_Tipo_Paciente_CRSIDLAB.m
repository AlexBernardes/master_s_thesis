%% Faz o alinhamento, reamostragem e análise dos dados parte 1.

%% 0 - Ir para o diretório dos arquivos de pacientes
path_pacientes = "C:\Users\AlexA\Meu Drive\UnB - Mestrado - Regular\Projeto e Pesquisa\Repositório de Dados\Dados Pré-processados\CDED-1.0.1-final\Dados Processados - Arquivos PATIENT\Alinhado\";
cd(path_pacientes);

% Janela
janela_n = 2;
stringJanela = strcat('J', string(janela_n), '.mat');

%% 1 - Pegar todos os arquivos .irr presente na pasta do repositório dos arquivos refinados.
% Remove arquivos de outras janelas da lista
list_converted_files_data = ls(convertStringsToChars(strcat('*', stringJanela)));
[numConvertedFiles, chars] = size(list_converted_files_data);

%% 2 - Caminho da pasta do softwares
% path_software = "C:\Users\AlexA\Meu Drive\UnB - Mestrado - Regular\Projeto e Pesquisa\Repositório de Dados\Pre-processing Test\Softwares\CRSIDLab_Fev_2022 - MBF (Atualizado - OG Funcionando)\";
path_software = "C:\Users\AlexA\Meu Drive\UnB - Mestrado - Regular\Projeto e Pesquisa\Repositório de Dados\Dados Pré-processados\Softwares\CRSIDLab_2_0\CRSIDLab_Fev2023\";
cd(path_software);

%% Injetando shadowing na pasta do software
shadow_path = "C:\Users\AlexA\Meu Drive\UnB - Mestrado - Regular\Projeto e Pesquisa\Repositório de Dados\Dados Pré-processados\Algoritmos\";
shadow_file_1 = "uigetfile.m";
shadow_file_2 = "msgbox.m";
shadow_file_3 = "uiwait.m";
copyfile(fullfile(shadow_path, shadow_file_1), fullfile(path_software, shadow_file_1), 'f');
copyfile(fullfile(shadow_path, shadow_file_2), fullfile(path_software, shadow_file_2), 'f');
copyfile(fullfile(shadow_path, shadow_file_3), fullfile(path_software, shadow_file_3), 'f');

%% Mapa de sinais considerados e descartados para a montagem dos sistemas
% Sincronizador de janela
windowControl = 0; % Vai ser incrementado a cada loop de paciente i;
MapWindowCDED101 = [%Ordem: 1-ECG,2-ABP,3-RF
1	1	1	1	0	0;% S0030
1	1	1	1	1	0;% S0033
1	1	1	0	0	0;% S0068
1	0	0	0	0	0;% S0078
0	0	0	0	0	0;% S0134
1	0	1	1	0	1;% S0153
1	1	0	1	0	1;% S0166
0	0	0	1	0	0;% S0174
1	1	0	1	0	0;% S0187
1	1	1	1	1	1;% S0197
1	0	1	1	0	1;% S0215
1	0	1	1	1	1;% S0221
1	1	1	1	1	0;% S0228
1	0	1	0	0	0;% S0264
1	1	1	1	1	1;% S0296
1	1	1	1	1	1;% S0301
1	1	1	1	1	1;% S0308
1	1	1	1	1	1;% S0314
1	1	1	1	1	1;% S0318
0	0	0	0	0	0;% S0366
1	0	1	0	0	0;% S0372
1	1	0	1	0	0;% S0411
1	0	1	1	0	1;% S0434
1	0	1	1	1	1;% S0452
1	1	1	1	1	1;% S0454
1	1	1	1	0	1;% S0513
0	0	0	0	0	0;% S0515
1	1	1	1	1	1;% S0522
1	0	1	1	0	1;% S0527
1	0	1	1	0	1;% S0531
1	1	1	1	1	1;% S0532
1	1	1	1	1	1;% S0534
1	1	1	0	0	0;% S0536
1	1	1	1	1	1;% S0539
1	0	1	1	1	1;% S0540
1	1	1	1	1	1;% S0541
1	1	1	1	1	1;% S0543
1	0	1	1	0	1;% S0544
1	1	1	1	1	1;% S0545
1	1	1	1	0	0;% S0546
0	0	0	0	0	0;% S0550
1	1	1	1	1	1;% S0551
1	0	1	1	1	1;% S0554
0	0	0	1	1	0;% S0555
1	1	1	1	1	1;% S0557
1	1	1	1	1	1;% S0560
1	1	1	1	1	1;% S0561
1	0	1	1	0	1;% S0562
1	0	1	1	0	1;% S0565
1	1	1	1	1	1;% S0569
1	1	1	0	0	0;% S0570
1	1	1	1	0	1;% S0575
1	1	0	1	1	0;% S0576
1	0	1	1	0	0;% S0578
0	0	0	1	0	1;% S0579
1	0	1	1	1	1;% S0580
1	1	1	1	0	1;% S0582
0	0	0	0	0	0;% S0583
1	0	1	1	0	0;% S0584
0	0	0	1	1	1;% S0585
1	0	1	1	0	1;% S0591
1	0	0	1	1	1;% S0592
0	0	0	0	0	0;% S0594
1	0	1	1	0	1;% S0595
1	1	1	1	1	1;% S0597
1	1	1	1	1	1;% S0600
1	1	1	1	0	0;% S0601
0	0	0	0	0	0;% S0608
1	1	0	1	0	1;% S0610
];

if janela_n == 1
    usabilitySignalMap = MapWindowCDED101(:,1:3);
else
    usabilitySignalMap = MapWindowCDED101(:,4:6);
end

for i=1:numConvertedFiles

    % Sincronizador de janela
    windowControl = windowControl + 1;
    
    % Carregando arquivo de pacientes
    filename = list_converted_files_data(i, :);
    
    % Abrindo Software crsidlab
    crsidlab;
    
    % Correção para janelas inexistentes com o mapa -> ECG = 0, Bp = 0, ILV = 0
    while usabilitySignalMap(windowControl,1) == 0 && usabilitySignalMap(windowControl,2) == 0 && usabilitySignalMap(windowControl,3) == 0
        windowControl = windowControl + 1;

        disp("Nova Janela - Ajuste: " + string(windowControl));
        disp(usabilitySignalMap(windowControl, :));
    end
    
    % Validação de Janela-Indivíduo
    disp("arquivo: " + string(i));
    disp(filename)
    disp("janela: " + string(usabilitySignalMap(windowControl, :)));
    
    % -----------------------------------------------------------
    % -----------------------------------------------------------
    
    % Clica em Open Patient File
    openPatientFile = findobj(gcf, 'string', 'Open Patient File');
    callbacksOpenPatientFile = get(openPatientFile, 'Callback');
    callbackOpenPatientFileHandle = callbacksOpenPatientFile{1};
    
    % Configurando o caminho e o usuário
    callbacksOpenPatientFile{7}.String = extractBefore(filename, ".mat");
    callbacksOpenPatientFile{8}.String = path_pacientes;
    
    % Gambiarra para mudar arquivo no uigetfile
    callbacksOpenPatientFile{16}.UserData.session.filename = convertStringsToChars(fullfile(path_pacientes, filename));
    
    % Invoca método para abrir arquivo
    feval(callbackOpenPatientFileHandle, openPatientFile, callbacksOpenPatientFile{:});

    % -----------------------------------------------------------
    % -----------------------------------------------------------
        
    % Abrindo a aba de pre-processamento
    abaPreProcessamento = findobj(gcf, 'string', 'Pre-processing');
    callbacksAbaPreProcessamento = get(abaPreProcessamento, 'Callback');
    callbackAbaPreProcessamentoHandle = callbacksAbaPreProcessamento{1};
    
    % Invoca método de troca de aba para pre-processamento
    feval(callbackAbaPreProcessamentoHandle, abaPreProcessamento, callbacksAbaPreProcessamento{:});
    
    % Abrindo ferramentas de pre-processamento
    preProcessamento = callbacksAbaPreProcessamento{4};
    callbacksPreProcessamento = get(preProcessamento, 'Callback');
    callbackPreProcessamentoHandle = callbacksPreProcessamento{1};
    
    % Invoca metodo de ferramentas para pre-processamento
    feval(callbackPreProcessamentoHandle, preProcessamento, callbacksPreProcessamento{:});
    
    % -----------------------------------------------------------
    % -----------------------------------------------------------
    
    % Abrir Align and resample data set
    abaAlinhamento = findobj(gcf, 'tag', 'align');
    callbacksAbaAlinhamento = get(abaAlinhamento, 'Callback');
    callbackAbaAlinhamentoHandle = callbacksAbaAlinhamento{1};
    feval(callbackAbaAlinhamentoHandle, abaAlinhamento, callbacksAbaAlinhamento{:});
    
    % Carregar ferramentas da aba Align and resample data set
    alinhamentoTools = callbacksAbaAlinhamento{8};
    callbacksAlinhamentoTools = get(alinhamentoTools, 'Callback');
    callbackAlinhamentoToolsHandle = callbacksAlinhamentoTools{:};
    feval(callbackAlinhamentoToolsHandle, alinhamentoTools, callbacksAlinhamentoTools{:});
    
    % -----------------------------------------------------------
    % -----------------------------------------------------------

    % PARA DBP
    % obter todos os popup menus para os sinais de ECG, BP e RESP
    popupMenus = findobj(gcf, 'style', 'popupmenu');
    
    popupECG = findobj(popupMenus, 'tag', 'ecg');
    popupECG.Value = 2; % 2 - RRI
    callbacksPopupECG = get(popupECG, 'Callback');
    callbackPopupECGHandle = callbacksPopupECG{1};
    feval(callbackPopupECGHandle, popupECG, callbacksPopupECG{:});
    
    popupBP = findobj(popupMenus, 'tag', 'bp');
    popupBP.Value = 3; % 2 - SBP, 3 - DBP
    callbacksPopupBP = get(popupBP, 'Callback');
    callbackPopupBPHandle = callbacksPopupBP{1};
    feval(callbackPopupBPHandle, popupBP, callbacksPopupBP{:});
    
    popupRSP = findobj(popupMenus, 'tag', 'rsp');
    popupRSP.Value = 3; % 3 - Filtered ILV Data
    callbacksPopupRSP = get(popupRSP, 'Callback');
    callbackPopupRSPHandle = callbacksPopupRSP{1};
    feval(callbackPopupRSPHandle, popupRSP, callbacksPopupRSP{:});
    
    % Marcar Ectopic Marks para interpolate
    ectopicMark = findobj(gcf, 'tag', 'rbEctopic');
    
    ectopicTypeRemove = findobj(ectopicMark, 'string', 'Remove');
    ectopicTypeRemove.Value = 0;
    
    ectopicTypeDontRemove = findobj(ectopicMark, 'string', "Don't Remove");
    ectopicTypeDontRemove.Value = 0;
    
    ectopicTypeInterpolate = findobj(ectopicMark, 'string', 'Interpolate');
    ectopicTypeInterpolate.Value = 1;
    callbacksEctopicTypeInterpolate = get(ectopicTypeInterpolate, 'Callback');
    callbackEctopicTypeInterpolateHandle = callbacksEctopicTypeInterpolate{1};
    feval(callbackEctopicTypeInterpolateHandle, ectopicTypeInterpolate, callbacksEctopicTypeInterpolate{:});
    
    % Marcar Resampling method para cubic interpolation
    resampleMethod = findobj(gcf, 'tag', 'rbMethod');
    
    resampleBerger = findobj(resampleMethod, 'string', 'Berger algorithm');
    resampleBerger.Value = 0;
    
    resampleLinear = findobj(resampleMethod, 'string', 'Linear interpolation');
    resampleLinear.Value = 0;
    
    resampleCubic = findobj(resampleMethod, 'string', 'Cubic interpolation');
    resampleCubic.Value = 1;
    callbacksResampleCubic = get(resampleCubic, 'Callback');
    callbackResampleCubicHandle = callbacksResampleCubic{:};
    feval(callbackResampleCubicHandle, resampleCubic, callbacksResampleCubic{:});
    
    % Marcar limits for resampling para ILV Start e End.
    % Start (Uso do for pq o Matlab nao aceita regex pra propriedade string
    % no findobj).
    startLimit = findobj(gcf, 'tag', 'rbStart');
    for j=1:length(startLimit)
        if (contains(startLimit(j).String, 'RRI'))
            RRIStartLimit = startLimit(j);
            RRIStartLimit.Value = 0;
            
        elseif (contains(startLimit(j).String, 'DBP'))
            DBPStartLimit = startLimit(j);
            DBPStartLimit.Value = 0;
            
        elseif (contains(startLimit(j).String, 'ILV'))
            ILVStartLimit = startLimit(j);
            ILVStartLimit.Value = 1;
            callbacksILVStartLimit = get(ILVStartLimit, 'Callback');
            callbackILVStartLimitHandle = callbacksILVStartLimit{1};
            feval(callbackILVStartLimitHandle, ILVStartLimit, callbacksILVStartLimit{:});
            
        else
            error('Erro ao escolher limites do Resampling');
        end
    end
        
    % End
    endLimit = findobj(gcf, 'tag', 'rbEnd');
    for j=1:length(endLimit)
        if (contains(endLimit(j).String, 'RRI'))
            RRIEndLimit = endLimit(j);
            RRIEndLimit.Value = 0;
            
        elseif (contains(endLimit(j).String, 'DBP'))
            DBPEndLimit = endLimit(j);
            DBPEndLimit.Value = 0;
            
        elseif (contains(endLimit(j).String, 'ILV'))
            ILVEndLimit = endLimit(j);
            ILVEndLimit.Value = 1;
            callbacksILVEndLimit = get(ILVEndLimit, 'Callback');
            callbackILVEndLimitHandle = callbacksILVEndLimit{1};
            feval(callbackILVEndLimitHandle, ILVEndLimit, callbacksILVEndLimit{:});
        elseif (contains(endLimit(j).String, 'No. of samples'))
            continue
        else
            error('Erro ao escolher limites do Resampling');
        end
    end
    
    % Marcar Method to fill data borders to constant padding
    border = findobj(gcf, 'tag', 'rbBorder');
    
    borderSym = findobj(border, 'string', 'Symmetric extension');
    borderSym.Value = 0;
    
    borderConst = findobj(border, 'string', 'Constant padding (border values)');
    borderConst.Value = 1;
    callbacksBorderConst = get(borderConst, 'Callback');
    callbacksBorderConstHandle = callbacksBorderConst{1};
    feval(callbacksBorderConstHandle, borderConst, callbacksBorderConst{:});
    
    % Marcar RRI output para RRI
    output = findobj(gcf, 'tag', 'rbRRIOut');
    
    HROutput = findobj(output, 'string', 'HR');
    HROutput.Value = 0;
    
    RRIOutput = findobj(output, 'string', 'RRI');
    RRIOutput.Value = 1;
    callbacksRRIOutput = get(RRIOutput, 'Callback');
    callbackRRIOutputHandle = callbacksRRIOutput{1};
    feval(callbackRRIOutputHandle, RRIOutput, callbacksRRIOutput{:});
    
    % Configurar Resampling Frequency para 4 hz
    edits = findobj(gcf, 'style', 'edit');
    
    for k=1:length(edits)
        functionHandle = edits(k).Callback{1};
        functionName = functions(functionHandle).function;
        if(strcmp(functionName, 'teFsCallback'))
            frequencyObj = edits(k);
        end
    end
    
    frequencyObj.String = '4'; %4Hz
    callbacksFrequencyObj = get(frequencyObj, 'Callback');
    callbackFrequencyObjHandle = callbacksFrequencyObj{:};
    feval(callbackFrequencyObjHandle, frequencyObj, callbacksFrequencyObj{:});
    
    % Clicar Resample
    resample = findobj(gcf, 'string', 'Resample');
    callbacksResample = get(resample, 'Callback');
    callbackResampleHandle = callbacksResample{:};
    feval(callbackResampleHandle, resample, callbacksResample{:});
    
    % Clicar Save
    saveAlign = findobj(gcf, 'string', 'SAVE');
    callbacksSaveAlign = get(saveAlign, 'Callback');
    callbackSaveAlignHandle = callbacksSaveAlign{1};
    feval(callbackSaveAlignHandle, saveAlign, callbacksSaveAlign{:});
    
    % -----------------------------------------------------------
    % -----------------------------------------------------------
    
    % PARA SBP
    % obter todos os popup menus para os sinais de ECG, BP e RESP
    popupMenus = findobj(gcf, 'style', 'popupmenu');
    
    popupECG = findobj(popupMenus, 'tag', 'ecg');
    popupECG.Value = 2; % 2 - RRI
    callbacksPopupECG = get(popupECG, 'Callback');
    callbackPopupECGHandle = callbacksPopupECG{1};
    feval(callbackPopupECGHandle, popupECG, callbacksPopupECG{:});
    
    popupBP = findobj(popupMenus, 'tag', 'bp');
    popupBP.Value = 2; % 2 - SBP, 3 - DBP
    callbacksPopupBP = get(popupBP, 'Callback');
    callbackPopupBPHandle = callbacksPopupBP{1};
    feval(callbackPopupBPHandle, popupBP, callbacksPopupBP{:});
    
    popupRSP = findobj(popupMenus, 'tag', 'rsp');
    popupRSP.Value = 3; % 3 - Filtered ILV Data
    callbacksPopupRSP = get(popupRSP, 'Callback');
    callbackPopupRSPHandle = callbacksPopupRSP{1};
    feval(callbackPopupRSPHandle, popupRSP, callbacksPopupRSP{:});
    
    % Marcar Ectopic Marks para interpolate
    ectopicMark = findobj(gcf, 'tag', 'rbEctopic');
    
    ectopicTypeRemove = findobj(ectopicMark, 'string', 'Remove');
    ectopicTypeRemove.Value = 0;
    
    ectopicTypeDontRemove = findobj(ectopicMark, 'string', "Don't Remove");
    ectopicTypeDontRemove.Value = 0;
    
    ectopicTypeInterpolate = findobj(ectopicMark, 'string', 'Interpolate');
    ectopicTypeInterpolate.Value = 1;
    callbacksEctopicTypeInterpolate = get(ectopicTypeInterpolate, 'Callback');
    callbackEctopicTypeInterpolateHandle = callbacksEctopicTypeInterpolate{1};
    feval(callbackEctopicTypeInterpolateHandle, ectopicTypeInterpolate, callbacksEctopicTypeInterpolate{:});
    
    % Marcar Resampling method para cubic interpolation
    resampleMethod = findobj(gcf, 'tag', 'rbMethod');
    
    resampleBerger = findobj(resampleMethod, 'string', 'Berger algorithm');
    resampleBerger.Value = 0;
    
    resampleLinear = findobj(resampleMethod, 'string', 'Linear interpolation');
    resampleLinear.Value = 0;
    
    resampleCubic = findobj(resampleMethod, 'string', 'Cubic interpolation');
    resampleCubic.Value = 1;
    callbacksResampleCubic = get(resampleCubic, 'Callback');
    callbackResampleCubicHandle = callbacksResampleCubic{:};
    feval(callbackResampleCubicHandle, resampleCubic, callbacksResampleCubic{:});
    
    % Marcar limits for resampling para ILV Start e End.
    % Start (Uso do for pq o Matlab nao aceita regex pra propriedade string
    % no findobj).
    startLimit = findobj(gcf, 'tag', 'rbStart');
    for j=1:length(startLimit)
        if (contains(startLimit(j).String, 'RRI'))
            RRIStartLimit = startLimit(j);
            RRIStartLimit.Value = 0;
            
        elseif (contains(startLimit(j).String, 'SBP'))
            SBPStartLimit = startLimit(j);
            SBPStartLimit.Value = 0;
            
        elseif (contains(startLimit(j).String, 'ILV'))
            ILVStartLimit = startLimit(j);
            ILVStartLimit.Value = 1;
            callbacksILVStartLimit = get(ILVStartLimit, 'Callback');
            callbackILVStartLimitHandle = callbacksILVStartLimit{1};
            feval(callbackILVStartLimitHandle, ILVStartLimit, callbacksILVStartLimit{:});
            
        else
            error('Erro ao escolher limites do Resampling');
        end
    end
        
    % End
    endLimit = findobj(gcf, 'tag', 'rbEnd');
    for j=1:length(endLimit)
        if (contains(endLimit(j).String, 'RRI'))
            RRIEndLimit = endLimit(j);
            RRIEndLimit.Value = 0;
            
        elseif (contains(endLimit(j).String, 'SBP'))
            SBPEndLimit = endLimit(j);
            SBPEndLimit.Value = 0;
            
        elseif (contains(endLimit(j).String, 'ILV'))
            ILVEndLimit = endLimit(j);
            ILVEndLimit.Value = 1;
            callbacksILVEndLimit = get(ILVEndLimit, 'Callback');
            callbackILVEndLimitHandle = callbacksILVEndLimit{1};
            feval(callbackILVEndLimitHandle, ILVEndLimit, callbacksILVEndLimit{:});
        elseif (contains(endLimit(j).String, 'No. of samples'))
            continue
        else
            error('Erro ao escolher limites do Resampling');
        end
    end
    
    % Marcar Method to fill data borders to constant padding
    border = findobj(gcf, 'tag', 'rbBorder');
    
    borderSym = findobj(border, 'string', 'Symmetric extension');
    borderSym.Value = 0;
    
    borderConst = findobj(border, 'string', 'Constant padding (border values)');
    borderConst.Value = 1;
    callbacksBorderConst = get(borderConst, 'Callback');
    callbacksBorderConstHandle = callbacksBorderConst{1};
    feval(callbacksBorderConstHandle, borderConst, callbacksBorderConst{:});
    
    % Marcar RRI output para RRI
    output = findobj(gcf, 'tag', 'rbRRIOut');
    
    HROutput = findobj(output, 'string', 'HR');
    HROutput.Value = 0;
    
    RRIOutput = findobj(output, 'string', 'RRI');
    RRIOutput.Value = 1;
    callbacksRRIOutput = get(RRIOutput, 'Callback');
    callbackRRIOutputHandle = callbacksRRIOutput{1};
    feval(callbackRRIOutputHandle, RRIOutput, callbacksRRIOutput{:});
    
    % Configurar Resampling Frequency para 4 hz
    edits = findobj(gcf, 'style', 'edit');
    
    for k=1:length(edits)
        functionHandle = edits(k).Callback{1};
        functionName = functions(functionHandle).function;
        if(strcmp(functionName, 'teFsCallback'))
            frequencyObj = edits(k);
        end
    end
    
    frequencyObj.String = '4'; %4Hz
    callbacksFrequencyObj = get(frequencyObj, 'Callback');
    callbackFrequencyObjHandle = callbacksFrequencyObj{:};
    feval(callbackFrequencyObjHandle, frequencyObj, callbacksFrequencyObj{:});
    
    % Clicar Resample
    resample = findobj(gcf, 'string', 'Resample');
    callbacksResample = get(resample, 'Callback');
    callbackResampleHandle = callbacksResample{:};
    feval(callbackResampleHandle, resample, callbacksResample{:});
    
    % Clicar Save
    saveAlign = findobj(gcf, 'string', 'SAVE');
    callbacksSaveAlign = get(saveAlign, 'Callback');
    callbackSaveAlignHandle = callbacksSaveAlign{1};
    feval(callbackSaveAlignHandle, saveAlign, callbacksSaveAlign{:});
    
    % -----------------------------------------------------------
    % -----------------------------------------------------------
    
    % Abrir aba de análise
    abaAnalysis = findobj(gcf, 'string', 'Analysis');
    callbacksAbaAnalysis = get(abaAnalysis, 'Callback');
    callbackAbaAnalysisHandle = callbacksAbaAnalysis{1};
    feval(callbackAbaAnalysisHandle, abaAnalysis, callbacksAbaAnalysis{:});
    
    % Abrindo ferramentas de análise
    analisys = callbacksAbaAnalysis{6};
    callbacksAnalysis = get(analisys, 'Callback');
    callbackAnalysisHandle = callbacksAnalysis{1};
    feval(callbackAnalysisHandle, analisys, callbacksAnalysis{:});
    
    % -----------------------------------------------------------
    % -----------------------------------------------------------
    
    % Abrir aba PSD
%     abaPSD = findobj(gcf, 'tag', 'psd');
%     callbacksAbaPSD = get(abaPSD, 'Callback');
%     callbackAbaPSDHandle = callbacksAbaPSD{1};
%     feval(callbackAbaPSDHandle, abaPSD, callbacksAbaPSD{:});
    
    % Abrir ferramentas PSD
%     PSD = callbacksAbaPSD{2};
%     callbacksPSD = get(PSD, 'Callback');
%     callbackPSDHandle = callbacksPSD{1};
%     feval(callbackPSDHandle, PSD, callbacksPSD{:});
    
    % -----------------------------------------------------------
    % -----------------------------------------------------------
    
    % Pegar popupMenu
    popupMenus = findobj(gcf, 'style', 'popupmenu');
    
    % % Gambiarra
    % popupMenus = popupMenus(1);
    callbacksPopupMenus = get(popupMenus, 'Callback');
    CallbackPopupMenusHandle = callbacksPopupMenus{1};
    
    % -----------------------------------------------------------
    % -----------------------------------------------------------
    
    % Sistemas    
    
    % -----------------------------------------------------------
    % -----------------------------------------------------------
    
    for signalIndex=1:length(popupMenus.("String"))
        popupMenus.Value = signalIndex;
        
        % Chama validação do sinal escolhido
        feval(CallbackPopupMenusHandle, popupMenus, callbacksPopupMenus{:});
        
        % Spectorgram Parameters
        
            % # of Points
            nPoints = findobj(gcf, 'tag', 'N');
            nPoints.String = '2048';
            callbacksNPoints = get(nPoints, 'Callback');
            callbackNPointsHandle = callbacksNPoints{1};
            feval(callbackNPointsHandle, nPoints, callbacksNPoints{:});

            % AR Order
            arOrder = findobj(gcf, 'tag', 'arOrder');
            arOrder.String = '20';
            callbacksArOrder = get(arOrder, 'Callback');
            callbackArOrderHandle = callbacksArOrder{1};
            feval(callbackArOrderHandle, arOrder, callbacksArOrder{:});

            % Samples per segment
            samples = findobj(gcf, 'tag', 'segments');
            samples.String = '256';
            callbacksSamples = get(samples, 'Callback');
            callbackSamplesHandle = callbacksSamples{1};
            feval(callbackSamplesHandle, samples, callbacksSamples{:});
            
            % Overlapping samples
            overlap = findobj(gcf, 'tag', 'overlap');
            overlap.String = '128';
            callbacksOverlap = get(overlap, 'Callback');
            callbackOverlapHandle = callbacksOverlap{1};
            feval(callbackOverlapHandle, overlap, callbacksOverlap{:});
        
        % Window
        window = findobj(gcf, 'tag', 'window');
        
            % Deselect other
            rectangular = findobj(window, 'String', 'Hanning');
            rectangular.Value = 0;
            bartlett = findobj(window, 'String', 'Bartlett');
            bartlett.Value = 0;
            hamming = findobj(window, 'String', 'Hamming');
            hamming.Value = 0;
            blackman = findobj(window, 'String', 'Blackman');
            blackman.Value = 0;
        
            % Select Hanning
            hanning = findobj(window, 'String', 'Hanning');
            hanning.Value = 1;
            callbacksHanning = get(hanning, 'Callback');
            callbackHanningHandle = callbacksHanning{1};
            feval(callbackHanningHandle, hanning, callbacksHanning{:});
            
        % Method
            methods = findobj(gcf, 'Style', 'checkbox');
        
            % Select all three
            fourier = findobj(methods, 'string', 'Fourier Transform');
            fourier.Value = 1;
            callbacksFourier = get(fourier, 'Callback');
            callbackFourierHandle = callbacksFourier{1};
            feval(callbackFourierHandle, fourier, callbacksFourier{:});
            
            welch = findobj(methods, 'string', 'Welch Method');
            welch.Value = 1;
            callbacksWelch = get(welch, 'Callback');
            callbackWelchHandle = callbacksWelch{1};
            feval(callbackWelchHandle, welch, callbacksWelch{:});
            
            arModel = findobj(methods, 'string', 'AR Model');
            arModel.Value = 1;
            callbacksArModel = get(arModel, 'Callback');
            callbackArModelHandle = callbacksArModel{1};
            feval(callbackArModelHandle, arModel, callbacksArModel{:});
            
        % Scale
        
        scales = findobj(gcf, 'tag', 'scale');
        
            % Deselect others
            normal = findobj(scales, 'string', 'Normal');
            normal.Value = 0;
            
            logLog = findobj(scales, 'string', 'Log-Log');
            logLog.Value = 0;
            
            % Select Monolog
            monolog = findobj(scales, 'string', 'Monolog');
            monolog.Value = 1;
            callbacksMonolog = get(monolog, 'Callback');
            callbackMonologHandle = callbacksMonolog{1};
            feval(callbackMonologHandle, monolog, callbacksMonolog{:});
            
        % Frequencias
        
            % Very-low: 0 - 0.04
            vlf = findobj(gcf, 'tag', 'vlf');
            vlf.String = '0.04';
            callbacksVLF = get(vlf, 'Callback');
            callbackVLFHandle = callbacksVLF{1};
            feval(callbackVLFHandle, vlf, callbacksVLF{:});

            % Low-frequencies: 0.04 - 0.15
            lf = findobj(gcf, 'tag', 'lf');
            lf.String = '0.15';
            callbacksLF = get(lf, 'Callback');
            callbackLFHandle = callbacksLF{1};
            feval(callbackLFHandle, lf, callbacksLF{:});

            % High-frequencies: 0.15 - 0.4
            hf = findobj(gcf, 'tag', 'hf');
            hf.String = '0.4';
            callbacksHF = get(hf, 'Callback');
            callbackHFHandle = callbacksHF{1};
            feval(callbackHFHandle, hf, callbacksHF{:});
        
        % Save Spectrogram
        save = findobj(gcf, 'string', 'Save Spectrogram');
        callbacksSave = get(save, 'Callback');
        callbackSaveHandle = callbacksSave{1};
        feval(callbackSaveHandle, save, callbacksSave{:});
        
    end
    
    % -----------------------------------------------------------
    % -----------------------------------------------------------
    
    abaSysIdent = findobj(gcf, 'tag', 'ident');
    callbacksAbaSysIdent = get(abaSysIdent, 'Callback');
    callbackAbaSysIdentHandle = callbacksAbaSysIdent{1};
    feval(callbackAbaSysIdentHandle, abaSysIdent, callbacksAbaSysIdent{:});
    
    sysIdent = callbacksAbaSysIdent{4};
    callbacksSysIdent = get(sysIdent, 'Callback');
    callbackSysIdentHandle = callbacksSysIdent{1};
    feval(callbackSysIdentHandle, sysIdent, callbacksSysIdent{:});
    
    % -----------------------------------------------------------
    % -----------------------------------------------------------
    
    % Pegar os popup menus nas combinações desejadas
    popupMenus = findobj(gcf, 'style', 'popupmenu');
    
    %% Output RRI -> Input SBP
    
    if usabilitySignalMap(windowControl, 1) == 1 && usabilitySignalMap(windowControl, 2) == 1
        out = findobj(popupMenus, 'tag', 'out');
        out.Value = 2; % RRI
        callbacksOut = get(out, 'Callback');
        callbackOutHandle = callbacksOut{1};
        feval(callbackOutHandle, out, callbacksOut{:});

        in1 = findobj(popupMenus, 'tag', 'in1');
        in1.Value = 3; % SBP
        callbacksIn1 = get(in1, 'Callback');
        callbackIn1Handle = callbacksIn1{1};
        feval(callbackIn1Handle, in1, callbacksIn1{:});

        in2 = findobj(popupMenus, 'tag', 'in2');
        in2.Value = 1; % Vazio
        callbacksIn2 = get(in2, 'Callback');
        callbackIn2Handle = callbacksIn2{1};
        feval(callbackIn2Handle, in2, callbacksIn2);

        % Configurando o percentual para estimação
        percent = findobj(gcf, 'tag', 'perc');
        percent.String = '80'; % 80 porcento
        callbacksPercent = get(percent, 'Callback');
        callbackPercentHandle = callbacksPercent{1};
        feval(callbackPercentHandle, percent, callbacksPercent{:});

        % Aplicando Filtro Kaiser
        kaiser = findobj(gcf, 'string', 'Apply filter');
        callbacksKaiser = get(kaiser, 'Callback');
        callbackKaiserHandle = callbacksKaiser{:};
        feval(callbackKaiserHandle, kaiser, callbacksKaiser{:});

        % Aplicando Detrend do sinal -> Polinomio ordem 5
        poly = findobj(gcf, 'tag', 'poly');
        poly.String = '5'; % Ordem 5
        callbacksPoly = get(poly, 'Callback');
        callbackPolyHandle = callbacksPoly{1};
        feval(callbackPolyHandle, poly, callbacksPoly{:});

        detrendSig = findobj(gcf, 'string', 'Detrend signals');
        callbacksDetrendSig = get(detrendSig, 'Callback');
        callbackDetrendSigHandle = callbacksDetrendSig{1};
        feval(callbackDetrendSigHandle, detrendSig, callbacksDetrendSig{:});

        % Salvar
        save = findobj(gcf, 'string', 'SAVE');
        callbacksSave = get(save, 'Callback');
        callbackSaveHandle = callbacksSave{1};
        feval(callbackSaveHandle, save, callbacksSave{:});
        
    end
    
    %% Output RRI -> Input ILV
    
    if usabilitySignalMap(windowControl, 1) == 1 && usabilitySignalMap(windowControl, 3) == 1
        out = findobj(popupMenus, 'tag', 'out');
        out.Value = 2; % RRI
        callbacksOut = get(out, 'Callback');
        callbackOutHandle = callbacksOut{1};
        feval(callbackOutHandle, out, callbacksOut{:});

        in1 = findobj(popupMenus, 'tag', 'in1');
        in1.Value = 2; % ILV
        callbacksIn1 = get(in1, 'Callback');
        callbackIn1Handle = callbacksIn1{1};
        feval(callbackIn1Handle, in1, callbacksIn1{:});

        in2 = findobj(popupMenus, 'tag', 'in2');
        in2.Value = 1; % Vazio
        callbacksIn2 = get(in2, 'Callback');
        callbackIn2Handle = callbacksIn2{1};
        feval(callbackIn2Handle, in2, callbacksIn2);

        % Configurando o percentual para estimação
        percent = findobj(gcf, 'tag', 'perc');
        percent.String = '80'; % 80 porcento
        callbacksPercent = get(percent, 'Callback');
        callbackPercentHandle = callbacksPercent{1};
        feval(callbackPercentHandle, percent, callbacksPercent{:});

        % Aplicando Filtro Kaiser
        kaiser = findobj(gcf, 'string', 'Apply filter');
        callbacksKaiser = get(kaiser, 'Callback');
        callbackKaiserHandle = callbacksKaiser{:};
        feval(callbackKaiserHandle, kaiser, callbacksKaiser{:});

        % Aplicando Detrend do sinal -> Polinomio ordem 5
        poly = findobj(gcf, 'tag', 'poly');
        poly.String = '5'; % Ordem 5
        callbacksPoly = get(poly, 'Callback');
        callbackPolyHandle = callbacksPoly{1};
        feval(callbackPolyHandle, poly, callbacksPoly{:});

        detrendSig = findobj(gcf, 'string', 'Detrend signals');
        callbacksDetrendSig = get(detrendSig, 'Callback');
        callbackDetrendSigHandle = callbacksDetrendSig{1};
        feval(callbackDetrendSigHandle, detrendSig, callbacksDetrendSig{:});

        % Salvar
        save = findobj(gcf, 'string', 'SAVE');
        callbacksSave = get(save, 'Callback');
        callbackSaveHandle = callbacksSave{1};
        feval(callbackSaveHandle, save, callbacksSave{:});

    end
    
    %% Output RRI -> Input SBP & ILV
    
    if usabilitySignalMap(windowControl, 1) == 1 && usabilitySignalMap(windowControl, 2) == 1 && usabilitySignalMap(windowControl, 3) == 1
        out = findobj(popupMenus, 'tag', 'out');
        out.Value = 2; % RRI
        callbacksOut = get(out, 'Callback');
        callbackOutHandle = callbacksOut{1};
        feval(callbackOutHandle, out, callbacksOut{:});

        in1 = findobj(popupMenus, 'tag', 'in1');
        in1.Value = 3; % SBP
        callbacksIn1 = get(in1, 'Callback');
        callbackIn1Handle = callbacksIn1{1};
        feval(callbackIn1Handle, in1, callbacksIn1{:});

        in2 = findobj(popupMenus, 'tag', 'in2');
        in2.Value = 2; % ILV
        callbacksIn2 = get(in2, 'Callback');
        callbackIn2Handle = callbacksIn2{1};
        feval(callbackIn2Handle, in2, callbacksIn2{:});

        % Configurando o percentual para estimação
        percent = findobj(gcf, 'tag', 'perc');
        percent.String = '80'; % 80 porcento
        callbacksPercent = get(percent, 'Callback');
        callbackPercentHandle = callbacksPercent{1};
        feval(callbackPercentHandle, percent, callbacksPercent{:});

        % Aplicando Filtro Kaiser
        kaiser = findobj(gcf, 'string', 'Apply filter');
        callbacksKaiser = get(kaiser, 'Callback');
        callbackKaiserHandle = callbacksKaiser{:};
        feval(callbackKaiserHandle, kaiser, callbacksKaiser{:});

        % Aplicando Detrend do sinal -> Polinomio ordem 5
        poly = findobj(gcf, 'tag', 'poly');
        poly.String = '5'; % Ordem 5
        callbacksPoly = get(poly, 'Callback');
        callbackPolyHandle = callbacksPoly{1};
        feval(callbackPolyHandle, poly, callbacksPoly{:});

        detrendSig = findobj(gcf, 'string', 'Detrend signals');
        callbacksDetrendSig = get(detrendSig, 'Callback');
        callbackDetrendSigHandle = callbacksDetrendSig{1};
        feval(callbackDetrendSigHandle, detrendSig, callbacksDetrendSig{:});

        % Salvar
        save = findobj(gcf, 'string', 'SAVE');
        callbacksSave = get(save, 'Callback');
        callbackSaveHandle = callbacksSave{1};
        feval(callbackSaveHandle, save, callbacksSave{:});

    end
    
end

% Deletando Handles e limpando variáveis
handles = findall(groot, 'Type', 'figure');
delete(handles);

%% Removendo Shadowing da pasta do software
delete(fullfile(path_software, shadow_file_1));
delete(fullfile(path_software, shadow_file_2));
delete(fullfile(path_software, shadow_file_3));

% clear;
% clc;