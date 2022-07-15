-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_dt_repique (nr_seq_cirur_agente_p bigint) AS $body$
BEGIN

update 	cirurgia_agente_anest_ocor
set 	dt_aviso_repique = clock_timestamp()
where 	nr_seq_cirur_agente = nr_seq_cirur_agente_p
and coalesce(dt_aviso_repique::text, '') = '';

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_dt_repique (nr_seq_cirur_agente_p bigint) FROM PUBLIC;

