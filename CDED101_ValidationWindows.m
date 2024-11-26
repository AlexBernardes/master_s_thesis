MapWindowCDED101 = [
140	380	230	470;% S0030
80	320	300	540;% S0033
0	0	0	0;% S0064 - Sem Dados
60	300	330	570;% S0068
110	350	200	440;% S0078
0	0	0	0;% S0105 - Sem Dados
200	440	280	520;% S0134 - Tem dados, mas não registrado
300	540	360	600;% S0153
10	250	130	370;% S0166
0	240	0	0;% S0174
155	395	360	600;% S0187
35	275	215	455;% S0197
0	240	225	465;% S0215
330	570	75	315;% S0221
50	290	270	510;% S0228
0	0	0	0;% S0233 - Sem Dados
115	355	0	240;% S0264
0	0	0	0;% S0292 - Sem Dados
20	260	165	405;% S0296
55	295	300	540;% S0301
20	260	300	540;% S0308
110	350	360	600;% S0314
90	330	270	510;% S0318
360	600	85	325;% S0366
240	480	95	335;% S0372
0	240	300	540;% S0411
0	0	0	0;% S0430 - Sem Dados
95	335	360	600;% S0434
255	495	360	600;% S0452
15	255	130	370;% S0454
36	276	290	530;% S0513
0	0	0	0;% S0515 - Paciente Descartado, porém existente
0	0	0	0;% S0516 - Sem Dados
40	280	280	520;% S0522
0	0	0	0;% S0523 - Sem Dados
45	285	260	500;% S0527
35	275	300	540;% S0531
85	325	360	600;% S0532
180	420	345	585;% S0534
80	320	360	600;% S0536
20	260	275	515;% S0539
60	300	300	540;% S0540
160	400	360	600;% S0541
160	400	360	600;% S0543
0	240	340	580;% S0544
65	305	230	470;% S0545
0	240	230	470;% S0546
65	305	0	0;% S0550
115	355	340	580;% S0551
0	0	0	0;% S0552 - Sem Dados
205	445	0	240;% S0554
360	600	0	0;% S0555
115	355	360	600;% S0557
135	375	360	600;% S0560
360	600	195	435;% S0561
60	300	360	600;% S0562
0	0	0	0;% S0564 - Sem Dados
100	340	360	600;% S0565
215	455	330	570;% S0569
95	335	215	455;% S0570
0	0	0	0;% S0574 - Sem Dados
175	415	290	530;% S0575
60	300	360	600;% S0576
60	300	360	600;% S0578
0	240	360	600;% S0579
0	240	360	600;% S0580
0	240	320	560;% S0582
60	300	360	600;% S0583
190	430	360	600;% S0584
285	525	0	0;% S0585
60	300	340	580;% S0591
240	480	360	600;% S0592
65	305	340	580;% S0594
360	600	0	0;% S0595
155	395	360	600;% S0597
10	250	360	600;% S0600
85	325	190	430;% S0601
20	260	310	550;% S0608
185	425	360	600;% S0610
];

% Verification for time window equals 240s
disp('%%%%%%%%%%%%% Verificação de time window %%%%%%%%%%%%%')
wrongTimeWindow = 0;
for i=1:length(MapWindowCDED101)
    if (MapWindowCDED101(i, 2) - MapWindowCDED101(i, 1) ~= 240 && MapWindowCDED101(i, 2) - MapWindowCDED101(i, 1) ~= 0)
        disp('Erro Janela 1: ');
        MapWindowCDED101(i, :)
        wrongTimeWindow = wrongTimeWindow + 1;
    end 
    if (MapWindowCDED101(i, 4) - MapWindowCDED101(i, 3) ~= 240 && MapWindowCDED101(i, 4) - MapWindowCDED101(i, 3) ~= 0)
        disp('Erro Janela 2' + string(i));
        MapWindowCDED101(i, :)
        wrongTimeWindow = wrongTimeWindow + 1;
    end 
end

