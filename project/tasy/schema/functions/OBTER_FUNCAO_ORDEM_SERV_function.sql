-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_funcao_ordem_serv ( nr_sequencia_p bigint ) RETURNS bigint AS $body$
DECLARE


nr_seq_funcao_w	bigint;


BEGIN

select		max(nr_seq_funcao)
into STRICT		nr_seq_funcao_w
from		man_ordem_serv_ativ
where		nr_seq_ordem_serv = nr_sequencia_p;

return nr_seq_funcao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_funcao_ordem_serv ( nr_sequencia_p bigint ) FROM PUBLIC;
