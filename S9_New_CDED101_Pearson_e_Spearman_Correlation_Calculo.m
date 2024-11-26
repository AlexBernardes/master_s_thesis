%% Nova Análise de Correlação de Pearson.
JANELA = 2;

% Caminho para o arquivo com a tabela "T" com os marcadores extraídos.
% Arquivos separados por Janelas - 1 e 2.
path_data = "C:\Users\AlexA\Meu Drive\UnB - Mestrado - Regular\Projeto e Pesquisa\Repositório de Dados\Dados Pré-processados\CDED-1.0.1-final\Planilhas e Dados de Controle\";
cd(path_data);

%% Nome dos Arquivos
filename_data = "ALL_FEATURES_DATA_J" + string(JANELA) +  ".mat";
file_path = fullfile(path_data, filename_data);
load(file_path);

%% Preparando dados para análise.
% Control = 0
% Diabetes Mellitus = 1
T_Geral = T(T.LABEL ~= -1, :); %% Removendo dados de Pacientes com tipagem/label desconhecidas
T_Controle = T(T.LABEL == 0, :); 
T_DM = T(T.LABEL == 1, :);

% Obtendo dimensões da tabela
tableSize = size(T);

%% Análise de Correlação de Marcadores Com Remoção de Outliers.
% "Quartile Method" = Outliers are defined as elements more than 1.5 interquartile ranges above the upper quartile (75 percent) or below the lower quartile (25 percent). This method is useful when the data in A is not normally distributed.
% Outlier Limite Superior = Q3 + 1.5*(Q3 - Q1)
% Outlier Limite Inferior = Q1 - 1.5*(Q3 - Q1)

%% Remoção Manual de Outliers.
T_Manual_Geral = T_Geral;

for coluna=6:(tableSize(2) - 1) % Dados entre 1 e 5 são apenas identificadores; Última coluna são as labels.
    Quartils = quantile(T_Manual_Geral{:, coluna}, [0.25 0.75]);
    LimSup = Quartils(2) + 1.5*(Quartils(2) - Quartils(1));
    LimInf = Quartils(1) - 1.5*(Quartils(2) - Quartils(1));
    
    % Removendo Outliers.
    outliers = T_Manual_Geral{:, coluna} < LimInf | ...
                                T_Manual_Geral{:, coluna} > LimSup;
    
    T_Manual_Geral{outliers, coluna} = nan();
end

T_Manual_Controle = T_Controle;

for coluna=6:(tableSize(2) - 1) % Dados entre 1 e 5 são apenas identificadores; Última coluna são as labels.
    Quartils = quantile(T_Manual_Controle{:, coluna}, [0.25 0.75]);
    LimSup = Quartils(2) + 1.5*(Quartils(2) - Quartils(1));
    LimInf = Quartils(1) - 1.5*(Quartils(2) - Quartils(1));
    
    % Removendo Outliers.
    outliers = T_Manual_Controle{:, coluna} < LimInf | ...
                                T_Manual_Controle{:, coluna} > LimSup;
    
    T_Manual_Controle{outliers, coluna} = nan();
end

T_Manual_DM = T_DM;

for coluna=6:(tableSize(2) - 1) % Dados entre 1 e 5 são apenas identificadores; Última coluna são as labels.
    Quartils = quantile(T_Manual_DM{:, coluna}, [0.25 0.75]);
    LimSup = Quartils(2) + 1.5*(Quartils(2) - Quartils(1));
    LimInf = Quartils(1) - 1.5*(Quartils(2) - Quartils(1));
    
    % Removendo Outliers.
    
    
    outliers = T_Manual_DM{:, coluna} < LimInf | ...
                                T_Manual_DM{:, coluna} > LimSup;
    
    T_Manual_DM{outliers, coluna} = nan();
end

%% Correlação com T_Manual

[R_Manual_Geral, P_Manual_Geral, RLO_Manual_Geral, RUP_Manual_Geral] = corrcoef(table2array(T_Manual_Geral(:, 6:width(T_Manual_Geral)-1)),'Rows','pairwise');
[R_Manual_Controle, P_Manual_Controle, RLO_Manual_Controle, RUP_Manual_Controle] = corrcoef(table2array(T_Manual_Controle(:, 6:width(T_Manual_Geral)-1)),'Rows','pairwise');
[R_Manual_DM, P_Manual_DM, RLO_Manual_DM, RUP_Manual_DM] = corrcoef(table2array(T_Manual_DM(:, 6:width(T_Manual_DM)-1)),'Rows','pairwise');

% Labels
headers = convertCharsToStrings(T(:, 6:tableSize(2)-1).Properties.VariableNames);
labels = replace(headers, "_", "\_");

%%--------------------------------------------------
%% Criando o gráfico com a matrix de confiança GERAL
figure();
R_Grafico_Geral = heatmap(R_Manual_Geral, "MissingDataColor", "W");
R_Grafico_Geral.Title = "Matriz de Correlação (Pairwise) - Pacientes Gerais - Janela " + string(JANELA);
R_Grafico_Geral.Colormap = turbo;
caxis([-1, 1]);
set(R_Grafico_Geral,'defaulttextinterpreter','none');  
set(R_Grafico_Geral, 'defaultAxesTickLabelInterpreter','none');  
set(R_Grafico_Geral, 'defaultLegendInterpreter','none');

