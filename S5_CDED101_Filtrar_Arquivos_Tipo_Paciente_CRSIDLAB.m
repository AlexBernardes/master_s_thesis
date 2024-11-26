%% Faz a filtragem dos arquivos do tipo pacientes.

%% 0 - Ir para o diretório dos arquivos de pacientes
path_pacientes = "C:\Users\AlexA\Meu Drive\UnB - Mestrado - Regular\Projeto e Pesquisa\Repositório de Dados\Dados Pré-processados\CDED-1.0.1-final\Dados Processados - Arquivos PATIENT\Filtrado\";
cd(path_pacientes);

%% 1 - Pegar todos os arquivos do tipo 
% list_converted_files_data = ls(convertStringsToChars(strcat('*', stringJanela)));
list_converted_files_data = ls(convertStringsToChars("*.mat"));
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

for i=1:numConvertedFiles

    % Carregando arquivo de pacientes
    filename = list_converted_files_data(i, :);
    
    % Abrindo Software crsidlab
    crsidlab;
    
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
    
    % Selecionando sinal de Raw ECG data para filtragem
    popupMenu = findobj(gcf, 'style', 'popupmenu');
    callbacksPopupMenu = get(popupMenu, 'Callback');
    callbackPopupManuHandle = callbacksPopupMenu{1};
    popupMenu.Value = 1; % 1 - Raw ECG Data, 2 - Raw BP Data
    feval(callbackPopupManuHandle, popupMenu, callbacksPopupMenu{:});
    
    % Width of Notch 20% -> Filter 60Hz
    notch = findobj(gcf, 'tag', 'notch');
    callbacksNotch = get(notch, 'Callback');
    callbackNotchHandle = callbacksNotch{1};
    notch.String = '20';
    feval(callbackNotchHandle, notch, callbacksNotch{:});
    
    filter60Hz = findobj(gcf, 'string', 'Filter 60 Hz');
    callbacksFilter60Hz = get(filter60Hz, 'Callback');
    callbackFilter60HzHandle = callbacksFilter60Hz{1};
    feval(callbackFilter60HzHandle, filter60Hz, callbacksFilter60Hz{:});
    
    %Low-pass at 35Hz -> Filter HF Noise
    lowPass = findobj(gcf, 'tag', 'lowPass');
    callbacksLowPass = get(lowPass, 'Callback');
    callbackLowPassHandle = callbacksLowPass{1};
    lowPass.String = '35';
    feval(callbackLowPassHandle, lowPass, callbacksLowPass{:});
    
    filterHFNoise = findobj(gcf, 'string', 'Filter HF Noise');
    callbacksFilterHFNoise = get(filterHFNoise, 'Callback');
    callbackFilterHFNoiseHandle = callbacksFilterHFNoise{1};
    feval(callbackFilterHFNoiseHandle, filterHFNoise, callbacksFilterHFNoise{:});
    
    % High-pass at 0.01 h(53) -> F. Baseline Wander h(51)
    highPass = findobj(gcf, 'tag', 'highPass');
    callbacksHighPass = get(highPass, 'Callback');
    callbackHighPassHandle = callbacksHighPass{1};
    highPass.String = '0.001';
    feval(callbackHighPassHandle, highPass, callbacksHighPass{:});
    
    filterBaselineWander = findobj(gcf, 'string', 'F. Baseline Wander');
    callbacksFilterBaselineWander = get(filterBaselineWander, 'Callback');
    callbackFilterBaselineWanderHandle = callbacksFilterBaselineWander{1};
    feval(callbackFilterBaselineWanderHandle, filterBaselineWander, callbacksFilterBaselineWander{:});
    
    % SAVE
    saveECG = findobj(gcf, 'string', 'SAVE');
    callbacksSaveECG = get(saveECG, 'Callback');
    callbackSaveECGHandle = callbacksSaveECG{1};
    feval(callbackSaveECGHandle, saveECG, callbacksSaveECG{:});
    
    % -----------------------------------------------------------
    % -----------------------------------------------------------
    
    % Selecionando sinal de Raw BP data para filtragem
    popupMenu = findobj(gcf, 'style', 'popupmenu');
    callbacksPopupMenu = get(popupMenu, 'Callback');
    callbackPopupManuHandle = callbacksPopupMenu{1};
    popupMenu.Value = 2; % 1 - Raw ECG Data, 2 - Raw BP Data
    
    feval(callbackPopupManuHandle, popupMenu, callbacksPopupMenu{:});
    
    % Width of Notch 20% -> Filter 60Hz
    notch = findobj(gcf, 'tag', 'notch');
    callbacksNotch = get(notch, 'Callback');
    callbackNotchHandle = callbacksNotch{1};
    notch.String = '1';
    feval(callbackNotchHandle, notch, callbacksNotch{:});
    
    filter60Hz = findobj(gcf, 'string', 'Filter 60 Hz');
    callbacksFilter60Hz = get(filter60Hz, 'Callback');
    callbackFilter60HzHandle = callbacksFilter60Hz{1};
    feval(callbackFilter60HzHandle, filter60Hz, callbacksFilter60Hz{:});
    
    %Low-pass at 35Hz -> Filter HF Noise
    lowPass = findobj(gcf, 'tag', 'lowPass');
    callbacksLowPass = get(lowPass, 'Callback');
    callbackLowPassHandle = callbacksLowPass{1};
    lowPass.String = '35';
    feval(callbackLowPassHandle, lowPass, callbacksLowPass{:});
    
    filterHFNoise = findobj(gcf, 'string', 'Filter HF Noise');
    callbacksFilterHFNoise = get(filterHFNoise, 'Callback');
    callbackFilterHFNoiseHandle = callbacksFilterHFNoise{1};
    feval(callbackFilterHFNoiseHandle, filterHFNoise, callbacksFilterHFNoise{:});
    
    % Salvar
    saveBP = findobj(gcf, 'string', 'SAVE');
    callbacksSaveECG = get(saveBP, 'Callback');
    callbackSaveECGHandle = callbacksSaveECG{1};
    feval(callbackSaveECGHandle, saveBP, callbacksSaveECG{:});
    
    % -----------------------------------------------------------
    % -----------------------------------------------------------
    
    % Abrir aba Extract Variables
    abaExtractVariables = findobj(gcf, 'tag', 'ext');
    callbacksAbaExtractVariables = get(abaExtractVariables, 'Callback');
    callbackAbaExtractVariablesHandle = callbacksAbaExtractVariables{1};
    feval(callbackAbaExtractVariablesHandle, abaExtractVariables, callbacksAbaExtractVariables{:});
    
    % Abrir ferramentas da janela
    extractVariables = callbacksAbaExtractVariables{4};
    callbacksExtractVariables = get(extractVariables, 'Callback');
    callbackExtractVariablesHandle = callbacksExtractVariables{1};
    feval(callbackExtractVariablesHandle, extractVariables, callbacksExtractVariables{:});

    % -----------------------------------------------------------
    % -----------------------------------------------------------
    
    % Obtendo uicontrols de popups
    popupMenu = findobj(gcf, 'style', 'popupmenu');
    
    % Selecionar ECG filtrado
    ecgFiltradoPopup = findobj(popupMenu, 'tag', 'ecg');
    callbacksEcgFiltradoPopup = get(ecgFiltradoPopup, 'Callback');
    callbackEcgFiltradoPopupHandle = callbacksEcgFiltradoPopup{1};
    ecgFiltradoPopup.Value = 2;
    feval(callbackEcgFiltradoPopupHandle, ecgFiltradoPopup, callbacksEcgFiltradoPopup{:});
    
    % Selecionar BP filtrado
    bpFiltradoPopup = findobj(popupMenu, 'tag', 'bp');
    callbacksBpFiltradoPopup = get(bpFiltradoPopup, 'Callback');
    callbackBpFiltradoPopupHandle = callbacksBpFiltradoPopup{1};
    bpFiltradoPopup.Value = 2;
    feval(callbackBpFiltradoPopupHandle,bpFiltradoPopup, callbacksBpFiltradoPopup{:});
    
    % Extrair RR com Algoritmo Lento (Slow Algorithm)
    rriPopup = findobj(popupMenu, 'string', {'R-R Interval', 'Fast algorithm', 'Slow algorithm'});
    callbacksRriPopup = get(rriPopup, 'Callback');
    callbackRriPopupHandle = callbacksRriPopup{:};
    rriPopup.Value = 3;
    feval(callbackRriPopupHandle, rriPopup, callbacksRriPopup{:});

    % Extrair Pressão Sistólica com RRI
    systolicBPPopup = findobj(popupMenu, 'string', {'Systolic BP', 'Waveform algorithm', 'From RRI'});
    callbacksSystolicBPPopup = get(systolicBPPopup, 'Callback');
    callbackSystolicBPPopupHandle = callbacksSystolicBPPopup{:};
    systolicBPPopup.Value = 2;
    feval(callbackSystolicBPPopupHandle, systolicBPPopup, callbacksSystolicBPPopup{:});
    
    % Extrair Pressão Diastólica com RRI & SBP
    diastolicBPPopup = findobj(popupMenu, 'string', {'Diastolic BP', 'Waveform algorithm', 'From SBP', 'From RRI & SBP'});
    callbacksDiastolicBPPopup = get(diastolicBPPopup, 'Callback');
    callbackDiastolicBPPopupHandle = callbacksDiastolicBPPopup{:};
    diastolicBPPopup.Value = 2;
    feval(callbackDiastolicBPPopupHandle, diastolicBPPopup, callbacksDiastolicBPPopup{:});
    
    % Salvar
    saveExtract = findobj(gcf, 'string', 'SAVE');
    callbacksSaveExtract = get(saveExtract, 'Callback');
    callbackSaveExtractHandle = callbacksSaveExtract{1};
    feval(callbackSaveExtractHandle, saveExtract, callbacksSaveExtract{:});
    
    % -----------------------------------------------------------
    % -----------------------------------------------------------
    
    % Abrir aba Pre-process Respiration data
    abaPreProcResp = findobj(gcf, 'tag', 'resp');
    callbacksAbaPreProcResp = get(abaPreProcResp, 'Callback');
    callbackAbaPreProcRespHandle = callbacksAbaPreProcResp{1};
    feval(callbackAbaPreProcRespHandle, abaPreProcResp, callbacksAbaPreProcResp{:});
    
    % Abrir ferramentas da janela
    preProcResp = callbacksAbaPreProcResp{6};
    callbacksPreProcResp = get(preProcResp, 'Callback');
    callbackPreProcRespHandle = callbacksPreProcResp{1};
    feval(callbackPreProcRespHandle, preProcResp, callbacksPreProcResp{:});
    
    % -----------------------------------------------------------
    % -----------------------------------------------------------
    
    % Obtém Popup menu
    popupMenu = findobj(gcf, 'style', 'popupmenu');
    callbacksPopupMenu = get(popupMenu, 'Callback');
    callbackPopupManuHandle = callbacksPopupMenu{1};
    popupMenu.Value = 1; % 1 - Raw airflow data
    
    % Faz a integração do sinal
    integrate = findobj(gcf, 'string', 'Integrate');
    callbacksIntegrate = get(integrate, 'Callback');
    callbackIntegrate= callbacksIntegrate{1};
    feval(callbackIntegrate, integrate, callbacksIntegrate{:});
    
    % Acessa a sub sub-aba Detrend
    detrends = findobj(gcf, 'string', 'Detrend'); %% Vem o botão e a aba
    
    subAbaDetrend = findobj(detrends, 'style', 'togglebutton');
    callbacksSubAbaDetrend = get(subAbaDetrend, 'Callback');
    callbackSubAbaDetrendHandle = callbacksSubAbaDetrend{1};
    feval(callbackSubAbaDetrendHandle, subAbaDetrend, callbacksSubAbaDetrend{:});
    
    % Seleciona e Aplica detrend polinomial de grau 5
    detrendHighPass = findobj(gcf, 'string', 'High-pass at:');
    detrendHighPass.Value = 0;
    detrendLinear = findobj(gcf, 'string', 'Linear detrend');
    detrendLinear.Value = 0;
    detrendPoly = findobj(gcf, 'string', 'Polynomial');
    detrendPoly.Value = 1;
    detrendPolyOrdem = findobj(gcf, 'tag', 'polyOrd');
    detrendPolyOrdem.String = '5'; % Ordem 5
    
    % Valida entrada
    callbacksDetrendPolyOrdem = get(detrendPolyOrdem, 'Callback');
    callbackDetrendPolyOrdemHandle = callbacksDetrendPolyOrdem{1};
    feval(callbackDetrendPolyOrdemHandle, detrendPolyOrdem, callbacksDetrendPolyOrdem{:});
    
    % Chama detrend
    detrendFilter = findobj(detrends, 'style', 'pushbutton');
    callbacksDetrendFilter = get(detrendFilter, 'Callback');
    callbackDetrendFilterHandle = callbacksDetrendFilter{1};
    feval(callbackDetrendFilterHandle, detrendFilter, callbacksDetrendFilter{:})
    
    % Acessa a sub-aba Filter
    abaFilter = findobj(gcf, 'string', 'Filter');
    callbacksAbaFilter = get(abaFilter, 'Callback');
    callbackAbaFilterHandle = callbacksAbaFilter{1};
    feval(callbackAbaFilterHandle, abaFilter, callbacksAbaFilter{:});
    
    % Chama ferramentas da aba filter
    toolsAbaFilter = callbacksAbaFilter{4};
    callbacksToolsAbaFilter = get(toolsAbaFilter, 'Callback');
    callbackToolsAbaFilterHandle = callbacksToolsAbaFilter{1};
    feval(callbackToolsAbaFilterHandle, toolsAbaFilter, callbacksToolsAbaFilter{:});
    
    % Cut-off freq -> for second filter at 4Hz
    cutFreq = findobj(gcf, 'tag', 'lowPass2');
    cutFreq.String = '4'; % 4Hz
    
    cutFreqT = findobj(gcf, 'string', 'Cut-off freq.'); % Vem os dois radiobuttons
    cutFreqT1 = findobj(cutFreqT, 'UserData', 1);
    cutFreqT1.Value = 0;
    cutFreqT2 = findobj(cutFreqT, 'UserData', 2);
    cutFreqT2.Value = 1;
    
    % Call filter
    filterHF = findobj(gcf, 'string', 'Filter HF noise');
    callbacksFilterHF = get(filterHF,'Callback');
    callbackFilterHFHandle = callbacksFilterHF{1};
    feval(callbackFilterHFHandle, filterHF, callbacksFilterHF{:});
    
    % Salvar
    saveExtract = findobj(gcf, 'string', 'SAVE');
    callbacksSaveExtract = get(saveExtract, 'Callback');
    callbackSaveExtractHandle = callbacksSaveExtract{1};
    feval(callbackSaveExtractHandle, saveExtract, callbacksSaveExtract{:});
    
end

% Deletando Handles e limpando variáveis
handles = findall(groot, 'Type', 'figure');
delete(handles);

%% Removendo Shadowing da pasta do software
delete(fullfile(path_software, shadow_file_1));
delete(fullfile(path_software, shadow_file_2));
delete(fullfile(path_software, shadow_file_3));

% clear;