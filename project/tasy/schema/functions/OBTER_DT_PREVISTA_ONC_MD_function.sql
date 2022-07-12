-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dt_prevista_onc_md ( dt_inicio_p timestamp, dia_p text, ds_dias_aplicacao_p text) RETURNS timestamp AS $body$
DECLARE

dt_prevista_w timestamp;

BEGIN
    dt_prevista_w := dt_inicio_p + coalesce((dia_p)::numeric ,0);
    if ( dt_prevista_w < clock_timestamp() ) and ( position('-' in somente_numero_real(ds_dias_aplicacao_p)) = 0 ) then
        dt_prevista_w := clock_timestamp();
	end if;

    return dt_prevista_w;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dt_prevista_onc_md ( dt_inicio_p timestamp, dia_p text, ds_dias_aplicacao_p text) FROM PUBLIC;

