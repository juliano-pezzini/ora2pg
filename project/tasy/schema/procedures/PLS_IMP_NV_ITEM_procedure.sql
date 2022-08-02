-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_imp_nv_item ( nr_seq_conta_p pls_conta_item_imp.nr_seq_conta%type, ie_tipo_item_p pls_conta_item_imp.ie_tipo_item%type, cd_procedimento_p pls_conta_item_imp.cd_procedimento%type, qt_executado_p pls_conta_item_imp.qt_executado%type, ds_procedimento_p pls_conta_item_imp.ds_procedimento%type, cd_tipo_tabela_p pls_conta_item_imp.cd_tipo_tabela%type, dt_execucao_p pls_conta_item_imp.dt_execucao%type, dt_inicio_p pls_conta_item_imp.dt_inicio%type, dt_fim_p pls_conta_item_imp.dt_fim%type, tx_reducao_acrescimo_p pls_conta_item_imp.tx_reducao_acrescimo%type, vl_unitario_p pls_conta_item_imp.vl_unitario%type, vl_total_p pls_conta_item_imp.vl_total%type, -- específicos para material
 ie_tipo_despesa_p pls_conta_item_imp.ie_tipo_despesa%type, cd_unidade_medida_p pls_conta_item_imp.cd_unidade_medida%type, nr_registro_anvisa_p pls_conta_item_imp.nr_registro_anvisa%type, cd_ref_fabricante_p pls_conta_item_imp.cd_ref_fabricante%type, nr_aut_funcionamento_p pls_conta_item_imp.nr_aut_funcionamento%type, -- específicos para procedimentos
 ie_via_acesso_p pls_conta_item_imp.ie_via_acesso%type, ie_tecnica_utilizada_p pls_conta_item_imp.ie_tecnica_utilizada%type, qt_unidade_serv_p pls_conta_item_imp.qt_unidade_serv%type, vl_proc_copartic_p pls_conta_item_imp.vl_proc_copartic%type, ie_autorizado_p pls_conta_item_imp.ie_autorizado%type, cd_dente_p pls_conta_item_imp.cd_dente%type, cd_regiao_boca_p pls_conta_item_imp.cd_regiao_boca%type, cd_face_dente_p pls_conta_item_imp.cd_face_dente%type, -- FIM específicos para procedimentos
 nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_sequencia_p INOUT pls_conta_item_imp.nr_sequencia%type, nr_seq_item_tiss_p pls_conta_proc_regra.nr_seq_item_tiss%type default null, nr_seq_item_tiss_vinculo_p pls_conta_mat_regra.nr_seq_item_tiss_vinculo%type default null) AS $body$
DECLARE


ie_tipo_guia_w		pls_conta.ie_tipo_guia%type;
tx_item_w			pls_conta_proc.tx_item%type;
cd_procedimento_w	bigint;


BEGIN

-- se for para usar a nova forma de importação XML chama da package, caso contrário chama a rotina antiga
if (pls_imp_xml_cta_pck.usar_nova_imp_xml(cd_estabelecimento_p) = 'S') then
	
	nr_sequencia_p := pls_imp_xml_cta_pck.pls_imp_nv_item(	nr_seq_conta_p, ie_tipo_item_p, cd_procedimento_p, qt_executado_p, ds_procedimento_p, cd_tipo_tabela_p, dt_execucao_p, dt_inicio_p, dt_fim_p, tx_reducao_acrescimo_p, vl_unitario_p, vl_total_p, nr_seq_item_tiss_p, nr_seq_item_tiss_vinculo_p, ie_tipo_despesa_p, cd_unidade_medida_p, nr_registro_anvisa_p, cd_ref_fabricante_p, nr_aut_funcionamento_p, ie_via_acesso_p, ie_tecnica_utilizada_p, qt_unidade_serv_p, vl_proc_copartic_p, ie_autorizado_p, cd_dente_p, cd_regiao_boca_p, cd_face_dente_p, nm_usuario_p, nr_sequencia_p);
