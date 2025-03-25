clc;
clear;

% Carregar os dados
load("step_response_2.mat");

% Métodos de identificação
metodos = ["ziegler", "sundaresan", "nishkiwa", "smith", "hagglund"];


% Configurações iniciais
s = tf('s');
y = step_response;
A = step_amplitude;
N = numel(y);
Ts = 1 / fs;
tempo = (0:N-1) * Ts;

% Cores e estilos para os diferentes métodos
cores = {'r--', 'g--', 'm--', 'c--', 'k--'};
legendas = cell(1, length(metodos));

% Plot da resposta original
figure;
plot(tempo, y, 'b', 'LineWidth', 2);
hold on;

% Loop sobre os métodos
for i = 1:length(metodos)
    % Identificação do modelo
    [K, tau, L] = lab1ex(y, A, fs, metodos(i));
    
    % Modelo do sistema
    sys = K / (s * tau + 1);
    sys.InputDelay = L;
    
    % Resposta do modelo
    y_model = step(sys, tempo);
    
    % Plot da resposta do modelo
    plot(tempo, y_model, cores{i}, 'LineWidth', 1.5);
    
    % Cálculo do erro quadrático médio (MSE)
    y = y(:);
    y_model = y_model(:);
    erro = y - y_model;
    MSE(i) = sum(erro.^2);
    
    % Legenda para cada método com o MSE
    legendas{i} = sprintf('Modelo (%s) - MSE: %.4f', metodos(i), MSE(i));
end

% Configurações do gráfico
xlabel('Tempo (s)');
ylabel('Resposta');
title('Comparação entre a Resposta Original e os Modelos');
legend(['Resposta Original', legendas], 'Location', 'best'); % Legenda com MSE
grid on;
hold off;