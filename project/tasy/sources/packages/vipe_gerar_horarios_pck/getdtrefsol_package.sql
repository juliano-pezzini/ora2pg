-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE vipe_gerar_horarios_pck.getdtrefsol (dt_limite_validade_p timestamp, dt_inicio_P INOUT timestamp, dt_fim_P INOUT timestamp) AS $body$
BEGIN
	if (getQtDiasAnteriorSolucao = 0) then
		dt_inicio_P 	:= dt_limite_validade_p - 7;
		dt_fim_P	:= vipe_gerar_horarios_pck.getdtfimvalidade(dt_limite_validade_p) + 7;
	else
		dt_inicio_P 	:= dt_limite_validade_p - vipe_gerar_horarios_pck.getqtdiasanteriorsolucao();
		dt_fim_P	:= vipe_gerar_horarios_pck.getdtfimvalidade(dt_limite_validade_p);
	end if;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vipe_gerar_horarios_pck.getdtrefsol (dt_limite_validade_p timestamp, dt_inicio_P INOUT timestamp, dt_fim_P INOUT timestamp) FROM PUBLIC;