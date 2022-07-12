-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION nutrition_intake_manager_pck.get_qt_duracao ( ie_duracao_p text, dt_fim_p timestamp, dt_suspensao_p timestamp, dt_start_p timestamp) RETURNS bigint AS $body$
BEGIN

		if (dt_suspensao_p IS NOT NULL AND dt_suspensao_p::text <> '') then
			qt_duracao_pre_calc_w :=  (24 * (dt_suspensao_p - dt_start_p));
		elsif (dt_fim_p IS NOT NULL AND dt_fim_p::text <> '') then
			qt_duracao_pre_calc_w :=  (24 * (dt_fim_p - dt_start_p));
		elsif (ie_duracao_p = 'C') then
			qt_duracao_pre_calc_w :=  (24 * ((dt_start_p + 1) - dt_start_p));
		else
			return 0;
		end if;

		if (qt_duracao_pre_calc_w > 24) then
			return 24;
		elsif (qt_duracao_pre_calc_w < 0) then
			return 0;
		else
			return qt_duracao_pre_calc_w;
		end if;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nutrition_intake_manager_pck.get_qt_duracao ( ie_duracao_p text, dt_fim_p timestamp, dt_suspensao_p timestamp, dt_start_p timestamp) FROM PUBLIC;
