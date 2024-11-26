% % Preencher e criar objetos do tipo paciente utilizando os arquivos de dados agrupados

%% 0 - Ir para o diretório dos arquivos agrupados
path_of_agrupados = "C:\Users\AlexA\Meu Drive\UnB - Mestrado - Regular\Projeto e Pesquisa\Repositório de Dados\Dados Pré-processados\CDED-1.0.1-final\Dados Processados - Separacao de Dados\Agrupados\"; 
cd(path_of_agrupados);

%% 1 - Criar o diretório para o arquivo com os arquivos de pacientes.
path_paciente = "C:\Users\AlexA\Meu Drive\UnB - Mestrado - Regular\Projeto e Pesquisa\Repositório de Dados\Dados Pré-processados\CDED-1.0.1-final\Dados Processados - Arquivos PATIENT\Cortado\";
[SUCCESS,MESSAGE,MESSAGEID] = mkdir(path_paciente);

% Janela
janela_n = 2;
stringJanela = strcat('-4minutes-j', string(janela_n), '-agrupado.mat');

%% 2 - Pegar todos os arquivos .irr presente na pasta do repositório dos arquivos refinados.
% Remove arquivos de outras janelas da lista
list_converted_files_data = ls(convertStringsToChars(strcat('*', stringJanela)));
[numConvertedFiles, chars] = size(list_converted_files_data);

% path_software = "C:\Users\AlexA\Meu Drive\UnB - Mestrado - Regular\Projeto e Pesquisa\Repositório de Dados\Pre-processing Test\Softwares\CRSIDLab_Fev_2022 - MBF (Atualizado - OG Funcionando)\";
path_software = "C:\Users\AlexA\Meu Drive\UnB - Mestrado - Regular\Projeto e Pesquisa\Repositório de Dados\Dados Pré-processados\Softwares\CRSIDLab_2_0\CRSIDLab_Fev2023\";
cd(path_software);

for i=1:numConvertedFiles
    
    disp("arquivo : " + i)
    
    % Carregando arquivo com dados agrupados
    filename = list_converted_files_data(i, :);
    load(fullfile(path_of_agrupados, filename));
    
    % Criando nome do arquivo paciente
    patientID = extractBefore(filename, stringJanela);
    patientID = strcat(patientID, 'J', string(janela_n));
    
    disp(strcat("Loop: ", num2str(i), " ", patientID));
    
    % Abrindo Software crsidlab
    crsidlab;

    % Clica em 'Create Patient File'
    createPatient = findobj(gcf, 'string', 'Create Patient File');
    callbacksCreate = get(createPatient, 'Callback');
    callbackCreateHandle = callbacksCreate{1};

    % Configurando parametros/variáveis
    callbacksCreate{2}.String = convertStringsToChars(patientID);
    % Configurando ID
    patientID = callbacksCreate{2};
    callbacksPatientID = get(patientID, 'Callback');
    callbackPatientIDHandle = callbacksPatientID{1};
    feval(callbackPatientIDHandle, patientID, callbacksPatientID{:});

    folderToStoreFile = convertStringsToChars(path_paciente);
    callbacksCreate{3}.String = folderToStoreFile;

    listbox = {'Raw ECG'; 'Raw BP'; 'Airflow'};
    callbacksCreate{10}.String = listbox;

        % Clica em 'Import variables'
        importVariables = findobj(gcf, 'string', 'Import variables');
        callbacksVariables = get(importVariables, 'Callback');

        % ecg     
        callbacksVariables{2}.UserData.sig.ecg.raw.data = ecg;
        callbacksVariables{2}.UserData.sig.ecg.raw.fs = fs;
        callbacksVariables{2}.UserData.sig.ecg.raw.time = linspace(0,length(ecg)-1,length(ecg)).*1/fs;

        % bp     
        callbacksVariables{2}.UserData.sig.bp.raw.data = abp;
        callbacksVariables{2}.UserData.sig.bp.raw.fs = fs;
        callbacksVariables{2}.UserData.sig.bp.raw.time = linspace(0,length(ecg)-1,length(abp)).*1/fs;

        % rsp     
        callbacksVariables{2}.UserData.sig.rsp.raw.data = flow_rate;
        callbacksVariables{2}.UserData.sig.rsp.raw.fs = fs;
        callbacksVariables{2}.UserData.sig.rsp.raw.time = linspace(0,length(ecg)-1,length(flow_rate)).*1/fs;

        % listbox 2
        callbacksVariables{3}.String = listbox;
        
    % Chamada do callback
    feval(callbackCreateHandle, createPatient, callbacksCreate{:});
    
    % Deletando Handles e limpando variáveis
    handles = findall(groot, 'Type', 'figure');
    delete(handles);
    
end
