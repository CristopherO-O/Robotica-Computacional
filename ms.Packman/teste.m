clear;
warning off;
pkg load image;
pkg load retro_games;

%funcs
% ===== imagem das barreiras =====
function imbar=barrier(imgray)
  bar = imopen(imgray>40, ones(4));
  barn = bwlabel(bar);
  barreiras = regionprops(barn, 'Area');
  maior = [];
  for i=1:numel(barreiras)
    if barreiras(i).Area>200
      maior=[maior i];
    end
  end
  imbar = zeros(size(imgray));
  for i=1:numel(maior)
    imbar = imbar | barn == maior(i);
  end
end

% ===== imagem das bolinhas =====
function bolinhas=bolinha(imgray)
  imgg= imgray>50;
  im1 = imopen(imgg,ones(3));
  bolinhas = imgg-im1;
  bolinhas = imerode(bolinhas, ones(2));
  bolinhas = medfilt2(bolinhas);
  bolinhas = imdilate(bolinhas,ones(3));
end

% ===== inicia o jogo direto na gameplay =====
function jogo=inicio(jogo)
  jogo.step(400);
  jogo.set_input([1 0 0 0 0 0 0 0]);
  jogo.step(200);
  jogo.set_input([0 0 0 0 0 0 0 0]);
  jogo.step(5);
  jogo.step(243);
end

function agentes = agentes(imgray)
  cena_completa = imgray > 40; 
  imbar = barrier(imgray);
  bolinhas = bolinha(imgray);
  agentes = cena_completa & ~imbar & ~bolinhas;
end

%main

% ===== lista HSV ======
Vermelho=H==0;
Laranja=H>0 & H<=.1;
Amarelo=H>.1 & H<=.4;
Azul=H>.5 & H<=.6;
Rosa=H>.8 & H<=.9;
S_fraca=S>0 & S<=.1;
S_cor=S>.1 & S<=1;
Sombra=V>.3 & V<=.6;
Claro= V>=.9

% ===== Cor Entidades =====
FL = Laranja & Claro; %fantasma laranja;
FA = Azul & Claro; %fantasma Azul;
FV = Vermelho & Claro; %fantasma Vermelho;
FR = Rosa & Claro & S_cor; %fantasma Rosa;
PA = Amarelo & Claro; %packman;
PC = Cinza & Sombra; %Pilula poder;

% ===== Eliminando Ruidos =====
FL = medfilter(FL);
FA = imclose(FA,ones(5));
FR = imopen(imclose(FR,ones(7)),ones(7));
FV = medfilt2(FV);
FV = imclose(FV,ones(7));
PA = imerode(PA,ones(3));
PA = imopen(PA,ones(2));
PC = imclose(PC,ones(4));

jogo=load_rom('Ms._Pac-Man.md');
[jogo]=inicio(jogo);

for i = 1:40
  jogo.step(5);
  im = jogo.get_image();
  imgray = rgb2gray(im);
  img = agentes(imgray);
  imshow(img);
  drawnow;
end

imshow(img);


% jogo.set_input([1 0 0 0 0 0 0 0]); aciona botoes
% [start select up down left right a b]



