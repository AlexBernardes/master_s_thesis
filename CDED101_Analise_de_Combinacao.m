% Agrupamento dos Marcadores Avaliados

marcadores_grupo_1 = ["MEDIA" "MEDIANA" "MINIMO" "QUARTIL_1" "QUARTIL_3"]; % Grupo dependente apenas do sinal de ECG/RRI
marcadores_grupo_2 = ["ABR_FIT_ESTIMATION" "IRM_ABR" "ABR_HF" "ABR_DYNAMIC_GAIN"]; % Grupo dependente dos sinais de ECG/RRI e BP/SBP
marcadores_grupo_3 = ["IRM_RCC" "RCC_LF" "RCC_HF" "RCC_DYNAMIC_GAIN" "RCC_FIT_ESTIMATION"]; % Grupo dependente dos sinais de ECG/RRI e RESP/ILV
marcadores_grupo_4 = [marcadores_grupo_1 marcadores_grupo_2];
marcadores_grupo_5 = [marcadores_grupo_1 marcadores_grupo_3];
marcadores_grupo_6 = [marcadores_grupo_2 marcadores_grupo_3];
marcadores_grupo_7 = [marcadores_grupo_1 marcadores_grupo_2 marcadores_grupo_3];

% Análise Combinatória

C_2_elem_grupo_1 = combntns(marcadores_grupo_1, 2)
C_3_elem_grupo_1 = combntns(marcadores_grupo_1, 3)
C_4_elem_grupo_1 = combntns(marcadores_grupo_1, 4)
C_5_elem_grupo_1 = combntns(marcadores_grupo_1, 5)

C_2_elem_grupo_2 = combntns(marcadores_grupo_2, 2)
C_3_elem_grupo_2 = combntns(marcadores_grupo_2, 3)
C_4_elem_grupo_2 = combntns(marcadores_grupo_2, 4)

C_2_elem_grupo_3 = combntns(marcadores_grupo_3, 2)
C_3_elem_grupo_3 = combntns(marcadores_grupo_3, 3)
C_4_elem_grupo_3 = combntns(marcadores_grupo_3, 4)
C_5_elem_grupo_3 = combntns(marcadores_grupo_3, 5)

C_2_elem_grupo_4 = combntns(marcadores_grupo_4, 2)
C_3_elem_grupo_4 = combntns(marcadores_grupo_4, 3)
C_4_elem_grupo_4 = combntns(marcadores_grupo_4, 4)
C_5_elem_grupo_4 = combntns(marcadores_grupo_4, 5)
C_6_elem_grupo_4 = combntns(marcadores_grupo_4, 6)
C_7_elem_grupo_4 = combntns(marcadores_grupo_4, 7)
C_8_elem_grupo_4 = combntns(marcadores_grupo_4, 8)
C_9_elem_grupo_4 = combntns(marcadores_grupo_4, 9)