else
	-- rotinas da estrutura antiga

	-- com o tempo a mesma deve sair daqui e ficar só o novo método de implementação

	
	-- outras despesas viram materiais, qualquer coisa vira procedimento

	-- na importação

	--Tipos de despesa

	--01 Gases medicinais	

	--02 Medicamentos	

	--03 Materiais	

	--04 Taxas diversas Inativo

	--05 Diárias	

	--06 Aluguéis Inativo

	--07 Taxas e aluguéis	

	--08 OPME	
	if	( (ie_tipo_item_p = 'OD') and  ie_tipo_despesa_p in (1,2,3,8) ) then
		
		-- rotina que alimenta os materiais
		CALL pls_imp_conta_mat(	nr_seq_conta_p, cd_procedimento_p,
					qt_executado_p, vl_unitario_p,
					vl_total_p, cd_tipo_tabela_p,
					ds_procedimento_p, null,
					nm_usuario_p, null,
					tx_reducao_acrescimo_p, (ie_tipo_despesa_p)::numeric ,
					dt_execucao_p, dt_inicio_p,
					dt_fim_p, cd_unidade_medida_p,
					nr_registro_anvisa_p, cd_ref_fabricante_p,
					nr_aut_funcionamento_p, nr_seq_item_tiss_p,
					nr_seq_item_tiss_vinculo_p);
	else
		select	max(ie_tipo_guia)
		into STRICT	ie_tipo_guia_w
		from	pls_conta
		where	nr_sequencia = nr_seq_conta_p;
		
		--Somente se aplica a taxa para as guias de Honorário
		if ( ie_tipo_guia_w = '6' ) then
			tx_item_w := obter_tx_proc_via_acesso(ie_via_acesso_p);
		end if;
		

		begin
			cd_procedimento_w := (cd_procedimento_p)::numeric;
		exception
		when others then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(777355,'CD_PROCEDIMENTO='||cd_procedimento_p);
		end;
		
		select	nextval('pls_conta_proc_seq')
		into STRICT	nr_sequencia_p
		;
		
		-- rotina que alimenta os procedimentos
		CALL pls_imp_conta_proc(	null, nr_sequencia_p,
					ie_tipo_guia_w, ie_tipo_despesa_p,
					nr_seq_conta_p, (cd_procedimento_p)::numeric ,
					qt_executado_p, ds_procedimento_p,
					vl_unitario_p, vl_total_p,
					cd_tipo_tabela_p, tx_reducao_acrescimo_p,
					dt_execucao_p, ie_via_acesso_p,
					null, nm_usuario_p,
					tx_item_w, dt_inicio_p,
					dt_fim_p, null,
					ie_tecnica_utilizada_p, nr_seq_item_tiss_p,
					nr_seq_item_tiss_vinculo_p, cd_dente_p,
					cd_regiao_boca_p, cd_face_dente_p,
					qt_unidade_serv_p, vl_proc_copartic_p,
					ie_autorizado_p);
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_imp_nv_item ( nr_seq_conta_p pls_conta_item_imp.nr_seq_conta%type, ie_tipo_item_p pls_conta_item_imp.ie_tipo_item%type, cd_procedimento_p pls_conta_item_imp.cd_procedimento%type, qt_executado_p pls_conta_item_imp.qt_executado%type, ds_procedimento_p pls_conta_item_imp.ds_procedimento%type, cd_tipo_tabela_p pls_conta_item_imp.cd_tipo_tabela%type, dt_execucao_p pls_conta_item_imp.dt_execucao%type, dt_inicio_p pls_conta_item_imp.dt_inicio%type, dt_fim_p pls_conta_item_imp.dt_fim%type, tx_reducao_acrescimo_p pls_conta_item_imp.tx_reducao_acrescimo%type, vl_unitario_p pls_conta_item_imp.vl_unitario%type, vl_total_p pls_conta_item_imp.vl_total%type,  ie_tipo_despesa_p pls_conta_item_imp.ie_tipo_despesa%type, cd_unidade_medida_p pls_conta_item_imp.cd_unidade_medida%type, nr_registro_anvisa_p pls_conta_item_imp.nr_registro_anvisa%type, cd_ref_fabricante_p pls_conta_item_imp.cd_ref_fabricante%type, nr_aut_funcionamento_p pls_conta_item_imp.nr_aut_funcionamento%type,  ie_via_acesso_p pls_conta_item_imp.ie_via_acesso%type, ie_tecnica_utilizada_p pls_conta_item_imp.ie_tecnica_utilizada%type, qt_unidade_serv_p pls_conta_item_imp.qt_unidade_serv%type, vl_proc_copartic_p pls_conta_item_imp.vl_proc_copartic%type, ie_autorizado_p pls_conta_item_imp.ie_autorizado%type, cd_dente_p pls_conta_item_imp.cd_dente%type, cd_regiao_boca_p pls_conta_item_imp.cd_regiao_boca%type, cd_face_dente_p pls_conta_item_imp.cd_face_dente%type,  nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_sequencia_p INOUT pls_conta_item_imp.nr_sequencia%type, nr_seq_item_tiss_p pls_conta_proc_regra.nr_seq_item_tiss%type default null, nr_seq_item_tiss_vinculo_p pls_conta_mat_regra.nr_seq_item_tiss_vinculo%type default null) FROM PUBLIC;

