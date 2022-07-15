-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_pat_bem_taxa ( nr_seq_bem_p bigint, dt_vigencia_p timestamp, pr_depreciacao_p bigint, pr_deprec_fiscal_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert into pat_bem_taxa(
	nr_sequencia,
	nr_seq_bem,
	dt_atualizacao,
	nm_usuario,
	dt_vigencia,
	pr_depreciacao,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	pr_deprec_fiscal)
values (nextval('pat_bem_taxa_seq'),
	nr_seq_bem_p,
	clock_timestamp(),
	nm_usuario_p,
	dt_vigencia_p,
	pr_depreciacao_p,
	clock_timestamp(),
	nm_usuario_p,
	CASE WHEN pr_deprec_fiscal_p=0 THEN null  ELSE pr_deprec_fiscal_p END );

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_pat_bem_taxa ( nr_seq_bem_p bigint, dt_vigencia_p timestamp, pr_depreciacao_p bigint, pr_deprec_fiscal_p bigint, nm_usuario_p text) FROM PUBLIC;

