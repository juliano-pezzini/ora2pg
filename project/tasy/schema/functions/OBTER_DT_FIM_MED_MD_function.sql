-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dt_fim_med_md ( dt_fim_item_p timestamp, dt_fim_cih_item_p timestamp, dt_suspensao_item_p timestamp, dt_lib_suspensao_item_p timestamp) RETURNS timestamp AS $body$
DECLARE


dt_suspensao_w timestamp;

	
BEGIN
		if (dt_lib_suspensao_item_p IS NOT NULL AND dt_lib_suspensao_item_p::text <> '') then
			dt_suspensao_w := dt_suspensao_item_p;
		end if;

		if ((dt_fim_cih_item_p IS NOT NULL AND dt_fim_cih_item_p::text <> '') and (coalesce(dt_suspensao_w::text, '') = '' or dt_fim_cih_item_p < dt_suspensao_w)) then
			return dt_fim_cih_item_p;
		elsif (coalesce(dt_fim_cih_item_p::text, '') = '' and (dt_fim_item_p IS NOT NULL AND dt_fim_item_p::text <> '') and (coalesce(dt_suspensao_w::text, '') = '' or dt_fim_item_p < dt_suspensao_w)) then
			return dt_fim_item_p;
		elsif (dt_suspensao_w < coalesce(dt_fim_cih_item_p, dt_fim_item_p)) then
			return dt_suspensao_w;
		end if;

		return coalesce(dt_fim_cih_item_p, dt_fim_item_p);	

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dt_fim_med_md ( dt_fim_item_p timestamp, dt_fim_cih_item_p timestamp, dt_suspensao_item_p timestamp, dt_lib_suspensao_item_p timestamp) FROM PUBLIC;