% Verification for overlap max 50%
disp('%%%%%%%%%%%%% Verificação de Overlap %%%%%%%%%%%%%')
overlapPatients = 0;
for i=1:length(MapWindowCDED101)
    
    patient = MapWindowCDED101(i, :);
    
    % Verify if windows are not 100% overlapped
    uni = unique(patient);
    
    if (numel(uni) ~= 4)
        continue;
        %disp('Erro Patient: ' + string(i));
        %MapWindowCDED101(i, :)
    end
    
    % Verify overlap
    % remove the biggest and smallest number, take the absolute of the
    % differente of the remaining two.
    window_1 = patient(1:2);
    window_2 = patient(3:4);
    
    % Reorganizando janelas
    if window_1(2) > window_2(2)
        patient = [window_2 window_1];
    else
        patient = [window_1 window_2];
    end
    
    overlap = ((patient(3)-patient(2))/240)*100;
    
    if (abs(overlap) > 75 && overlap < 0) % Mais de 3 minutos
        disp('Sobreposição Excessiva: ' + string(overlap));
        disp('Paciente: ' + string(i));
        MapWindowCDED101(i, :)
        overlapPatients = overlapPatients + 1;
    elseif (abs(overlap) > 75 && overlap > 0)
        continue
    end
    
end

MapSignalSelectionCDED101 = [
% ECG, BP, ILV
1   1   1   1   1   1;% S0030
1   1   1   1   1   1;% S0033
0   0   0   0   0   0;% S0064
1   1   0   0   0   1;% S0068
1   0   0   0   1   1;% S0078
0   0   0   0   0   0;% S0105
1   0   1   1   0   1;% S0134 67% - Tem dados, mas não registrado
1   0   1   1   0   1;% S0153 75%
1   1   0   1   0   1;% S0166
0   0   1   0   0   0;% S0174
1   0   0   1   0   0;% S0187
1   1   1   1   1   1;% S0197
1   0   1   1   0   1;% S0215
1   1   0   1   0   1;% S0221
1   0   1   1   1   1;% S0228
0   0   0   0   0   0;% S0233
0   0   1   1   0   0;% S0264
0   0   0   0   0   0;% S0292
1   1   1   1   1   0;% S0296
1   1   1   1   1   0;% S0301
1   1   1   1   1   1;% S0308
1   1   1   1   1   0;% S0314
1   1   1   1   1   1;% S0318
1   1   0   1   0   1;% S0366
1   0   1   0   0   1;% S0372
1   0   1   1   0   0;% S0411
0   0   0   0   0   0;% S0430
1   0   1   1   0   1;% S0434
1   1   1   1   1   0;% S0452
1   1   1   1   1   0;% S0454
1   1   1   1   0   1;% S0513 // Validar nos dados
0   0   0   0   0   0;% S0515 - Paciente Descartado, porém existente
0   0   0   0   0   0;% S0516
1   1   1   1   1   1;% S0522
0   0   0   0   0   0;% S0523
1   0   1   1   0   1;% S0527
1   0   1   1   0   0;% S0531
1   1   1   1   1   1;% S0532
1   1   1   1   1   1;% S0534
1   1   1   1   1   1;% S0536
1   1   1   1   1   1;% S0539
1   0   0   1   0   0;% S0540
1   1   1   1   0   1;% S0541
1   1   1   1   1   1;% S0543
1   0   1   1   0   0;% S0544
1   1   1   1   1   1;% S0545
1   0   1   1   0   1;% S0546
0   0   1   0   0   0;% S0550
1   1   0   1   1   1;% S0551
0   0   0   0   0   0;% S0552
1   1   0   1   0   1;% S0554
1   1   0   0   0   0;% S0555
1   1   1   1   1   0;% S0557
1   1   1   1   1   1;% S0560
1   1   1   1   0   1;% S0561
1   0   1   1   0   1;% S0562
0   0   0   0   0   0;% S0564
1   0   1   1   0   0;% S0565
1   1   1   1   1   0;% S0569
1   1   1   1   0   0;% S0570
0   0   0   0   0   0;% S0574
1   0   1   1   0   1;% S0575
1   0   0   1   0   0;% S0576
1   0   0   1   0   0;% S0578
1   0   0   1   0   1;% S0579
1   0   1   1   1   1;% S0580
1   0   1   1   0   1;% S0582
0   0   1   0   0   1;% S0583
1   0   1   1   0   0;% S0584
1   1   1   0   0   0;% S0585
1   0   1   1   0   1;% S0591
1   1   1   1   1   1;% S0592
0   0   1   0   0   1;% S0594
1   0   1   0   0   0;% S0595
1   1   0   1   1   1;% S0597
1   1   1   1   1   0;% S0600
1   1   1   1   0   1;% S0601
0   0   1   0   0   1;% S0608
1   0   1   1   0   1;% S0610
];

