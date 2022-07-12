-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION retorna_cron_etapa ( nr_seq_ordem_p bigint, nm_usuario_p text) RETURNS bigint AS $body$
DECLARE


nr_seq_atividade_w	bigint;
nr_seq_cron_etapa_w	bigint;


BEGIN

	select	max(nr_sequencia)
	into STRICT	nr_seq_atividade_w
	from	man_ordem_serv_ativ
	where	nr_seq_ordem_serv = nr_seq_ordem_p
	and	nm_usuario_exec	= nm_usuario_p;

	if (nr_seq_atividade_w IS NOT NULL AND nr_seq_atividade_w::text <> '') then
		select	max(nr_seq_proj_cron_etapa)
		into STRICT	nr_seq_cron_etapa_w
		from	man_ordem_serv_ativ a
		where	nr_sequencia	= nr_seq_atividade_w;
	end if;

return	nr_seq_cron_etapa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION retorna_cron_etapa ( nr_seq_ordem_p bigint, nm_usuario_p text) FROM PUBLIC;

