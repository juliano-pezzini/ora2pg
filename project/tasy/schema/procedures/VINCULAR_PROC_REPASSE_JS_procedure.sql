-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vincular_proc_repasse_js ( nm_usuario_p text, nr_sequencia_p bigint, nr_repasse_terceiro_p bigint) AS $body$
BEGIN

update	procedimento_repasse
set	dt_atualizacao = clock_timestamp(),
	nm_usuario = nm_usuario_p,
	nr_repasse_terceiro = nr_repasse_terceiro_p
where	nr_sequencia = nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vincular_proc_repasse_js ( nm_usuario_p text, nr_sequencia_p bigint, nr_repasse_terceiro_p bigint) FROM PUBLIC;

