-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW prescr_laboratorio_suspensao_v (nr_prescricao, nr_sequencia, cd_procedimento, ds_procedimento, qt_procedimento, dt_atualizacao, nm_usuario, ds_observacao, ie_origem_proced, ie_urgencia, ds_dado_clinico, ie_suspenso, cd_setor_atendimento, nr_atendimento, cd_medico, dt_prescricao, dt_liberacao, dt_liberacao_medico, ie_recem_nato, cd_setor_paciente, nm_paciente, nm_paciente_sem_acento, dt_nascimento, ie_sexo, nr_cpf, nr_prontuario, nm_medico, nr_cpf_medico, nr_crm, uf_crm, cd_convenio, cd_categoria, cd_usuario_convenio, dt_validade_carteira, nr_doc_convenio, ie_tipo_guia, ds_convenio, cd_cgc_conv, cd_regional_conv, cd_material_exame, ds_material_exame, cd_exame, nm_exame, ds_material_especial, ie_amostra_entregue, ds_horarios, nr_seq_exame, ds_endereco, nr_endereco, ds_complemento, ds_bairro, ds_municipio, sg_estado, nr_telefone, cd_cep, dt_prev_execucao, ds_setor_paciente, cd_unidade, vl_procedimento, ie_executar_leito, cd_recem_nato, nm_recem_nato, nr_seq_grupo, cd_estabelecimento, nr_seq_proc_interno, cd_interno_integracao, cd_exame_integracao, ds_classif_risco) AS select
	A.NR_PRESCRICAO,
	A.NR_SEQUENCIA,
	A.CD_PROCEDIMENTO,
	p.ds_procedimento,
	A.QT_PROCEDIMENTO,
	A.DT_ATUALIZACAO,
	A.NM_USUARIO,
	A.DS_OBSERVACAO,
	A.IE_ORIGEM_PROCED,
	A.IE_URGENCIA,
	A.DS_DADO_CLINICO,
	A.IE_SUSPENSO,
	A.cd_setor_atendimento,
	B.NR_ATENDIMENTO,
 	B.CD_MEDICO,
 	B.DT_PRESCRICAO,
	B.DT_LIBERACAO,
	B.DT_LIBERACAO_MEDICO,
	B.IE_RECEM_NATO,
	G.cd_setor_atendimento cd_setor_paciente,
	CASE WHEN B.CD_RECEM_NATO IS NULL THEN C.NM_PESSOA_FISICA  ELSE substr(obter_nome_pf(B.CD_RECEM_NATO),1,80) ||' RN de '||C.NM_PESSOA_FISICA END  NM_PACIENTE,
	elimina_acentuacao(UPPER(CASE WHEN B.CD_RECEM_NATO IS NULL THEN C.NM_PESSOA_FISICA  ELSE substr(obter_nome_pf(B.CD_RECEM_NATO),1,80) ||' RN de '||C.NM_PESSOA_FISICA END )) NM_PACIENTE_SEM_ACENTO,
	C.DT_NASCIMENTO,
	C.IE_SEXO,
	C.NR_CPF,
	C.NR_PRONTUARIO,
	D.NM_PESSOA_FISICA NM_MEDICO,
	D.nr_cpf nr_cpf_medico,		/*Elemar - 27/08/2008*/

	E.NR_CRM,
	E.UF_CRM,			/*Elemar - 27/08/2008*/

	F.CD_CONVENIO,	
	F.CD_CATEGORIA,
	F.CD_USUARIO_CONVENIO,
	F.DT_VALIDADE_CARTEIRA, 	/*Elemar - 27/08/2008*/

	F.NR_DOC_CONVENIO,		/*Elemar - 27/08/2008*/

	F.IE_TIPO_GUIA,			/*Elemar - 27/08/2008*/

	V.DS_CONVENIO,
	V.CD_CGC CD_CGC_CONV,		/*Elemar - 27/08/2008*/

	V.CD_REGIONAL CD_REGIONAL_CONV,	/*Elemar - 27/08/2008*/

	A.CD_MATERIAL_EXAME,
	M.ds_material_exame,
	Y.CD_EXAME,
	Y.nm_exame,
	A.DS_MATERIAL_ESPECIAL,
	coalesce(A.ie_amostra,'N') ie_amostra_entregue,
	A.ds_horarios,
	A.nr_seq_exame,
	Z.ds_endereco,
	Z.nr_endereco,
	Z.ds_complemento,
	Z.ds_bairro,
	Z.ds_municipio,
	Z.sg_estado,
	Z.nr_telefone,
	Z.cd_cep,
	A.dt_prev_execucao,
	s.ds_setor_atendimento ds_setor_paciente,
	G.cd_unidade_basica || ' ' || cd_unidade_compl cd_unidade,
	obter_preco_procedimento(T.cd_estabelecimento, F.cd_convenio, F.cd_categoria,
		B.dt_prescricao, A.cd_procedimento, A.ie_origem_proced,
		F.cd_tipo_acomodacao, T.ie_tipo_atendimento, G.cd_setor_atendimento,
		B.cd_medico, null, 
		F.cd_usuario_convenio, F.cd_plano_convenio, T.ie_clinica, F.cd_empresa,
		'P') vl_procedimento,
	A.ie_executar_leito,
	B.CD_RECEM_NATO,
	substr(obter_nome_pf(B.CD_RECEM_NATO),1,80) NM_RECEM_NATO,
	Y.nr_seq_grupo,
	B.cd_estabelecimento,
	A.nr_seq_proc_interno,
	substr(obter_proc_interno(A.nr_seq_proc_interno,'CI'),1,20) cd_interno_integracao,
	Y.cd_exame_integracao cd_exame_integracao,
	substr(obter_desc_triagem(T.nr_seq_triagem),1,60) ds_classif_risco
