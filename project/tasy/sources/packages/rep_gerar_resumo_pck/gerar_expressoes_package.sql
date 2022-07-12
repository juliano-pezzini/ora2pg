-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

--Long;--Varchar2(30000);
	--long;
	


CREATE OR REPLACE PROCEDURE rep_gerar_resumo_pck.gerar_expressoes () AS $body$
BEGIN
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp1_w', substr(obter_desc_expressao(317184),1,255), false); -- Resumo da prescrico
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp2_w', substr(obter_desc_expressao(325811),1,255), false); -- Paciente:
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp3_w', substr(obter_desc_expressao(287913),1,255), false); -- Dieta oral
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp4_w', substr(obter_desc_expressao(625490),1,255), false); -- Descricao
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp5_w', substr(obter_desc_expressao(680664),1,255), false); --  UM
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp6_w', substr(obter_desc_expressao(291449),1,255), false); -- Horarios
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp7_w', substr(obter_desc_expressao(314221),1,255), false); -- Suplemen/Modul/Pediat
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp8_w', substr(obter_desc_expressao(288220),1,255), false); -- Dose
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp9_w', substr(obter_desc_expressao(288219),1,255), false); -- Dosagem
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp10_w', substr(obter_desc_expressao(314222),1,255), false); -- Suporte nutricional enteral
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp11_w', substr(obter_desc_expressao(292190),1,255), false); -- Intervalo
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp12_w', substr(obter_desc_expressao(305331),1,255), false); -- NPT Adulta
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp13_w', substr(obter_desc_expressao(301588),1,255), false); --Vel Inf
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp14_w', substr(obter_desc_expressao(293085),1,255), false); -- Medicamentos
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp15_w', substr(obter_desc_expressao(298694),1,255), false); -- Solucoes
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp16_w', substr(obter_desc_expressao(296465),1,255), false); -- Procedimentos
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp17_w', substr(obter_desc_expressao(784685),1,255), false); -- Recomendacoes
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp18_w', substr(obter_desc_expressao(291246),1,255), false); -- Hemoderivados
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp19_w', substr(obter_desc_expressao(290567),1,255), false); -- Gasoterapia
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp20_w', substr(obter_desc_expressao(294823),1,255), false); -- OPM
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp21_w', substr(obter_desc_expressao(341829),1,255), false); -- Leites e derivados
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp22_w', substr(obter_desc_expressao(288031),1,255), false); -- Dispositivo
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp23_w', substr(obter_desc_expressao(325773),1,255), false); -- Justificativa:
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp24_w', substr(obter_desc_expressao(329252),1,255), false); -- Observacao:
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp25_w', substr(obter_desc_expressao(287111),1,255), false); -- Data prescricao
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp26_w', substr(obter_desc_expressao(296944),1,255), false); -- Qtde
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp27_w', substr(obter_desc_expressao(791289),1,255), false); -- Protocolo / Dispositivo
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp28_w', substr(obter_desc_expressao(302525),1,255), false); -- Administrar
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp29_w', substr(obter_desc_expressao(302256),1,255), false); -- Volume dia (ml)
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp30_w', substr(obter_desc_expressao(287657),1,255), false); -- Dia / Num fases
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp31_w', substr(obter_desc_expressao(287942),1,255), false); -- Diluicao
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp32_w', substr(obter_desc_expressao(296422),1,255), false); -- Procedimento
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp33_w', substr(obter_desc_expressao(753406),1,255), false); -- Observacao
	PERFORM set_config('rep_gerar_resumo_pck.ds_exp34_w', substr(obter_desc_expressao(301661),1,255), false); -- Via
  PERFORM set_config('rep_gerar_resumo_pck.c_nbsp', chr('38') || 'nbsp;', false);
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rep_gerar_resumo_pck.gerar_expressoes () FROM PUBLIC;