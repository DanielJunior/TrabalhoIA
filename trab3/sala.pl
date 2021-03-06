%

:-dynamic datashow/2.
:-dynamic computador/2.
:-dynamic ar/2.
:-dynamic esta/2.
:-dynamic ocupada(sala,professor).

%Salas Disponiveis
sala(s1).
sala(s2).
sala(s3).

%professores
professor(aline).
professor(marcos).
professor(rosseti).
professor(martinhon).
professor(teste).

%aonde est�o os professores no momento
esta(aline,casa).
esta(marcos,uff).
esta(rosseti,uff).
esta(martinhon,casa).
esta(teste,casa).

%quando chegam e v�o embora
chega(aline,12).
chega(marcos,17).
chega(rosseti,9).
chega(martinhon,7).
chega(teste,7).

embora(aline,19).
embora(marcos,23).
embora(rosseti,17).
embora(martinhon,12).
embora(teste,23).

%aulas dos professores
aula(aline, s1, 16, 18).
aula(marcos,s2, 20, 22).
aula(rosseti,s1,14,16).
aula(martinhon,s3,08,10).
aula(teste,s2,20,22).

%preferencias de casa um
usa_datashow(aline).
usa_computador(aline).
usa_computador(marcos).
usa_computador(martinhon).
usa_ar(rosseti).
usa_ar(aline).
usa_ar(marcos).
usa_ar(teste).

%professor so pode dar aula se estiver na faculdade
esta_na_faculdade(X):-esta(X,uff)-> write(X),write_ln(' esta na uff');esta(X,aula)->write(X),write_ln(' esta em aula');write(X),write_ln(' n�o est� na uff').

%professor da aula em determinado horario
dar_aula(X,Y):- sala_aberta(X,Y) ->(esta(X,uff)->(retract(esta(X,_)),assert(esta(X,aula)),write('aula do(a) '),write_ln(X),usa_aparelhos(X),(usa_ar(X)->liga_ar(S);write_ln('ar foi ligado')));write_ln('professor nao tem aula agora')); write_ln('n�o � possivel ter aula').
sala_aberta(X,Y):- (esta_na_faculdade(X),aula(X,S,Y,_)) -> esta_ocupada(X,S) ; write_ln('professor n�o tem aula nesse horario'),fail.

%ligar os aparelhos de acordo com o professor
usa_aparelhos(X):-(usa_computador(X)->liga_computador(X);write_ln('pc n�o foi ligado')),(usa_datashow(X)->liga_datashow(X);write_ln('datashow n�o foi ligado')),!.

liga_ar(S):-assert(ar(S,ligado)), write_ln('ar ligado').
liga_computador(X):-assert(computador(X,ligado)),write_ln('computador ligado').
liga_datashow(X):-assert(datashow(X,ligado)),write_ln('datashow ligado').

%verificar se a sala esta ocupada
esta_ocupada(X,S):- ocupada(S,_)->(write_ln('sala ocupada'), fail);assert(ocupada(S,X)).

%desligar aparelhos
desliga_aparelhos(X):-(usa_computador(X)->desliga_computador(X);write_ln('pc nao est� ligado')),(usa_datashow(X)->desliga_datashow(X);write_ln('datashow n�o est� ligado')),!.

desliga_ar(S):-retract(ar(S,ligado)),assert(ar(S,desligado)), write_ln('ar desligado').
desliga_computador(X):-retract(computador(X,ligado)),assert(computador(X,desligado)),write_ln('computador desligado').
desliga_datashow(X):-retract(datashow(X,ligado)),assert(datashow(X,desligado)),write_ln('datashow desligado').

%terminar a aula
terminar_aula(X,Y):-(esta(X,aula),aula(X,S,_,Y))->(retract(ocupada(S,X)),write('fim da aula do(a)'),write_ln(X),desliga_aparelhos(X),(usa_ar(X)->desliga_ar(S));write_ln('ar n�o est� ligado'),retract(esta(X,_)),assert(esta(X,uff)));write_ln('n�o esta em aula').


%buscas
busca_hor(P,H):- aula(P,_,H,_)->dar_aula(P,H);true.
busca_ter(P,H):- aula(P,_,_,H)->terminar_aula(P,H);true.

%verifica quando o professor chega ou sai
chega_prof(X,H,L):- chega(X,H)->(retract(esta(X,_)),assert(esta(X,L)),write(X),write_ln(' chegou'));true.

sai_prof(X,H):-embora(X,H)->(retract(esta(X,_)),assert(esta(X,casa)),write(X),write_ln(' foi embora'));true.


%simula um dia normal

dia(I):-
  write('HORA: '),
  write_ln(I),
  I < 24,
  forall(chega(X,I),chega_prof(X,I,uff)),
  forall(aula(X,_,_,I),busca_ter(X,I)),
  forall(aula(X,_,I,_),busca_hor(X,I)),
  forall(embora(X,I),sai_prof(X,I)),
  write_ln(''),
  I2 is I+1,
  dia(I2).