% Legend - Array with variables name
R_Grafico_Geral.XDisplayLabels = labels;
R_Grafico_Geral.YDisplayLabels = labels;

%% Criando o gráfico com a matrix de confiança Controle
figure();
R_Grafico_Controle = heatmap(R_Manual_Controle, "MissingDataColor", "W");
R_Grafico_Controle.Title = "Matriz de Correlação (Pairwise) - Pacientes Controle - Janela " + string(JANELA);
R_Grafico_Controle.Colormap = turbo;
caxis([-1, 1]);
set(R_Grafico_Controle,'defaulttextinterpreter','none');  
set(R_Grafico_Controle, 'defaultAxesTickLabelInterpreter','none');  
set(R_Grafico_Controle, 'defaultLegendInterpreter','none');

% Legend - Array with variables name
R_Grafico_Controle.XDisplayLabels = labels;
R_Grafico_Controle.YDisplayLabels = labels;

%% Criando o gráfico com a matrix de confiança DM
figure();
R_Grafico_DM = heatmap(R_Manual_DM, "MissingDataColor", "W");
R_Grafico_DM.Title = "Matriz de Correlação (Pairwise) - Pacientes Diabetes Mellitus - Janela " + string(JANELA);
R_Grafico_DM.Colormap = turbo;
caxis([-1, 1]);
set(R_Grafico_DM,'defaulttextinterpreter','none');  
set(R_Grafico_DM, 'defaultAxesTickLabelInterpreter','none');  
set(R_Grafico_DM, 'defaultLegendInterpreter','none');

% Legend - Array with variables name
R_Grafico_DM.XDisplayLabels = labels;
R_Grafico_DM.YDisplayLabels = labels;

%% Salvar como CSV e .mat
save('Correlacao_Marcadores_Gerais_Pearson_J' + string(JANELA) + '.mat', 'T_Manual_Geral', 'R_Manual_Geral', 'P_Manual_Geral', 'R_Grafico_Geral');
save('Correlacao_Marcadores_Controle_Pearson_J' + string(JANELA) + '.mat', 'T_Manual_Controle', 'R_Manual_Controle', 'P_Manual_Controle', 'R_Grafico_Controle');
save('Correlacao_Marcadores_DM_Pearson_J' + string(JANELA) + '.mat', 'T_Manual_DM', 'R_Manual_DM', 'P_Manual_DM', 'R_Grafico_Controle');

%%------------------------------------------------------------------------------------------
%%------------------------------------------------------------------------------------------
%%------------------------------------------------------------------------------------------

%% Trecho exclusivo para arquivos prontos para ML.
writetable(T_Manual_Geral, "Features_Without_Outliers_GERAL_Pearson_J" + string(JANELA) + ".csv");
writetable(T_Manual_Controle, "Features_Without_Outliers_CONTROLE_Pearson_J" + string(JANELA) + ".csv");
writetable(T_Manual_DM, "Features_Without_Outliers_DM_Pearson_J" + string(JANELA) + ".csv");

%% Para análise no Excel

% writetable(array2table(P_Manual_Geral, 'VariableNames', headers), "Features_Without_Outliers_GERAL_P_Matrix_Pearson_J" + string(JANELA) + ".csv");
% writetable(array2table(P_Manual_Controle, 'VariableNames', headers), "Features_Without_Outliers_CONTROLE_P_Matrix_Pearson_J" + string(JANELA) + ".csv");
% writetable(array2table(P_Manual_DM, 'VariableNames', headers), "Features_Without_Outliers_DM_P_Matrix_Pearson_J" + string(JANELA) + ".csv");
% 
% writetable(array2table(R_Manual_Geral, 'VariableNames', headers), "Features_Without_Outliers_GERAL_R_Matrix_Pearson_J" + string(JANELA) + ".csv");
% writetable(array2table(R_Manual_Controle, 'VariableNames', headers), "Features_Without_Outliers_CONTROLE_R_Matrix_Pearson_J" + string(JANELA) + ".csv");
% writetable(array2table(R_Manual_DM, 'VariableNames', headers), "Features_Without_Outliers_DM_R_Matrix_Pearson_J" + string(JANELA) + ".csv");

%%------------------------------------------------------------------------------------------
%%------------------------------------------------------------------------------------------
%%------------------------------------------------------------------------------------------

%% Teste para Correlação de Spearman é apropriado para dados não-normalizados e com outliers

[rho_Geral, pval_Geral] = corr(table2array(T_Geral(:, 6:width(T_Geral)-1)), 'Type', 'Spearman', 'Rows', 'pairwise');
[rho_Controle, pval_Controle] = corr(table2array(T_Controle(:, 6:width(T_Controle)-1)), 'Type', 'Spearman', 'Rows', 'pairwise');
[rho_DM, pval_DM] = corr(table2array(T_DM(:, 6:width(T_DM)-1)), 'Type', 'Spearman', 'Rows', 'pairwise');

