-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cih_obter_desc_modo_aplicacao ( nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_w    cih_modo_aplicacao.ds_modo_aplicacao%type;
				

BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
    begin
	select	ds_modo_aplicacao
	into STRICT	ds_retorno_w
	from	cih_modo_aplicacao
	where	nr_sequencia = nr_sequencia_p;
    exception when others then
        ds_retorno_w    := '';
    end;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cih_obter_desc_modo_aplicacao ( nr_sequencia_p bigint) FROM PUBLIC;

