-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_prescricao_estoque_js ( cd_estabelecimento_p bigint, nr_atendimento_p bigint, dt_entrada_Unidade_p timestamp, cd_material_p bigint, dt_atendimento_p timestamp, cd_acao_p text, cd_local_estoque_p bigint, qt_material_p bigint, cd_setor_atendimento_p bigint, cd_unidade_medida_p text, nm_usuario_p text, ie_inserir_excluir_p text, nr_prescricao_p bigint, nr_seq_prescricao_p bigint, nr_seq_proc_princ_p bigint, nr_sequencia_p bigint, cd_cgc_fornecedor_p text, ds_observacao_p text, nr_seq_lote_fornec_p bigint, nr_receita_p bigint, nr_serie_material_p text, nr_lote_ap_p bigint, ie_vago1_p text, ie_vago2_p text, ie_vago3_p text, ie_atualizar_mat_atend_pac_p text, nr_seq_mat_atend_pac_p bigint) AS $body$
DECLARE


ie_consignado_w				varchar(1);
cd_cgc_fornecedor_w			varchar(14);
ie_tipo_saldo_w				varchar(1);
ds_observacao_w			varchar(2000);


BEGIN

	select	max(a.ie_consignado)
	into STRICT	ie_consignado_w
	from	material a,
			material_estab b
	where	a.cd_material = cd_material_p
	and		b.cd_material = a.cd_material
	and 	b.cd_estabelecimento = cd_estabelecimento_p;

	cd_cgc_fornecedor_w:= cd_cgc_fornecedor_p;	

	if (nr_seq_lote_fornec_p IS NOT NULL AND nr_seq_lote_fornec_p::text <> '') and (coalesce(cd_cgc_fornecedor_w::text, '') = '') then
		if (ie_consignado_w = '2') then
			SELECT * FROM obter_fornec_consig_ambos(cd_estabelecimento_p, cd_material_p, nr_seq_lote_fornec_p, cd_local_estoque_p, ie_tipo_saldo_w, cd_cgc_fornecedor_w) INTO STRICT ie_tipo_saldo_w, cd_cgc_fornecedor_w;
		elsif (ie_consignado_w = '1')  then
			SELECT * FROM obter_fornecedor_consignado(cd_material_p, trunc(clock_timestamp(), 'mm'), cd_local_estoque_p, cd_estabelecimento_p, qt_material_p, 'E', nr_atendimento_p, cd_cgc_fornecedor_w, ds_observacao_w, nr_seq_lote_fornec_p) INTO STRICT cd_cgc_fornecedor_w, ds_observacao_w;
		end if;
	end if;

	ds_observacao_w:= ds_observacao_p || ' ' || ds_observacao_w;

CALL gerar_prescricao_estoque(	cd_estabelecimento_p,
			nr_atendimento_p,
			dt_entrada_Unidade_p,
			cd_material_p,
			dt_atendimento_p,
			cd_acao_p,
			cd_local_estoque_p,
			qt_material_p,
			cd_setor_atendimento_p,
			cd_unidade_medida_p,
			nm_usuario_p,
			ie_inserir_excluir_p,
			nr_prescricao_p,
			nr_seq_prescricao_p,
			nr_seq_proc_princ_p,
			nr_sequencia_p,
			cd_cgc_fornecedor_w,
			ds_observacao_w,
			nr_seq_lote_fornec_p,
			nr_receita_p,
			nr_serie_material_p,
			nr_lote_ap_p,
			ie_vago1_p,
			ie_vago2_p,
			ie_vago3_p);
			
if (coalesce(ie_atualizar_mat_atend_pac_p, 'N') = 'S') then
	begin
	
	update	material_atend_paciente
    	     set	dt_atualizacao_estoque	= clock_timestamp(),
		nm_usuario		= nm_usuario_p
      	   where	nr_sequencia		= nr_seq_mat_atend_pac_p;
	
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_prescricao_estoque_js ( cd_estabelecimento_p bigint, nr_atendimento_p bigint, dt_entrada_Unidade_p timestamp, cd_material_p bigint, dt_atendimento_p timestamp, cd_acao_p text, cd_local_estoque_p bigint, qt_material_p bigint, cd_setor_atendimento_p bigint, cd_unidade_medida_p text, nm_usuario_p text, ie_inserir_excluir_p text, nr_prescricao_p bigint, nr_seq_prescricao_p bigint, nr_seq_proc_princ_p bigint, nr_sequencia_p bigint, cd_cgc_fornecedor_p text, ds_observacao_p text, nr_seq_lote_fornec_p bigint, nr_receita_p bigint, nr_serie_material_p text, nr_lote_ap_p bigint, ie_vago1_p text, ie_vago2_p text, ie_vago3_p text, ie_atualizar_mat_atend_pac_p text, nr_seq_mat_atend_pac_p bigint) FROM PUBLIC;
