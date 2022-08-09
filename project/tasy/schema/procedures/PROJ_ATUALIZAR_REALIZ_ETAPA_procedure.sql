-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_atualizar_realiz_etapa (nr_seq_etapa_p bigint, pr_realizacao_p bigint, nm_usuario_p text) AS $body$
BEGIN
	update	proj_cron_etapa
	set	pr_etapa = LEAST(abs(pr_realizacao_p), 100)
	where	nr_sequencia = nr_seq_etapa_p;
	commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_atualizar_realiz_etapa (nr_seq_etapa_p bigint, pr_realizacao_p bigint, nm_usuario_p text) FROM PUBLIC;
