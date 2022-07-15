-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desfazer_liberacao_checklist (nr_seq_servico_p bigint) AS $body$
BEGIN

update 	sl_check_list_unid
set 	dt_liberacao  = NULL
WHERE	nr_seq_sl_unid	= nr_seq_servico_p;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desfazer_liberacao_checklist (nr_seq_servico_p bigint) FROM PUBLIC;

