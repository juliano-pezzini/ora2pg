-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_cod_prestador ( nr_seq_prestador_p bigint, cd_prestador_p text) RETURNS varchar AS $body$
DECLARE

				
ds_retorno_w		varchar(30)	:= null;
qt_prestador_w		bigint;


BEGIN
if (nr_seq_prestador_p IS NOT NULL AND nr_seq_prestador_p::text <> '') then
	select	max(cd_prestador)
	into STRICT	ds_retorno_w
	from	pls_prestador
	where	nr_sequencia	= nr_seq_prestador_p
	and	ie_situacao	= 'A';
	
	if (coalesce(ds_retorno_w,'0') = '0') then
		select	max(cd_prestador)
		into STRICT	ds_retorno_w
		from	pls_prestador
		where	nr_sequencia	= nr_seq_prestador_p;
	end if;
elsif (cd_prestador_p IS NOT NULL AND cd_prestador_p::text <> '') then
	select	max(nr_sequencia)
	into STRICT	ds_retorno_w
	from	pls_prestador
	where	upper(cd_prestador) = upper(cd_prestador_p)
	and	ie_situacao = 'A';
	
	if (coalesce(ds_retorno_w,'0') = '0') then
		select	max(nr_sequencia)
		into STRICT	ds_retorno_w
		from	pls_prestador
		where	upper(cd_prestador) = upper(cd_prestador_p);
	end if;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_cod_prestador ( nr_seq_prestador_p bigint, cd_prestador_p text) FROM PUBLIC;

