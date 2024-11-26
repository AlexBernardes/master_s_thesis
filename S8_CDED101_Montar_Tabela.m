% Script para Montagem da Tabela de Dados de Paciente de Diabetes Mellitus
% Para utilização desse Script, o pré-processamento de todos os pacientes
% devem ter sido executados anteriormentes, fornecendo arquivos válidos do
% tipo dataPkg.patientData

% 0 - Obter Lista de Arquivos de Pacientes
path_pacientes_arquivos = "C:\Users\AlexA\Meu Drive\UnB - Mestrado - Regular\Projeto e Pesquisa\Repositório de Dados\Dados Pré-processados\CDED-1.0.1-final\Dados Processados - Arquivos PATIENT\Finalizados\";
cd(path_pacientes_arquivos);

% Janela
janela_n = 1;
stringJanela = strcat('J', string(janela_n), '.mat');

%% 1 - Pegar todos os arquivos .irr presente na pasta do repositório dos arquivos de pacientes finalizados.
% Remove arquivos de outras janelas da lista
list_converted_files_data = ls(convertStringsToChars(strcat('*', stringJanela)));
[numConvertedFiles, chars] = size(list_converted_files_data);

T = table();
T2Pearson = table();

% 2 - Ir para o diretório do Software. Só é possível abrir o objeto .Patient se estiver nesse diretório do CRSIDLAB (Tem que investigar isso).
path_ecglab_software = "C:\Users\AlexA\Meu Drive\UnB - Mestrado - Regular\Projeto e Pesquisa\Repositório de Dados\Dados Pré-processados\Softwares\ecglab_matlab2014a\";
path_crsidlab_software = "C:\Users\AlexA\Meu Drive\UnB - Mestrado - Regular\Projeto e Pesquisa\Repositório de Dados\Dados Pré-processados\Softwares\CRSIDLab_2_0\CRSIDLab_Fev2023\"; 

%% Mapa de sinais considerados e descartados para a montagem dos sistemas
windowControl = 0;

% Control = 0
% Diabete Mellitus = 1
MapWindowCDED101 = [%Ordem: 1-ECG,2-ABP,3-RF(Repete),7-label
1	1	1	1	0	0	0;% S0030
1	1	1	1	1	0	0;% S0033
1	1	1	0	0	0	0;% S0068
1	0	0	0	0	0	0;% S0078
0	0	0	0	0	0	-1;% S0134
1	0	1	1	0	1	0;% S0153
1	1	0	1	0	1	0;% S0166
0	0	0	1	0	0	0;% S0174
1	1	0	1	0	0	0;% S0187
1	1	1	1	1	1	0;% S0197
1	0	1	1	0	1	0;% S0215
1	0	1	1	1	1	0;% S0221
1	1	1	1	1	0	0;% S0228
1	0	1	0	0	0	1;% S0264
1	1	1	1	1	1	1;% S0296
1	1	1	1	1	1	1;% S0301
1	1	1	1	1	1	1;% S0308
1	1	1	1	1	1	1;% S0314
1	1	1	1	1	1	1;% S0318
0	0	0	0	0	0	-1;% S0366
1	0	1	0	0	0	1;% S0372
1	1	0	1	0	0	0;% S0411
1	0	1	1	0	1	1;% S0434
1	0	1	1	1	1	0;% S0452
1	1	1	1	1	1	0;% S0454
1	1	1	1	0	1	1;% S0513
0	0	0	0	0	0	1;% S0515
1	1	1	1	1	1	1;% S0522
1	0	1	1	0	1	1;% S0527
1	0	1	1	0	1	1;% S0531
1	1	1	1	1	1	0;% S0532
1	1	1	1	1	1	1;% S0534
1	1	1	0	0	0	1;% S0536
1	1	1	1	1	1	1;% S0539
1	0	1	1	1	1	1;% S0540
1	1	1	1	1	1	0;% S0541
1	1	1	1	1	1	1;% S0543
1	0	1	1	0	1	1;% S0544
1	1	1	1	1	1	0;% S0545
1	1	1	1	0	0	0;% S0546
0	0	0	0	0	0	1;% S0550
1	1	1	1	1	1	0;% S0551
1	0	1	1	1	1	1;% S0554
0	0	0	1	1	0	1;% S0555
1	1	1	1	1	1	1;% S0557
1	1	1	1	1	1	1;% S0560
1	1	1	1	1	1	1;% S0561
1	0	1	1	0	1	1;% S0562
1	0	1	1	0	1	1;% S0565
1	1	1	1	1	1	1;% S0569
1	1	1	0	0	0	1;% S0570
1	1	1	1	0	1	0;% S0575
1	1	0	1	1	0	0;% S0576
1	0	1	1	0	0	0;% S0578
0	0	0	1	0	1	1;% S0579
1	0	1	1	1	1	1;% S0580
1	1	1	1	0	1	1;% S0582
0	0	0	0	0	0	1;% S0583
1	0	1	1	0	0	0;% S0584
0	0	0	1	1	1	0;% S0585
1	0	1	1	0	1	1;% S0591
1	0	0	1	1	1	1;% S0592
0	0	0	0	0	0	0;% S0594
1	0	1	1	0	1	0;% S0595
1	1	1	1	1	1	0;% S0597
1	1	1	1	1	1	0;% S0600
1	1	1	1	0	0	1;% S0601
0	0	0	0	0	0	1;% S0608
1	1	0	1	0	1	1;% S0610
];

