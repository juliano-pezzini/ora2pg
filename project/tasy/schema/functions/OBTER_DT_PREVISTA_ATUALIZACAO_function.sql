-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dt_prevista_atualizacao (nr_sequencia_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_atualizacao_w  timestamp;

BEGIN

select 	to_date(trunc(dt_prevista_atualizacao),'dd/mm/yyyy')
into STRICT 	dt_atualizacao_w
from	atualizacao_tasy
where 	nr_sequencia = nr_sequencia_p;

return	dt_atualizacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dt_prevista_atualizacao (nr_sequencia_p bigint) FROM PUBLIC;

