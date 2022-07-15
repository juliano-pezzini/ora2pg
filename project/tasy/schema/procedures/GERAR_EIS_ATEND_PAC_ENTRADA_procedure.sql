-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_eis_atend_pac_entrada ( dt_parametro_p timestamp, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE

 
dt_ref_inicial_w	timestamp;
dt_ref_final_w		timestamp;
nr_sequencia_w		bigint;
ie_opcao_w		varchar(2);


BEGIN 
 
if (dt_parametro_p IS NOT NULL AND dt_parametro_p::text <> '') then 
	begin 
 
	if (ie_opcao_p = 'D') then 
		ie_opcao_w	:= 'dd';
	else 
		ie_opcao_w	:= 'mm';
	end if;	
	 
	nr_sequencia_w := Gravar_Log_Indicador(1197, wheb_mensagem_pck.get_texto(307511), clock_timestamp(), trunc(dt_parametro_p), nm_usuario_p, nr_sequencia_w); -- Atendimentos Paciente - Entrada (Novo) 
	delete	FROM eis_atend_pac_entrada where trunc(dt_entrada, ie_opcao_w) = trunc(dt_parametro_p, ie_opcao_w);	
	 
	/*Atualiza o indicador de entrada */
 
	insert into eis_atend_pac_entrada( 
			dt_entrada, 
			dt_alta, 
			nr_atendimento, 
			nr_atend_original, 
			ie_tipo_atendimento, 
			ie_clinica, 
			ie_carater_inter_sus, 
			cd_procedencia, 
			cd_medico_resp, 
			cd_medico_referido, 
			cd_motivo_alta, 
			cd_pessoa_indic, 
			cd_pessoa_juridica_indic, 
			cd_estabelecimento, 
			cd_empresa, 
			nr_seq_forma_chegada, 
			nr_seq_tipo_acidente, 
			nr_seq_classificacao, 
			nr_seq_classif_medico, 
			nr_seq_queixa, 
			nr_seq_indicacao, 
			nm_usuario_intern, 
			nm_usuario_atend, 
			nm_usuario_alta, 
			dt_nascimento, 
			cd_pessoa_fisica, 
			cd_religiao, 
			ie_sexo, 
			ie_estado_civil, 
			ie_grau_instrucao, 
			ie_fluencia_portugues, 
			nr_seq_cor_pele, 
			nr_cep_cidade_nasc, 
			cd_convenio, 
			cd_categoria, 
			cd_plano_convenio, 
			cd_convenio_glosa, 
			cd_categoria_glosa, 
			cd_setor_atendimento, 
			cd_unidade_basica, 
			cd_unidade_compl,	 
			nm_usuario_int, 
			nm_usuario_inter_up, 
			ds_usuario_internacao, 
			nm_usuario_atend_up, 
			ds_usuario_atend, 
			nm_usuario_alta_up, 
			ds_usuario_alta, 
			dt_dia_entrada, 
			dt_dia_alta, 
			dt_mes_entrada, 
			dt_ano_entrada, 
			ds_hora, 
			cd_hora, 
			ds_dia_semana, 
			ds_dia_mes, 
			ds_hora_intervalo, 
			cd_hora_intervalo, 
			ds_hora_alta, 
			cd_hora_alta, 
			nr_dias_internado, 
			nr_dias_internado_number, 
			nr_primeiro_atend, 
			ie_atendimento, 
			ds_atendimento,	 
			ds_tipo_atendimento, 
			ds_clinica,	 
			ds_carater_inter, 
			ds_procedencia, 
			nm_medico, 
			nm_medico_referido, 
			ds_motivo_alta, 
			nm_pessoa_indic, 
			nm_pj_indic, 
			ds_estabelecimento, 
			cd_empresa_atend, 
			nm_empresa_atend, 
			ds_forma_chegada, 
			ds_tipo_acidente, 
			ds_classificacao, 
			ds_classif_medico, 
			ds_queixa, 
			ds_tipo_indicacao, 
			cd_idade, 
			ds_idade, 
			ie_faixa_etaria, 
			ds_religiao, 
			ds_sexo, 
			ds_estado_civil, 
			ds_grau_instrucao, 
			ds_fluencia_portugues, 
			ds_cor_pele, 
			ds_cidade_natal, 
			ds_bairro, 
			ds_nacionalidade, 
			ds_municipio, 
			cd_municipio_ibge, 
			ds_municipio_ibge, 
			ds_municipio_estado_ibge, 
			cd_doenca_cid, 
			ds_diagnostico, 
			cd_especialidade, 
			ds_especialidade, 
			cd_retorno, 
			ds_retorno, 
			ds_dia_turno, 
			cd_turno, 
			ds_turno, 
			ds_motivo_transf, 
			ds_hospital_destino, 
			cd_tipo_historico, 
			ds_tipo_historico, 
			nr_seq_agrupamento, 
			ds_agrupamento, 
			cd_procedimento, 
			ds_procedimento, 
			ie_proced_origem, 
			nm_procedimento_up, 
			ds_lado, 
			ds_interna_proc, 
			ds_microregiao,	 
			ds_convenio, 
			cd_tipo_convenio, 
			ds_tipo_convenio, 
			ds_categoria, 
			ds_tipo_acomodacao, 
			ie_tipo_guia, 
			ds_tipo_guia, 
			ds_plano, 
			ds_convenio_glosa, 
			ds_categoria_glosa, 
			cd_categoria_cid, 
			ds_categoria_cid, 
			ds_setor_atendimento, 
			cd_classif_setor, 
			ds_classif_setor, 
			ds_unidade, 
			cd_setor_entrada, 
			ds_setor_entrada, 
			ie_atend_cancelado, 
			ds_atend_cancelado) 
		SELECT	a.dt_entrada, 
			a.dt_alta, 
			a.nr_atendimento, 
			a.nr_atend_original, 
			a.ie_tipo_atendimento, 
			a.ie_clinica, 
			a.ie_carater_inter_sus, 
			a.cd_procedencia, 
			a.cd_medico_resp, 
			a.cd_medico_referido, 
			a.cd_motivo_alta, 
			a.cd_pessoa_indic, 
			a.cd_pessoa_juridica_indic, 
			a.cd_estabelecimento, 
			f.cd_empresa, 
			a.nr_seq_forma_chegada, 
			a.nr_seq_tipo_acidente, 
			a.nr_seq_classificacao, 
			a.nr_seq_classif_medico, 
			a.nr_seq_queixa, 
			a.nr_seq_indicacao, 
			a.nm_usuario_intern, 
			a.nm_usuario_atend, 
			a.nm_usuario_alta, 
			b.dt_nascimento, 
			b.cd_pessoa_fisica, 
			b.cd_religiao, 
			b.ie_sexo, 
			b.ie_estado_civil, 
			b.ie_grau_instrucao, 
			b.ie_fluencia_portugues, 
			b.nr_seq_cor_pele, 
			b.nr_cep_cidade_nasc, 
			obter_convenio_atendimento(a.nr_atendimento) cd_convenio, 
			d.cd_categoria, 
			d.cd_plano_convenio, 
			d.cd_convenio_glosa, 
			d.cd_categoria_glosa, 
			c.cd_setor_atendimento, 
			c.cd_unidade_basica, 
			c.cd_unidade_compl, 
			substr(obter_usuario_prim_internacao(a.nm_usuario_intern,a.nr_atendimento),1,15) nm_usuario_int, 
			upper(substr(obter_usuario_prim_internacao(a.nm_usuario_intern,a.nr_atendimento),1,15)) nm_usuario_inter_up, 
			substr(obter_nome_usuario(substr(obter_usuario_prim_internacao(a.nm_usuario_intern,a.nr_atendimento),1,15)),1,100) ds_usuario_internacao, 
			uppeR(a.nm_usuario_atend) nm_usuario_atend_up, 
			substr(obter_nome_usuario(a.nm_usuario_atend),1,100) ds_usuario_atend, 
			upper(a.nm_usuario_alta) nm_usuario_alta_up, 
			substr(obter_nome_usuario(a.nm_usuario_alta),1,100) ds_usuario_alta,	 
			trunc(a.dt_entrada, 'dd') dt_dia_entrada, 
			trunc(a.dt_alta, 'dd') dt_dia_alta, 
			trunc(a.dt_entrada, 'mm') dt_mes_entrada, 
			trunc(a.dt_entrada, 'year') dt_ano_entrada,	 
			to_char(a.dt_entrada,'hh24')||':00' ds_hora, 
			(to_char(a.dt_entrada,'hh24'))::numeric  cd_hora, 
			substr(obter_dia_semana(a.dt_entrada),1,20) ds_dia_semana, 
			lpad(to_char(a.dt_entrada,'dd'),2,'0') ds_dia_mes, 
			to_char(truncar_hora_parametro(a.dt_entrada,15),'hh24:mi') ds_hora_intervalo, 
			(to_char(truncar_hora_parametro(a.dt_entrada,15),'hh24mi'))::numeric  cd_hora_intervalo,	 
			to_char(a.dt_alta,'hh24')||':00' ds_hora_alta, 
			(to_char(a.dt_alta,'hh24'))::numeric  cd_hora_alta,	 
			trunc(trunc(coalesce(a.dt_alta, clock_timestamp())) - trunc(a.dt_entrada)) nr_dias_internado, 
			lpad((trunc(trunc(coalesce(a.dt_alta, clock_timestamp())) - trunc(a.dt_entrada)))::numeric ,2,'0') nr_dias_internado_number, 
			CASE WHEN substr(obter_se_primeiro_atend(a.nr_atendimento),1,1)='N' THEN 0  ELSE 1 END  nr_primeiro_atend, 
			CASE WHEN coalesce(a.nr_atend_original,0)=0 THEN 'N'  ELSE 'O' END  ie_atendimento, 
			substr(obter_valor_dominio(1536,CASE WHEN coalesce(a.nr_atend_original,0)=0 THEN 'N'  ELSE 'O' END ),1,254) ds_atendimento,	 
			substr(obter_valor_dominio(12, a.ie_tipo_atendimento),1,254) ds_tipo_atendimento,	 
			substr(obter_valor_dominio(17, a.ie_clinica),1,254) ds_clinica,	 
			substr(Sus_Obter_Desc_Carater_Int(a.ie_carater_inter_sus),1,50) ds_carater_inter, 
			substr(obter_desc_procedencia(a.cd_procedencia),1,40) ds_procedencia, 
			substr(obter_nome_pessoa_fisica(a.cd_medico_resp, null),1,100) nm_medico, 
			substr(obter_nome_medico(a.cd_medico_referido,'N'),1,254) nm_medico_referido, 
			substr(obter_desc_motivo_alta(a.cd_motivo_alta),1,80) ds_motivo_alta, 
			substr(obter_nome_pf(a.cd_pessoa_indic),1,200) nm_pessoa_indic, 
			substr(obter_nome_pf_pj(null,a.cd_pessoa_juridica_indic),1,200) nm_pj_indic,	 
			substr(obter_nome_estabelecimento(a.cd_estabelecimento),1,80) ds_estabelecimento, 
			substr(Obter_Empresa_Atend(a.nr_atendimento,'A','C'),1,100) cd_empresa_atend, 
			substr(Obter_Empresa_Atend(a.nr_atendimento,'A','N'),1,100) nm_empresa_atend,	 
			substr(obter_descricao_padrao('FORMA_CHEGADA', 'DS_FORMA', a.nr_seq_forma_chegada),1,255) ds_forma_chegada, 
			substr(obter_descricao_padrao('TIPO_ACIDENTE', 'DS_TIPO_ACIDENTE', a.nr_seq_tipo_acidente),1,255) ds_tipo_acidente, 
			substr(obter_descricao_padrao('CLASSIFICACAO_ATENDIMENTO','DS_CLASSIFICACAO',a.nr_seq_classificacao),1,254) ds_classificacao, 
			substr(obter_descricao_padrao('MEDICO_CLASSIF_ATEND','DS_CLASSIFICACAO',a.nr_seq_classif_medico),1,40) ds_classif_medico, 
			substr(obter_descricao_padrao('QUEIXA_PACIENTE','DS_QUEIXA',a.nr_seq_queixa),1,40) ds_queixa, 
			substr(obter_descricao_padrao('TIPO_INDICACAO', 'DS_INDICACAO', a.nr_seq_indicacao),1,100) ds_tipo_indicacao,	 
			(substr(obter_idade(b.dt_nascimento,clock_timestamp(),'A'),1,50))::numeric  cd_idade, 
			substr(lpad(obter_idade(b.dt_nascimento,clock_timestamp(),'A'),3,'0'),1,50) ds_idade, 
			substr(obter_idade(b.dt_nascimento,a.dt_entrada,'E'),1,10) ie_faixa_etaria, 
			substr(obter_descricao_padrao('RELIGIAO', 'DS_RELIGIAO', b.cd_religiao),1,255) ds_religiao, 
			substr(obter_valor_dominio(4, b.ie_sexo),1,254) ds_sexo, 
			substr(obter_valor_dominio(5, b.ie_estado_civil),1,254) ds_estado_civil, 
			substr(obter_valor_dominio(10, b.ie_grau_instrucao),1,254) ds_grau_instrucao, 
			substr(obter_valor_dominio(1343,b.ie_fluencia_portugues),1,100) ds_fluencia_portugues, 
			substr(coalesce(obter_desc_cor_pele(b.nr_seq_cor_pele),wheb_mensagem_pck.get_texto(307457)),1,80) ds_cor_pele, -- Não Informada 
			substr(obter_desc_cep_loc(b.nr_cep_cidade_nasc),1,240) ds_cidade_natal,	 
			Initcap(substr(obter_compl_pf(b.cd_pessoa_fisica,1, 'B'),1,255)) ds_bairro, 
			substr(obter_compl_pf(a.cd_pessoa_fisica,1,'NA'),1,30) ds_nacionalidade, 
			Initcap(substr(obter_compl_pf(b.cd_pessoa_fisica,1, 'DSM'),1,255)) ds_municipio, 
			substr(obter_compl_pf(b.cd_pessoa_fisica,1, 'CDM'),1,255) cd_municipio_ibge, 
			Initcap(substr(obter_compl_pf(b.cd_pessoa_fisica,1, 'DM'),1,255)) ds_municipio_ibge, 
			Initcap(obter_compl_pf(b.cd_pessoa_fisica,1, 'DM'))||CASE WHEN coalesce(obter_compl_pf(b.cd_pessoa_fisica,1,'DM')::text, '') = '' THEN ''  ELSE CASE WHEN obter_uf_ibge(obter_compl_pf(b.cd_pessoa_fisica,1, 'CDM')) IS NULL THEN ''  ELSE ' - '||obter_uf_ibge(obter_compl_pf(b.cd_pessoa_fisica,1, 'CDM')) END  END  ds_municipio_estado_ibge,	 
			substr(obter_diag_atend_opcao(a.nr_atendimento,'CD'),1,254) cd_doenca_cid, 
			substr(obter_diagnostico_atendimento(a.nr_atendimento),1,100) ds_diagnostico, 
			coalesce(substr(Obter_Espec_medico_atend(a.nr_atendimento,a.cd_medico_resp,'C'),1,255), substr(Obter_Especialidade_medico(a.cd_medico_resp, 'C'),1,255)) cd_especialidade, 
			coalesce(substr(Obter_Espec_medico_atend(a.nr_atendimento,a.cd_medico_resp,'D'),1,255), substr(Obter_Especialidade_medico(a.cd_medico_resp, 'D'),1,255)) ds_especialidade,	 
			substr(Obter_se_atend_retorno(a.nr_atendimento),1,1) cd_retorno, 
			CASE WHEN substr(Obter_se_atend_retorno(a.nr_atendimento),1,1)='S' THEN wheb_mensagem_pck.get_texto(307510)  ELSE wheb_mensagem_pck.get_texto(307509) END  ds_retorno, -- Retorno		Não Retorno 
			substr(Obter_Turno_Atendimento(a.dt_entrada,a.cd_estabelecimento,'T'),1,15) ds_dia_turno, 
			substr(Obter_Turno_Atendimento(a.dt_entrada,a.cd_estabelecimento,'C'),1,15) cd_turno, 
			substr(Obter_Turno_Atendimento(a.dt_entrada,a.cd_estabelecimento,'D'),1,15) ds_turno, 
			substr(Obter_dados_alta_transf(a.nr_atendimento,'DM'),1,255) ds_motivo_transf, 
			substr(Obter_dados_alta_transf(a.nr_atendimento,'HD'),1,255) ds_hospital_destino, 
			substr(obter_historico_atendimento(a.nr_atendimento, 'C'), 1, 10) cd_tipo_historico, 
			substr(coalesce(obter_historico_atendimento(a.nr_atendimento, 'D'),wheb_mensagem_pck.get_texto(307465)), 1, 100) ds_tipo_historico, -- Não informado 
			(substr(Obter_agrupamento_setor(c.cd_setor_atendimento),1,10))::numeric  nr_seq_agrupamento, 
			substr(Obter_desc_agrupamento_setor(c.cd_setor_atendimento),1,255) ds_agrupamento,	 
			substr(obter_proc_principal(a.nr_atendimento, obter_convenio_atendimento(a.nr_atendimento), a.ie_tipo_atendimento, null, 'C'),1,50) cd_procedimento, 
			substr(obter_proc_principal(a.nr_atendimento, obter_convenio_atendimento(a.nr_atendimento), a.ie_tipo_atendimento, null, 'D'),1,50) ds_procedimento, 
			substr(obter_proc_principal(a.nr_atendimento, obter_convenio_atendimento(a.nr_atendimento), a.ie_tipo_atendimento, null, 'IO'),1,50) ie_proced_origem, 
			upper(substr(obter_proc_principal(a.nr_atendimento, obter_convenio_atendimento(a.nr_atendimento), a.ie_tipo_atendimento, null, 'D'),1,50)) nm_procedimento_up, 
			substr(obter_lado_proced_princ_atend(a.nr_atendimento, 'D'),1,254) ds_lado, 
			substr(Obter_Desc_intern_Proc_Princ(a.nr_atendimento),1,125) ds_interna_proc, 
			coalesce(Obter_Microregiao_Paciente(obter_compl_pf(b.cd_pessoa_fisica,1,'CEP'),obter_compl_pf(b.cd_pessoa_fisica,1,'CDM')),Obter_Microregiao_Paciente(null,obter_compl_pf(b.cd_pessoa_fisica,1,'CDM'))) ds_microregiao,	 
			substr(obter_nome_convenio(obter_convenio_atendimento(a.nr_atendimento)),1,150) ds_convenio, 
			obter_tipo_convenio(obter_convenio_atendimento(a.nr_atendimento)) cd_tipo_convenio, 
			substr(obter_desc_tipo_convenio(obter_convenio_atendimento(a.nr_atendimento)),1,200) ds_tipo_convenio, 
			substr(obter_categoria_convenio(d.cd_convenio, d.cd_categoria),1,100) ds_categoria, 
			substr(obter_tipo_acomod_atend(a.nr_atendimento,'D'),1,80) ds_tipo_acomodacao, 
			substr(obter_tipo_guia_convenio(a.nr_atendimento),1,20) ie_tipo_guia, 
			substr(obter_valor_dominio(1031,obter_tipo_guia_convenio(a.nr_atendimento)),1,254) ds_tipo_guia, 
			substr(obter_desc_plano_conv(d.cd_convenio,d.cd_plano_convenio),1,100) ds_plano, 
			substr(obter_nome_convenio(d.cd_convenio_glosa),1,150) ds_convenio_glosa, 
			substr(obter_categoria_convenio(d.cd_convenio_glosa, d.cd_categoria_glosa),1,100) ds_categoria_glosa, 
			substr(Obter_Categoria_Cid(obter_diag_atend_opcao(a.nr_atendimento,'CD')),1,10) cd_categoria_cid, 
			substr(obter_desc_categoria_cid(Obter_Categoria_Cid(obter_diag_atend_opcao(a.nr_atendimento,'CD'))),1,100) ds_categoria_cid,	 
			substr(obter_nome_setor(c.cd_setor_atendimento),1,100) ds_setor_atendimento, 
			obter_classif_setor(c.cd_setor_atendimento) cd_classif_setor, 
			substr(obter_valor_dominio(1,obter_classif_setor(c.cd_setor_atendimento)),1,100) ds_classif_setor, 
			substr(obter_nome_setor(c.cd_setor_atendimento),1,100) || ' ' || c.cd_unidade_basica || ' ' || c.cd_unidade_compl ds_unidade, 
			(SELECT	coalesce(cd_setor_atendimento,0) 
			from	atend_paciente_unidade 
			where	nr_seq_interno = obter_atepacu_paciente(a.nr_atendimento, 'P')) cd_setor_entrada, 
			coalesce(substr(obter_nome_setor((select	cd_setor_atendimento 
			from	atend_paciente_unidade 
			where	nr_seq_interno = obter_atepacu_paciente(a.nr_atendimento, 'P'))),1,255),wheb_mensagem_pck.get_texto(307465)) ds_setor_entrada, -- Não informado 
			substr(CASE WHEN coalesce(a.dt_cancelamento::text, '') = '' THEN 'N'  ELSE 'C' END ,1,1) ie_atend_cancelado, 
			substr(obter_valor_dominio(5727,CASE WHEN coalesce(a.dt_cancelamento::text, '') = '' THEN 'N'  ELSE 'C' END ),1,255) ds_atend_cancelado 
		FROM estabelecimento f, atend_categoria_convenio d, atend_paciente_unidade c, pessoa_fisica b, atendimento_paciente a
LEFT OUTER JOIN motivo_alta h ON (a.cd_motivo_alta = h.cd_motivo_alta)
WHERE a.cd_pessoa_fisica	= b.cd_pessoa_fisica and a.nr_atendimento	= c.nr_atendimento and d.nr_atendimento	= a.nr_atendimento and a.cd_estabelecimento	= f.cd_estabelecimento  and trunc(a.dt_entrada, ie_opcao_w) = trunc(dt_parametro_p, ie_opcao_w) and coalesce(h.ie_cancelado,'N')	= 'N' and c.nr_seq_interno 	= (select obter_atepacu_paciente(c.nr_atendimento, 'A') ) and d.nr_seq_interno	= Obter_Atecaco_atendimento(a.nr_atendimento);
		  
		CALL Atualizar_Log_Indicador(clock_timestamp(), nr_sequencia_w);
	 
		COMMIT;
	end;
end if;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_eis_atend_pac_entrada ( dt_parametro_p timestamp, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;

