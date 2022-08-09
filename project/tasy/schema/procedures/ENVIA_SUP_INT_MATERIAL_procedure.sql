-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE envia_sup_int_material ( cd_material_p bigint, ds_material_p text, ds_reduzida_p text, cd_material_generico_p bigint, cd_material_estoque_p bigint, cd_material_conta_p bigint, cd_classe_material_p bigint, cd_unidade_medida_compra_p text, cd_unidade_medida_estoque_p text, cd_unidade_medida_consumo_p text, cd_unidade_medida_solic_p text, qt_conv_compra_estoque_p bigint, qt_conv_estoque_consumo_p bigint, qt_minimo_multiplo_solic_p bigint, ie_prescricao_p text, ie_preco_compra_p text, ie_inf_ultima_compra_p text, ie_consignado_p text, ie_baixa_estoq_pac_p text, ie_tipo_material_p text, ie_padronizado_p text, ie_situacao_p text, ie_obrig_via_aplicacao_p text, ie_receita_p text, ie_cobra_paciente_p text, ie_disponivel_mercado_p text, ie_material_estoque_p text, ie_via_aplicacao_p text, qt_dia_estoque_minimo_p bigint, qt_dias_validade_p bigint, qt_dia_interv_ressup_p bigint, qt_dia_ressup_forn_p bigint, nr_seq_localizacao_p bigint, nr_seq_familia_p bigint, cd_fabricante_p text, cd_sistema_ant_p text, nr_doc_externo_p text, ie_catalogo_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


ie_de_para_unid_med_w		varchar(15);
cd_unidade_medida_compra_w	varchar(30);
cd_unidade_medida_consumo_w	varchar(30);
cd_unidade_medida_estoque_w	varchar(30);
cd_unidade_medida_solic_w	varchar(30);


BEGIN

select	obter_ie_de_para_sup_integr('CM','E','UNIDADE_MEDIDA')
into STRICT	ie_de_para_unid_med_w
;

/*Conversao para unidade de medida*/

cd_unidade_medida_compra_w 	:= cd_unidade_medida_compra_p;
cd_unidade_medida_consumo_w	:= cd_unidade_medida_consumo_p;
cd_unidade_medida_estoque_w	:= cd_unidade_medida_estoque_p;
cd_unidade_medida_solic_w	:= cd_unidade_medida_solic_p;

if (ie_de_para_unid_med_w = 'C') then
	cd_unidade_medida_compra_w	:= coalesce(Obter_Conversao_externa(null,'UNIDADE_MEDIDA','CD_UNIDADE_MEDIDA',cd_unidade_medida_compra_p),cd_unidade_medida_compra_p);
	cd_unidade_medida_consumo_w	:= coalesce(Obter_Conversao_externa(null,'UNIDADE_MEDIDA','CD_UNIDADE_MEDIDA',cd_unidade_medida_consumo_p),cd_unidade_medida_consumo_p);
	cd_unidade_medida_estoque_w	:= coalesce(Obter_Conversao_externa(null,'UNIDADE_MEDIDA','CD_UNIDADE_MEDIDA',cd_unidade_medida_estoque_p),cd_unidade_medida_estoque_p);
	cd_unidade_medida_solic_w	:= coalesce(Obter_Conversao_externa(null,'UNIDADE_MEDIDA','CD_UNIDADE_MEDIDA',cd_unidade_medida_solic_p),cd_unidade_medida_solic_p);

elsif (ie_de_para_unid_med_w = 'S') then
	cd_unidade_medida_compra_w	:= coalesce(obter_dados_unid_medida(cd_unidade_medida_compra_p,'SA'),cd_unidade_medida_compra_p);
	cd_unidade_medida_consumo_w	:= coalesce(obter_dados_unid_medida(cd_unidade_medida_consumo_p,'SA'),cd_unidade_medida_consumo_p);
	cd_unidade_medida_estoque_w	:= coalesce(obter_dados_unid_medida(cd_unidade_medida_estoque_p,'SA'),cd_unidade_medida_estoque_p);
	cd_unidade_medida_solic_w	:= coalesce(obter_dados_unid_medida(cd_unidade_medida_solic_p,'SA'),cd_unidade_medida_solic_p);
end if;
/*Fim*/

insert into sup_int_material(
	nr_sequencia,
	ie_forma_integracao,
	dt_liberacao,
	cd_material,
	ds_material,
	ds_reduzida,
	cd_material_generico,
	cd_material_estoque,
	cd_material_conta,
	cd_classe_material,
	cd_unidade_medida_compra,
	cd_unidade_medida_estoque,
	cd_unidade_medida_consumo,
	cd_unidade_medida_solic,
	qt_conv_compra_estoque,
	qt_conv_estoque_consumo,
	qt_minimo_multiplo_solic,
	ie_prescricao,
	ie_preco_compra,
	ie_inf_ultima_compra,
	ie_consignado,
	ie_baixa_estoq_pac,
	ie_tipo_material,
	ie_padronizado,
	ie_situacao,
	ie_obrig_via_aplicacao,
	ie_receita,
	ie_cobra_paciente,
	ie_disponivel_mercado,
	ie_material_estoque,
	ie_via_aplicacao,
	qt_dia_estoque_minimo,
	qt_dias_validade,
	qt_dia_interv_ressup,
	qt_dia_ressup_forn,
	nr_seq_localizacao,
	nr_seq_familia,
	cd_fabricante,
	cd_sistema_ant,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	cd_estabelecimento,
	nr_doc_externo,
	ie_catalogo)
values (	nextval('sup_int_material_seq'),
	'E',
	clock_timestamp(),
	cd_material_p,
	ds_material_p,
	ds_reduzida_p,
	cd_material_generico_p,
	cd_material_estoque_p,
	cd_material_conta_p,
	cd_classe_material_p,
	cd_unidade_medida_compra_w,
	cd_unidade_medida_estoque_w,
	cd_unidade_medida_consumo_w,
	cd_unidade_medida_solic_w,
	qt_conv_compra_estoque_p,
	qt_conv_estoque_consumo_p,
	qt_minimo_multiplo_solic_p,
	ie_prescricao_p,
	ie_preco_compra_p,
	ie_inf_ultima_compra_p,
	ie_consignado_p,
	ie_baixa_estoq_pac_p,
	ie_tipo_material_p,
	ie_padronizado_p,
	ie_situacao_p,
	ie_obrig_via_aplicacao_p,
	ie_receita_p,
	ie_cobra_paciente_p,
	ie_disponivel_mercado_p,
	ie_material_estoque_p,
	ie_via_aplicacao_p,
	qt_dia_estoque_minimo_p,
	qt_dias_validade_p,
	qt_dia_interv_ressup_p,
	qt_dia_ressup_forn_p,
	nr_seq_localizacao_p,
	nr_seq_familia_p,
	cd_fabricante_p,
	cd_sistema_ant_p,
	clock_timestamp(),
	coalesce(nm_usuario_p,'Tasy'),
	clock_timestamp(),
	coalesce(nm_usuario_p,'Tasy'),
	coalesce(cd_estabelecimento_p, obter_estabelecimento_ativo),
	nr_doc_externo_p,
	ie_catalogo_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE envia_sup_int_material ( cd_material_p bigint, ds_material_p text, ds_reduzida_p text, cd_material_generico_p bigint, cd_material_estoque_p bigint, cd_material_conta_p bigint, cd_classe_material_p bigint, cd_unidade_medida_compra_p text, cd_unidade_medida_estoque_p text, cd_unidade_medida_consumo_p text, cd_unidade_medida_solic_p text, qt_conv_compra_estoque_p bigint, qt_conv_estoque_consumo_p bigint, qt_minimo_multiplo_solic_p bigint, ie_prescricao_p text, ie_preco_compra_p text, ie_inf_ultima_compra_p text, ie_consignado_p text, ie_baixa_estoq_pac_p text, ie_tipo_material_p text, ie_padronizado_p text, ie_situacao_p text, ie_obrig_via_aplicacao_p text, ie_receita_p text, ie_cobra_paciente_p text, ie_disponivel_mercado_p text, ie_material_estoque_p text, ie_via_aplicacao_p text, qt_dia_estoque_minimo_p bigint, qt_dias_validade_p bigint, qt_dia_interv_ressup_p bigint, qt_dia_ressup_forn_p bigint, nr_seq_localizacao_p bigint, nr_seq_familia_p bigint, cd_fabricante_p text, cd_sistema_ant_p text, nr_doc_externo_p text, ie_catalogo_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
