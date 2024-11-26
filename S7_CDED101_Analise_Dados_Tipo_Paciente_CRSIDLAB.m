%% Faz o alinhamento, reamostragem e análise dos dados.

%% 0 - Ir para o diretório dos arquivos de pacientes
path_pacientes = "C:\Users\AlexA\Meu Drive\UnB - Mestrado - Regular\Projeto e Pesquisa\Repositório de Dados\Dados Pré-processados\CDED-1.0.1-final\Dados Processados - Arquivos PATIENT\Sistemas\";
cd(path_pacientes);

%% 1 - Pegar todos os arquivos do tipo 
list_converted_files_data = ls("*.mat");
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

disp(list_converted_files_data)

%% Mapa para fitting das funções de laguerre 
fittingMap = [
0.9 300; 
0.88 260;
0.86 240;
0.84 220;
0.82 190;
0.80 170;
0.78 150;
0.76 140;
0.74 130;
0.72 120;
0.70 110;
0.68 100;
0.66 90;
0.64 85;
0.62 80;
0.60 75;
0.58 70;
0.56 70;
0.54 65;
0.52 60;
];

% for i=6:numConvertedFiles
for i=1:14
    
    disp("janela: " + string(i) + " de " + string(numConvertedFiles))
    
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
    
    % Abrir aba do System Identification
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
    
    % Abrindo aba System Model
    abaSystemModel = findobj(gcf, 'tag', 'model');
    callbacksAbaSystemModel = get(abaSystemModel, 'Callback');
    callbackAbaSystemModelHandle = callbacksAbaSystemModel{1};
    feval(callbackAbaSystemModelHandle, abaSystemModel, callbacksAbaSystemModel{:});
    
    % Abrir ferramentas dos System Model
    systemModel = callbacksAbaSystemModel{4};
    callbacksSystemModel = get(systemModel, 'Callback');
    callbackSystemModelHandle = callbacksSystemModel{1};
    feval(callbackSystemModelHandle, systemModel, callbacksSystemModel{:});
    
    % -----------------------------------------------------------
    % -----------------------------------------------------------
    
    % Seleciona o Sistema para análise
    popupMenu = findobj(gcf, 'style', 'popupmenu');
    callbacksPopupMenu = get(popupMenu, 'Callback');
    callbackPopupMenuHandle = callbacksPopupMenu{1};
    
    systemsDynamicUpdate = {};
    %% Para quando os sistemas já existem e estão salvos
    for systemsIndex=1:length(popupMenu.String)
        if contains(popupMenu.String(systemsIndex), 'sys')
            systemsDynamicUpdate{end+1} = systemsIndex;
        end
    end
    
    numberSystems = length(systemsDynamicUpdate);
   
    for sistema=2:(numberSystems) % Ignorar primeira opção - sem sistema
        
        % Corrigindo a mudança do popup dinamico
        systemsDynamicUpdate = {};
        for systemsIndex=1:length(popupMenu.String)
            if contains(popupMenu.String(systemsIndex), 'sys')
                systemsDynamicUpdate{end+1} = systemsIndex;
            end
        end
        
        popupMenu.Value = systemsDynamicUpdate{sistema};
        
        feval(callbackPopupMenuHandle, popupMenu, callbacksPopupMenu{:});
        
        % Selecionar Método de Identificação por Bases de Laguerre
        identMet = findobj(gcf, 'tag', 'model');
        
        MBF = findobj(identMet, 'string', 'MBF');
        MBF.Value = 0;

        ARX =  findobj(identMet, 'string', 'ARX');
        ARX.Value = 0;
        
        LBF = findobj(identMet, 'string', 'LBF');
        LBF.Value = 1;
        callbacksLBF = get(LBF, 'Callback');
        callbackLBFHandle = callbacksLBF{1};
        feval(callbackLBFHandle, LBF, callbacksLBF{:});
        
        % Selecionar critério de ordem dos parametros
        criteria = findobj(gcf, 'tag', 'criteria');
        
        MDL = findobj(criteria, 'string', 'MDL');
        MDL.Value = 0;
        
        AIC = findobj(criteria, 'string', 'AIC');
        AIC.Value = 0;
        
        bestFit = findobj(criteria, 'string', 'Best Fit');
        bestFit.Value = 1;
        callbacksBestFit = get(bestFit, 'Callback');
        callbackBestFitHandle = callbacksBestFit{1};
        feval(callbackBestFitHandle, bestFit, callbacksBestFit{:});
        
        % Selecionar Ordens e Delays -> Choose limit values for parameters testing
        ordDel = findobj(gcf, 'tag', 'orMax');
        
        direct = findobj(ordDel, 'string', 'Choose parameters directly');
        direct.Value = 0;
        
        testing = findobj(ordDel, 'string', 'Choose limit values for parameters testing');
        testing.Value = 1;
        callbacksTesting = get(testing, 'Callback');
        callbackTestingHandle = callbacksTesting{:};
        feval(callbackTestingHandle, testing, callbacksTesting{:});

        if contains(popupMenu.String(systemsDynamicUpdate{sistema}), 'RRI') && ...
                contains(popupMenu.String(systemsDynamicUpdate{sistema}), 'SBP') && ...
                    ~contains(popupMenu.String(systemsDynamicUpdate{sistema}), 'ILV')
            %if sistema == 2 % RRI -> SBP (Atraso não pode ser negativo)
            % nb1-
            nb1Min = findobj(gcf, 'tag', 'nb1Min');
            nb1Min.String = '1'; %Ordem
            callbacksNb1Min = get(nb1Min, 'Callback');
            callbackNb1MinHandle = callbacksNb1Min{1};
            feval(callbackNb1MinHandle, nb1Min, callbacksNb1Min{:});
            
            % nb1+
            nb1Max = findobj(gcf, 'tag', 'nb1Max');
            nb1Max.String = '12';%Ordem
            callbacksNb1Max = get(nb1Max, 'Callback');
            callbackNb1MaxHandle = callbacksNb1Max{1};
            feval(callbackNb1MaxHandle, nb1Max, callbacksNb1Max{:});

            % nk1-
            nk1Min = findobj(gcf, 'tag', 'nk1Min');
            nk1Min.String = '0'; %Delay
            callbacksNk1Min = get(nk1Min, 'Callback');
            callbackNk1MinHandle = callbacksNk1Min{1};
            feval(callbackNk1MinHandle, nk1Min, callbacksNk1Min{:});
            
            % nk1+
            nk1Max = findobj(gcf, 'tag', 'nk1Max');
            nk1Max.String = '12'; %delay
            callbacksNk1Max = get(nk1Max, 'Callback');
            callbackNk1MaxHandle = callbacksNk1Max{1};
            feval(callbackNk1MaxHandle, nk1Max, callbacksNk1Max{:});
            
        elseif contains(popupMenu.String(systemsDynamicUpdate{sistema}), 'RRI') && ...
                ~contains(popupMenu.String(systemsDynamicUpdate{sistema}), 'SBP') && ...
                    contains(popupMenu.String(systemsDynamicUpdate{sistema}), 'ILV')
            % sistema == 3 % RRI -> ILV (Atraso pode ser negativo)
            % nb1-
            nb1Min = findobj(gcf, 'tag', 'nb1Min');
            nb1Min.String = '1'; %Ordem
            callbacksNb1Min = get(nb1Min, 'Callback');
            callbackNb1MinHandle = callbacksNb1Min{1};
            feval(callbackNb1MinHandle, nb1Min, callbacksNb1Min{:});
            
            % nb1+
            nb1Max = findobj(gcf, 'tag', 'nb1Max');
            nb1Max.String = '12';%Ordem
            callbacksNb1Max = get(nb1Max, 'Callback');
            callbackNb1MaxHandle = callbacksNb1Max{1};
            feval(callbackNb1MaxHandle, nb1Max, callbacksNb1Max{:});

            % nk1-
            nk1Min = findobj(gcf, 'tag', 'nk1Min');
            nk1Min.String = '-8'; %Delay
            callbacksNk1Min = get(nk1Min, 'Callback');
            callbackNk1MinHandle = callbacksNk1Min{1};
            feval(callbackNk1MinHandle, nk1Min, callbacksNk1Min{:});
            
            % nk1+
            nk1Max = findobj(gcf, 'tag', 'nk1Max');
            nk1Max.String = '12'; %delay
            callbacksNk1Max = get(nk1Max, 'Callback');
            callbackNk1MaxHandle = callbacksNk1Max{1};
            feval(callbackNk1MaxHandle, nk1Max, callbacksNk1Max{:});
        
        elseif contains(popupMenu.String(systemsDynamicUpdate{sistema}), 'RRI') && ...
                contains(popupMenu.String(systemsDynamicUpdate{sistema}), 'SBP') && ...
                 contains(popupMenu.String(systemsDynamicUpdate{sistema}), 'ILV')
            % sistema == 4 % RRI -> SBP & ILV (Atraso só é negativo para ILV)
            % nb1-
            nb1Min = findobj(gcf, 'tag', 'nb1Min');
            nb1Min.String = '1'; %Ordem
            callbacksNb1Min = get(nb1Min, 'Callback');
            callbackNb1MinHandle = callbacksNb1Min{1};
            feval(callbackNb1MinHandle, nb1Min, callbacksNb1Min{:});
            
            % nb1+
            nb1Max = findobj(gcf, 'tag', 'nb1Max');
            nb1Max.String = '12';%Ordem
            callbacksNb1Max = get(nb1Max, 'Callback');
            callbackNb1MaxHandle = callbacksNb1Max{1};
            feval(callbackNb1MaxHandle, nb1Max, callbacksNb1Max{:});

            % nk1-
            nk1Min = findobj(gcf, 'tag', 'nk1Min');
            nk1Min.String = '0'; %Delay
            callbacksNk1Min = get(nk1Min, 'Callback');
            callbackNk1MinHandle = callbacksNk1Min{1};
            feval(callbackNk1MinHandle, nk1Min, callbacksNk1Min{:});
            
            % nk1+
            nk1Max = findobj(gcf, 'tag', 'nk1Max');
            nk1Max.String = '12'; %delay
            callbacksNk1Max = get(nk1Max, 'Callback');
            callbackNk1MaxHandle = callbacksNk1Max{1};
            feval(callbackNk1MaxHandle, nk1Max, callbacksNk1Max{:});
            
            % nb2-
            nb2Min = findobj(gcf, 'tag', 'nb2Min');
            nb2Min.String = '1'; %Ordem
            callbacksNb2Min = get(nb2Min, 'Callback');
            callbackNb2MinHandle = callbacksNb2Min{1};
            feval(callbackNb2MinHandle, nb2Min, callbacksNb2Min{:});
            
            % nb2+
            nb2Max = findobj(gcf, 'tag', 'nb2Max');
            nb2Max.String = '12';%Ordem
            callbacksNb2Max = get(nb2Max, 'Callback');
            callbackNb2MaxHandle = callbacksNb2Max{1};
            feval(callbackNb2MaxHandle, nb2Max, callbacksNb2Max{:});

            % nk2-
            nk2Min = findobj(gcf, 'tag', 'nk2Min');
            nk2Min.String = '-8'; %Delay
            callbacksNk2Min = get(nk2Min, 'Callback');
            callbackNk2MinHandle = callbacksNk2Min{1};
            feval(callbackNk2MinHandle, nk2Min, callbacksNk2Min{:});
            
            % nk2+
            nk2Max = findobj(gcf, 'tag', 'nk2Max');
            nk2Max.String = '12'; %delay
            callbacksNk2Max = get(nk2Max, 'Callback');
            callbackNk2MaxHandle = callbacksNk2Max{1};
            feval(callbackNk2MaxHandle, nk2Max, callbacksNk2Max{:});
            
        else
            continue;
