-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dt_ativ_real ( nr_seq_ordem_p bigint, nm_usuario_exec_p text) RETURNS timestamp AS $body$
DECLARE


dt_fim_atividade_w	timestamp;


BEGIN

select	max(dt_fim_atividade)
into STRICT	dt_fim_atividade_w
from	man_ordem_serv_ativ
where	nr_seq_ordem_serv	= nr_seq_ordem_p
and	(dt_fim_atividade IS NOT NULL AND dt_fim_atividade::text <> '')
and	nm_usuario_exec		= nm_usuario_exec_p
and	dt_atividade between trunc(clock_timestamp()) and fim_dia(clock_timestamp());

return dt_fim_atividade_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dt_ativ_real ( nr_seq_ordem_p bigint, nm_usuario_exec_p text) FROM PUBLIC;