if janela_n == 1
    usabilitySignalMap = MapWindowCDED101(:,1:3);
    usabilitySignalMap(:, 4) = MapWindowCDED101(:, 7);
else
    usabilitySignalMap = MapWindowCDED101(:,4:6);
    usabilitySignalMap(:, 4) = MapWindowCDED101(:, 7);
end

% 3 - Loop para criar e montar tabela csv com todos os dados dos pacientes
for i=1:numConvertedFiles

    %% 3.1 - Caminho para os dados
    %% Inicializando/Resetando as variáveis
    PATIENT = NaN; 
    ECG = NaN; BP = NaN; ILV = NaN;
    RRI_FS = NaN; TOTAL_AMOSTRAS_RRI = NaN; MEDIA = NaN; MEDIANA = NaN; SDNN = NaN; MINIMO = NaN; MAXIMO = NaN;
    QUARTIL_1 = NaN; QUARTIL_3 = NaN; pNN50 = NaN; RMSSD = NaN; COEFICIENTE_VARIANCIA = NaN; FAIXA_DINAMICA = NaN;
    SD_1 = NaN; SD_2 = NaN;
    LF_RRI_WELCH = NaN; HF_RRI_WELCH = NaN; LF_HF_RATIO_RRI_WELCH = NaN;
    LF_SBP_WELCH = NaN; HF_SBP_WELCH = NaN; LF_HF_RATIO_SBP_WELCH = NaN;
    LF_DBP_WELCH = NaN; HF_DBP_WELCH = NaN; LF_HF_RATIO_DBP_WELCH = NaN;
    LF_ILV_WELCH = NaN; HF_ILV_WELCH = NaN; LF_HF_RATIO_ILV_WELCH = NaN;
    ACOPLAM_TS = NaN; ABR_TS = NaN; RCC_TS = NaN;
    ACOPLAM_FIT_ESTIMATION = NaN;
    ACOPLAM_FIT_VALIDATION = NaN;
    IRM_ACOPLAM_SBP = NaN; ACOPLAM_LF_SBP = NaN; ACOPLAM_HF_SBP = NaN; ACOPLAM_DYNAMIC_GAIN_SBP = NaN; ACOPLAM_TIME_TO_PEAK_SAMPLE_SBP = NaN;
    IRM_ACOPLAM_ILV = NaN; ACOPLAM_LF_ILV = NaN; ACOPLAM_HF_ILV = NaN; ACOPLAM_DYNAMIC_GAIN_ILV = NaN; ACOPLAM_TIME_TO_PEAK_SAMPLE_ILV = NaN;
    ABR_FIT_ESTIMATION = NaN;
    ABR_FIT_VALIDATION = NaN;
    IRM_ABR = NaN; ABR_LF = NaN; ABR_HF = NaN; ABR_DYNAMIC_GAIN = NaN;
    IRM_RCC = NaN; RCC_LF = NaN; RCC_HF = NaN; RCC_DYNAMIC_GAIN = NaN;
    RCC_FIT_ESTIMATION = NaN;
    RCC_FIT_VALIDATION = NaN;
    LABEL = NaN;
    
    %% Carrega Paciente.
    cd(path_crsidlab_software);
    filename = convertStringsToChars(fullfile(path_pacientes_arquivos, list_converted_files_data(i, :)));
    load(filename);
    PATIENT = string(patient.info.ID);

    %% Abrir pasta do software do ECGlab.
    cd(path_ecglab_software);
    
    % Sincronizador de janela.
    windowControl = windowControl + 1;
    
    % Validação de Janela-Indivíduo
    disp("Paciente: " + PATIENT);
    disp("arquivo: " + string(i));
    disp(filename)
    disp("janela: " + string(usabilitySignalMap(windowControl, :)));
    
    % Correção para janelas inexistentes com o mapa -> ECG = 0, BP = 0, ILV = 0
    while usabilitySignalMap(windowControl,1) == 0 && usabilitySignalMap(windowControl,2) == 0 && usabilitySignalMap(windowControl,3) == 0
        windowControl = windowControl + 1;

        disp("Nova Janela - Ajuste: " + string(windowControl));
        disp(usabilitySignalMap(windowControl, :));
    end
    
    MapWindowPatient = usabilitySignalMap(windowControl, 1:4);
    ECG = MapWindowPatient(1);
    BP = MapWindowPatient(2);
    ILV = MapWindowPatient(3);
    
    % Control = 0
    % Diabete Mellitus = 1
    LABEL = MapWindowPatient(4);
    
    %% MapWindowPatient(1) RRI
    if MapWindowPatient(1) == 1
        %% Obtendo RRI alinhado do paciente para extrair estatísticas com Software ECGLAB.
        intervaloRR = patient.sig.ecg.rri.aligned.data;
        rri_time = patient.sig.ecg.rri.aligned.time;
        rri_fs = patient.sig.ecg.rri.aligned.fs;

        %% Calcula Estatísticas Temporais - ECGLAB.
        [TOTAL_AMOSTRAS_RRI, MEDIA, MEDIANA, SDNN, MINIMO, MAXIMO, QUARTIL_1, QUARTIL_3, pNN50, RMSSD, COEFICIENTE_VARIANCIA, FAIXA_DINAMICA] = ...
            temporalRR_calcula_stats(intervaloRR);

        %% Poincaré Plot    
        % intervaloRR_original=intervaloRR;tempoRR_original=tempoRR;
        % [intervaloRR,tempoRR]=temporalRR_interpola(intervaloRR_original,tempoRR_original,ebs_indices);

        [eixo1,eixo2,precisaopct,pcts,incl,sds,reta]=poincareRR_le_cfg;
        indices=poincareRR_grafico2(intervaloRR,eixo1,eixo2,precisaopct,pcts,sds,incl,reta);

        %% Extraindo apenas as variáveis desejádas
        SD_1 = indices(3);
        SD_2 = indices(4);

        %% Fechar as figuras abertas pelo poincareRR_grafico2
        close all;
    end
    
