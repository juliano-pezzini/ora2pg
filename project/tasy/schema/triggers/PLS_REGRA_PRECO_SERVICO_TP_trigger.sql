-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_regra_preco_servico_tp ON pls_regra_preco_servico CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_regra_preco_servico_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SITUACAO,1,4000), substr(NEW.IE_SITUACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SITUACAO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.VL_NEGOCIADO,1,4000), substr(NEW.VL_NEGOCIADO,1,4000), NEW.nm_usuario, nr_seq_w, 'VL_NEGOCIADO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ORIGEM_PROCED,1,4000), substr(NEW.IE_ORIGEM_PROCED,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_ORIGEM_PROCED', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_PRESTADOR,1,4000), substr(NEW.NR_SEQ_PRESTADOR,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_PRESTADOR', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_INICIO_VIGENCIA,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_INICIO_VIGENCIA,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_INICIO_VIGENCIA', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_FIM_VIGENCIA,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_FIM_VIGENCIA,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_FIM_VIGENCIA', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_TABELA,1,4000), substr(NEW.IE_TIPO_TABELA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_TABELA', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_OUTORGANTE,1,4000), substr(NEW.NR_SEQ_OUTORGANTE,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_OUTORGANTE', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_CONTRATO,1,4000), substr(NEW.NR_SEQ_CONTRATO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_CONTRATO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.TX_AJUSTE,1,4000), substr(NEW.TX_AJUSTE,1,4000), NEW.nm_usuario, nr_seq_w, 'TX_AJUSTE', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_ESPECIALIDADE,1,4000), substr(NEW.CD_ESPECIALIDADE,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_ESPECIALIDADE', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_GRUPO_PROC,1,4000), substr(NEW.CD_GRUPO_PROC,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_GRUPO_PROC', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PROCEDIMENTO,1,4000), substr(NEW.CD_PROCEDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PROCEDIMENTO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_TABELA_SERVICO,1,4000), substr(NEW.CD_TABELA_SERVICO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_TABELA_SERVICO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_AREA_PROCEDIMENTO,1,4000), substr(NEW.CD_AREA_PROCEDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_AREA_PROCEDIMENTO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_CONGENERE,1,4000), substr(NEW.NR_SEQ_CONGENERE,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_CONGENERE', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_OBSERVACAO,1,4000), substr(NEW.DS_OBSERVACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_OBSERVACAO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_PLANO,1,4000), substr(NEW.NR_SEQ_PLANO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_PLANO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_CONTRATACAO,1,4000), substr(NEW.IE_TIPO_CONTRATACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_CONTRATACAO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PRECO,1,4000), substr(NEW.IE_PRECO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_PRECO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_VINCULO,1,4000), substr(NEW.IE_TIPO_VINCULO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_VINCULO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_CLASSIFICACAO,1,4000), substr(NEW.NR_SEQ_CLASSIFICACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_CLASSIFICACAO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_CATEGORIA,1,4000), substr(NEW.NR_SEQ_CATEGORIA,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_CATEGORIA', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_INTERNADO,1,4000), substr(NEW.IE_INTERNADO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_INTERNADO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_GRUPO_CONTRATO,1,4000), substr(NEW.NR_SEQ_GRUPO_CONTRATO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_GRUPO_CONTRATO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_GRUPO_PRODUTO,1,4000), substr(NEW.NR_SEQ_GRUPO_PRODUTO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_GRUPO_PRODUTO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_GRUPO_PRESTADOR,1,4000), substr(NEW.NR_SEQ_GRUPO_PRESTADOR,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_GRUPO_PRESTADOR', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_GRUPO_SERVICO,1,4000), substr(NEW.NR_SEQ_GRUPO_SERVICO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_GRUPO_SERVICO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_SEGURADO,1,4000), substr(NEW.IE_TIPO_SEGURADO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_SEGURADO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PRESTADOR,1,4000), substr(NEW.CD_PRESTADOR,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PRESTADOR', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_GRUPO_REC,1,4000), substr(NEW.NR_SEQ_GRUPO_REC,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_GRUPO_REC', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_INTERCAMBIO,1,4000), substr(NEW.IE_TIPO_INTERCAMBIO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_INTERCAMBIO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_TIPO_ACOMODACAO,1,4000), substr(NEW.NR_SEQ_TIPO_ACOMODACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_TIPO_ACOMODACAO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.TX_AJUSTE_PRECO,1,4000), substr(NEW.TX_AJUSTE_PRECO,1,4000), NEW.nm_usuario, nr_seq_w, 'TX_AJUSTE_PRECO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TAXA_COLETA,1,4000), substr(NEW.IE_TAXA_COLETA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TAXA_COLETA', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PCMSO,1,4000), substr(NEW.IE_PCMSO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_PCMSO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_CONGENERE_PROT,1,4000), substr(NEW.NR_SEQ_CONGENERE_PROT,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_CONGENERE_PROT', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_TIPO_ATENDIMENTO,1,4000), substr(NEW.NR_SEQ_TIPO_ATENDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_TIPO_ATENDIMENTO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_CLINICA,1,4000), substr(NEW.NR_SEQ_CLINICA,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_CLINICA', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_TIPO_PRESTADOR,1,4000), substr(NEW.NR_SEQ_TIPO_PRESTADOR,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_TIPO_PRESTADOR', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CARATER_INTERNACAO,1,4000), substr(NEW.IE_CARATER_INTERNACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CARATER_INTERNACAO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_GUIA,1,4000), substr(NEW.IE_TIPO_GUIA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_GUIA', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_CBO_SAUDE,1,4000), substr(NEW.NR_SEQ_CBO_SAUDE,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_CBO_SAUDE', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_GRUPO_INTERCAMBIO,1,4000), substr(NEW.NR_SEQ_GRUPO_INTERCAMBIO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_GRUPO_INTERCAMBIO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_INTERCAMBIO,1,4000), substr(NEW.NR_SEQ_INTERCAMBIO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_INTERCAMBIO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ACOMODACAO,1,4000), substr(NEW.IE_ACOMODACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_ACOMODACAO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_AUTOGERADO,1,4000), substr(NEW.IE_AUTOGERADO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_AUTOGERADO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_CONTRATO,1,4000), substr(NEW.NR_CONTRATO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_CONTRATO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MOEDA,1,4000), substr(NEW.CD_MOEDA,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_MOEDA', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_SERV_REF,1,4000), substr(NEW.NR_SEQ_SERV_REF,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_SERV_REF', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_ACOMODACAO_PTU,1,4000), substr(NEW.IE_TIPO_ACOMODACAO_PTU,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_ACOMODACAO_PTU', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_REGRA,1,4000), substr(NEW.DS_REGRA,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_REGRA', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_ESPECIALIDADE_PREST,1,4000), substr(NEW.CD_ESPECIALIDADE_PREST,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_ESPECIALIDADE_PREST', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_NAO_GERA_TX_INTER,1,4000), substr(NEW.IE_NAO_GERA_TX_INTER,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_NAO_GERA_TX_INTER', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_COOPERADO,1,4000), substr(NEW.IE_COOPERADO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_COOPERADO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PRESTADOR_PROT,1,4000), substr(NEW.CD_PRESTADOR_PROT,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PRESTADOR_PROT', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_TIPO_PRESTADOR_PROT,1,4000), substr(NEW.NR_SEQ_TIPO_PRESTADOR_PROT,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_TIPO_PRESTADOR_PROT', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_PRESTADOR,1,4000), substr(NEW.IE_TIPO_PRESTADOR,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_PRESTADOR', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_REGRA_ATEND_CART,1,4000), substr(NEW.NR_SEQ_REGRA_ATEND_CART,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_REGRA_ATEND_CART', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_CP_COMBINADA,1,4000), substr(NEW.NR_SEQ_CP_COMBINADA,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_CP_COMBINADA', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ORIGEM_PROTOCOLO,1,4000), substr(NEW.IE_ORIGEM_PROTOCOLO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_ORIGEM_PROTOCOLO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ATEND_PCMSO,1,4000), substr(NEW.IE_ATEND_PCMSO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_ATEND_PCMSO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_GRUPO_OPERADORA,1,4000), substr(NEW.NR_SEQ_GRUPO_OPERADORA,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_GRUPO_OPERADORA', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_REF_GUIA_INTERNACAO,1,4000), substr(NEW.IE_REF_GUIA_INTERNACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_REF_GUIA_INTERNACAO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_VERSAO_TISS,1,4000), substr(NEW.CD_VERSAO_TISS,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_VERSAO_TISS', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_PRESTADOR_INTER,1,4000), substr(NEW.NR_SEQ_PRESTADOR_INTER,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_PRESTADOR_INTER', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ACOMODACAO_AUTORIZADA,1,4000), substr(NEW.IE_ACOMODACAO_AUTORIZADA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_ACOMODACAO_AUTORIZADA', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PRESTADOR_SOLIC,1,4000), substr(NEW.CD_PRESTADOR_SOLIC,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PRESTADOR_SOLIC', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_TIPO_ATEND_PRINC,1,4000), substr(NEW.NR_SEQ_TIPO_ATEND_PRINC,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_TIPO_ATEND_PRINC', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_IDADE_FINAL,1,4000), substr(NEW.QT_IDADE_FINAL,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_IDADE_FINAL', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_IDADE_INICIAL,1,4000), substr(NEW.QT_IDADE_INICIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_IDADE_INICIAL', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_VALOR_AUTORIZADO,1,4000), substr(NEW.IE_VALOR_AUTORIZADO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_VALOR_AUTORIZADO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_MOT_REEMBOLSO,1,4000), substr(NEW.NR_SEQ_MOT_REEMBOLSO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_MOT_REEMBOLSO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_ATENDIMENTO,1,4000), substr(NEW.IE_TIPO_ATENDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_ATENDIMENTO', ie_log_w, ds_w, 'PLS_REGRA_PRECO_SERVICO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_regra_preco_servico_tp() FROM PUBLIC;

CREATE TRIGGER pls_regra_preco_servico_tp
	AFTER UPDATE ON pls_regra_preco_servico FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_regra_preco_servico_tp();

