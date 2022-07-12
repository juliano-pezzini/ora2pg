-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tre_obter_qtde_curso ( nr_seq_curso_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE

qt_min_pessoas_w		integer;
qt_max_pessoas_w		integer;
qt_carga_horaria_w	double precision;
qt_retorno_w		bigint;


BEGIN
select	max(b.qt_min_pessoas),
	max(b.qt_max_pessoas),
	max(b.qt_carga_horaria)
into STRICT	qt_min_pessoas_w,
	qt_max_pessoas_w,
	qt_carga_horaria_w
from   	tre_curso b
where    b.nr_sequencia = nr_seq_curso_p;

if (ie_opcao_p = 'MI') then
	qt_retorno_w := qt_min_pessoas_w;
elsif (ie_opcao_p = 'MA') then
	qt_retorno_w := qt_max_pessoas_w;
elsif (ie_opcao_p = 'CA') then
	qt_retorno_w := qt_carga_horaria_w;
end if;


return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tre_obter_qtde_curso ( nr_seq_curso_p bigint, ie_opcao_p text) FROM PUBLIC;