% % % SDNN - Script ECGLAB - Temporal
% % % RMSSD - Script ECGLAB - Temporal
% % % pNN50 - Script ECGLAB - Temporal
% % % Pointcaré Plot - SD1 e SD2: Script ECGLAB (Não implementado) - Índice Geométrico
% EXTRA --------------------------------------------------------------
% % % CoefVar
% % % FaixaDinamica
% % % Maximo
% % % Media
% % % Mediana
% % % Minimo
% % % Quartil1
% % % Quartil3
% % % TotalAmostras 
% EXTRA --------------------------------------------------------------

    %% Obtem índices espectrais do RRI
        if anyisfield(patient.sig.ecg.rri.aligned.psd, "specs.areas.psdWelch") && MapWindowPatient(1)
            LF_RRI_WELCH = patient.sig.ecg.rri.aligned.psd.specs.areas.psdWelch.lf;
            HF_RRI_WELCH = patient.sig.ecg.rri.aligned.psd.specs.areas.psdWelch.hf;
            LF_HF_RATIO_RRI_WELCH = patient.sig.ecg.rri.aligned.psd.specs.areas.psdWelch.ratio;
        end

% % % LF - RRI - Welch: patient.sig.ecg.rri.aligned.psd.specs.areas.psdWelch.lf - Espectral
% % % HF - RRI - Welch: patient.sig.ecg.rri.aligned.psd.specs.areas.psdWelch.hf - Espectral
% % % LF/HF - RRI - Welch: patient.sig.ecg.rri.aligned.psd.specs.areas.psdWelch.ratio - Espectral

    %% Obtem índices espectrais do SBP e do DBP
    if anyisfield(patient.sig.bp.sbp.aligned.psd, "specs.areas.psdWelch") && MapWindowPatient(2)
        LF_SBP_WELCH = patient.sig.bp.sbp.aligned.psd.specs.areas.psdWelch.lf;
        HF_SBP_WELCH = patient.sig.bp.sbp.aligned.psd.specs.areas.psdWelch.hf;
        LF_HF_RATIO_SBP_WELCH = patient.sig.bp.sbp.aligned.psd.specs.areas.psdWelch.ratio;
    
    end
    
    if anyisfield(patient.sig.bp.dbp.aligned.psd, "specs.areas.psdWelch") && MapWindowPatient(2)
        LF_DBP_WELCH = patient.sig.bp.dbp.aligned.psd.specs.areas.psdWelch.lf;
        HF_DBP_WELCH = patient.sig.bp.dbp.aligned.psd.specs.areas.psdWelch.hf;
        LF_HF_RATIO_DBP_WELCH = patient.sig.bp.dbp.aligned.psd.specs.areas.psdWelch.ratio;
    end

    %% Obtem índices espectrais da Respiração
    if anyisfield(patient.sig.rsp.filt.aligned.psd, 'specs.areas.psdWelch') && MapWindowPatient(3)
        LF_ILV_WELCH = patient.sig.rsp.filt.aligned.psd.specs.areas.psdWelch.lf;
        HF_ILV_WELCH = patient.sig.rsp.filt.aligned.psd.specs.areas.psdWelch.hf;
        LF_HF_RATIO_ILV_WELCH = patient.sig.rsp.filt.aligned.psd.specs.areas.psdWelch.ratio;
    end
    
