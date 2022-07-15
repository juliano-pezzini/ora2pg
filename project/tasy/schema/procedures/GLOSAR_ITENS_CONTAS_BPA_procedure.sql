-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE glosar_itens_contas_bpa ( nr_interno_conta_pos_p bigint, nr_interno_conta_neg_p bigint, nr_sequencia_p bigint, qt_glosado_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_interno_conta_w	bigint;
nr_conta_antiga_w	bigint;
nr_seq_nova_w		bigint;
qt_adic_w		smallint;
qt_acao_w		smallint;
cd_acao_w		varchar(1);
qt_contas_W		smallint	:= 0;
cont_w			smallint;
nr_seq_desc_dest_w	bigint;
nr_seq_protocolo_w	bigint	:= 0;
qt_proced_w		double precision	:= 0;
vl_adic_plant_w		double precision	:= 0;
vl_anestesista_w	double precision	:= 0;
vl_auxiliares_w		double precision	:= 0;
vl_custo_operacional_w	double precision	:= 0;
vl_materiais_w		double precision	:= 0;
vl_medico_w		double precision	:= 0;
vl_procedimento_w	double precision	:= 0;

 

BEGIN 
 
select	nr_interno_conta, 
	qt_procedimento 
into STRICT	nr_conta_antiga_w, 
	qt_proced_w 
from	procedimento_paciente 
where	nr_sequencia	= nr_sequencia_p;
 
select	max(coalesce(nr_seq_protocolo,0)) 
into STRICT	nr_seq_protocolo_w 
from	conta_Paciente 
where	nr_interno_conta	= nr_conta_antiga_w;
 
while(qt_contas_W	< 2) loop 
	begin 
	qt_contas_W	:= qt_contas_W + 1;
	 
	select	nextval('procedimento_paciente_seq') 
	into STRICT 	nr_seq_nova_w 
	;
 
	/* Gerar os procedimentos na conta negativa */
 
	if (qt_contas_W	= 1) then 
		nr_interno_conta_w	:= nr_interno_conta_neg_p;
		qt_adic_w		:= 1;
		qt_acao_w		:= -1;
		cd_acao_w		:= 1;
	/* Gerar os procedimentos na conta positiva */
 
	elsif (qt_contas_W	= 2) then 
		nr_interno_conta_w	:= nr_interno_conta_pos_p;
		qt_adic_w		:= 1;
		qt_acao_w		:= 1;
	end if;
 
	/* Busca os valores unitarios e multiplica pela quantidade glosada */
 
	select (vl_adic_plant / qt_procedimento) * qt_glosado_p, 
		(vl_anestesista / qt_procedimento) * qt_glosado_p, 
		(vl_auxiliares / qt_procedimento) * qt_glosado_p, 
		(vl_custo_operacional / qt_procedimento) * qt_glosado_p, 
		(vl_materiais / qt_procedimento) * qt_glosado_p, 
		(vl_medico / qt_procedimento) * qt_glosado_p, 
		(vl_procedimento / qt_procedimento) * qt_glosado_p 
	into STRICT	vl_adic_plant_w, 
		vl_anestesista_w, 
		vl_auxiliares_w, 
		vl_custo_operacional_w, 
		vl_materiais_w, 
		vl_medico_w, 
		vl_procedimento_w 
	from	procedimento_paciente 
	where	nr_Sequencia	= nr_sequencia_p;
	 
	insert	into procedimento_paciente( 
		nr_sequencia, nr_atendimento, dt_entrada_unidade, cd_procedimento, 
		dt_procedimento, qt_procedimento, dt_atualizacao, nm_usuario, 
		cd_medico, cd_convenio, cd_categoria, cd_pessoa_fisica, dt_prescricao, 
		ds_observacao, vl_procedimento, vl_medico, vl_anestesista, vl_materiais, 
		cd_edicao_amb, cd_tabela_servico, dt_vigencia_preco, cd_procedimento_princ, 
		dt_procedimento_princ, dt_acerto_conta, dt_acerto_convenio, 
		dt_acerto_medico,	vl_auxiliares, vl_custo_operacional, 
		tx_medico, tx_anestesia, nr_prescricao, nr_sequencia_prescricao, 
		cd_motivo_exc_conta, ds_compl_motivo_excon, cd_acao, qt_devolvida, 
		cd_motivo_devolucao, nr_cirurgia, nr_doc_convenio, cd_medico_executor, 
		ie_cobra_pf_pj, nr_laudo, dt_conta, cd_setor_atendimento, 
		cd_conta_contabil, cd_procedimento_aih, ie_origem_proced, nr_aih,	 
		ie_responsavel_credito,	tx_procedimento, cd_equipamento,ie_valor_informado, 
		cd_estabelecimento_custo, cd_tabela_custo, cd_situacao_glosa, 
		nr_lote_contabil,	cd_procedimento_convenio, nr_seq_autorizacao, 
		ie_tipo_servico_sus, ie_tipo_ato_sus, cd_cgc_prestador, nr_nf_prestador, 
		cd_atividade_prof_bpa, nr_interno_conta, nr_seq_proc_princ,	ie_guia_informada, 
		dt_inicio_procedimento,	ie_emite_conta, ie_funcao_medico, ie_classif_sus, 
		cd_especialidade, nm_usuario_original, 
		ie_tipo_proc_sus,cd_setor_receita, vl_adic_plant, nr_seq_atepacu, ie_proc_princ_atend, 
		nr_seq_proc_pacote, cd_medico_req, ie_tipo_guia, ie_video, ie_auditoria, nr_seq_exame,nr_seq_aih,ie_doc_executor,cd_cbo) 
	SELECT 
		nr_seq_nova_w, nr_atendimento, dt_entrada_unidade, cd_procedimento, 
		dt_procedimento + (qt_adic_w / 86400), qt_glosado_p * qt_acao_w, 
		clock_timestamp(), nm_usuario_p, cd_medico, cd_convenio, cd_categoria, 
		cd_pessoa_fisica, dt_prescricao, ds_observacao, vl_procedimento_w * qt_acao_w, 
		vl_medico_w * qt_acao_w, vl_anestesista_w * qt_acao_w, 
		vl_materiais_w * qt_acao_w, cd_edicao_amb, cd_tabela_servico, 
		dt_vigencia_preco, cd_procedimento_princ,	dt_procedimento_princ, 
		dt_acerto_conta + (qt_adic_w / 86400), dt_acerto_convenio, 
		dt_acerto_medico, vl_auxiliares_w * qt_acao_w, vl_custo_operacional_w * qt_acao_w, 
		tx_medico, tx_anestesia, nr_prescricao, nr_sequencia_prescricao, 
		cd_motivo_exc_conta, ds_compl_motivo_excon, cd_acao_w, 
		qt_devolvida * qt_acao_w, cd_motivo_devolucao, nr_cirurgia, nr_doc_convenio, 
		cd_medico_executor, ie_cobra_pf_pj,	nr_laudo, dt_conta, 
		cd_setor_atendimento, cd_conta_contabil, cd_procedimento_aih, 
		ie_origem_proced,	nr_aih, ie_responsavel_credito, tx_procedimento, 
		cd_equipamento, CASE WHEN qt_adic_w=1 THEN 'S'  ELSE ie_valor_informado END , 
		cd_estabelecimento_custo, cd_tabela_custo, cd_situacao_glosa, 0, 
		cd_procedimento_convenio, nr_seq_autorizacao, ie_tipo_servico_sus, 
		ie_tipo_ato_sus, cd_cgc_prestador, nr_nf_prestador, cd_atividade_prof_bpa, 
		nr_interno_conta_w, nr_seq_proc_princ, ie_guia_informada, 
		dt_inicio_procedimento,	ie_emite_conta, ie_funcao_medico, ie_classif_sus, 
		cd_especialidade,	nm_usuario_original, ie_tipo_proc_sus, 
		cd_setor_receita, vl_adic_plant_w * qt_acao_w, nr_seq_atepacu, ie_proc_princ_atend, 
		CASE WHEN nr_conta_antiga_w=nr_interno_conta_w THEN  nr_seq_proc_pacote  ELSE null END , 
		cd_medico_req, ie_tipo_guia, ie_video, ie_auditoria, nr_seq_exame,nr_seq_aih,ie_doc_executor,cd_cbo 
	from	procedimento_paciente 
	where	nr_sequencia = nr_sequencia_p;
 
	insert into procedimento_participante( 
		nr_sequencia, nr_seq_partic, ie_funcao, dt_atualizacao, 
		nm_usuario,	cd_pessoa_fisica,	cd_cgc, ie_valor_informado, 
		ie_emite_conta, vl_participante, vl_conta, nr_lote_contabil, 
		nr_conta_medico, ie_tipo_servico_sus, ie_tipo_ato_sus, 
		qt_ponto_sus, vl_ponto_sus, vl_original, ie_responsavel_credito, 
		pr_procedimento) 
	SELECT 
		nr_seq_nova_w, nr_seq_partic,ie_funcao, clock_timestamp(), 
		nm_usuario_p, cd_pessoa_fisica, cd_cgc, 
		CASE WHEN qt_adic_w=1 THEN 'S'  ELSE ie_valor_informado END ,ie_emite_conta, 
		vl_participante * qt_acao_w,	vl_conta * qt_acao_w, 
		0,	nr_conta_medico, ie_tipo_servico_sus, 
		ie_tipo_ato_sus, qt_ponto_sus * qt_acao_w, 
		vl_ponto_sus * qt_acao_w, vl_original * qt_acao_w, 
		ie_responsavel_credito,	pr_procedimento 
	from	procedimento_participante 
	where	nr_sequencia = nr_sequencia_p;
 
	Insert into proc_paciente_valor( 
		nr_seq_procedimento, nr_sequencia, ie_tipo_valor, 
 		dt_atualizacao, nm_usuario, vl_procedimento, 
 		vl_medico, vl_anestesista, vl_materiais, vl_auxiliares, 
 		vl_custo_operacional, cd_convenio, cd_categoria, pr_valor) 
	SELECT 
		nr_seq_nova_w, nr_sequencia, ie_tipo_valor, 
 		clock_timestamp(), nm_usuario_p, vl_procedimento * qt_acao_w, 
 		vl_medico * qt_acao_w, vl_anestesista * qt_acao_w, 
 		vl_materiais * qt_acao_w, vl_auxiliares * qt_acao_w, 
 		vl_custo_operacional * qt_acao_w, cd_convenio, 
 		cd_categoria, pr_valor 
	from proc_paciente_valor 
	where nr_seq_procedimento = nr_sequencia_p;
 
 
	insert into sus_valor_proc_paciente( 
		nr_sequencia, dt_atualizacao, nm_usuario, dt_competencia, 
		qt_ato_medico, qt_ato_anestesista, vl_matmed, vl_diaria, vl_taxas, 
		vl_medico, vl_sadt, vl_contraste, vl_gesso, vl_quimioterapia, 
		vl_dialise, vl_tph, vl_filme_rx, vl_filme_ressonancia, vl_anestesia, 
		vl_sadt_rx, vl_sadt_pc, vl_outros, vl_ato_medico, vl_ato_anestesista, 
		cd_faixa_etaria, ie_tipo_atend_bpa, ie_grupo_atend_bpa, vl_ato_sadt, 
		vl_ponto_sp, vl_ponto_sadt, ie_versao, cd_porte_anestesico) 
	SELECT	nr_seq_nova_w, clock_timestamp(), nm_usuario_p, dt_competencia, 
		qt_ato_medico, qt_ato_anestesista, vl_matmed * qt_acao_w, vl_diaria * qt_acao_w, 
		vl_taxas * qt_acao_w, vl_medico * qt_acao_w, vl_sadt * qt_acao_w, vl_contraste * qt_acao_w, 
		vl_gesso * qt_acao_w, vl_quimioterapia * qt_acao_w, vl_dialise * qt_acao_w, vl_tph * qt_acao_w, 
		vl_filme_rx * qt_acao_w, vl_filme_ressonancia * qt_acao_w, vl_anestesia * qt_acao_w, 
		vl_sadt_rx * qt_acao_w, vl_sadt_pc * qt_acao_w, vl_outros * qt_acao_w, vl_ato_medico * qt_acao_w, 
		vl_ato_anestesista * qt_acao_w, 
		cd_faixa_etaria, ie_tipo_atend_bpa, ie_grupo_atend_bpa, vl_ato_sadt * qt_acao_w, 
		vl_ponto_sp * qt_acao_w, vl_ponto_sadt * qt_acao_w, ie_versao, cd_porte_anestesico 
	from	sus_valor_proc_paciente 
	where	nr_sequencia	= nr_sequencia_p;	
	end;
end loop;
 
/*Felipe - 08/11/2006, comentei pois assim não estava gerando o repasse para os itens não glosados 
update	conta_paciente 
set	ie_cancelamento		= 'C', 
	dt_cancelamento		= sysdate 
where	nr_interno_conta	= nr_conta_antiga_w; 
 
update	conta_paciente 
set 	ie_cancelamento		= 'E', 
	nr_seq_conta_origem	= nr_conta_antiga_w 
where	nr_interno_conta	= nr_interno_conta_neg_p; 
*/
 
 
update	conta_paciente 
set 	nr_seq_conta_origem	= nr_conta_antiga_w 
where	nr_interno_conta	= nr_interno_conta_pos_p;
 
if (nr_seq_protocolo_w	> 0) then 
	update	conta_paciente 
	set	nr_seq_protocolo	= nr_seq_protocolo_w 
	where	nr_interno_conta	= nr_interno_conta_neg_p;
end if;
 
 
/* Atualizar as tabelas resumo da conta de estorno */
 
--gerar_conta_paciente_repasse(nr_interno_conta_neg_p, nm_usuario_p); Edgar 27/11/2006 OS 44530, troquei pela linha abaixo para forçar o estorno 
CALL Recalcular_Conta_Repasse(nr_interno_conta_neg_p,null,null, nm_usuario_p);
CALL Gerar_conta_paciente_guia(nr_interno_conta_neg_p, 2);
CALL Atualizar_Resumo_Conta(nr_interno_conta_neg_p, 2);
 
 
/* Atualizar as tabelas resumo da conta de estorno */
 
CALL Gerar_conta_paciente_guia(nr_interno_conta_pos_p, 2);
CALL Atualizar_Resumo_Conta(nr_interno_conta_pos_p, 2);
 
commit;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE glosar_itens_contas_bpa ( nr_interno_conta_pos_p bigint, nr_interno_conta_neg_p bigint, nr_sequencia_p bigint, qt_glosado_p bigint, nm_usuario_p text) FROM PUBLIC;