%% Criando o gráfico com a matrix de confiança Geral
figure();
R_Grafico_Spearman_Geral = heatmap(rho_Geral, "MissingDataColor", "W");
R_Grafico_Spearman_Geral.Title = "Matriz de Correlação Spearman (Pairwise) - Pacientes Gerais - Janela " + string(JANELA);
R_Grafico_Spearman_Geral.Colormap = turbo;
caxis([-1, 1]);
set(R_Grafico_Spearman_Geral,'defaulttextinterpreter','none');  
set(R_Grafico_Spearman_Geral, 'defaultAxesTickLabelInterpreter','none');  
set(R_Grafico_Spearman_Geral, 'defaultLegendInterpreter','none');

% Legend - Array with variables name
R_Grafico_Spearman_Geral.XDisplayLabels = labels;
R_Grafico_Spearman_Geral.YDisplayLabels = labels;

%% Criando o gráfico com a matrix de confiança Controle
figure();
R_Grafico_Spearman_Controle = heatmap(rho_Controle, "MissingDataColor", "W");
R_Grafico_Spearman_Controle.Title = "Matriz de Correlação Spearman (Pairwise) - Pacientes Controle - Janela " + string(JANELA);
R_Grafico_Spearman_Controle.Colormap = turbo;
caxis([-1, 1]);
set(R_Grafico_Spearman_Controle,'defaulttextinterpreter','none');  
set(R_Grafico_Spearman_Controle, 'defaultAxesTickLabelInterpreter','none');  
set(R_Grafico_Spearman_Controle, 'defaultLegendInterpreter','none');

% Legend - Array with variables name
R_Grafico_Spearman_Controle.XDisplayLabels = labels;
R_Grafico_Spearman_Controle.YDisplayLabels = labels;

%% Criando o gráfico com a matrix de confiança DM
figure();
R_Grafico_Spearman_DM = heatmap(rho_DM, "MissingDataColor", "W");
R_Grafico_Spearman_DM.Title = "Matriz de Correlação Spearman (Pairwise) - Pacientes Diabetes Mellitus - Janela " + string(JANELA);
R_Grafico_Spearman_DM.Colormap = turbo;
caxis([-1, 1]);
set(R_Grafico_Spearman_DM,'defaulttextinterpreter','none');  
set(R_Grafico_Spearman_DM, 'defaultAxesTickLabelInterpreter','none');  
set(R_Grafico_Spearman_DM, 'defaultLegendInterpreter','none');

% Legend - Array with variables name
R_Grafico_Spearman_DM.XDisplayLabels = labels;
R_Grafico_Spearman_DM.YDisplayLabels = labels;

%% Salvar como CSV e .mat
save('Correlacao_Marcadores_Gerais_Spearman_J' + string(JANELA) + '.mat', 'T_Geral', 'rho_Geral', 'pval_Geral', 'R_Grafico_Spearman_Geral');
save('Correlacao_Marcadores_Controle_Spearman_J' + string(JANELA) + '.mat', 'T_Controle', 'rho_Controle', 'pval_Controle', 'R_Grafico_Spearman_Controle');
save('Correlacao_Marcadores_DM_Spearman_J' + string(JANELA) + '.mat', 'T_DM', 'rho_DM', 'pval_DM', 'R_Grafico_Spearman_DM');

%%------------------------------------------------------------------------------------------
%%------------------------------------------------------------------------------------------
%%------------------------------------------------------------------------------------------

%% Trecho exclusivo para arquivos prontos para ML.
writetable(T_Geral, "Features_With_Outliers_GERAL_Spearman_J" + string(JANELA) + ".csv");
writetable(T_Controle, "Features_With_Outliers_CONTROLE_Spearman_J" + string(JANELA) + ".csv");
writetable(T_DM, "Features_With_Outliers_DM_Spearman_J" + string(JANELA) + ".csv");

%% Para análise no Excel
% writetable(array2table(rho_Geral, 'VariableNames', headers), "Features_With_Outliers_GERAL_P_Matrix_Spearman_J" + string(JANELA) + ".csv");
% writetable(array2table(rho_Controle, 'VariableNames', headers), "Features_With_Outliers_CONTROLE_P_Matrix_Spearman_J" + string(JANELA) + ".csv");
% writetable(array2table(rho_DM, 'VariableNames', headers), "Features_With_Outliers_DM_P_Matrix_Spearman_J" + string(JANELA) + ".csv");
% 
% writetable(array2table(pval_Geral, 'VariableNames', headers), "Features_With_Outliers_GERAL_R_Matrix_Spearman_J" + string(JANELA) + ".csv");
% writetable(array2table(pval_Controle, 'VariableNames', headers), "Features_With_Outliers_CONTROLE_R_Matrix_Spearman_J" + string(JANELA) + ".csv");
% writetable(array2table(pval_DM, 'VariableNames', headers), "Features_With_Outliers_DM_R_Matrix_Spearman_J" + string(JANELA) + ".csv");

%%------------------------------------------------------------------------------------------
%%------------------------------------------------------------------------------------------
%%------------------------------------------------------------------------------------------