% % % LF - SBP - Welch: patient.sig.bp.sbp.aligned.psd.specs.areas.psdWelch.lf - Espectral
% % % HF - SBP - Welch: patient.sig.bp.sbp.aligned.psd.specs.areas.psdWelch.hf - Espectral
% % % LF - DBP - Welch: patient.sig.bp.dbp.aligned.psd.specs.areas.psdWelch.lf - Espectral
% % % HF - DBP - Welch: patient.sig.bp.dbp.aligned.psd.specs.areas.psdWelch.hf - Espectral

    % Obtém índices do Acoplamento Cardiorrespiratório.

% % % RCC_LF - LBF - MDF (ILV -> RRI):
% % % RCC_HF - LBF - MDF (ILV -> RRI):
% % % IRM_RCC - LBF - MDF (ILV -> RRI):

    % Obtém índices do Mecanismo do Baroreflexo.

% % % ABR_LF - LBF - MDF (SBP -> RRI):
% % % ABR_HF - LBF - MDF (SBP -> RRI):
% % % IRM_ABR - LBF - MDF (SBP -> RRI):

    % Obtém índices do Acomplamento conjunto do Cardiorrespiratório + Mecanismo do Baroreflexo.

% % % ACOPLAM_LF - LBF - MDF (SBP + ILV -> RRI):
% % % ACOPLAM_HF - LBF - MDF (SBP + ILV -> RRI):
% % % IRM_ACOPLAM - LBF - MDF (SBP + ILV -> RRI):