FROM dual x, convenio v, atendimento_paciente t, setor_atendimento s, procedimento p, atend_paciente_unidade g, atend_categoria_convenio f, pessoa_fisica d, pessoa_fisica c, prescr_medica b
LEFT OUTER JOIN compl_pessoa_fisica z ON (B.CD_PESSOA_FISICA = Z.CD_PESSOA_FISICA AND 1 = Z.IE_TIPO_COMPLEMENTO)
LEFT OUTER JOIN medico e ON (B.CD_MEDICO = E.CD_PESSOA_FISICA)
, prescr_procedimento a
LEFT OUTER JOIN material_exame_lab m ON (A.CD_MATERIAL_EXAME = M.CD_MATERIAL_EXAME)
, coalesce(a
LEFT OUTER JOIN exame_laboratorio y ON (coalesce(A.NR_SEQ_EXAME,obter_exame_lab_proc_int(A.nr_seq_proc_interno)) = Y.NR_SEQ_EXAME)
WHERE A.dt_integracao_suspenso is null and A.cd_procedimento		= p.cd_procedimento and A.ie_origem_proced		= p.ie_origem_proced and coalesce(dt_liberacao_medico, dt_liberacao) is not null AND A.NR_PRESCRICAO 		= B.NR_PRESCRICAO AND B.CD_PESSOA_FISICA 		= C.CD_PESSOA_FISICA   AND B.CD_MEDICO 			= D.CD_PESSOA_FISICA    AND G.NR_SEQ_INTERNO		= obter_atepacu_paciente(B.nr_atendimento,'A') AND G.CD_SETOR_ATENDIMENTO	= s.CD_SETOR_ATENDIMENTO AND coalesce(A.IE_SUSPENSO,'N')	= 'S' AND A.CD_SETOR_ATENDIMENTO in (SELECT s.CD_SETOR_ATENDIMENTO
	FROM SETOR_ATENDIMENTO S
	WHERE s.NM_USUARIO_BANCO IN (SELECT USER )
	) AND B.dt_prescricao BETWEEN LOCALTIMESTAMP - interval '30 days' AND LOCALTIMESTAMP + interval '10 days' AND F.NR_ATENDIMENTO  		= B.NR_ATENDIMENTO AND T.NR_ATENDIMENTO  		= B.NR_ATENDIMENTO AND F.DT_INICIO_VIGENCIA 		= 
      (SELECT MAX(W.DT_INICIO_VIGENCIA) 
       FROM ATEND_CATEGORIA_CONVENIO W
       WHERE W.NR_ATENDIMENTO  = B.NR_ATENDIMENTO) AND F.CD_CONVENIO           	= V.CD_CONVENIO;

