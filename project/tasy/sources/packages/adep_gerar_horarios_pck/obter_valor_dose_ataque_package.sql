-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION adep_gerar_horarios_pck.obter_valor_dose_ataque (ds_dose_ataque_p text) RETURNS varchar AS $body$
BEGIN
		if (ds_dose_ataque_p IS NOT NULL AND ds_dose_ataque_p::text <> '') then
			return(ds_dose_ataque_p || chr(10));
		end if;
		return null;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION adep_gerar_horarios_pck.obter_valor_dose_ataque (ds_dose_ataque_p text) FROM PUBLIC;
