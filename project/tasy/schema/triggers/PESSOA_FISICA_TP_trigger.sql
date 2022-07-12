-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pessoa_fisica_tp ON pessoa_fisica CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pessoa_fisica_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.CD_PESSOA_FISICA);  ds_c_w:=null; ds_w:=substr(NEW.NR_SEQ_PERFIL,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_PERFIL,1,4000), substr(NEW.NR_SEQ_PERFIL,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_PERFIL', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NM_SOCIAL,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NM_SOCIAL,1,4000), substr(NEW.NM_SOCIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_SOCIAL', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NM_PESSOA_FISICA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NM_PESSOA_FISICA,1,4000), substr(NEW.NM_PESSOA_FISICA,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_PESSOA_FISICA', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_USUARIO_ORIGINAL,1,4000), substr(NEW.NM_USUARIO_ORIGINAL,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_USUARIO_ORIGINAL', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_CADASTRO_ORIGINAL,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_CADASTRO_ORIGINAL,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_CADASTRO_ORIGINAL', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_HISTORICO,1,4000), substr(NEW.DS_HISTORICO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_HISTORICO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_NATURALIZACAO_PF,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_NATURALIZACAO_PF,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_NATURALIZACAO_PF', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.SG_EMISSORA_CI,1,4000), substr(NEW.SG_EMISSORA_CI,1,4000), NEW.nm_usuario, nr_seq_w, 'SG_EMISSORA_CI', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_CTPS,1,4000), substr(NEW.NR_CTPS,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_CTPS', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SERIE_CTPS,1,4000), substr(NEW.NR_SERIE_CTPS,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SERIE_CTPS', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.UF_EMISSORA_CTPS,1,4000), substr(NEW.UF_EMISSORA_CTPS,1,4000), NEW.nm_usuario, nr_seq_w, 'UF_EMISSORA_CTPS', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_EMISSAO_CTPS,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_EMISSAO_CTPS,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_EMISSAO_CTPS', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_PRONTUARIO,1,4000), substr(NEW.IE_TIPO_PRONTUARIO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_PRONTUARIO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_DEPENDENTE,1,4000), substr(NEW.QT_DEPENDENTE,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_DEPENDENTE', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PUERICULTURA,1,4000), substr(NEW.CD_PUERICULTURA,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PUERICULTURA', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_CONTRA_REF_SUS,1,4000), substr(NEW.NR_CONTRA_REF_SUS,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_CONTRA_REF_SUS', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_REVISAO,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_REVISAO,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_REVISAO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_USUARIO_REVISAO,1,4000), substr(NEW.NM_USUARIO_REVISAO,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_USUARIO_REVISAO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_SENHA,1,4000), substr(NEW.DS_SENHA,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_SENHA', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_DEMISSAO_HOSP,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_DEMISSAO_HOSP,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_DEMISSAO_HOSP', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_PORTARIA_NAT,1,4000), substr(NEW.NR_PORTARIA_NAT,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_PORTARIA_NAT', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_CNES,1,4000), substr(NEW.CD_CNES,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_CNES', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_FONETICA,1,4000), substr(NEW.DS_FONETICA,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_FONETICA', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_EMPRESA,1,4000), substr(NEW.CD_EMPRESA,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_EMPRESA', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_TRANSPLANTE,1,4000), substr(NEW.NR_TRANSPLANTE,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_TRANSPLANTE', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_OBSERVACAO,1,4000), substr(NEW.DS_OBSERVACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_OBSERVACAO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SAME,1,4000), substr(NEW.NR_SAME,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SAME', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SEXO,1,4000), substr(NEW.IE_SEXO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SEXO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ESTADO_CIVIL,1,4000), substr(NEW.IE_ESTADO_CIVIL,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_ESTADO_CIVIL', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_IDENTIDADE,1,4000), substr(NEW.NR_IDENTIDADE,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_IDENTIDADE', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_GRAU_INSTRUCAO,1,4000), substr(NEW.IE_GRAU_INSTRUCAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_GRAU_INSTRUCAO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_PRONTUARIO,1,4000), substr(NEW.NR_PRONTUARIO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_PRONTUARIO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_RELIGIAO,1,4000), substr(NEW.CD_RELIGIAO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_RELIGIAO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_PIS_PASEP,1,4000), substr(NEW.NR_PIS_PASEP,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_PIS_PASEP', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_DEPENDENCIA_SUS,1,4000), substr(NEW.IE_DEPENDENCIA_SUS,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_DEPENDENCIA_SUS', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_INTEGRACAO_EXTERNA,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_INTEGRACAO_EXTERNA,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_INTEGRACAO_EXTERNA', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_PESSOA_FISICA_SEM_ACENTO,1,4000), substr(NEW.NM_PESSOA_FISICA_SEM_ACENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_PESSOA_FISICA_SEM_ACENTO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_SANGUE,1,4000), substr(NEW.IE_TIPO_SANGUE,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_SANGUE', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_REVISAR,1,4000), substr(NEW.IE_REVISAR,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_REVISAR', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_CEP_CIDADE_NASC,1,4000), substr(NEW.NR_CEP_CIDADE_NASC,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_CEP_CIDADE_NASC', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_COR_PELE,1,4000), substr(NEW.NR_SEQ_COR_PELE,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_COR_PELE', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_ORGAO_EMISSOR_CI,1,4000), substr(NEW.DS_ORGAO_EMISSOR_CI,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_ORGAO_EMISSOR_CI', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_CBO_SAUDE,1,4000), substr(NEW.NR_SEQ_CBO_SAUDE,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_CBO_SAUDE', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_CODIGO_PROF,1,4000), substr(NEW.DS_CODIGO_PROF,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_CODIGO_PROF', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_OBITO,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_OBITO,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_OBITO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_SISTEMA_ANT,1,4000), substr(NEW.CD_SISTEMA_ANT,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_SISTEMA_ANT', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_CBO_SUS,1,4000), substr(NEW.CD_CBO_SUS,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_CBO_SUS', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_ALTURA_CM,1,4000), substr(NEW.QT_ALTURA_CM,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_ALTURA_CM', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_ATIVIDADE_SUS,1,4000), substr(NEW.CD_ATIVIDADE_SUS,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_ATIVIDADE_SUS', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_VINCULO_SUS,1,4000), substr(NEW.IE_VINCULO_SUS,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_VINCULO_SUS', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_FUNCIONARIO,1,4000), substr(NEW.IE_FUNCIONARIO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_FUNCIONARIO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_ISS,1,4000), substr(NEW.NR_ISS,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_ISS', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_INSS,1,4000), substr(NEW.NR_INSS,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_INSS', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_PESSOA,1,4000), substr(NEW.IE_TIPO_PESSOA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_PESSOA', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_CARTAO_NAC_SUS,1,4000), substr(NEW.NR_CARTAO_NAC_SUS,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_CARTAO_NAC_SUS', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_NACIONALIDADE,1,4000), substr(NEW.CD_NACIONALIDADE,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_NACIONALIDADE', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_TELEFONE_CELULAR,1,4000), substr(NEW.NR_TELEFONE_CELULAR,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_TELEFONE_CELULAR', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_FATOR_RH,1,4000), substr(NEW.IE_FATOR_RH,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_FATOR_RH', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_NASCIMENTO,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_NASCIMENTO,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_NASCIMENTO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_FUNCIONARIO,1,4000), substr(NEW.CD_FUNCIONARIO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_FUNCIONARIO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_CPF,1,4000), substr(NEW.NR_CPF,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_CPF', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_CARGO,1,4000), substr(NEW.CD_CARGO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_CARGO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MEDICO,1,4000), substr(NEW.CD_MEDICO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_MEDICO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_PESSOA_PESQUISA,1,4000), substr(NEW.NM_PESSOA_PESQUISA,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_PESSOA_PESQUISA', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_CONSELHO,1,4000), substr(NEW.NR_SEQ_CONSELHO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_CONSELHO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_ADMISSAO_HOSP,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_ADMISSAO_HOSP,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_ADMISSAO_HOSP', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_CERT_NASC,1,4000), substr(NEW.NR_CERT_NASC,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_CERT_NASC', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_TRANSACAO_SUS,1,4000), substr(NEW.NR_TRANSACAO_SUS,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_TRANSACAO_SUS', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_EMISSAO_CI,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_EMISSAO_CI,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_EMISSAO_CI', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_ZONA,1,4000), substr(NEW.NR_ZONA,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_ZONA', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SECAO,1,4000), substr(NEW.NR_SECAO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SECAO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_CARTAO_ESTRANGEIRO,1,4000), substr(NEW.NR_CARTAO_ESTRANGEIRO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_CARTAO_ESTRANGEIRO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_REG_GERAL_ESTRANG,1,4000), substr(NEW.NR_REG_GERAL_ESTRANG,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_REG_GERAL_ESTRANG', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_CHEGADA_BRASIL,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_CHEGADA_BRASIL,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_CHEGADA_BRASIL', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_FLUENCIA_PORTUGUES,1,4000), substr(NEW.IE_FLUENCIA_PORTUGUES,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_FLUENCIA_PORTUGUES', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_APELIDO,1,4000), substr(NEW.DS_APELIDO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_APELIDO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_PAGER_BIP,1,4000), substr(NEW.NR_PAGER_BIP,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_PAGER_BIP', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_REGISTRO_PLS,1,4000), substr(NEW.NR_REGISTRO_PLS,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_REGISTRO_PLS', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_FONETICA_CNS,1,4000), substr(NEW.DS_FONETICA_CNS,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_FONETICA_CNS', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_FOLHA_CERT_CASAMENTO,1,4000), substr(NEW.NR_FOLHA_CERT_CASAMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_FOLHA_CERT_CASAMENTO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_CERT_CASAMENTO,1,4000), substr(NEW.NR_CERT_CASAMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_CERT_CASAMENTO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_CARTORIO_NASC,1,4000), substr(NEW.NR_SEQ_CARTORIO_NASC,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_CARTORIO_NASC', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_CARTORIO_CASAMENTO,1,4000), substr(NEW.NR_SEQ_CARTORIO_CASAMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_CARTORIO_CASAMENTO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_EMISSAO_CERT_NASC,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_EMISSAO_CERT_NASC,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_EMISSAO_CERT_NASC', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_EMISSAO_CERT_CASAMENTO,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_EMISSAO_CERT_CASAMENTO,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_EMISSAO_CERT_CASAMENTO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_LIVRO_CERT_NASC,1,4000), substr(NEW.NR_LIVRO_CERT_NASC,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_LIVRO_CERT_NASC', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_LIVRO_CERT_CASAMENTO,1,4000), substr(NEW.NR_LIVRO_CERT_CASAMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_LIVRO_CERT_CASAMENTO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_FOLHA_CERT_NASC,1,4000), substr(NEW.NR_FOLHA_CERT_NASC,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_FOLHA_CERT_NASC', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MUNICIPIO_IBGE,1,4000), substr(NEW.CD_MUNICIPIO_IBGE,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_MUNICIPIO_IBGE', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_GERACAO_PRONT,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_GERACAO_PRONT,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_GERACAO_PRONT', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_TITULO_ELEITOR,1,4000), substr(NEW.NR_TITULO_ELEITOR,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_TITULO_ELEITOR', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_PAIS,1,4000), substr(NEW.NR_SEQ_PAIS,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_PAIS', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_NUT_PERFIL,1,4000), substr(NEW.NR_SEQ_NUT_PERFIL,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_NUT_PERFIL', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_PESO_NASC,1,4000), substr(NEW.QT_PESO_NASC,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_PESO_NASC', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_VALIDADE_RG,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_VALIDADE_RG,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_VALIDADE_RG', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_STATUS_EXPORTAR,1,4000), substr(NEW.IE_STATUS_EXPORTAR,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_STATUS_EXPORTAR', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.UF_CONSELHO,1,4000), substr(NEW.UF_CONSELHO,1,4000), NEW.nm_usuario, nr_seq_w, 'UF_CONSELHO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ENDERECO_CORRESPONDENCIA,1,4000), substr(NEW.IE_ENDERECO_CORRESPONDENCIA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_ENDERECO_CORRESPONDENCIA', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NM_ABREVIADO,1,4000), substr(NEW.NM_ABREVIADO,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_ABREVIADO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_PRONT_DV,1,4000), substr(NEW.NR_PRONT_DV,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_PRONT_DV', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_FREQUENTA_ESCOLA,1,4000), substr(NEW.IE_FREQUENTA_ESCOLA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_FREQUENTA_ESCOLA', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_DDD_CELULAR,1,4000), substr(NEW.NR_DDD_CELULAR,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_DDD_CELULAR', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_DDI_CELULAR,1,4000), substr(NEW.NR_DDI_CELULAR,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_DDI_CELULAR', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_CCM,1,4000), substr(NEW.NR_CCM,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_CCM', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_VALIDADE_CONSELHO,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_VALIDADE_CONSELHO,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_VALIDADE_CONSELHO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_TIPO_PJ,1,4000), substr(NEW.CD_TIPO_PJ,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_TIPO_PJ', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_CNH,1,4000), substr(NEW.NR_CNH,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_CNH', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_FIM_EXPERIENCIA,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_FIM_EXPERIENCIA,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_FIM_EXPERIENCIA', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_PASSAPORTE,1,4000), substr(NEW.NR_PASSAPORTE,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_PASSAPORTE', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_PROFISSAO,1,4000), substr(NEW.DS_PROFISSAO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_PROFISSAO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_EMPRESA_PF,1,4000), substr(NEW.DS_EMPRESA_PF,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_EMPRESA_PF', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_NF_CORREIO,1,4000), substr(NEW.IE_NF_CORREIO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_NF_CORREIO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_CERT_MILITAR,1,4000), substr(NEW.NR_CERT_MILITAR,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_CERT_MILITAR', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_CERT_DIVORCIO,1,4000), substr(NEW.NR_CERT_DIVORCIO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_CERT_DIVORCIO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_PRONT_EXT,1,4000), substr(NEW.NR_PRONT_EXT,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_PRONT_EXT', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_CARTORIO_DIVORCIO,1,4000), substr(NEW.NR_SEQ_CARTORIO_DIVORCIO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_CARTORIO_DIVORCIO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_LIVRO_CERT_DIVORCIO,1,4000), substr(NEW.NR_LIVRO_CERT_DIVORCIO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_LIVRO_CERT_DIVORCIO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_EMISSAO_CERT_DIVORCIO,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_EMISSAO_CERT_DIVORCIO,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_EMISSAO_CERT_DIVORCIO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_FOLHA_CERT_DIV,1,4000), substr(NEW.NR_FOLHA_CERT_DIV,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_FOLHA_CERT_DIV', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ESCOLARIDADE_CNS,1,4000), substr(NEW.IE_ESCOLARIDADE_CNS,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_ESCOLARIDADE_CNS', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SITUACAO_CONJ_CNS,1,4000), substr(NEW.IE_SITUACAO_CONJ_CNS,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SITUACAO_CONJ_CNS', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_INICIO_OCUP_ATUAL,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_INICIO_OCUP_ATUAL,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_INICIO_OCUP_ATUAL', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_DECLARACAO_NASC_VIVO,1,4000), substr(NEW.CD_DECLARACAO_NASC_VIVO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_DECLARACAO_NASC_VIVO', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_DEPENDENTE,1,4000), substr(NEW.IE_DEPENDENTE,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_DEPENDENTE', ie_log_w, ds_w, 'PESSOA_FISICA', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pessoa_fisica_tp() FROM PUBLIC;

CREATE TRIGGER pessoa_fisica_tp
	AFTER UPDATE ON pessoa_fisica FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pessoa_fisica_tp();

