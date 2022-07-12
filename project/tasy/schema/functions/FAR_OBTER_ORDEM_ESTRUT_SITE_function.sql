-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION far_obter_ordem_estrut_site ( nr_seq_estrutura_p bigint) RETURNS bigint AS $body$
DECLARE


nr_retorno_w	bigint;


BEGIN

select	max(nr_seq_ordem)
into STRICT	nr_retorno_w
from	far_estrut_mat_site
where	nr_sequencia = nr_seq_estrutura_p;

return	nr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION far_obter_ordem_estrut_site ( nr_seq_estrutura_p bigint) FROM PUBLIC;
