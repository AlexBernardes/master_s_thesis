%% Features Extraction - Dados de Diabetes Mellitus
%% Declarando taxa de amostragem global
global samplerate_ecg;
global ecg_column;
global abp_column;
global flow_rate_column;
global marker_column;

marker_column = 1;
ecg_column = 2;
abp_column = 3;
flow_rate_column = 8;

%% Ajustar trechos de cortes para o número de pacientes
%% Os dados originais não começam em 0 e não possuem exatamente 600 segundos. 
%% Por esse motivo é necessário ajustar um offset (começo e fim do sinal original).
offset = [
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

%% Declarando trechos de corte para o ECG 
janela_n = 2; % 1 ou 2
dm_protocol_cuts = [
180.5 420.5 400 640;% S0030
39.5 279.5 330 570;% S0033
142 382 0 0;% S0068
107 347 0 0;% S0078
0 0 0 0;% S0134
25 265 368 608;% S0153
12 252 276 516;% S0166
161.5 401.5 0 0;% S0174
223 463 372 612;% S0187
10 250 202 442;% S0197
0 240 179 419;% S0215
70 310 340 580;% S0221
209.5 449.5 420 660;% S0228
0 240 0 0;% S0264
0 240 160 400;% S0296
44.5 284.5 307 547;% S0301
53 293 387 627;% S0308
108.5 348.5 360 600;% S0314
81 321 269 509;% S0318
0 0 0 0;% S0366
109 349 0 0;% S0372
0.5 240.5 350 590;% S0411
107.5 347.5 286 526;% S0434
217 457 384 624;% S0452
53 293 358 598;% S0454
80 320 318 558;% S0513
0 0 0 0;% S0515
21 261 335 575;% S0522
0 240 221 461;% S0527
44 284 312 552;% S0531
95 335 365 605;% S0532
59.5 299.5 345 585;% S0534
22.5 262.5 0 0;% S0536
21 261 271 511;% S0539
90 330 266.5 506.5;% S0540
0 240 240 480;% S0541
22 262 322 562;% S0543
14.5 254.5 300.5 540.5;% S0544
55 295 350 590;% S0545
275 515 507 747;% S0546
88.5 328.5 369.5 609.5;% S0550
109 349 334 574;% S0551
0 240 189 429;% S0554
92 332 369.5 609.5;% S0555
123 363 383 623;% S0557
144 384 366 606;% S0560
238 478 478 718;% S0561
10 250 260 500;% S0562
19 259 290 530;% S0565
0 240 247 487;% S0569
109 349 0 0;% S0570
170 410 377 617;% S0575
55.5 295.5 310 550;% S0576
15 255 280 520;% S0578
28 268 335 575;% S0579
34 274 334.5 574.5;% S0580
7 247 318.5 558.5;% S0582
0 0 0 0;% S0583
157 397 363 603;% S0584
186.5 426.5 361.5 601.5;% S0585
21 261 294 534;% S0591
0 240 263 503;% S0592
0 0 0 0;% S0594
20 260 299.5 539.5;% S0595
29 269 333 573;% S0597
25 265 316 556;% S0600
92 332 346 586;% S0601
0 0 0 0;% S0608
0 240 245 485;% S0610
]; %% Os valores nesse vetor são dados em segundos. O intervalo está totalizando um sinal contínuo de 4 minutos.

% signalTypeMap = [
% % 1 1 1 1 0 0;
% 1 1 1 1 1 0;
% 1 1 1 0 0 0;
% 1 0 0 0 0 0;
% 0 0 0 0 0 0;
% 1 0 1 1 0 1;
% 1 1 0 1 0 1;
% 1 0 0 0 0 0;
% 1 1 0 1 0 0;
% 1 1 1 1 1 1;
% 1 0 1 0 0 0;
% 1 0 1 1 1 1;
% 1 1 1 1 1 0;
% 1 0 1 1 0 1;
% 1 1 1 1 1 1;
% 1 1 1 1 1 1;
% 1 1 1 1 1 1;
% 1 1 1 1 1 1;
% 1 1 1 1 1 1;
% 0 0 0 0 0 0;
% 1 0 1 0 0 0;
% 1 1 0 1 0 0;
% 1 0 1 1 0 1;
% 1 1 1 1 1 1;
% 1 1 1 1 1 1;
% 1 1 1 1 1 1;
% 0 0 0 0 0 0;
% 1 1 1 1 1 1;
% 1 0 1 1 0 1;
% 1 0 1 1 0 1;
% 1 1 1 1 1 1;
% 1 1 1 1 1 1;
% 1 1 1 0 0 0;
% 1 1 0 1 1 1;
% 1 0 1 1 1 1;
% 1 1 1 1 1 1;
% 1 1 1 1 1 1;
% 1 0 1 1 0 1;
% 1 1 1 1 1 1;
% 1 1 1 1 1 1;
% 1 0 1 1 0 1;
% 1 1 1 1 1 1;
% 1 1 1 1 1 1;
% 1 0 1 1 1 1;
% 1 1 1 1 1 1;
% 1 1 1 1 1 1;
% 1 1 1 1 1 1;
% 1 0 1 1 0 1;
% 1 0 1 1 0 1;
% 1 1 1 1 1 1;
% 1 1 1 0 0 0;
% 1 1 1 1 0 1;
% 1 1 0 1 1 0;
% 1 0 1 1 0 0;
% 1 0 1 1 0 1;
% 1 0 1 1 1 1;
% 1 1 1 1 0 1;
% 0 0 0 0 0 0;
% 1 0 1 1 0 0;
% 0 0 0 1 1 1;
% 1 0 1 1 0 1;
% 1 0 0 1 1 1;
% 0 0 0 0 0 0;
% 1 0 1 1 0 1;
% 1 1 1 1 1 1;
% 1 1 1 1 1 1;
% 1 1 0 1 0 0;
% 0 0 0 0 0 0;
% 1 1 0 1 0 1;
% ];

%% 0 - Ir para o diretório dos arquivos convertidos
path_of_converted = "C:\Users\AlexA\Meu Drive\UnB - Mestrado - Regular\Projeto e Pesquisa\Repositório de Dados\Dados Pré-processados\CDED-1.0.1-final\Dados Originais - Nao Tratados\LabviewV2\Dados Originais - Convertidos para Matlab\"; 
cd(path_of_converted);

%% 1 - Pegar todos os arquivos .mat presente na pasta do repositório dos arquivos convertidos e a dimensão da matriz de saída com o nome dos arquivos.
list_converted_files_data = ls("*.mat");
[numConvertedFiles, chars] = size(list_converted_files_data);

%% 1.1 - Criar uma pasta para salvar os arquivos refinados.
path_abp_data = "C:\Users\AlexA\Meu Drive\UnB - Mestrado - Regular\Projeto e Pesquisa\Repositório de Dados\Dados Pré-processados\CDED-1.0.1-final\Dados Processados - Separacao de Dados\Pressao Arterial\";
[SUCCESS,MESSAGE,MESSAGEID] = mkdir(path_abp_data);
path_rf_data = "C:\Users\AlexA\Meu Drive\UnB - Mestrado - Regular\Projeto e Pesquisa\Repositório de Dados\Dados Pré-processados\CDED-1.0.1-final\Dados Processados - Separacao de Dados\Fluxo Respiratorio\";
[SUCCESS,MESSAGE,MESSAGEID] = mkdir(path_rf_data);
path_ecg_data = "C:\Users\AlexA\Meu Drive\UnB - Mestrado - Regular\Projeto e Pesquisa\Repositório de Dados\Dados Pré-processados\CDED-1.0.1-final\Dados Processados - Separacao de Dados\Eletrocardiograma\";
[SUCCESS,MESSAGE,MESSAGEID] = mkdir(path_ecg_data);
path_agrupado_data = "C:\Users\AlexA\Meu Drive\UnB - Mestrado - Regular\Projeto e Pesquisa\Repositório de Dados\Dados Pré-processados\CDED-1.0.1-final\Dados Processados - Separacao de Dados\Agrupados\";
[SUCCESS,MESSAGE,MESSAGEID] = mkdir(path_agrupado_data);

%% 2 - utilizar um loop para separar os dados de janelas nos intervalos selecionados.
for i=1:numConvertedFiles

    disp("arquivo : " + i);
    
    %% Pula paciente descartado
    if janela_n == 1
        if (isequal(dm_protocol_cuts(i,1:2), [0 0]))
            continue
        end
    else
        if (isequal(dm_protocol_cuts(i,3:4), [0 0]))
            continue
        end
    end
    
    %% Carrega Dados convertidos um a um para pegar dados importantes
    filename = list_converted_files_data(i, :);
    load(filename);
    
    %% Obtendo dados de ECG
    marker_original = signal(:, marker_column);
    abp_original = signal(:, abp_column);
    flow_rate_original = signal(:, flow_rate_column);
    ecg_original = signal(:, ecg_column);
    fs = Fs;
    
    %% Por limitação da lib, devemos inicializar a taxa de amostragem do sinal antes de extrair os dados
    samplerate_ecg = double(fs);
    
    disp(offset(i, :));
    disp(dm_protocol_cuts(i,:));
    
    %% Ajustando vetor de tempo para ms
    if janela_n == 1
        cuts = (offset(i, 1) + dm_protocol_cuts(i,1:2)).*fs;
    else
        cuts = (offset(i, 1) + dm_protocol_cuts(i,3:4)).*fs;
    end
    
    cuts = [int64((cuts(:,1)+1)) int64(cuts(:,2))]; % Corrigindo janela para intervalo aberto pela esquerda e fechado pela direita.
    
    %% Corte
    if (length(ecg_original) < cuts(1))
        continue
    end
    
    if (length(ecg_original) >= cuts(2))
        marker = marker_original(cuts(1):cuts(2));
        ecg = ecg_original(cuts(1):cuts(2));
        abp = abp_original(cuts(1):cuts(2));
        flow_rate = flow_rate_original(cuts(1):cuts(2));
        tm_cut = tm(cuts(1):cuts(2));
    else %% Caso de análise com erro
        disp("Erro" + i);
        continue
    end

    %% Configurando o nome do arquivo e path
    abp_filename = strcat(extractBefore(filename ,"-v2m.mat"), "-4minutes-j", string(janela_n), "-abp.mat");
    path_abp_data_file = fullfile(path_abp_data, abp_filename);
    %% Salvar o ABP no formato do ECGLab
    save(path_abp_data_file, "abp", "fs");

    %% Configurando o nome do arquivo e path
    rf_filename = strcat(extractBefore(filename ,"-v2m.mat"), "-4minutes-j", string(janela_n), "-rf.mat");
    path_rf_data_file = fullfile(path_rf_data, rf_filename);
    %% Salvar o frair no formato do ECGLab
    save(path_rf_data_file, "flow_rate", "fs");

    %% Configurando o nome do arquivo e path
    ecg_filename = strcat(extractBefore(filename ,"-v2m.mat"), "-4minutes-j", string(janela_n), "-ecg.mat");
    path_ecg_data_file = fullfile(path_ecg_data, ecg_filename);
    %% Salvar o ECG no formato do ECGLab
    save(path_ecg_data_file, "ecg", "fs");
    
    %% Configurando o nome do arquivo e path
    ecg_filename = strcat(extractBefore(filename ,"-v2m.mat"), "-4minutes-j", string(janela_n), "-agrupado.mat");
    path_agrupado_data_file = fullfile(path_agrupado_data, ecg_filename);
    %% Salvar o Agrupado no formato do ECGLab
    save(path_agrupado_data_file, "ecg", "abp", "flow_rate", "fs", "tm_cut", "marker");

end

%% Limpar tudo
clear;