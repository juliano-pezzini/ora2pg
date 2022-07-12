-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION proj_obter_valor_hora (nr_seq_proj_p bigint, ie_recurso_p text, ie_recente_p text default 'N') RETURNS bigint AS $body$
DECLARE

vl_retorno_w		proj_hora_cobrar.vl_hora%type;

BEGIN

select	max(vl_hora)
into STRICT	vl_retorno_w
from	proj_hora_cobrar
where	nr_seq_proj = nr_seq_proj_p
and 	clock_timestamp() between dt_inicio and dt_fim
and 	ie_recurso = ie_recurso_p
and		coalesce(cd_executor::text, '') = '';

if (coalesce(vl_retorno_w::text, '') = '') and (ie_recente_p = 'S') then
	select	max(vl_hora)
	into STRICT	vl_retorno_w
	from	proj_hora_cobrar
	where	nr_seq_proj = nr_seq_proj_p
	and 	ie_recurso = ie_recurso_p
	and	coalesce(cd_executor::text, '') = '';
end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION proj_obter_valor_hora (nr_seq_proj_p bigint, ie_recurso_p text, ie_recente_p text default 'N') FROM PUBLIC;