% EXTRA --------------------------------------------------------------
% % % Dynamic Gain
% % % Time-to-Peak
% EXTRA --------------------------------------------------------------
   

    %% Os sistemas já foram montados considerando a tabela de mapeamento de sinais, ao contrário da montagem base do paciente
    if sum(MapWindowPatient(1:3)) >= 2
        for j=1:length(fieldnames(patient.sys))
        try
            systemIndex = strcat("sys", string(j));
            InputName = patient.sys.(systemIndex).models.model1.InputName;
            OutputName = patient.sys.(systemIndex).models.model1.OutputName;

            if (length(string(InputName)) == 2) && ...
                    and(strcmp(string(InputName(1)), "SBP"), strcmp(string(InputName(2)), "Filtered ILV")) && ...
                        strcmp(string(OutputName), "RRI")

                ACOPLAM_TS = patient.sys.(systemIndex).models.model1.Ts;

                IRM_ACOPLAM_SBP = patient.sys.(systemIndex).models.model1.imResp.indicators.irm(1);
                ACOPLAM_LF_SBP = patient.sys.(systemIndex).models.model1.imResp.indicators.dg.lf(1);
                ACOPLAM_HF_SBP = patient.sys.(systemIndex).models.model1.imResp.indicators.dg.hf(1);
                ACOPLAM_DYNAMIC_GAIN_SBP = patient.sys.(systemIndex).models.model1.imResp.indicators.dg.total(1);
                ACOPLAM_TIME_TO_PEAK_SAMPLE_SBP = patient.sys.(systemIndex).models.model1.imResp.indicators.ttp.samp(1);

                IRM_ACOPLAM_ILV = patient.sys.(systemIndex).models.model1.imResp.indicators.irm(2);
                ACOPLAM_LF_ILV = patient.sys.(systemIndex).models.model1.imResp.indicators.dg.lf(2);
                ACOPLAM_HF_ILV = patient.sys.(systemIndex).models.model1.imResp.indicators.dg.hf(2);
                ACOPLAM_DYNAMIC_GAIN_ILV = patient.sys.(systemIndex).models.model1.imResp.indicators.dg.total(2);
                ACOPLAM_TIME_TO_PEAK_SAMPLE_ILV = patient.sys.(systemIndex).models.model1.imResp.indicators.ttp.samp(2);
                
                ACOPLAM_FIT_ESTIMATION = patient.sys.(systemIndex).models.model1.fit(1);
                ACOPLAM_FIT_VALIDATION = patient.sys.(systemIndex).models.model1.fit(2);
            end

            if length(string(InputName)) == 1 && ...
                    and(strcmp(string(OutputName), "RRI"), strcmp(string(InputName), "SBP"))

                ABR_TS = patient.sys.(systemIndex).models.model1.Ts;

                IRM_ABR = patient.sys.(systemIndex).models.model1.imResp.indicators.irm;
                ABR_LF = patient.sys.(systemIndex).models.model1.imResp.indicators.dg.lf;
                ABR_HF = patient.sys.(systemIndex).models.model1.imResp.indicators.dg.hf;
                ABR_DYNAMIC_GAIN = patient.sys.(systemIndex).models.model1.imResp.indicators.dg.total;
                ABR_TIME_TO_PEAK_SAMPLE = patient.sys.(systemIndex).models.model1.imResp.indicators.ttp.samp;
                
                ABR_FIT_ESTIMATION = patient.sys.(systemIndex).models.model1.fit(1);
                ABR_FIT_VALIDATION = patient.sys.(systemIndex).models.model1.fit(2);
            end

            if length(string(InputName)) == 1 && ...
                    and(strcmp(string(OutputName), "RRI"), strcmp(string(InputName), "Filtered ILV"))

                RCC_TS = patient.sys.(systemIndex).models.model1.Ts;

                IRM_RCC = patient.sys.(systemIndex).models.model1.imResp.indicators.irm;
                RCC_LF = patient.sys.(systemIndex).models.model1.imResp.indicators.dg.lf;
                RCC_HF = patient.sys.(systemIndex).models.model1.imResp.indicators.dg.hf;
                RCC_DYNAMIC_GAIN = patient.sys.(systemIndex).models.model1.imResp.indicators.dg.total;
                RCC_TIME_TO_PEAK_SAMPLE = patient.sys.(systemIndex).models.model1.imResp.indicators.ttp.samp;
                
                RCC_FIT_ESTIMATION = patient.sys.(systemIndex).models.model1.fit(1);
                RCC_FIT_VALIDATION = patient.sys.(systemIndex).models.model1.fit(2);
            end
        catch ERRO
            ERRO;
        end
        end
    end
        
    % Montar a Tabela para o Excel
    T_line = table(PATIENT, ECG, BP, ILV, ...
        TOTAL_AMOSTRAS_RRI, MEDIA, MEDIANA, SDNN, MINIMO, MAXIMO, ...
        QUARTIL_1, QUARTIL_3, pNN50, RMSSD, COEFICIENTE_VARIANCIA, FAIXA_DINAMICA, ...
        SD_1, SD_2, ...
        LF_RRI_WELCH, HF_RRI_WELCH, LF_HF_RATIO_RRI_WELCH, ...
        LF_SBP_WELCH, HF_SBP_WELCH, LF_HF_RATIO_SBP_WELCH, ...
        LF_DBP_WELCH, HF_DBP_WELCH, LF_HF_RATIO_DBP_WELCH, ...
        LF_ILV_WELCH, HF_ILV_WELCH, LF_HF_RATIO_ILV_WELCH, ...
        ACOPLAM_FIT_ESTIMATION, ...
        ACOPLAM_FIT_VALIDATION, ...
        IRM_ACOPLAM_SBP, ACOPLAM_LF_SBP, ACOPLAM_HF_SBP, ACOPLAM_DYNAMIC_GAIN_SBP, ACOPLAM_TIME_TO_PEAK_SAMPLE_SBP, ...
        IRM_ACOPLAM_ILV, ACOPLAM_LF_ILV, ACOPLAM_HF_ILV, ACOPLAM_DYNAMIC_GAIN_ILV, ACOPLAM_TIME_TO_PEAK_SAMPLE_ILV, ...
        ABR_FIT_ESTIMATION, ...
        ABR_FIT_VALIDATION, ...
        IRM_ABR, ABR_LF, ABR_HF, ABR_DYNAMIC_GAIN, ...
        IRM_RCC, RCC_LF, RCC_HF, RCC_DYNAMIC_GAIN, ...
        RCC_FIT_ESTIMATION, ...
        RCC_FIT_VALIDATION, ...
        LABEL);
    
    T = [T; T_line];
    
