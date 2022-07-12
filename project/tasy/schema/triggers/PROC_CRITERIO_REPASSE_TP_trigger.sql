-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS proc_criterio_repasse_tp ON proc_criterio_repasse CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_proc_criterio_repasse_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.NR_SEQUENCIA);  ds_c_w:=null; ds_w:=substr(NEW.CD_GRUPO_PROC_AIH,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_GRUPO_PROC_AIH,1,4000), substr(NEW.CD_GRUPO_PROC_AIH,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_GRUPO_PROC_AIH', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.HR_INICIAL,1,500);SELECT * FROM gravar_log_alteracao(to_char(OLD.HR_INICIAL,'hh24:mi:ss'), to_char(NEW.HR_INICIAL,'hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'HR_INICIAL', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.HR_FINAL,1,500);SELECT * FROM gravar_log_alteracao(to_char(OLD.HR_FINAL,'hh24:mi:ss'), to_char(NEW.HR_FINAL,'hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'HR_FINAL', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_REGRA_DIA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_REGRA_DIA,1,4000), substr(NEW.IE_REGRA_DIA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_REGRA_DIA', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_HONORARIO_RESTRICAO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_HONORARIO_RESTRICAO,1,4000), substr(NEW.IE_HONORARIO_RESTRICAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_HONORARIO_RESTRICAO', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_TIPO_SERVICO_SUS,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_SERVICO_SUS,1,4000), substr(NEW.IE_TIPO_SERVICO_SUS,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_SERVICO_SUS', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_TIPO_ATO_SUS,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_ATO_SUS,1,4000), substr(NEW.IE_TIPO_ATO_SUS,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_ATO_SUS', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DT_ATUALIZACAO_NREC,1,500);SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_ATUALIZACAO_NREC,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_ATUALIZACAO_NREC,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_ATUALIZACAO_NREC', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NM_USUARIO_NREC,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NM_USUARIO_NREC,1,4000), substr(NEW.NM_USUARIO_NREC,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_USUARIO_NREC', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.TX_MEDICO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.TX_MEDICO,1,4000), substr(NEW.TX_MEDICO,1,4000), NEW.nm_usuario, nr_seq_w, 'TX_MEDICO', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.TX_CUSTO_OPERACIONAL,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.TX_CUSTO_OPERACIONAL,1,4000), substr(NEW.TX_CUSTO_OPERACIONAL,1,4000), NEW.nm_usuario, nr_seq_w, 'TX_CUSTO_OPERACIONAL', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NR_SEQUENCIA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQUENCIA,1,4000), substr(NEW.NR_SEQUENCIA,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQUENCIA', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_REGRA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_REGRA,1,4000), substr(NEW.CD_REGRA,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_REGRA', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DT_ATUALIZACAO,1,500);SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_ATUALIZACAO,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_ATUALIZACAO,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_ATUALIZACAO', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_EDICAO_AMB,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_EDICAO_AMB,1,4000), substr(NEW.CD_EDICAO_AMB,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_EDICAO_AMB', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_AREA_PROCED,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_AREA_PROCED,1,4000), substr(NEW.CD_AREA_PROCED,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_AREA_PROCED', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.TX_MATERIAIS,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.TX_MATERIAIS,1,4000), substr(NEW.TX_MATERIAIS,1,4000), NEW.nm_usuario, nr_seq_w, 'TX_MATERIAIS', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_ESPECIAL_PROCED,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_ESPECIAL_PROCED,1,4000), substr(NEW.CD_ESPECIAL_PROCED,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_ESPECIAL_PROCED', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_GRUPO_PROCED,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_GRUPO_PROCED,1,4000), substr(NEW.CD_GRUPO_PROCED,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_GRUPO_PROCED', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_ORIGEM_PROCED,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ORIGEM_PROCED,1,4000), substr(NEW.IE_ORIGEM_PROCED,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_ORIGEM_PROCED', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_CONVENIO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_CONVENIO,1,4000), substr(NEW.CD_CONVENIO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_CONVENIO', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_FUNCAO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_FUNCAO,1,4000), substr(NEW.IE_FUNCAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_FUNCAO', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_SETOR_ATENDIMENTO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_SETOR_ATENDIMENTO,1,4000), substr(NEW.CD_SETOR_ATENDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_SETOR_ATENDIMENTO', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_MEDICO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MEDICO,1,4000), substr(NEW.CD_MEDICO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_MEDICO', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_FORMA_CALCULO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_FORMA_CALCULO,1,4000), substr(NEW.IE_FORMA_CALCULO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_FORMA_CALCULO', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_PACOTE,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PACOTE,1,4000), substr(NEW.IE_PACOTE,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_PACOTE', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_PLANTAO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PLANTAO,1,4000), substr(NEW.IE_PLANTAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_PLANTAO', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_PERC_PACOTE,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PERC_PACOTE,1,4000), substr(NEW.IE_PERC_PACOTE,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_PERC_PACOTE', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.TX_ANESTESISTA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.TX_ANESTESISTA,1,4000), substr(NEW.TX_ANESTESISTA,1,4000), NEW.nm_usuario, nr_seq_w, 'TX_ANESTESISTA', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.VL_REPASSE,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.VL_REPASSE,1,4000), substr(NEW.VL_REPASSE,1,4000), NEW.nm_usuario, nr_seq_w, 'VL_REPASSE', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_TABELA_PRECO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_TABELA_PRECO,1,4000), substr(NEW.CD_TABELA_PRECO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_TABELA_PRECO', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_CONVENIO_CALC,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_CONVENIO_CALC,1,4000), substr(NEW.CD_CONVENIO_CALC,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_CONVENIO_CALC', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_CATEGORIA_CALC,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_CATEGORIA_CALC,1,4000), substr(NEW.CD_CATEGORIA_CALC,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_CATEGORIA_CALC', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_PROCEDIMENTO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PROCEDIMENTO,1,4000), substr(NEW.CD_PROCEDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PROCEDIMENTO', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.TX_AUXILIARES,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.TX_AUXILIARES,1,4000), substr(NEW.TX_AUXILIARES,1,4000), NEW.nm_usuario, nr_seq_w, 'TX_AUXILIARES', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NM_USUARIO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NM_USUARIO,1,4000), substr(NEW.NM_USUARIO,1,4000), NEW.nm_usuario, nr_seq_w, 'NM_USUARIO', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_TIPO_ATENDIMENTO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_ATENDIMENTO,1,4000), substr(NEW.IE_TIPO_ATENDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_ATENDIMENTO', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_HONORARIO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_HONORARIO,1,4000), substr(NEW.IE_HONORARIO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_HONORARIO', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_EDICAO_AMB_CALC,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_EDICAO_AMB_CALC,1,4000), substr(NEW.CD_EDICAO_AMB_CALC,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_EDICAO_AMB_CALC', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DT_VIGENCIA_INICIAL,1,500);SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_VIGENCIA_INICIAL,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_VIGENCIA_INICIAL,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_VIGENCIA_INICIAL', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.DT_VIGENCIA_FINAL,1,500);SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_VIGENCIA_FINAL,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_VIGENCIA_FINAL,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_VIGENCIA_FINAL', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.VL_LIMITE,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.VL_LIMITE,1,4000), substr(NEW.VL_LIMITE,1,4000), NEW.nm_usuario, nr_seq_w, 'VL_LIMITE', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_PRESTADOR,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PRESTADOR,1,4000), substr(NEW.CD_PRESTADOR,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PRESTADOR', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_CARATER_INTER_SUS,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CARATER_INTER_SUS,1,4000), substr(NEW.IE_CARATER_INTER_SUS,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CARATER_INTER_SUS', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.TX_PROCEDIMENTO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.TX_PROCEDIMENTO,1,4000), substr(NEW.TX_PROCEDIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'TX_PROCEDIMENTO', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_TIPO_CONVENIO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_CONVENIO,1,4000), substr(NEW.IE_TIPO_CONVENIO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_CONVENIO', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_REGISTRO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_REGISTRO,1,4000), substr(NEW.CD_REGISTRO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_REGISTRO', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_MUNICIPIO_IBGE,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MUNICIPIO_IBGE,1,4000), substr(NEW.CD_MUNICIPIO_IBGE,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_MUNICIPIO_IBGE', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_CATEGORIA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_CATEGORIA,1,4000), substr(NEW.CD_CATEGORIA,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_CATEGORIA', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_SITUACAO_GLOSA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_SITUACAO_GLOSA,1,4000), substr(NEW.CD_SITUACAO_GLOSA,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_SITUACAO_GLOSA', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.QT_DIA_INICIAL,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.QT_DIA_INICIAL,1,4000), substr(NEW.QT_DIA_INICIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_DIA_INICIAL', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.QT_DIA_FINAL,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.QT_DIA_FINAL,1,4000), substr(NEW.QT_DIA_FINAL,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_DIA_FINAL', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_MEDICO_LAUDO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MEDICO_LAUDO,1,4000), substr(NEW.CD_MEDICO_LAUDO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_MEDICO_LAUDO', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_COBRA_PF_PJ,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_COBRA_PF_PJ,1,4000), substr(NEW.IE_COBRA_PF_PJ,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_COBRA_PF_PJ', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NR_SEQ_GRUPO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_GRUPO,1,4000), substr(NEW.NR_SEQ_GRUPO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_GRUPO', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NR_SEQ_SUBGRUPO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_SUBGRUPO,1,4000), substr(NEW.NR_SEQ_SUBGRUPO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_SUBGRUPO', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NR_SEQ_FORMA_ORG,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_FORMA_ORG,1,4000), substr(NEW.NR_SEQ_FORMA_ORG,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_FORMA_ORG', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_MED_EXEC_SOCIO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_MED_EXEC_SOCIO,1,4000), substr(NEW.IE_MED_EXEC_SOCIO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_MED_EXEC_SOCIO', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_ESPECIALIDADE,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_ESPECIALIDADE,1,4000), substr(NEW.CD_ESPECIALIDADE,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_ESPECIALIDADE', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_ATEND_RETORNO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ATEND_RETORNO,1,4000), substr(NEW.IE_ATEND_RETORNO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_ATEND_RETORNO', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NR_SEQ_PROC_INTERNO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_PROC_INTERNO,1,4000), substr(NEW.NR_SEQ_PROC_INTERNO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_PROC_INTERNO', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.NR_SEQ_EXAME,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.NR_SEQ_EXAME,1,4000), substr(NEW.NR_SEQ_EXAME,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_SEQ_EXAME', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_CONVENIADO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CONVENIADO,1,4000), substr(NEW.IE_CONVENIADO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CONVENIADO', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_PARTICIPOU_SUS,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PARTICIPOU_SUS,1,4000), substr(NEW.IE_PARTICIPOU_SUS,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_PARTICIPOU_SUS', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_CLINICA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CLINICA,1,4000), substr(NEW.IE_CLINICA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CLINICA', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_EQUIPAMENTO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_EQUIPAMENTO,1,4000), substr(NEW.CD_EQUIPAMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_EQUIPAMENTO', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_REGRA_MEDICO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_REGRA_MEDICO,1,4000), substr(NEW.IE_REGRA_MEDICO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_REGRA_MEDICO', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_MED_EXEC_PROC_PRINC,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MED_EXEC_PROC_PRINC,1,4000), substr(NEW.CD_MED_EXEC_PROC_PRINC,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_MED_EXEC_PROC_PRINC', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_REPASSE_CALC,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_REPASSE_CALC,1,4000), substr(NEW.IE_REPASSE_CALC,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_REPASSE_CALC', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.QT_PORTE_ANESTESICO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.QT_PORTE_ANESTESICO,1,4000), substr(NEW.QT_PORTE_ANESTESICO,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_PORTE_ANESTESICO', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_SITUACAO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SITUACAO,1,4000), substr(NEW.IE_SITUACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SITUACAO', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_PROCEDENCIA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PROCEDENCIA,1,4000), substr(NEW.CD_PROCEDENCIA,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PROCEDENCIA', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_TIPO_ATEND_CALC,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_ATEND_CALC,1,4000), substr(NEW.IE_TIPO_ATEND_CALC,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_ATEND_CALC', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_PLANO,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PLANO,1,4000), substr(NEW.CD_PLANO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PLANO', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_PESSOA_FUNC,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PESSOA_FUNC,1,4000), substr(NEW.CD_PESSOA_FUNC,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PESSOA_FUNC', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_MEDICO_PRESCR,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MEDICO_PRESCR,1,4000), substr(NEW.CD_MEDICO_PRESCR,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_MEDICO_PRESCR', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_MEDICO_REQ,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MEDICO_REQ,1,4000), substr(NEW.CD_MEDICO_REQ,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_MEDICO_REQ', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.IE_MED_PLANTONISTA,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.IE_MED_PLANTONISTA,1,4000), substr(NEW.IE_MED_PLANTONISTA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_MED_PLANTONISTA', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;  ds_w:=substr(NEW.CD_SETOR_PROC_PRESCR,1,500);SELECT * FROM gravar_log_alteracao(substr(OLD.CD_SETOR_PROC_PRESCR,1,4000), substr(NEW.CD_SETOR_PROC_PRESCR,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_SETOR_PROC_PRESCR', ie_log_w, ds_w, 'PROC_CRITERIO_REPASSE', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_proc_criterio_repasse_tp() FROM PUBLIC;

CREATE TRIGGER proc_criterio_repasse_tp
	AFTER UPDATE ON proc_criterio_repasse FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_proc_criterio_repasse_tp();