%             error('Sistema não definido.');
        end
         
        fite = 0;
        fitv = 0;
        betterFitIndex = 1;
        for fitIndex=1:length(fittingMap)

            % rodando estimação dinamica de polos
            estimation = fittingDynamic(fittingMap, fitIndex);
        
            % Verificando fit
            disp(estimation);
            fit = estimation;

            if (fite + fitv) < (fit(1) + fit(2))
                fite = fit(1);
                fitv = fit(2);
                betterFitIndex = fitIndex;
            end
        end
        
        % Executando melhor polo e memoria para o sistema
        estimation = fittingDynamic(fittingMap, betterFitIndex);
        disp('Estimação final');
        disp(estimation);
        
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

clear;
clc;

function estimation = fittingDynamic(fittingMap, fitIndex)
    % Selecionar o Pole e a Memória do sistema
    pole = findobj(gcf, 'tag', 'pole');
    % pole.String = '0.76';
    pole.String = string(fittingMap(fitIndex, 1));
    callbacksPole = get(pole, 'Callback');
    callbackPoleHandle = callbacksPole{1};
    feval(callbackPoleHandle, pole, callbacksPole{:});

    mem = findobj(gcf, 'tag', 'sysMem');
    % mem.String = '140';
    mem.String = fittingMap(fitIndex, 2);
    callbacksMem = get(mem, 'Callback');
    callbackMemHandle = callbacksMem{1};
    feval(callbackMemHandle, mem, callbacksMem{:});

    % Clicar estimar modelo
    estimate = findobj(gcf, 'string', 'Estimate Model');
    callbacksEstimate = get(estimate, 'Callback');
    callbackEstimateHandle = callbacksEstimate{1};
    feval(callbackEstimateHandle, estimate, callbacksEstimate{:});
    
    % return
    estimation = callbacksEstimate{4}.UserData.fit;
end