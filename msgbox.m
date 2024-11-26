function handle = msgbox(texto1,texto2,texto3, ~)
    disp(strcat(texto1, texto2, texto3));
    handle = figure();
    close(handle);
    