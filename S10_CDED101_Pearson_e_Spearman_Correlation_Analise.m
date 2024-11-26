%% Este scrips funcionará como a análise da correlação e não apenas o cálculo

JANELA = 2;

%% Caminho dos arquivos para extraír tabelas
path = "C:\Users\AlexA\Meu Drive\UnB - Mestrado - Regular\Projeto e Pesquisa\Repositório de Dados\Dados Pré-processados\CDED-1.0.1-final\Planilhas e Dados de Controle\";
cd(path);
 
%% Carregamento dos arquivos
arquivo_geral = "Correlacao_Marcadores_Gerais_Pearson_J" + string(JANELA)+ ".mat";
arquivo_controle = "Correlacao_Marcadores_Controle_Pearson_J" + string(JANELA)+ ".mat";
arquivo_dm = "Correlacao_Marcadores_DM_Pearson_J" + string(JANELA)+ ".mat";

load(fullfile(path, arquivo_geral));
load(fullfile(path, arquivo_controle));
load(fullfile(path, arquivo_dm));

%% Extraíndo headers para a tabela
headers = convertCharsToStrings(T_Manual_Geral(:, 6:width(T_Manual_Geral) - 1).Properties.VariableNames);

%% Para auxiliar na separação dos dados e na redução do volume. Todos os itens de correlação com P-value menor que 0.05
R_new_Geral = R_Manual_Geral;
R_new_Geral(P_Manual_Geral >= 0.05) = 0;

R_new_Controle = R_Manual_Controle;
R_new_Controle(P_Manual_Controle >= 0.05) = 0;

R_new_DM = R_Manual_DM;
R_new_DM(P_Manual_DM >= 0.05) = 0;

%% Para análise posterior e registro
writetable(array2table(R_new_Geral, 'VariableNames', headers), "Filtered_Corr_Pearson_Geral_J" + string(JANELA) + ".csv");
writetable(array2table(R_new_Controle, 'VariableNames', headers), "Filtered_Corr_Pearson_Controle_J" + string(JANELA) + ".csv");
writetable(array2table(R_new_DM, 'VariableNames', headers), "Filtered_Corr_Pearson_DM_J" + string(JANELA) + ".csv");

%% Carregamento dos arquivos
arquivo_geral_spearman = "Correlacao_Marcadores_Gerais_Spearman_J" + string(JANELA)+ ".mat";
arquivo_controle_spearman = "Correlacao_Marcadores_Controle_Spearman_J" + string(JANELA)+ ".mat";
arquivo_dm_spearman = "Correlacao_Marcadores_DM_Spearman_J" + string(JANELA)+ ".mat";

load(fullfile(path, arquivo_geral_spearman));
load(fullfile(path, arquivo_controle_spearman));
load(fullfile(path, arquivo_dm_spearman));

%% Extraíndo headers para a tabela
headers = convertCharsToStrings(T_Geral(:, 6:width(T_Geral) - 1).Properties.VariableNames);

%% Para auxiliar na separação dos dados e na redução do volume. Todos os itens de correlação com P-value menor que 0.05
rho_new_Geral = rho_Geral;
rho_new_Geral(pval_Geral >= 0.05) = 0;

rho_new_Controle = rho_Controle;
rho_new_Controle(pval_Controle >= 0.05) = 0;

rho_new_DM = rho_DM;
rho_new_DM(pval_DM >= 0.05) = 0;

%% Para análise posterior e registro
writetable(array2table(rho_new_Geral, 'VariableNames', headers), "Filtered_Corr_Spearman_Geral_J" + string(JANELA) + ".csv");
writetable(array2table(rho_new_Controle, 'VariableNames', headers), "Filtered_Corr_Spearman_Controle_J" + string(JANELA) + ".csv");
writetable(array2table(rho_new_DM, 'VariableNames', headers), "Filtered_Corr_Spearman_DM_J" + string(JANELA) + ".csv");





























































