-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE execucao_prescricao_pck.material_atend_pac_after_post ( nr_sequencia_p bigint, ie_acao_executada_p bigint, nr_atendimento_p bigint, cd_material_p bigint, nr_interno_conta_p bigint, ie_barras_p text, ie_devolucao_barras_p text, nr_seq_audit_chamada_p bigint, nr_seq_motivo_audit_p bigint, qt_material_p INOUT bigint, ie_auditoria_p INOUT text, nr_seq_cor_exec_p INOUT bigint, ie_selecao_lanc_autom_p INOUT text, -- Ficar ligado pois dependendo do tipo de nr_seq_cor_exec ele deve abortar apos informar a regra de lancamento automatico.
 ie_necessita_justificativa_p INOUT text,--Variavel de retorno para informar a justificativa
 nm_usuario_p text) AS $body$
BEGIN
	
	if (ie_acao_executada_p = 3) then
		CALL excluir_glosa_valor_mat(nr_sequencia_p, nm_usuario_p);
		CALL exclui_item_integracao_opme(nr_sequencia_p);
	end if;
	
	obter_param_usuario(24, 258, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, current_setting('execucao_prescricao_pck.ie_parametro_258_w')::varchar(1));
	obter_param_usuario(24, 83, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, current_setting('execucao_prescricao_pck.qt_parametro_83_w')::bigint);
	obter_param_usuario(24, 145, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, current_setting('execucao_prescricao_pck.ie_parametro_145_w')::varchar(1));	
	
	CALL atualiza_preco_material(nr_sequencia_p, nm_usuario_p);
	
	/*if (not VarBaixa_Prescricao) and  // OS 215755
	   (Uvar.Varcd_funcao_ativa = 24) and
	   (Inserindo) then
	   begin
	   Material_Atend_Paciente_q.Cancel;
	   Ativa_Query(AtePac_qm.Material_Atend_Paciente_q, True);
	   Abort;
	   end;*/

	
	if (ie_acao_executada_p = 1) and (current_setting('execucao_prescricao_pck.ie_atualiza_auditoria_w')::varchar(1) = 'S') then
		CALL atepac_altera_status_auditado(
							nr_sequencia_p,
							wheb_usuario_pck.get_cd_estabelecimento, 
							nm_usuario_p);
	end if;
	
	CALL envia_alerta_mat_alto_custo(
						cd_material_p,
						nr_atendimento_p,
						nr_interno_conta_p,
						nr_sequencia_p,
						wheb_usuario_pck.get_cd_estabelecimento,
						nm_usuario_p);
	
	CALL gerar_envio_email_material(
						nr_sequencia_p,
						0,
						1,
						wheb_usuario_pck.get_cd_estabelecimento,
						nm_usuario_p,
						null);
						
	if (ie_acao_executada_p in (1,2)) and (ie_devolucao_barras_p = 'N') and
		(((current_setting('execucao_prescricao_pck.ie_parametro_258_w')::varchar(1) = 'S') and (ie_barras_p = 'N')) or (current_setting('execucao_prescricao_pck.ie_parametro_258_w')::varchar(1) = 'B')) then
		ie_necessita_justificativa_p := 'S';--Sera tratado no programa a chamada da WDLG.
	end if;
	
	PERFORM set_config('execucao_prescricao_pck.ie_gerar_lanc_w', 'S', false);
	
	if (ie_acao_executada_p = 1) and (current_setting('execucao_prescricao_pck.ie_parametro_145_w')::varchar(1) = 'N') and (nr_seq_cor_exec_p = 369) then
		PERFORM set_config('execucao_prescricao_pck.ie_gerar_lanc_w', 'N', false);
	end if;
	
	if (current_setting('execucao_prescricao_pck.ie_gerar_lanc_w')::varchar(1) = 'S') and (ie_acao_executada_p = 1) then
		if (current_setting('execucao_prescricao_pck.qt_parametro_83_w')::bigint = 0) then
			CALL gerar_lanc_automatico_mat(
						nr_atendimento_p,
						null,
						132,
						nm_usuario_p,
						nr_sequencia_p,
						null,
						null);
		elsif (current_setting('execucao_prescricao_pck.qt_parametro_83_w')::bigint = 1) then
			ie_selecao_lanc_autom_p := 'S';
		end if;
	end if;
	
	CALL gerar_autor_regra(
				nr_atendimento_p,
				nr_sequencia_p,
				null,
				null,
				null,
				null,
				'EP',
				nm_usuario_p,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null);
				
	if (ie_barras_p = 'S') then
		CALL atualizar_lista_itens_audit(
					nr_interno_conta_p,
					nr_sequencia_p,
					2,
					qt_material_p,
					nm_usuario_p,
					nr_seq_motivo_audit_p,
					nr_seq_audit_chamada_p,
					'N');
	end if;
				
				
	/*
	if (Material_Atend_Paciente_q.FieldByName('ie_auditoria').AsString = 'S') then
   Selecao_Motivo_Auditoria_Modal(UVar.VarFormAtual, Material_Atend_Paciente_q.FieldByName('nr_sequencia').AsInteger);
Atualizar_Lista_Itens_Audit_sp.Prepare;
Atualizar_Lista_Itens_Audit_sp.ParamByName('nr_interno_conta_p').AsInteger    := Material_Atend_Paciente_q.FieldByName('nr_interno_conta').AsInteger;
Atualizar_Lista_Itens_Audit_sp.ParamByName('nr_seq_item_p').AsInteger         := Material_Atend_Paciente_q.FieldByName('nr_sequencia').AsInteger;
Atualizar_Lista_Itens_Audit_sp.ParamByName('ie_tipo_item_p').AsInteger        := 1;
Atualizar_Lista_Itens_Audit_sp.ParamByName('qt_item_p').AsFloat               := Material_Atend_Paciente_q.FieldByName('qt_material').AsFloat;
Atualizar_Lista_Itens_Audit_sp.ParamByName('nm_usuario_p').AsString           := Uvar.Usuarios.Nm_Usuario;
Atualizar_Lista_Itens_Audit_sp.ParamByName('nr_seq_motivo_p').AsInteger       := nr_seq_motivo_audit;
Atualizar_Lista_Itens_Audit_sp.ParamByName('nr_seq_auditoria_p').AsInteger    := VarNr_Seq_Auditoria;
Atualizar_Lista_Itens_Audit_sp.ParamByName('ie_agrupado_p').AsString          := 'N';
Atualizar_Lista_Itens_Audit_sp.ExecProc;

if (Inserindo) and
   (Uvar.Varcd_funcao_ativa = 24) and
   (ie_filtro_ativo) then
   DataSet.Filtered:= True;
ie_filtro_ativo := False;


VarRefreshBarrasSomenteUltimo:= False;
if (VarParam84 = 'B') and
   (Uvar.Varcd_funcao_ativa = 24) and
   (VarUltimoLactoBarras) then
   VarRefreshBarrasSomenteUltimo:= True;  //O Refresh apenas no ultimo nao vai ocorrer aqui no atepac_qm, vai ser no atepac_f6, onde ele ja faz a ativacao no final

if (Inserindo) and (varrefresh) and (not VarRefreshBarrasSomenteUltimo) then
   begin
   Ativa_Query(Material_Atend_Paciente_q, True);
   Material_Atend_Paciente_q.Last;

   if (nr_seq_material_p > 0) then
      Material_Atend_Paciente_q.Locate('NR_SEQUENCIA', nr_seq_material_p, []);
   end;

VarUltimoLactoBarras:= False;
	
	*/


	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE execucao_prescricao_pck.material_atend_pac_after_post ( nr_sequencia_p bigint, ie_acao_executada_p bigint, nr_atendimento_p bigint, cd_material_p bigint, nr_interno_conta_p bigint, ie_barras_p text, ie_devolucao_barras_p text, nr_seq_audit_chamada_p bigint, nr_seq_motivo_audit_p bigint, qt_material_p INOUT bigint, ie_auditoria_p INOUT text, nr_seq_cor_exec_p INOUT bigint, ie_selecao_lanc_autom_p INOUT text, ie_necessita_justificativa_p INOUT text, nm_usuario_p text) FROM PUBLIC;
