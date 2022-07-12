-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_grupo_local (nr_seq_local_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(30);


BEGIN

if (nr_seq_local_p IS NOT NULL AND nr_seq_local_p::text <> '') then
	select 	max(ds_nome_curto)
	into STRICT	ds_retorno_w
	from 	qt_local_grupo a,
		qt_local b
	where	b.nr_sequencia = nr_seq_local_p
	and 	b.nr_seq_grupo_quimio = a.nr_sequencia;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_grupo_local (nr_seq_local_p bigint) FROM PUBLIC;

