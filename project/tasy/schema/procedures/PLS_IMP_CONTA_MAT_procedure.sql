-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_imp_conta_mat ( nr_seq_conta_p bigint, cd_material_imp_p text, qt_material_imp_p bigint, vl_unitario_imp_p bigint, vl_material_imp_p bigint, ie_origem_preco_imp_p bigint, ds_material_imp_p text, cd_barras_imp_p text, nm_usuario_p text, ds_justificativa_p text, tx_red_acrescimo_imp_p bigint, ie_tipo_despesa_imp_p text, dt_atendimento_imp_p timestamp, dt_inicio_atend_imp_p timestamp, dt_fim_atend_imp_p timestamp, cd_unidade_medida_p text, nr_registro_anvisa_imp_p text, cd_ref_fabricante_imp_p text, ds_aut_funcionamento_imp_p text, nr_seq_item_tiss_p pls_conta_mat_regra.nr_seq_item_tiss%type, nr_seq_item_tiss_vinculo_p pls_conta_mat_regra.nr_seq_item_tiss_vinculo%type) AS $body$
DECLARE

				
ie_tipo_despesa_imp_w	varchar(2) := '7'; -- A rotina éra utilizada somente para OPME
nr_seq_conta_mat_w	pls_conta_mat.nr_sequencia%type;
qt_mat_regra_w		integer;


BEGIN

if (ie_tipo_despesa_imp_p IS NOT NULL AND ie_tipo_despesa_imp_p::text <> '') then
	ie_tipo_despesa_imp_w := ie_tipo_despesa_imp_p;
end if;


insert into pls_conta_mat(
		nr_sequencia, dt_atualizacao, nm_usuario,
                dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_conta,
                cd_material_imp, qt_material_imp, vl_unitario_imp,
                vl_material_imp, ie_origem_preco_imp, ds_material_imp,
		ie_tipo_despesa_imp, ie_status, ie_situacao,
                cd_barras_imp, ds_justificativa, tx_reducao_acrescimo_imp,
		dt_atendimento_imp, dt_inicio_atend_imp, dt_fim_atend_imp,
		cd_unidade_medida_imp, nr_registro_anvisa_imp, cd_ref_fabricante_imp,
		ds_aut_funcionamento_imp, vl_material_imp_xml) 
	values (nextval('pls_conta_mat_seq'), clock_timestamp(), nm_usuario_p,
                clock_timestamp(), nm_usuario_p, nr_seq_conta_p,
                cd_material_imp_p, qt_material_imp_p,  coalesce(vl_unitario_imp_p,dividir(coalesce(vl_material_imp_p,0),qt_material_imp_p)),
                vl_material_imp_p, ie_origem_preco_imp_p, ds_material_imp_p,
                ie_tipo_despesa_imp_w, 'U', 'I',
                cd_barras_imp_p, ds_justificativa_p, tx_red_acrescimo_imp_p,
		dt_atendimento_imp_p, dt_inicio_atend_imp_p, dt_fim_atend_imp_p,
		cd_unidade_medida_p, nr_registro_anvisa_imp_p, cd_ref_fabricante_imp_p,
		ds_aut_funcionamento_imp_p, vl_material_imp_p) returning nr_sequencia into nr_seq_conta_mat_w;
commit;

-- so gera neste momento quando possui informação
if (nr_seq_item_tiss_p IS NOT NULL AND nr_seq_item_tiss_p::text <> '') then

	-- Se existe a regra, so atualiza, senão gera novamente
	CALL pls_cta_proc_mat_regra_pck.cria_registro_regra_mat(nr_seq_conta_mat_w, nm_usuario_p);
	
	CALL pls_cta_proc_mat_regra_pck.atualiza_seq_tiss_mat(nr_seq_conta_mat_w, nr_seq_item_tiss_p, nr_seq_item_tiss_vinculo_p, nm_usuario_p);
	
	commit;
	
end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_imp_conta_mat ( nr_seq_conta_p bigint, cd_material_imp_p text, qt_material_imp_p bigint, vl_unitario_imp_p bigint, vl_material_imp_p bigint, ie_origem_preco_imp_p bigint, ds_material_imp_p text, cd_barras_imp_p text, nm_usuario_p text, ds_justificativa_p text, tx_red_acrescimo_imp_p bigint, ie_tipo_despesa_imp_p text, dt_atendimento_imp_p timestamp, dt_inicio_atend_imp_p timestamp, dt_fim_atend_imp_p timestamp, cd_unidade_medida_p text, nr_registro_anvisa_imp_p text, cd_ref_fabricante_imp_p text, ds_aut_funcionamento_imp_p text, nr_seq_item_tiss_p pls_conta_mat_regra.nr_seq_item_tiss%type, nr_seq_item_tiss_vinculo_p pls_conta_mat_regra.nr_seq_item_tiss_vinculo%type) FROM PUBLIC;
