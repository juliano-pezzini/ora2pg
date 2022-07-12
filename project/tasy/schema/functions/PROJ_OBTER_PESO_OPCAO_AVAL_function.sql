-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION proj_obter_peso_opcao_aval ( nr_seq_opcao_p bigint) RETURNS bigint AS $body$
DECLARE


qt_retorno_w			varchar(255);


BEGIN

select	coalesce(max(qt_peso),0)
into STRICT	qt_retorno_w
from	proj_aval_opcao
where	nr_sequencia	= nr_seq_opcao_p;

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION proj_obter_peso_opcao_aval ( nr_seq_opcao_p bigint) FROM PUBLIC;

