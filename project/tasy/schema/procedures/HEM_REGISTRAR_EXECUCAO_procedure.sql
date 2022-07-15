-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hem_registrar_execucao ( nr_seq_proc_p bigint, nr_seq_plan_p bigint, ds_observacao_rel_p text, nm_usuario_p text) AS $body$
BEGIN
if (coalesce(nr_seq_proc_p,0) > 0) then

	insert into hem_plan_etapa(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_proc,
				nr_seq_plan,
				ds_observacao_rel,
				nm_usuario_rel,
				dt_realizada)
	values (		nextval('hem_plan_etapa_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_proc_p,
				nr_seq_plan_p,
				ds_observacao_rel_p,
				nm_usuario_p,
				clock_timestamp());

end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hem_registrar_execucao ( nr_seq_proc_p bigint, nr_seq_plan_p bigint, ds_observacao_rel_p text, nm_usuario_p text) FROM PUBLIC;

