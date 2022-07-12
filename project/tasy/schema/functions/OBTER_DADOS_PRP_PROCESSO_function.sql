-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_prp_processo (nr_seq_projeto_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);


BEGIN

select 	substr(nm_fase,1,255)
into STRICT	ds_retorno_w
from	prp_processo a,
	prp_fase_processo b
where	a.nr_seq_fase_processo = b.nr_sequencia
and	a.nr_seq_projeto = nr_seq_projeto_p;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_prp_processo (nr_seq_projeto_p bigint) FROM PUBLIC;

