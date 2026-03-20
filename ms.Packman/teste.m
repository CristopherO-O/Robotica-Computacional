clear;
warning off;
pkg load image;
pkg load retro_games;

%funcs

function imbar=barrier(im)
  imgray = rgb2gray(im);
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

function jogo=inicio(jogo)
  jogo.step(400);
  jogo.set_input([1 0 0 0 0 0 0 0]);
  jogo.step(200);
  jogo.set_input([0 0 0 0 0 0 0 0]);
  jogo.step(5);
  jogo.step(243);
end

%main
jogo=load_rom('Ms._Pac-Man.md');

[jogo]=inicio(jogo);


for i = 1:40
  jogo.step(5);
  im = jogo.get_image();
  img = barrier(im);
  imshow(img);
  drawnow;
end

imshow(img);


% jogo.set_input([1 0 0 0 0 0 0 0]); aciona botoes
% [start select up down left right a b]



