-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_lote_fornec_dt ( nr_sequencia_p bigint, ie_opcao_p text) RETURNS timestamp AS $body$
DECLARE

/*' ie_opcao

V - Validade

'*/
dt_validade_w		timestamp;
ds_retorno_w		timestamp;


BEGIN
begin

select 	dt_validade
into STRICT 	dt_validade_w
from	material_lote_fornec
where	nr_sequencia	= nr_sequencia_p;
exception
when others then
	null;
end;

if (ie_opcao_p = 'V') then
	ds_retorno_w	:= pkg_date_utils.start_of(dt_validade_w,'dd');
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_lote_fornec_dt ( nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;
