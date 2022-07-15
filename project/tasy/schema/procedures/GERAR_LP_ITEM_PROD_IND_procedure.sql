-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_lp_item_prod_ind ( nr_seq_lp_individual_p bigint, cd_material_p bigint, qt_material_p bigint, nr_seq_lote_fornec_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_lote_fornec_w	bigint;


BEGIN

if (coalesce(nr_seq_lote_fornec_p,0) > 0) then
	nr_seq_lote_fornec_w	:= nr_seq_lote_fornec_p;
else
	select	max(b.nr_seq_lote_fornec)
	into STRICT	nr_seq_lote_fornec_w
	from	lote_producao a,
		lp_item_util b,
		lp_individual c
	where	a.nr_lote_producao	= b.nr_lote_producao
	and	b.nr_lote_producao 	= c.nr_lote_producao
	and	c.nr_sequencia 		= nr_seq_lp_individual_p
	and	b.cd_material 		= cd_material_p;
end if;

insert into lp_item_prod_ind(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_lp_individual,
	cd_material,
	nr_seq_lote_fornec)
values (
	nextval('lp_item_prod_ind_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_lp_individual_p,
	cd_material_p,
	nr_seq_lote_fornec_w);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_lp_item_prod_ind ( nr_seq_lp_individual_p bigint, cd_material_p bigint, qt_material_p bigint, nr_seq_lote_fornec_p bigint, nm_usuario_p text) FROM PUBLIC;

