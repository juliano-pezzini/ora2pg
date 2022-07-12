-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_os_possui_orc ( nr_seq_ordem_p bigint ) RETURNS varchar AS $body$
DECLARE


ds_retorno_w 	varchar(1);


BEGIN

	select 	coalesce(max('S'), 'N') ie_possui_orc
	into STRICT 	ds_retorno_w
	from 	man_ordem_servico_orc
	where 	nr_seq_ordem 	= nr_seq_ordem_p
	and 	coalesce(dt_reprovacao::text, '') = '';

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_os_possui_orc ( nr_seq_ordem_p bigint ) FROM PUBLIC;
