-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tempo_os_sup_usuario ( nr_sequencia_p bigint, nm_usuario_exec_p text) RETURNS bigint AS $body$
DECLARE

ds_retorno_w	bigint;

BEGIN

select	coalesce(dividir(sum(t.qt_minuto),60),0)
into STRICT	ds_retorno_w
from	man_ordem_serv_ativ t
where	t.nr_seq_ordem_serv = nr_sequencia_p
and	t.nm_usuario_exec = nm_usuario_exec_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tempo_os_sup_usuario ( nr_sequencia_p bigint, nm_usuario_exec_p text) FROM PUBLIC;

