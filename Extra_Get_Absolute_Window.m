%% Obter inicio e fim do trecho inicial de repouso
%% Declarando taxa de amostragem global

global marker_column;
marker_column = 1;

%% 0 - Ir para o diretório dos arquivos convertidos
path_of_converted = "C:\Users\AlexA\Meu Drive\UnB - Mestrado - Regular\Projeto e Pesquisa\Repositório de Dados\Dados Pré-processados\CDED-1.0.1-final\Dados Originais - Nao Tratados\LabviewV2\Dados Originais - Convertidos para Matlab\"; 
cd(path_of_converted);

%% 1 - Pegar todos os arquivos .mat presente na pasta do repositório dos arquivos convertidos e a dimensão da matriz de saída com o nome dos arquivos.
list_converted_files_data = ls("*.mat");
[numConvertedFiles, chars] = size(list_converted_files_data);

Matrix_X = [];

for i=1:numConvertedFiles
   
    %% Carrega Dados convertidos um a um para pegar dados importantes
    filename = list_converted_files_data(i, :);
    load(filename);
    
    marker_original_A = signal(1:175000, marker_column);
    marker_original_B = signal(175001:350000, marker_column);
    
    instantes_A = find(marker_original_A > 1);
    instantes_B = find(marker_original_B > 1);
    
    disp(filename);
        
    if ~isempty(instantes_A)
%         disp(instantes_A(length(instantes_A))/Fs);
        Matrix_X(i,1) = instantes_A(length(instantes_A))/Fs;
    else
%         disp(1/Fs);
        Matrix_X(i,1) = 1/Fs;
    end
    
    
    if ~isempty(instantes_B)
%         disp((instantes_B(1)+175000)/Fs);
        Matrix_X(i,2) = (instantes_B(1)+175000)/Fs;
    else
%         disp("Erro");
        Matrix_X(i,2) = -1;
    end

end