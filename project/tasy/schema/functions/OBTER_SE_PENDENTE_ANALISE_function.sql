-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_pendente_analise (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w 		varchar(10);
nr_sequencia_w		bigint;


BEGIN


select 	max(coalesce(ie_analise,'N'))
into STRICT	ds_retorno_w
from	atendimento_precaucao
where	nr_atendimento = nr_atendimento_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_pendente_analise (nr_atendimento_p bigint) FROM PUBLIC;
