-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE enviar_lote_inca ( nr_seq_lote_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_lote_w	integer := 0;
nr_seq_can_inca_lote_item_w 	integer;
ie_tipo_data_w	varchar(1);
dt_inicial_w	timestamp;
dt_fim_w	timestamp;
nr_pront_ini_w	bigint;
nr_pront_fim_w	bigint;

BEGIN
-- verifica se já foi inserido uma consulta para essa sequencia 
 
SELECT 	coalesce(MAX(nr_seq_lote),0) 
INTO STRICT 	nr_seq_lote_w 
FROM 	CAN_INCA_ENVIO_LOTE_ITEM 
WHERE 	nr_seq_lote = nr_seq_lote_p;
 
 
--se nao foi inserido , o sistema ir inserir essa consulta na tabela 
IF (nr_seq_lote_w = 0) THEN 
  BEGIN 
	--pega os dadaos da tabela de consulta 
 
	SELECT 	MAX(nr_pront_inicio), 
		MAX(nr_pront_fim), 
		MAX(ie_tipo_data), 
		MAX(dt_inicial), 
		MAX(dt_final) 
	INTO STRICT	nr_pront_ini_w, 
		nr_pront_fim_w, 
		ie_tipo_data_w, 
		dt_inicial_w, 
		dt_fim_w 
	FROM 	can_inca_envio_lote 
	WHERE	nr_sequencia = nr_seq_lote_p;
 
	IF (ie_tipo_data_w = 'C') THEN 
	  	INSERT INTO CAN_INCA_ENVIO_LOTE_ITEM(NR_SEQUENCIA, 
			DT_ATUALIZACAO, 
			NM_USUARIO, 
			DT_ATUALIZACAO_NREC, 
			NM_USUARIO_NREC, 
			NR_PRONTUARIO, 
			CD_TIPO_TUMOR, 
			IE_CASO_ANALITICO, 
			NM_PACIENTE, 
			CD_PESSOA_FISICA, 
			DS_SEXO, 
			DS_IDADE, 
			DT_NASCIMENTO, 
			NR_CEP_CIDADE_NASC, 
			DS_COR_PELE, 
			DS_GRAU_INSTRUCAO, 
			DS_PROFISSAO, 
			DS_MUNICIPIO, 
			CD_CLINICA_ATENDIMENTO, 
			NR_CPF, 
			DT_CONSULTA, 
			DT_DIAGNOSTICO, 
			IE_DIAG_TRAT_PREVIO, 
			CD_TOPOG_TU_PRIM, 
			IE_MAIS_UM_TU_PRIM, 
			CD_ESTADIO, 
			CD_ESTADIO_OUTRO, 
			DS_TNM, 
			DS_PTNM, 
			DS_LOCALIZACAO_METASTASE, 
			DT_INICIO_TRAT, 
			CD_RAZAO_NAO_TRAT, 
			DS_PRIMEIRO_TRATAMENTO, 
			IE_ESTADO_PAC_FIM_TRAT, 
			DT_OBITO, 
			CD_CID_MORTE_IMEDIATA, 
			CD_CID_MORTE_BASICA, 
			IE_SEGUIMENTO, 
			CD_TIPO_REGISTRO, 
			DT_PREENCH_FICHA, 
			DS_ESTADO_CIVIL, 
			DT_TRIAGEM, 
			IE_HIST_CANCER, 
			IE_ALCOOLISMO, 
			IE_TABAGISMO, 
			CD_CONVENIO, 
			CD_TOPOG_LOC_PROV, 
			DS_EXAMES_RELEVANTES, 
			CD_LATERALIDADE, 
			DS_RUA_PAC, 
			DS_BAIRRO_PAC, 
			DS_CIDADE_PAC, 
			DS_UF_PAC, 
			DS_TELEFONE_PAC, 
			DS_CEP_PAC, 
			NR_SEQ_LOTE, 
			CD_CLINICA_ENTRADA, 
			cd_morfologia_tu_prim, 
			cd_base_diag, 
			NM_MAE, 
			IE_OBITO_CANCER, 
			IE_CUSTO_DIAGNOSTICO, 
			IE_CUSTEIO_TRATAMENTO, 
			NR_ENDERECO, 
			DS_COMPLEMENTO, 
			DS_EMAIL 
			) 
			(SELECT 
			  nextval('can_inca_envio_lote_item_seq'), 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				a.NR_PRONTUARIO, 
				a.CD_TIPO_TUMOR, 
				a.IE_CASO_ANALITICO, 
				b.nm_pessoa_fisica, 
				b.cd_pessoa_fisica, 
				CASE WHEN b.ie_sexo='M' THEN '1' WHEN b.ie_sexo='F' THEN '2'  ELSE '8' END , 
				obter_idade(clock_timestamp(), b.dt_nascimento, 'A'), 
				b.dt_nascimento, 
				b.nr_cep_cidade_nasc, 
				b.nr_seq_cor_pele, 
				b.ie_grau_instrucao, 
				SUBSTR(c.cd_profissao, 1, (LENGTH(c.cd_profissao)-2)), 
				c.cd_municipio_ibge||CALCULA_DIGITO('MODULO10', c.cd_municipio_ibge), 
				a.cd_clinica_atendimento, 
				b.nr_cpf, 
				a.dt_consulta, 
				a.dt_diagnostico, 
				a.IE_DIAG_TRAT_PREVIO, 
				a.CD_TOPOG_TU_PRIM, 
				a.IE_MAIS_UM_TU_PRIM, 
				CASE WHEN UPPER(a.CD_ESTADIO)='I' THEN 1 WHEN UPPER(a.CD_ESTADIO)='II' THEN 2 WHEN UPPER(a.CD_ESTADIO)='III' THEN 3 WHEN UPPER(a.CD_ESTADIO)='IV' THEN 4 WHEN UPPER(a.CD_ESTADIO)='V' THEN 5 END , 
				CASE WHEN UPPER(a.CD_ESTADIO_OUTRO)='I' THEN 1 WHEN UPPER(a.CD_ESTADIO_OUTRO)='II' THEN 2 WHEN UPPER(a.CD_ESTADIO_OUTRO)='III' THEN 3 WHEN UPPER(a.CD_ESTADIO_OUTRO)='IV' THEN 4 WHEN UPPER(a.CD_ESTADIO_OUTRO)='V' THEN 5 END , 
				obter_somente_numero(a.CD_TUMOR_PRIMARIO||a.CD_LINFONODO_REGIONAL||a.CD_METASTASE_DISTANCIA), 
				obter_somente_numero(a.CD_LINFONODO_REG_PAT||a.CD_LINFONODO_REG_PAT||a.CD_METASTASE_DIST_PAT), 
				obter_somente_numero(a.CD_TOPOG_MD_PRIM||' '||CD_TOPOG_MD_SEG||' '||CD_TOPOG_MD_TER||' '||CD_TOPOG_MD_QUA), 
				a.DT_INICIO_TRAT, 
				a.CD_RAZAO_NAO_TRAT, 
				CASE WHEN IE_TRAT_INSTITUICAO='S' THEN '1' END ||CASE WHEN IE_TRAT_INST_CIR='S' THEN '2' END ||CASE WHEN IE_TRAT_INST_OUTRO='S' THEN '8' END ||CASE WHEN IE_TRAT_INST_QUIMIO='S' THEN '4' END ||CASE WHEN IE_TRAT_INST_RADIO='S' THEN '3' END ||CASE WHEN IE_TRAT_INST_SEM_INF='S' THEN '9' END ||CASE WHEN IE_TRAT_INST_HORM='S' THEN '5' END ||CASE WHEN IE_TRAT_INST_IMUNO='S' THEN '7' END ||CASE WHEN IE_TRAT_INST_TMO='S' THEN '6' END , 
				a.IE_ESTADO_PAC_FIM_TRAT, 
				a.DT_OBITO, 
				a.CD_CID_MORTE_IMEDIATA, 
				a.CD_CID_MORTE_BASICA, 
				CASE WHEN a.IE_SEGUIMENTO='S' THEN 1  ELSE 2 END , 
				02, 
				a.DT_PREENCH_FICHA, 
				b.ie_estado_civil, 
				a.dt_triagem, 
				CASE WHEN a.IE_HIST_CANCER='S' THEN 1 WHEN a.IE_HIST_CANCER='N' THEN 2 WHEN a.IE_HIST_CANCER='NA' THEN 8  ELSE 9 END , 
				CASE WHEN a.IE_ALCOOLISMO='S' THEN 1 WHEN a.IE_ALCOOLISMO='N' THEN 2 WHEN a.IE_ALCOOLISMO='NA' THEN 8  ELSE 9 END , 
				CASE WHEN a.IE_TABAGISMO='S' THEN 1 WHEN a.IE_TABAGISMO='N' THEN 2 WHEN a.IE_TABAGISMO='NA' THEN 8  ELSE 9 END , 
				(SELECT	e.cd_convenio 
				FROM	atend_categoria_convenio e 
				WHERE	e.nr_seq_interno = (	SELECT	MIN(f.nr_seq_interno) 
							 	FROM	atendimento_paciente f1, 
									atend_categoria_convenio f 
								WHERE	f1.nr_atendimento = f.nr_atendimento 
								AND	f1.cd_pessoa_fisica = a.cd_pessoa_fisica)), 
				a.CD_TOPOG_LOC_PROV, 
				CASE WHEN a.IE_ERD_EXAME_CLINICO='N' THEN ''  ELSE '1' END ||CASE WHEN a.IE_ERD_EXAME_IMAGEM='N' THEN ''  ELSE '2' END ||CASE WHEN a.IE_ERD_ANATOMIA_PAT='N' THEN ''  ELSE '4' END ||CASE WHEN a.IE_ERD_ENDOSCOPIA='N' THEN ''  ELSE '3' END ||CASE WHEN a.IE_ERD_SEM_INFORMACAO='N' THEN ''  ELSE '9' END ||CASE WHEN a.IE_ERD_NAO_SE_APLICA='N' THEN ''  ELSE '8' END , 
				a.CD_LATERALIDADE, 
				obter_compl_pf(b.cd_pessoa_fisica, 1, 'e'), 
				obter_compl_pf(b.cd_pessoa_fisica, 1, 'b'), 
				obter_compl_pf(b.cd_pessoa_fisica, 1, 'ci'), 
				obter_compl_pf(b.cd_pessoa_fisica, 1, 'UF'), 
				obter_compl_pf(b.cd_pessoa_fisica, 1, 't'), 
				obter_compl_pf(b.cd_pessoa_fisica, 1, 'CEP'), 
				nr_seq_lote_p, 
				a.CD_CLINICA_ENTRADA, 
				a.cd_morfologia_tu_prim, 
				a.cd_base_diag, 
				obter_dados_pf(b.cd_pessoa_fisica,'NDR'), 
				a.ie_obito_cancer, 
				a.ie_custo_diagnostico, 
				a.ie_custo_tratamento, 
				obter_compl_pf(b.cd_pessoa_fisica,1,'NR'), 
				obter_compl_pf(b.cd_pessoa_fisica,1,'CO'), 
				obter_compl_pf(b.cd_pessoa_fisica,1,'M') 
			FROM compl_pessoa_fisica c, pessoa_fisica b, can_ficha_admissao a
LEFT OUTER JOIN cido_topografia d ON (a.CD_TOPOG_TU_PRIM = d.cd_topografia)
WHERE a.cd_pessoa_fisica = b.cd_pessoa_fisica AND c.cd_pessoa_fisica = b.cd_pessoa_fisica AND c.ie_tipo_complemento = 1  AND (a.dt_consulta BETWEEN dt_inicial_w AND dt_fim_w ) 
			 );
		ELSIF (ie_tipo_data_w = 'T' ) THEN 
	  	INSERT INTO CAN_INCA_ENVIO_LOTE_ITEM(NR_SEQUENCIA, 
			DT_ATUALIZACAO, 
			NM_USUARIO, 
			DT_ATUALIZACAO_NREC, 
			NM_USUARIO_NREC, 
			NR_PRONTUARIO, 
			CD_TIPO_TUMOR, 
			IE_CASO_ANALITICO, 
			NM_PACIENTE, 
			CD_PESSOA_FISICA, 
			DS_SEXO, 
			DS_IDADE, 
			DT_NASCIMENTO, 
			NR_CEP_CIDADE_NASC, 
			DS_COR_PELE, 
			DS_GRAU_INSTRUCAO, 
			DS_PROFISSAO, 
			DS_MUNICIPIO, 
			CD_CLINICA_ATENDIMENTO, 
			NR_CPF, 
			DT_CONSULTA, 
			DT_DIAGNOSTICO, 
			IE_DIAG_TRAT_PREVIO, 
			CD_TOPOG_TU_PRIM, 
			IE_MAIS_UM_TU_PRIM, 
			CD_ESTADIO, 
			CD_ESTADIO_OUTRO, 
			DS_TNM, 
			DS_PTNM, 
			DS_LOCALIZACAO_METASTASE, 
			DT_INICIO_TRAT, 
			CD_RAZAO_NAO_TRAT, 
			DS_PRIMEIRO_TRATAMENTO, 
			IE_ESTADO_PAC_FIM_TRAT, 
			DT_OBITO, 
			CD_CID_MORTE_IMEDIATA, 
			CD_CID_MORTE_BASICA, 
			IE_SEGUIMENTO, 
			CD_TIPO_REGISTRO, 
			DT_PREENCH_FICHA, 
			DS_ESTADO_CIVIL, 
			DT_TRIAGEM, 
			IE_HIST_CANCER, 
			IE_ALCOOLISMO, 
			IE_TABAGISMO, 
			CD_CONVENIO, 
			CD_TOPOG_LOC_PROV, 
			DS_EXAMES_RELEVANTES, 
			CD_LATERALIDADE, 
			DS_RUA_PAC, 
			DS_BAIRRO_PAC, 
			DS_CIDADE_PAC, 
			DS_UF_PAC, 
			DS_TELEFONE_PAC, 
			DS_CEP_PAC, 
			NR_SEQ_LOTE, 
			CD_CLINICA_ENTRADA, 
			cd_morfologia_tu_prim, 
			cd_base_diag, 
			NM_MAE, 
			IE_OBITO_CANCER, 
			IE_CUSTO_DIAGNOSTICO, 
			IE_CUSTEIO_TRATAMENTO, 
			NR_ENDERECO, 
			DS_COMPLEMENTO, 
			DS_EMAIL 
			) 
			(SELECT 
				nextval('can_inca_envio_lote_item_seq'), 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				a.NR_PRONTUARIO, 
				a.CD_TIPO_TUMOR, 
				a.IE_CASO_ANALITICO, 
				b.nm_pessoa_fisica, 
				b.cd_pessoa_fisica, 
				CASE WHEN b.ie_sexo='M' THEN '1' WHEN b.ie_sexo='F' THEN '2'  ELSE '8' END , 
				obter_idade(clock_timestamp(), b.dt_nascimento, 'A'), 
				b.dt_nascimento, 
				b.nr_cep_cidade_nasc, 
				b.nr_seq_cor_pele, 
				b.ie_grau_instrucao, 
				SUBSTR(c.cd_profissao, 1, (LENGTH(c.cd_profissao)-2)), 
				c.cd_municipio_ibge||CALCULA_DIGITO('MODULO10', c.cd_municipio_ibge), 
				a.cd_clinica_atendimento, 
				b.nr_cpf, 
				a.dt_consulta, 
				a.dt_diagnostico, 
				a.IE_DIAG_TRAT_PREVIO, 
				a.CD_TOPOG_TU_PRIM, 
				a.IE_MAIS_UM_TU_PRIM, 
				CASE WHEN UPPER(a.CD_ESTADIO)='I' THEN 1 WHEN UPPER(a.CD_ESTADIO)='II' THEN 2 WHEN UPPER(a.CD_ESTADIO)='III' THEN 3 WHEN UPPER(a.CD_ESTADIO)='IV' THEN 4 WHEN UPPER(a.CD_ESTADIO)='V' THEN 5 END , 
				CASE WHEN UPPER(a.CD_ESTADIO_OUTRO)='I' THEN 1 WHEN UPPER(a.CD_ESTADIO_OUTRO)='II' THEN 2 WHEN UPPER(a.CD_ESTADIO_OUTRO)='III' THEN 3 WHEN UPPER(a.CD_ESTADIO_OUTRO)='IV' THEN 4 WHEN UPPER(a.CD_ESTADIO_OUTRO)='V' THEN 5 END , 
				obter_somente_numero(a.CD_TUMOR_PRIMARIO||a.CD_LINFONODO_REGIONAL||a.CD_METASTASE_DISTANCIA), 
				obter_somente_numero(a.CD_LINFONODO_REG_PAT||a.CD_LINFONODO_REG_PAT||a.CD_METASTASE_DIST_PAT), 
				obter_somente_numero(a.CD_TOPOG_MD_PRIM||' '||CD_TOPOG_MD_SEG||' '||CD_TOPOG_MD_TER||' '||CD_TOPOG_MD_QUA), 
				a.DT_INICIO_TRAT, 
				a.CD_RAZAO_NAO_TRAT, 
				CASE WHEN IE_TRAT_INSTITUICAO='S' THEN '1' END ||CASE WHEN IE_TRAT_INST_CIR='S' THEN '2' END ||CASE WHEN IE_TRAT_INST_OUTRO='S' THEN '8' END ||CASE WHEN IE_TRAT_INST_QUIMIO='S' THEN '4' END ||CASE WHEN IE_TRAT_INST_RADIO='S' THEN '3' END ||CASE WHEN IE_TRAT_INST_SEM_INF='S' THEN '9' END ||CASE WHEN IE_TRAT_INST_HORM='S' THEN '5' END ||CASE WHEN IE_TRAT_INST_IMUNO='S' THEN '7' END ||CASE WHEN IE_TRAT_INST_TMO='S' THEN '6' END , 
				a.IE_ESTADO_PAC_FIM_TRAT, 
				a.DT_OBITO, 
				a.CD_CID_MORTE_IMEDIATA, 
				a.CD_CID_MORTE_BASICA, 
				CASE WHEN a.IE_SEGUIMENTO='S' THEN 1  ELSE 2 END , 
				02, 
				a.DT_PREENCH_FICHA, 
				b.ie_estado_civil, 
				a.dt_triagem, 
				CASE WHEN a.IE_HIST_CANCER='S' THEN 1 WHEN a.IE_HIST_CANCER='N' THEN 2 WHEN a.IE_HIST_CANCER='NA' THEN 8  ELSE 9 END , 
				CASE WHEN a.IE_ALCOOLISMO='S' THEN 1 WHEN a.IE_ALCOOLISMO='N' THEN 2 WHEN a.IE_ALCOOLISMO='NA' THEN 8  ELSE 9 END , 
				CASE WHEN a.IE_TABAGISMO='S' THEN 1 WHEN a.IE_TABAGISMO='N' THEN 2 WHEN a.IE_TABAGISMO='NA' THEN 8  ELSE 9 END , 
				(SELECT	e.cd_convenio 
				FROM	atend_categoria_convenio e 
				WHERE	e.nr_seq_interno = (	SELECT	MIN(f.nr_seq_interno) 
							 	FROM	atendimento_paciente f1, 
									atend_categoria_convenio f 
								WHERE	f1.nr_atendimento = f.nr_atendimento 
								AND	f1.cd_pessoa_fisica = a.cd_pessoa_fisica)), 
				a.CD_TOPOG_LOC_PROV, 
				CASE WHEN a.IE_ERD_EXAME_CLINICO='N' THEN ''  ELSE '1' END ||CASE WHEN a.IE_ERD_EXAME_IMAGEM='N' THEN ''  ELSE '2' END ||CASE WHEN a.IE_ERD_ANATOMIA_PAT='N' THEN ''  ELSE '4' END ||CASE WHEN a.IE_ERD_ENDOSCOPIA='N' THEN ''  ELSE '3' END ||CASE WHEN a.IE_ERD_SEM_INFORMACAO='N' THEN ''  ELSE '9' END ||CASE WHEN a.IE_ERD_NAO_SE_APLICA='N' THEN ''  ELSE '8' END , 
				a.CD_LATERALIDADE, 
				obter_compl_pf(b.cd_pessoa_fisica, 1, 'e'), 
				obter_compl_pf(b.cd_pessoa_fisica, 1, 'b'), 
				obter_compl_pf(b.cd_pessoa_fisica, 1, 'ci'), 
				obter_compl_pf(b.cd_pessoa_fisica, 1, 'UF'), 
				obter_compl_pf(b.cd_pessoa_fisica, 1, 't'), 
				obter_compl_pf(b.cd_pessoa_fisica, 1, 'CEP'), 
				nr_seq_lote_p, 
				a.CD_CLINICA_ENTRADA, 
				a.cd_morfologia_tu_prim, 
				a.cd_base_diag, 
				obter_dados_pf(b.cd_pessoa_fisica,'NDR'), 
				a.ie_obito_cancer, 
				a.ie_custo_diagnostico, 
				a.ie_custo_tratamento, 
				obter_compl_pf(b.cd_pessoa_fisica,1,'NR'), 
				obter_compl_pf(b.cd_pessoa_fisica,1,'CO'), 
				obter_compl_pf(b.cd_pessoa_fisica,1,'M') 
			FROM compl_pessoa_fisica c, pessoa_fisica b, can_ficha_admissao a
LEFT OUTER JOIN cido_topografia d ON (a.CD_TOPOG_TU_PRIM = d.cd_topografia)
WHERE a.cd_pessoa_fisica = b.cd_pessoa_fisica AND c.cd_pessoa_fisica = b.cd_pessoa_fisica AND c.ie_tipo_complemento = 1  AND (a.dt_triagem BETWEEN dt_inicial_w AND dt_fim_w ) 
			 );
		ELSIF (ie_tipo_data_w = 'N') THEN 
	  	INSERT INTO CAN_INCA_ENVIO_LOTE_ITEM(NR_SEQUENCIA, 
			DT_ATUALIZACAO, 
			NM_USUARIO, 
			DT_ATUALIZACAO_NREC, 
			NM_USUARIO_NREC, 
			NR_PRONTUARIO, 
			CD_TIPO_TUMOR, 
			IE_CASO_ANALITICO, 
			NM_PACIENTE, 
			CD_PESSOA_FISICA, 
			DS_SEXO, 
			DS_IDADE, 
			DT_NASCIMENTO, 
			NR_CEP_CIDADE_NASC, 
			DS_COR_PELE, 
			DS_GRAU_INSTRUCAO, 
			DS_PROFISSAO, 
			DS_MUNICIPIO, 
			CD_CLINICA_ATENDIMENTO, 
			NR_CPF, 
			DT_CONSULTA, 
			DT_DIAGNOSTICO, 
			IE_DIAG_TRAT_PREVIO, 
			CD_TOPOG_TU_PRIM, 
			IE_MAIS_UM_TU_PRIM, 
			CD_ESTADIO, 
			CD_ESTADIO_OUTRO, 
			DS_TNM, 
			DS_PTNM, 
			DS_LOCALIZACAO_METASTASE, 
			DT_INICIO_TRAT, 
			CD_RAZAO_NAO_TRAT, 
			DS_PRIMEIRO_TRATAMENTO, 
			IE_ESTADO_PAC_FIM_TRAT, 
			DT_OBITO, 
			CD_CID_MORTE_IMEDIATA, 
			CD_CID_MORTE_BASICA, 
			IE_SEGUIMENTO, 
			CD_TIPO_REGISTRO, 
			DT_PREENCH_FICHA, 
			DS_ESTADO_CIVIL, 
			DT_TRIAGEM, 
			IE_HIST_CANCER, 
			IE_ALCOOLISMO, 
			IE_TABAGISMO, 
			CD_CONVENIO, 
			CD_TOPOG_LOC_PROV, 
			DS_EXAMES_RELEVANTES, 
			CD_LATERALIDADE, 
			DS_RUA_PAC, 
			DS_BAIRRO_PAC, 
			DS_CIDADE_PAC, 
			DS_UF_PAC, 
			DS_TELEFONE_PAC, 
			DS_CEP_PAC, 
			NR_SEQ_LOTE, 
			CD_CLINICA_ENTRADA, 
			cd_morfologia_tu_prim, 
			cd_base_diag, 
			NM_MAE, 
			IE_OBITO_CANCER, 
			IE_CUSTO_DIAGNOSTICO, 
			IE_CUSTEIO_TRATAMENTO, 
			NR_ENDERECO, 
			DS_COMPLEMENTO, 
			DS_EMAIL 
			) 
			(SELECT 
			  nextval('can_inca_envio_lote_item_seq'), 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				a.NR_PRONTUARIO, 
				a.CD_TIPO_TUMOR, 
				a.IE_CASO_ANALITICO, 
				b.nm_pessoa_fisica, 
				b.cd_pessoa_fisica, 
				CASE WHEN b.ie_sexo='M' THEN '1' WHEN b.ie_sexo='F' THEN '2'  ELSE '8' END , 
				obter_idade(clock_timestamp(), b.dt_nascimento, 'A'), 
				b.dt_nascimento, 
				b.nr_cep_cidade_nasc, 
				b.nr_seq_cor_pele, 
				b.ie_grau_instrucao, 
				SUBSTR(c.cd_profissao, 1, (LENGTH(c.cd_profissao)-2)), 
				c.cd_municipio_ibge||CALCULA_DIGITO('MODULO10', c.cd_municipio_ibge), 
				a.cd_clinica_atendimento, 
				b.nr_cpf, 
				a.dt_consulta, 
				a.dt_diagnostico, 
				a.IE_DIAG_TRAT_PREVIO, 
				a.CD_TOPOG_TU_PRIM, 
				a.IE_MAIS_UM_TU_PRIM, 
				CASE WHEN UPPER(a.CD_ESTADIO)='I' THEN 1 WHEN UPPER(a.CD_ESTADIO)='II' THEN 2 WHEN UPPER(a.CD_ESTADIO)='III' THEN 3 WHEN UPPER(a.CD_ESTADIO)='IV' THEN 4 WHEN UPPER(a.CD_ESTADIO)='V' THEN 5 END , 
				CASE WHEN UPPER(a.CD_ESTADIO_OUTRO)='I' THEN 1 WHEN UPPER(a.CD_ESTADIO_OUTRO)='II' THEN 2 WHEN UPPER(a.CD_ESTADIO_OUTRO)='III' THEN 3 WHEN UPPER(a.CD_ESTADIO_OUTRO)='IV' THEN 4 WHEN UPPER(a.CD_ESTADIO_OUTRO)='V' THEN 5 END , 
				obter_somente_numero(a.CD_TUMOR_PRIMARIO||a.CD_LINFONODO_REGIONAL||a.CD_METASTASE_DISTANCIA), 
				obter_somente_numero(a.CD_LINFONODO_REG_PAT||a.CD_LINFONODO_REG_PAT||a.CD_METASTASE_DIST_PAT), 
				obter_somente_numero(a.CD_TOPOG_MD_PRIM||' '||CD_TOPOG_MD_SEG||' '||CD_TOPOG_MD_TER||' '||CD_TOPOG_MD_QUA), 
				a.DT_INICIO_TRAT, 
				a.CD_RAZAO_NAO_TRAT, 
				CASE WHEN IE_TRAT_INSTITUICAO='S' THEN '1' END ||CASE WHEN IE_TRAT_INST_CIR='S' THEN '2' END ||CASE WHEN IE_TRAT_INST_OUTRO='S' THEN '8' END ||CASE WHEN IE_TRAT_INST_QUIMIO='S' THEN '4' END ||CASE WHEN IE_TRAT_INST_RADIO='S' THEN '3' END ||CASE WHEN IE_TRAT_INST_SEM_INF='S' THEN '9' END ||CASE WHEN IE_TRAT_INST_HORM='S' THEN '5' END ||CASE WHEN IE_TRAT_INST_IMUNO='S' THEN '7' END ||CASE WHEN IE_TRAT_INST_TMO='S' THEN '6' END , 
				a.IE_ESTADO_PAC_FIM_TRAT, 
				a.DT_OBITO, 
				a.CD_CID_MORTE_IMEDIATA, 
				a.CD_CID_MORTE_BASICA, 
				CASE WHEN a.IE_SEGUIMENTO='S' THEN 1  ELSE 2 END , 
				02, 
				a.DT_PREENCH_FICHA, 
				b.ie_estado_civil, 
				a.dt_triagem, 
				CASE WHEN a.IE_HIST_CANCER='S' THEN 1 WHEN a.IE_HIST_CANCER='N' THEN 2 WHEN a.IE_HIST_CANCER='NA' THEN 8  ELSE 9 END , 
				CASE WHEN a.IE_ALCOOLISMO='S' THEN 1 WHEN a.IE_ALCOOLISMO='N' THEN 2 WHEN a.IE_ALCOOLISMO='NA' THEN 8  ELSE 9 END , 
				CASE WHEN a.IE_TABAGISMO='S' THEN 1 WHEN a.IE_TABAGISMO='N' THEN 2 WHEN a.IE_TABAGISMO='NA' THEN 8  ELSE 9 END , 
				(SELECT	e.cd_convenio 
				FROM	atend_categoria_convenio e 
				WHERE	e.nr_seq_interno = (	SELECT	MIN(f.nr_seq_interno) 
							 	FROM	atendimento_paciente f1, 
									atend_categoria_convenio f 
								WHERE	f1.nr_atendimento = f.nr_atendimento 
								AND	f1.cd_pessoa_fisica = a.cd_pessoa_fisica)), 
				a.CD_TOPOG_LOC_PROV, 
				CASE WHEN a.IE_ERD_EXAME_CLINICO='N' THEN ''  ELSE '1' END ||CASE WHEN a.IE_ERD_EXAME_IMAGEM='N' THEN ''  ELSE '2' END ||CASE WHEN a.IE_ERD_ANATOMIA_PAT='N' THEN ''  ELSE '4' END ||CASE WHEN a.IE_ERD_ENDOSCOPIA='N' THEN ''  ELSE '3' END ||CASE WHEN a.IE_ERD_SEM_INFORMACAO='N' THEN ''  ELSE '9' END ||CASE WHEN a.IE_ERD_NAO_SE_APLICA='N' THEN ''  ELSE '8' END , 
				a.CD_LATERALIDADE, 
				obter_compl_pf(b.cd_pessoa_fisica, 1, 'e'), 
				obter_compl_pf(b.cd_pessoa_fisica, 1, 'b'), 
				obter_compl_pf(b.cd_pessoa_fisica, 1, 'ci'), 
				obter_compl_pf(b.cd_pessoa_fisica, 1, 'UF'), 
				obter_compl_pf(b.cd_pessoa_fisica, 1, 't'), 
				obter_compl_pf(b.cd_pessoa_fisica, 1, 'CEP'), 
				nr_seq_lote_p, 
				a.CD_CLINICA_ENTRADA, 
				a.cd_morfologia_tu_prim, 
				a.cd_base_diag, 
				obter_dados_pf(b.cd_pessoa_fisica,'NDR'), 
				a.ie_obito_cancer, 
				a.ie_custo_diagnostico, 
				a.ie_custo_tratamento, 
				obter_compl_pf(b.cd_pessoa_fisica,1,'NR'), 
				obter_compl_pf(b.cd_pessoa_fisica,1,'CO'), 
				obter_compl_pf(b.cd_pessoa_fisica,1,'M') 
			FROM compl_pessoa_fisica c, pessoa_fisica b, can_ficha_admissao a
LEFT OUTER JOIN cido_topografia d ON (a.CD_TOPOG_TU_PRIM = d.cd_topografia)
WHERE a.cd_pessoa_fisica = b.cd_pessoa_fisica AND c.cd_pessoa_fisica = b.cd_pessoa_fisica AND c.ie_tipo_complemento = 1  AND (a.nr_prontuario BETWEEN nr_pront_ini_w AND nr_pront_fim_w) 
			 );
		END IF;
	END;
  END IF;
COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE enviar_lote_inca ( nr_seq_lote_p bigint, nm_usuario_p text) FROM PUBLIC;

