-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_evolucao_cur ( nr_sequencia_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_evolucao_w	timestamp;


BEGIN
select	max(dt_evolucao)
into STRICT	dt_evolucao_w
from	cur_evolucao
where	nr_seq_ferida = nr_sequencia_p
and	ie_situacao = 'A';

return	dt_evolucao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_evolucao_cur ( nr_sequencia_p bigint) FROM PUBLIC;

