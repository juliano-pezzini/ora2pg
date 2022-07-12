-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_prest_matriz ( nr_seq_prestador_p pls_prestador.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);
ie_matriz_w	pls_prestador.ie_prestador_matriz%type;
ie_filial_w	pls_prestador.ie_filial%type;


BEGIN

select 	max(ie_prestador_matriz),
	max(ie_filial)
into STRICT	ie_matriz_w,
	ie_filial_w
from	pls_prestador
where	nr_sequencia = nr_seq_prestador_p;

if ( ie_matriz_w 	= 'S') then
	ds_retorno_w := 'Matriz';
elsif (ie_filial_w	= 'S') then
	ds_retorno_w := 'Filial';
else
	ds_retorno_w := '';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_prest_matriz ( nr_seq_prestador_p pls_prestador.nr_sequencia%type) FROM PUBLIC;

