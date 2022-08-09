-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE delete_proj_cron_etapa (nr_sequencia_p bigint) AS $body$
BEGIN

	delete from proj_cron_predec
	where NR_SEQ_ETAPA_ATUAL = nr_sequencia_p
	or NR_SEQ_ETAPA_PREDEC = nr_sequencia_p;

	delete from proj_cron_etapa
	where nr_sequencia = nr_sequencia_p;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE delete_proj_cron_etapa (nr_sequencia_p bigint) FROM PUBLIC;