end

%% Inserindo label de pacientes
sz = size(T);

% Salvar arquivos
path_csv = "C:\Users\AlexA\Meu Drive\UnB - Mestrado - Regular\Projeto e Pesquisa\Repositório de Dados\Dados Pré-processados\CDED-1.0.1-final\Planilhas e Dados de Controle\";
path_csv_data = fullfile(path_csv, "Features_Extraction_Data_Complete_J" + string(janela_n) + ".csv");
writetable(T, path_csv_data);

%% Análise do dados relacionando a confiabilidade da Tabela de Pearson.
path_mat_data = fullfile(path_csv, "ALL_FEATURES_DATA_J" + string(janela_n) + ".mat");
save(path_mat_data, "T");
clearvars -except T

%% Auxiliar Functions
function out_isfieldresult = anyisfield(in_rootstruct,in_field)
%ANYISFIELD: Extension of built in isfield function. Added features:
%1. Multilevel inputs (e.g. "b.c.d")
%2. Identification of matches at any level of nested structs
in_field = string(in_field);
rootfieldnames = string(fieldnames(in_rootstruct(1)));
out_isfieldresult = false;
if contains(in_field,".")
    current_searchfieldname = extractBefore(in_field,".");
else
    current_searchfieldname = in_field;
end
remaining_searchfieldnames = extractAfter(in_field,".");
for i=1:length(rootfieldnames)
    if strcmp(rootfieldnames(i),current_searchfieldname)
        if ismissing(remaining_searchfieldnames)
            out_isfieldresult = true;
            return
        else
            out_isfieldresult = anyisfield(in_rootstruct(1).(current_searchfieldname),remaining_searchfieldnames);
        end
    elseif isstruct(in_rootstruct(1).(rootfieldnames(i)))
        out_isfieldresult = anyisfield(in_rootstruct(1).(rootfieldnames(i)),current_searchfieldname);
        if out_isfieldresult == true
            return;
        end
    end
end
end

