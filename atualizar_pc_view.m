function atualizar_pc_view(handles, imc, frames_sem_mario, limite_sumido, mx, my, bx, by, bpx, bpy, fx, fy, estado_atual, MAX_SLOTS_VIS)
    % Atualiza a imagem de fundo
    set(handles.img_plot_pc, 'CData', imc);

    % Atualiza Mario
    if frames_sem_mario < limite_sumido
        set(handles.mario_plot, 'XData', mx, 'YData', my);
    else
        set(handles.mario_plot, 'XData', NaN, 'YData', NaN);
    end

    % Atualiza Barris — posição atual
    if ~isempty(bx)
        set(handles.barris_plot, 'XData', bx, 'YData', by);
    else
        set(handles.barris_plot, 'XData', NaN, 'YData', NaN);
    end

    % Atualiza Trajetórias previstas
    imp_x_all = [];
    imp_y_all = [];
    for s = 1:MAX_SLOTS_VIS
        if s <= length(bpx) && ~isempty(bpx{s})
            set(handles.prev_plots(s), 'XData', bpx{s}, 'YData', bpy{s});
            % Ponto de impacto = último ponto da trajetória
            imp_x_all(end+1) = bpx{s}(end);
            imp_y_all(end+1) = bpy{s}(end);
        else
            set(handles.prev_plots(s), 'XData', NaN, 'YData', NaN);
        end
    end
    
    % Atualiza Ponto de Impacto
    if ~isempty(imp_x_all)
        set(handles.impacto_plot, 'XData', imp_x_all, 'YData', imp_y_all);
    else
        set(handles.impacto_plot, 'XData', NaN, 'YData', NaN);
    end

    % Atualiza Foguinho
    if ~isempty(fx)
        set(handles.foguinho_plot, 'XData', fx, 'YData', fy);
    else
        set(handles.foguinho_plot, 'XData', NaN, 'YData', NaN);
    end

    % Atualiza Estado atual do Mario
    set(handles.texto_estado, 'String', estado_atual);

    drawnow;
end