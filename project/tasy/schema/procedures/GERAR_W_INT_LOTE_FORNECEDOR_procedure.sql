-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_int_lote_fornecedor ( cd_cgc_fornec_p text, cd_estabelecimento_p text, cd_material_p text, ds_lote_fornec_p text, ds_observacao_p text, dt_fabricacao_p text, dt_validade_p text, ie_situacao_p text, ie_validade_indeterminada_p text, nr_seq_local_p text, nr_seq_marca_p text, nr_serie_material_p text, qt_material_p text, nm_usuario_p text, nr_seq_lote_fornecedor_p INOUT text) AS $body$
DECLARE






nr_seq_lote_fornecedor_w	bigint;
ds_erro_w	varchar(4000);


BEGIN

select	nextval('w_int_lote_fornecedor_seq')
into STRICT	nr_seq_lote_fornecedor_w
;

insert into w_int_lote_fornecedor(
			nr_sequencia,
			cd_cgc_fornec,
			cd_estabelecimento,
			cd_material,
			ds_lote_fornec,
			ds_observacao,
			dt_fabricacao,
			dt_validade,
			ie_situacao,
			ie_validade_indeterminada,
			nr_seq_local,
			nr_seq_marca,
			nr_serie_material,
			qt_material,
			nm_usuario,
			nm_usuario_nrec,
			dt_atualizacao,
			dt_atualizacao_nrec)
values ( nr_seq_lote_fornecedor_w,
	cd_cgc_fornec_p,
	cd_estabelecimento_p,
	cd_material_p,
	ds_lote_fornec_p,
	ds_observacao_p,
	to_date(dt_fabricacao_p,'dd/mm/yyyy'),
	to_date(dt_validade_p,'dd/mm/yyyy'),
	ie_situacao_p,
	ie_validade_indeterminada_p,
	nr_seq_local_p,
	nr_seq_marca_p,
	nr_serie_material_p,
	(qt_material_p)::numeric ,
	nm_usuario_p,
	nm_usuario_p,
	clock_timestamp(),
	clock_timestamp());

nr_seq_lote_fornecedor_p := nr_seq_lote_fornecedor_w;

commit;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_int_lote_fornecedor ( cd_cgc_fornec_p text, cd_estabelecimento_p text, cd_material_p text, ds_lote_fornec_p text, ds_observacao_p text, dt_fabricacao_p text, dt_validade_p text, ie_situacao_p text, ie_validade_indeterminada_p text, nr_seq_local_p text, nr_seq_marca_p text, nr_serie_material_p text, qt_material_p text, nm_usuario_p text, nr_seq_lote_fornecedor_p INOUT text) FROM PUBLIC;

