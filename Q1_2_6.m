% script r�pondant � la question 1.2.6
clear all;

% taille diff�rente avec le bon nombre d'�tats
precision_s1_4 = Q1_2_6_fct(30, 4);
precision_s2_4 = Q1_2_6_fct(100, 4);
precision_s3_4 = Q1_2_6_fct(200, 4);
precision_s4_4 = Q1_2_6_fct(500, 4);

% m�me taille avec 1 � 6 �tats
precision_s2_1 = Q1_2_6_fct(100, 1);
precision_s2_2 = Q1_2_6_fct(100, 2);
precision_s2_3 = Q1_2_6_fct(100, 3);
precision_s2_5 = Q1_2_6_fct(100, 5);
precision_s2_6 = Q1_2_6_fct(100, 6);