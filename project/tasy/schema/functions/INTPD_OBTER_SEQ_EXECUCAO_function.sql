-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION intpd_obter_seq_execucao (nr_seq_evento_sistema_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_ordem_exec_w			intpd_eventos_sistema.nr_seq_ordem_exec%type;


BEGIN

select	max(nr_seq_ordem_exec)
into STRICT	nr_seq_ordem_exec_w
from	intpd_eventos_sistema
where	nr_sequencia = nr_seq_evento_sistema_p;

return	nr_seq_ordem_exec_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION intpd_obter_seq_execucao (nr_seq_evento_sistema_p bigint) FROM PUBLIC;
