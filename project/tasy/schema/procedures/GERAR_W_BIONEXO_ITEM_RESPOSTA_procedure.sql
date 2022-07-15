-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_bionexo_item_resposta ( cd_cnpj_p text, ds_comentario_p text, ds_embalagem_p text, ds_fabricante_p text, nr_seq_item_p text, vl_preco_total_p text, vl_preco_unitario_p text, ie_selecionado_p text, nm_usuario_p text) AS $body$
DECLARE



nr_sequencia_w	bigint;



BEGIN
--apapandini OS623800
select	nextval('w_bionexo_item_resposta_seq')
into STRICT	nr_sequencia_w
;


insert into w_bionexo_item_resposta(
			cd_cnpj,
			ds_comentario,
			ds_embalagem,
			ds_fabricante,
			nr_seq_item,
			nr_sequencia,
			vl_preco_total,
			vl_preco_unitario,
			ie_selecionado,
			nm_usuario,
			nm_usuario_nrec,
			dt_atualizacao,
			dt_atualizacao_nrec  )
values (	cd_cnpj_p,
	ds_comentario_p,
	ds_embalagem_p,
	ds_fabricante_p,
	nr_seq_item_p,
	nr_sequencia_w,
	vl_preco_total_p,
	vl_preco_unitario_p,
	ie_selecionado_p,
	nm_usuario_p,
	nm_usuario_p,
	clock_timestamp(),
	clock_timestamp());

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_bionexo_item_resposta ( cd_cnpj_p text, ds_comentario_p text, ds_embalagem_p text, ds_fabricante_p text, nr_seq_item_p text, vl_preco_total_p text, vl_preco_unitario_p text, ie_selecionado_p text, nm_usuario_p text) FROM PUBLIC;