% Verificação de classes
ECG_N = sum(MapSignalSelectionCDED101(:, 1)) + sum(MapSignalSelectionCDED101(:, 4));
BP_N = sum(MapSignalSelectionCDED101(:, 2)) + sum(MapSignalSelectionCDED101(:, 5));
ILV_N = sum(MapSignalSelectionCDED101(:, 3)) + sum(MapSignalSelectionCDED101(:, 6));

ECG_BP_N = 0;
ECG_ILV_N = 0;
BP_ILV_N = 0;
ECG_BP_ILV_N = 0;
DELETED_N = 0;
for i=1:length(MapSignalSelectionCDED101)
    
    if MapSignalSelectionCDED101(i, 1) == 1 && MapSignalSelectionCDED101(i, 2) == 1
        ECG_BP_N = ECG_BP_N + 1; 
    end
    if MapSignalSelectionCDED101(i, 4) == 1 && MapSignalSelectionCDED101(i, 5) == 1
        ECG_BP_N = ECG_BP_N + 1; 
    end
    
    if MapSignalSelectionCDED101(i, 1) == 1 && MapSignalSelectionCDED101(i, 3) == 1
        ECG_ILV_N = ECG_ILV_N + 1;
    end
    if MapSignalSelectionCDED101(i, 4) == 1 && MapSignalSelectionCDED101(i, 6) == 1
        ECG_ILV_N = ECG_ILV_N + 1;
    end
    
    if MapSignalSelectionCDED101(i, 2) == 1 && MapSignalSelectionCDED101(i, 3) == 1
        BP_ILV_N = BP_ILV_N + 1;
    end
    if MapSignalSelectionCDED101(i, 5) == 1 && MapSignalSelectionCDED101(i, 6) == 1
        BP_ILV_N = BP_ILV_N + 1;
    end
    
    if MapSignalSelectionCDED101(i, 1) == 1 && MapSignalSelectionCDED101(i, 2) == 1 && MapSignalSelectionCDED101(i, 3) == 1
        ECG_BP_ILV_N = ECG_BP_ILV_N + 1;
    end
    
    if MapSignalSelectionCDED101(i, 4) == 1 && MapSignalSelectionCDED101(i, 5) == 1 && MapSignalSelectionCDED101(i, 6) == 1
        ECG_BP_ILV_N = ECG_BP_ILV_N + 1;
    end
        

    if sum(MapSignalSelectionCDED101(i, :)) == 0
        DELETED_N = DELETED_N + 1;
    end
        
end

% Relatório
disp('%%%%%%%%%%%%% Relatório %%%%%%%%%%%%%')

disp('Pacientes com seleção de janela errados: ' + string(wrongTimeWindow))
disp('Pacientes com overlap excessivo (>75%): ' + string(overlapPatients));

disp('Janelas com ECG: ' + string(ECG_N));
disp('Janelas com BP: ' + string(BP_N));
disp('Janelas com ILV: ' + string(ILV_N));

disp('Janelas com ECG e BP: ' + string(ECG_BP_N));
disp('Janelas com ECG e ILV: ' + string(ECG_ILV_N));
disp('Janelas com BP e ILV: ' + string(BP_ILV_N));
disp('Janelas com ECG, BP e BP: ' + string(ECG_BP_ILV_N));

disp('Pacientes Deletados: ' + string(DELETED_N));














