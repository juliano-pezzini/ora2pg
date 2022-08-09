-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_int_nota_fiscal_item ( cd_centro_custo_p text, cd_conta_contabil_p text, cd_local_estoque_p text, cd_marca_p text, cd_material_p text, cd_setor_atendimento_p text, cd_unidade_medida_compra_p text, ds_complemento_p text, ds_observacao_p text, nm_usuario_p text, nr_seq_int_nf_p text, pr_desconto_p text, qt_item_nf_p text, vl_desconto_p text, vl_despesa_acessoria_p text, vl_frete_p text, vl_seguro_p text, vl_unitario_item_nf_p text, cd_barras_material_p text, cd_lote_fabricacao_p text, dt_validade_p text) AS $body$
DECLARE


ds_erro_w	varchar(4000);


BEGIN

begin
insert into w_int_nota_fiscal_item(
			nr_sequencia,
			cd_centro_custo,
			cd_conta_contabil,
			cd_local_estoque,
			cd_marca,
			cd_material,
			cd_setor_atendimento,
			cd_unidade_medida_compra,
			ds_complemento,
			ds_observacao,
			dt_atualizacao,
			dt_atualizacao_nrec,
			nm_usuario,
			nm_usuario_nrec,
			nr_seq_int_nf,
			pr_desconto,
			qt_item_nf,
			vl_desconto,
			vl_despesa_acessoria,
			vl_frete,
			vl_seguro,
			vl_unitario_item_nf,
			cd_barras_material,
			cd_lote_fabricacao,
			dt_validade)
values (	nextval('w_int_nota_fiscal_item_seq'),
			cd_centro_custo_p,
			cd_conta_contabil_p,
			cd_local_estoque_p,
			cd_marca_p,
			cd_material_p,
			cd_setor_atendimento_p,
			cd_unidade_medida_compra_p,
			ds_complemento_p,
			ds_observacao_p,
			clock_timestamp(),
			clock_timestamp(),
			nm_usuario_p,
			nm_usuario_p,
			nr_seq_int_nf_p,
			pr_desconto_p,
			qt_item_nf_p,
			vl_desconto_p,
			vl_despesa_acessoria_p,
			vl_frete_p,
			vl_seguro_p,
			vl_unitario_item_nf_p,
			cd_barras_material_p,
			cd_lote_fabricacao_p,
			dt_validade_p);

exception
when others then
	ds_erro_w	:= substr(sqlerrm,1,4000);
end;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_int_nota_fiscal_item ( cd_centro_custo_p text, cd_conta_contabil_p text, cd_local_estoque_p text, cd_marca_p text, cd_material_p text, cd_setor_atendimento_p text, cd_unidade_medida_compra_p text, ds_complemento_p text, ds_observacao_p text, nm_usuario_p text, nr_seq_int_nf_p text, pr_desconto_p text, qt_item_nf_p text, vl_desconto_p text, vl_despesa_acessoria_p text, vl_frete_p text, vl_seguro_p text, vl_unitario_item_nf_p text, cd_barras_material_p text, cd_lote_fabricacao_p text, dt_validade_p text) FROM PUBLIC;
