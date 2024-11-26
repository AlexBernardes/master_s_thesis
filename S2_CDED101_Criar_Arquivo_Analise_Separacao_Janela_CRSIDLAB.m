%% Separação de Janelas - Criação do Arquivo Tipo Paciente Com Dados Completos para visualização.
%% Declarando taxa de amostragem global

global ecg_column;
global abp_column;
global flow_rate_column;
global marker_column;

marker_column = 1;
ecg_column = 2;
abp_column = 3;
flow_rate_column = 8;

protocolo_corte_respouso = [
2.4200 643.7480;% S0030
3.4480 608.3280;% S0033
1.6260 601.9420;% S0068
2.2720 607.9680;% S0078
3.6860 597.6560;% S0134
5.8220 614.2580;% S0153
2.6240 604.2460;% S0166
0.0020 600.7720;% S0174
3.6000 616.3620;% S0187
19.4920 618.3100;% S0197
13.1340 611.6660;% S0215
3.1100 598.5780;% S0221
46.2500 651.8440;% S0228
4.5340 665.4720;% S0264
8.1100 613.0040;% S0296
8.7220 570.2360;% S0301
3.6680 684.8920;% S0308
7.8600 607.9480;% S0314
6.0800 605.1100;% S0318
2.5640 609.6280;% S0366
3.1180 608.5700;% S0372
3.3440 600.6120;% S0411
5.7080 604.6540;% S0434
3.1140 627.6340;% S0452
25.6520 659.7260;% S0454
6.3140 618.2580;% S0513
3.7880 1807.9100;% S0515
5.7700 601.2780;% S0522
24.3920 626.1760;% S0527
1.7520 604.8440;% S0531
3.7820 624.7260;% S0532
3.5680 602.2660;% S0534
2.9760 603.9380;% S0536
4.4660 612.8640;% S0539
4.6680 609.6060;% S0540
3.4580 603.2700;% S0541
3.8000 600.4380;% S0543
3.2120 602.6360;% S0544
14.6600 605.8040;% S0545
2.6340 750.4560;% S0546
4.0320 621.3320;% S0550
3.7180 602.7340;% S0551
2.4960 595.3480;% S0554
1.8140 629.4680;% S0555
2.0940 633.0880;% S0557
7.1920 613.8100;% S0560
3.4280 721.4860;% S0561
36.0500 638.1740;% S0562
1.9500 602.5240;% S0565
3.6080 652.0900;% S0569
2.4580 611.9240;% S0570
0.0020 617.4040;% S0575
3.3760 620.4640;% S0576
4.2300 614.1840;% S0578
5.8220 614.2580;% S0579
3.9460 600.7340;% S0580
3.8180 600.6160;% S0582
13.1340 615.5000;% S0583
4.6260 607.4100;% S0584
8.6480 621.5520;% S0585
47.8640 601.9160;% S0591
0.0020 607.3500;% S0592
2.9100 636.5180;% S0594
466.1140 1072.2100;% S0595
5.7420 635.1320;% S0597
1.6160 610.0620;% S0600
5.1760 631.1100;% S0601
3.0180 698.6460;% S0608
18.7940 618.5940;% S0610
];

%% Ajustando intervalo correto de repouso de aproximadamente 10 mimnutos dos pacientes v2

%% 0 - Ir para o diretório dos arquivos convertidos
path_of_converted = "C:\Users\AlexA\Meu Drive\UnB - Mestrado - Regular\Projeto e Pesquisa\Repositório de Dados\Dados Pré-processados\CDED-1.0.1-final\Dados Originais - Nao Tratados\LabviewV2\Dados Originais - Convertidos para Matlab\"; 
cd(path_of_converted);

%% 1 - Pegar todos os arquivos .mat presente na pasta do repositório dos arquivos convertidos e a dimensão da matriz de saída com o nome dos arquivos.
list_converted_files_data = ls("*.mat");
[numConvertedFiles, chars] = size(list_converted_files_data);

%% 2 - Criar uma pasta para salvar os arquivos para separação de janelas
path_separacao_janelas = "C:\Users\AlexA\Meu Drive\UnB - Mestrado - Regular\Projeto e Pesquisa\Repositório de Dados\Dados Pré-processados\CDED-1.0.1-final\Dados Originais - Nao Tratados\LabviewV2\Dados Originais - Tipo Paciente Completo - Para Selecao de Janelas\";
[SUCCESS,MESSAGE,MESSAGEID] = mkdir(path_separacao_janelas);

%% 3 - Carregando caminho do software
path_software = "C:\Users\AlexA\Meu Drive\UnB - Mestrado - Regular\Projeto e Pesquisa\Repositório de Dados\Dados Pré-processados\Softwares\CRSIDLab_2_0\CRSIDLab_Fev2023\";
cd(path_software);

%% 4 - utilizar um loop para separar os dados de janelas nos intervalos selecionados.
for i=1:numConvertedFiles
    
    disp("arquivo : " + i)
    
    % Carregando arquivo com dados agrupados
    filename = list_converted_files_data(i, :);
    load(fullfile(path_of_converted, filename));
    
    %% Obtendo dados Originais
    fs = Fs;
    abp = signal(protocolo_corte_respouso(i,1)*Fs:protocolo_corte_respouso(i,2)*Fs, abp_column);
    flow_rate = signal(protocolo_corte_respouso(i,1)*Fs:protocolo_corte_respouso(i,2)*Fs, flow_rate_column);
    ecg = signal(protocolo_corte_respouso(i,1)*Fs:protocolo_corte_respouso(i,2)*Fs, ecg_column);
    
    % Criando nome do arquivo paciente
%     patientID = convertCharsToStrings(filename);
    patientID = extractBefore(filename, "-v2m.mat");
    
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

    %% Salvando arquivo
    folderToStoreFile = convertStringsToChars(path_separacao_janelas);
    callbacksCreate{3}.String = folderToStoreFile;

    listbox = {'Raw ECG'; 'Raw BP'; 'Airflow'};
    callbacksCreate{10}.String = listbox;

        % Clica em 'Import variables'
        importVariables = findobj(gcf, 'string', 'Import variables');
        callbacksVariables = get(importVariables, 'Callback');

        % ecg     
        callbacksVariables{2}.UserData.sig.ecg.raw.data = ecg;
        callbacksVariables{2}.UserData.sig.ecg.raw.fs = fs;
        callbacksVariables{2}.UserData.sig.ecg.raw.time =  linspace(0,length(ecg)-1,length(ecg)).*1/fs;

        % bp     
        callbacksVariables{2}.UserData.sig.bp.raw.data = abp;
        callbacksVariables{2}.UserData.sig.bp.raw.fs = fs;
        callbacksVariables{2}.UserData.sig.bp.raw.time =  linspace(0,length(ecg)-1,length(abp)).*1/fs;

        % rsp     
        callbacksVariables{2}.UserData.sig.rsp.raw.data = flow_rate;
        callbacksVariables{2}.UserData.sig.rsp.raw.fs = fs;
        callbacksVariables{2}.UserData.sig.rsp.raw.time =  linspace(0,length(ecg)-1,length(flow_rate)).*1/fs;

        % listbox 2
        callbacksVariables{3}.String = listbox;
        
    % Chamada do callback
    feval(callbackCreateHandle, createPatient, callbacksCreate{:});
    
    % Deletando Handles e limpando variáveis
    handles = findall(groot, 'Type', 'figure');
    delete(handles);
    
end
