-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_gravar_disp_mat_mercado ( cd_material_p bigint, ie_disponivel_mercado_p text, nr_seq_motivo_p bigint, dt_prevista_disp_p timestamp, nm_usuario_p text) AS $body$
BEGIN
insert into sup_material_disp_mercado(
	nr_sequencia,
	nr_seq_motivo,
	cd_material,
	ie_disponivel_mercado,
	dt_prevista_disp,
	dt_atualizacao,
	dt_atualizacao_nrec,
	nm_usuario,
	nm_usuario_nrec)
values (	nextval('sup_material_disp_mercado_seq'),
	nr_seq_motivo_p,
	cd_material_p,
	ie_disponivel_mercado_p,
	dt_prevista_disp_p,
	clock_timestamp(),
	clock_timestamp(),
	nm_usuario_p,
	nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_gravar_disp_mat_mercado ( cd_material_p bigint, ie_disponivel_mercado_p text, nr_seq_motivo_p bigint, dt_prevista_disp_p timestamp, nm_usuario_p text) FROM PUBLIC;

