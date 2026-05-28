clear variables;
close all force;
clc;
warning off;

graphics_toolkit("fltk");

pkg load image;
pkg load retro_games;
% =====================================================
% variaveis de debug
loop_enter = false %se vai entrar no loop padrão(true)
pc_view = false %modo para ver como o pc está vizualizando os objetos padrão(false)
auto_reset = false %se vai reiniciar automaticamente quando o mario morrer padrão(true)

% =====================================================
% inicia jogo no momento ideal e salva esse momento
[jogo, startpoint] = inicializar_emulador("DK.nes");
% Cria a janela do jogo com um controle de estado para para o loop
fig = figure('Name', 'Donkey Kong');
set(fig, 'UserData', true);
% Só fecha se a tecla pressionada for 'escape'
set(fig, 'KeyPressFcn', @(obj, event) strcmp(event.Key, 'escape') && set(obj, 'UserData', false));
% =====================================================

%inicialização

%checa se os arquivos existem e os carrega ou cria
if exist('mapa_dk_level1.mat', 'file') && exist('mc_template.mat', 'file')
    load('mapa_dk_level1.mat');
    load('mc_template.mat');
else
    [mapa, mc] = varreduraInicial(jogo);
    jogo.set_state(startpoint);
end

if loop_enter == false

else
    % =====================================================
    % trecho para preparar par começar o jogo
    % config grafica
    figure(fig);
    % Pega a primeira imagem para inicializar os gráficos
    img_inicial = jogo.get_image(); 

    if pc_view
        % tela do jogo
        subplot(1, 2, 1); 
        img_plot_pc = imshow(img_inicial); 
        title('Visão Normal');

        % Visão do Computador
        subplot(1, 2, 2); 
        imshow(mapa.plataformas);
        title('PC View');
        hold on;

        % Desenha as escadas uma única vez
        for i = 1:length(mapa.escadas_lista)
            x_escada = mapa.escadas_lista(i).x_centro;
            y_topo = mapa.escadas_lista(i).y_topo;
            y_base = mapa.escadas_lista(i).y_base;
            plot([x_escada, x_escada], [y_topo, y_base], 'g-', 'LineWidth', 2); 
        end

        % Prepara o ponto do Mario
        mario_plot = plot(NaN, NaN, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 8);
        hold off;
    else
        % Modo normal: cria apenas uma tela ocupando tudo
        img_plot = imshow(img_inicial);
    end
    % =====================================================
    % configurações antes do loop
    frames_sem_mario = 0;
    limite_sumido = 3;

    % =====================================================

    while get(fig, 'UserData') == true
        % ===== tick =====
        % step
        jogo.step(2);
        imc = jogo.get_image();
        img = rgb2gray(imc);
        % logica
        [mx, my, mscr] = localizar_mario(img, mc);

        % ===== CONTROLE DE MORTE / RESET =====
        if auto_reset
            if mscr > 0.5 
                frames_sem_mario = 0; % Se achou o Mario, zera o contador
            else
                frames_sem_mario = frames_sem_mario + 1; % Se não achou, incrementa
            end

            % Se estourou o limite de frames sumido reseta
            if frames_sem_mario >= limite_sumido
                disp('Mario sumiu/morreu! Resetando para o ponto inicial...');
                jogo.set_state(startpoint);
                frames_sem_mario = 0;
                if pc_view
                    set(mario_plot, 'XData', NaN, 'YData', NaN);
                end
                continue; % Pula o restante do loop
            end
        end
        % ===== render =====
        if pc_view
            % Atualiza a tela da ESQUERDA (Jogo Normal)
            set(img_plot_pc, 'CData', imc);

            % Atualiza a tela da DIREITA (PC View)
            if mscr > 0.5 
                set(mario_plot, 'XData', mx, 'YData', my);
            else
                set(mario_plot, 'XData', NaN, 'YData', NaN);
            end

            % Força o desenho das duas telas
            drawnow;
        else
            % Renderiza o jogo normalmente se pc_view for false
            set(img_plot, 'CData', imc);
            drawnow;
        end
        % ===== pausa na execução =====
        pause(0.01);

    end
end
% =====================================================
% fecha o jogo
pause(1);
close all force;
clear jogo;
clear functions;
drawnow;
disp('processo encerrado');
