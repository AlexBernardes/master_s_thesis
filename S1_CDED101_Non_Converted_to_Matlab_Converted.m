%% 0 - Ir para a pasta do repositório
path_data = "C:\Users\AlexA\Meu Drive\UnB - Mestrado - Regular\Projeto e Pesquisa\Repositório de Dados\Dados Pré-processados\CDED-1.0.1-v2\Dados Experimento\Non-converted\Labview-v2\";
cd(path_data);

%% 0.1 - Criar uma pasta para salvar os arquivos convertidos.
path_of_converted = "C:\Users\AlexA\Meu Drive\UnB - Mestrado - Regular\Projeto e Pesquisa\Repositório de Dados\Dados Pré-processados\CDED-1.0.1-v2\Dados Experimento\Matlab-converted\Labview-v2\"; 
[SUCCESS,MESSAGE,MESSAGEID] = mkdir(path_of_converted);

%% 1 - Pegar todos os arquivos .dat presente na pasta do repositório e a dimensão da matriz de saída
list_files_dat = ls("*.dat");
[numFiles, chars] = size(list_files_dat);

%% 2 - Utilizar um loop para extrair os dados e salvá-los em formato .mat do MATLAB
for i = 1:numFiles
    
    disp("arquivo : " + i);
    
    %% 2.1 - Pega o arquivo sem a extensão no final
    file = extractBefore(list_files_dat(i,:),".dat");
    
    %% 2.2 - Transforma o arquivo .dat e .hea para arquivos .mat e um novo .hea terminados em "m"
    wfdb2mat(file);
    
    %% 2.3 - Cria uma String com o nome do arquivo convertido.
    converted_file = strcat(file, 'm');
    
    %% 2.4 - Separa os Dados do arquivo .mat para criarmos um novo arquivo .mat mais organizado.
    [tm,signal,Fs,labels]=rdmat(converted_file);
    
    %% 2.5 - Salvando o arquivo .mat mais organizado para a pasta de arquivos convertidos.
    save(fullfile(path_of_converted, strcat(converted_file, '.mat')), 'tm', 'signal', 'Fs', 'labels');
    
    %% 2.6 - Delete garbage files
    delete(strcat(converted_file, '.mat'));
    delete(strcat(converted_file, '.hea'));
end