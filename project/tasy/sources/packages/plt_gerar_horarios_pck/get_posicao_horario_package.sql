-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION plt_gerar_horarios_pck.get_posicao_horario (dt_horario_p timestamp) RETURNS bigint AS $body$
BEGIN
		for i in 1..vetor_w.count loop
			if (to_date(current_setting('plt_gerar_horarios_pck.vetor_w')::vetor[i].horario_w, 'dd/mm/yyyy hh24:mi:ss') = dt_horario_p) then
				return i;
			end if;
		end loop;
		return null;
	end;
	
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION plt_gerar_horarios_pck.get_posicao_horario (dt_horario_p timestamp) FROM PUBLIC;
