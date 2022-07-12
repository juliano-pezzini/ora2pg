-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rxt_obter_envio_fisico (nr_seq_fase_p bigint, ie_tipo_trat_p text) RETURNS bigint AS $body$
DECLARE

    ds_retorno_w		bigint;

BEGIN

	if (ie_tipo_trat_p = 'T') then
		select 	count(*) total
		into STRICT	ds_retorno_w
		from 	rxt_campo a
		where coalesce(a.dt_envio_fisico::text, '') = ''
		and coalesce(a.dt_lib_fisico::text, '') = ''
		and coalesce(a.ie_situacao,'A') = 'A'
		and a.nr_seq_fase = nr_seq_fase_p;
    elsif (ie_tipo_trat_p = 'B') then
		select 	count(*) total
		into STRICT	ds_retorno_w
		from 	rxt_braq_campo_aplic_trat a
		where coalesce(a.dt_envio_fisico::text, '') = ''
		and coalesce(a.dt_lib_fisico::text, '') = ''
		and coalesce(a.ie_situacao,'A') = 'A'
		and a.nr_seq_aplic_trat = nr_seq_fase_p;
	end if;
    return	ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rxt_obter_envio_fisico (nr_seq_fase_p bigint, ie_tipo_trat_p text) FROM PUBLIC;

