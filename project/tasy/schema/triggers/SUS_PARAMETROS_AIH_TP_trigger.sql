-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS sus_parametros_aih_tp ON sus_parametros_aih CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_sus_parametros_aih_tp() RETURNS trigger AS $BODY$
declare

nr_seq_w bigint;
ds_s_w   varchar(50);
ds_c_w   varchar(500);
ds_w    varchar(500);
ie_log_w varchar(1);
BEGIN
  BEGIN

BEGIN

ds_s_w 	:= to_char(OLD.CD_ESTABELECIMENTO);
ds_c_w	:= null;

CALL sus_parametros_aih_pck.set_dt_atualizacao(NEW.dt_atualizacao);

SELECT * FROM gravar_log_alteracao(substr(OLD.IE_DIARIA_UTI,1,2000), substr(NEW.IE_DIARIA_UTI,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_DIARIA_UTI', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_FORMA_CALCULO_SADT,1,2000), substr(NEW.IE_FORMA_CALCULO_SADT,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_FORMA_CALCULO_SADT', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_REPASSE_PROC,1,2000), substr(NEW.IE_REPASSE_PROC,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_REPASSE_PROC', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.QT_MAX_DIARIA_UTI,1,2000), substr(NEW.QT_MAX_DIARIA_UTI,1,2000), NEW.nm_usuario, nr_seq_w, 'QT_MAX_DIARIA_UTI', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_IGNORA_PARTICIPOU_SUS,1,2000), substr(NEW.IE_IGNORA_PARTICIPOU_SUS,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_IGNORA_PARTICIPOU_SUS', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ARRED_SP_SISAIH,1,2000), substr(NEW.IE_ARRED_SP_SISAIH,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_ARRED_SP_SISAIH', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.CD_ESTABELECIMENTO,1,2000), substr(NEW.CD_ESTABELECIMENTO,1,2000), NEW.nm_usuario, nr_seq_w, 'CD_ESTABELECIMENTO', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.CD_ORGAO_EMISSOR_AIH,1,2000), substr(NEW.CD_ORGAO_EMISSOR_AIH,1,2000), NEW.nm_usuario, nr_seq_w, 'CD_ORGAO_EMISSOR_AIH', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.CD_CNES_HOSPITAL,1,2000), substr(NEW.CD_CNES_HOSPITAL,1,2000), NEW.nm_usuario, nr_seq_w, 'CD_CNES_HOSPITAL', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MUNICIPIO_IBGE,1,2000), substr(NEW.CD_MUNICIPIO_IBGE,1,2000), NEW.nm_usuario, nr_seq_w, 'CD_MUNICIPIO_IBGE', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.CD_DIRETOR_CLINICO,1,2000), substr(NEW.CD_DIRETOR_CLINICO,1,2000), NEW.nm_usuario, nr_seq_w, 'CD_DIRETOR_CLINICO', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MEDICO_AUTORIZADOR,1,2000), substr(NEW.CD_MEDICO_AUTORIZADOR,1,2000), NEW.nm_usuario, nr_seq_w, 'CD_MEDICO_AUTORIZADOR', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.CD_INTERFACE_ENVIO,1,2000), substr(NEW.CD_INTERFACE_ENVIO,1,2000), NEW.nm_usuario, nr_seq_w, 'CD_INTERFACE_ENVIO', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.PR_URG_EMERG,1,2000), substr(NEW.PR_URG_EMERG,1,2000), NEW.nm_usuario, nr_seq_w, 'PR_URG_EMERG', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.PR_IVH,1,2000), substr(NEW.PR_IVH,1,2000), NEW.nm_usuario, nr_seq_w, 'PR_IVH', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_GERA_LONGA_PERM,1,2000), substr(NEW.IE_GERA_LONGA_PERM,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_GERA_LONGA_PERM', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_GERAR_PARTIC_CIRURG,1,2000), substr(NEW.IE_GERAR_PARTIC_CIRURG,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_GERAR_PARTIC_CIRURG', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_EXPORTA_RESP,1,2000), substr(NEW.IE_EXPORTA_RESP,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_EXPORTA_RESP', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.PR_CESARIANA_PERMITIDA,1,2000), substr(NEW.PR_CESARIANA_PERMITIDA,1,2000), NEW.nm_usuario, nr_seq_w, 'PR_CESARIANA_PERMITIDA', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_EXPORTA_CNES,1,2000), substr(NEW.IE_EXPORTA_CNES,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_EXPORTA_CNES', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_EXP_CNPJ_FORNEC_FABRIC,1,2000), substr(NEW.IE_EXP_CNPJ_FORNEC_FABRIC,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_EXP_CNPJ_FORNEC_FABRIC', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_EXPORTA_CNES_HOSP,1,2000), substr(NEW.IE_EXPORTA_CNES_HOSP,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_EXPORTA_CNES_HOSP', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_INC_PROC_URG_AIH,1,2000), substr(NEW.IE_INC_PROC_URG_AIH,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_INC_PROC_URG_AIH', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_INC_PROC_CONTA,1,2000), substr(NEW.IE_INC_PROC_CONTA,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_INC_PROC_CONTA', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ORDENA_PROC_VALOR,1,2000), substr(NEW.IE_ORDENA_PROC_VALOR,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_ORDENA_PROC_VALOR', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_INCREMENTO_ANESTESISTA,1,2000), substr(NEW.IE_INCREMENTO_ANESTESISTA,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_INCREMENTO_ANESTESISTA', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.CD_ACERVO,1,2000), substr(NEW.CD_ACERVO,1,2000), NEW.nm_usuario, nr_seq_w, 'CD_ACERVO', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.CD_DIRETOR_TECNICO,1,2000), substr(NEW.CD_DIRETOR_TECNICO,1,2000), NEW.nm_usuario, nr_seq_w, 'CD_DIRETOR_TECNICO', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PRESTADOR_LAUDO_ACH,1,2000), substr(NEW.CD_PRESTADOR_LAUDO_ACH,1,2000), NEW.nm_usuario, nr_seq_w, 'CD_PRESTADOR_LAUDO_ACH', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.DS_CARATER_INCREMENTO,1,2000), substr(NEW.DS_CARATER_INCREMENTO,1,2000), NEW.nm_usuario, nr_seq_w, 'DS_CARATER_INCREMENTO', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_AJUSTA_ATEND_DEST,1,2000), substr(NEW.IE_AJUSTA_ATEND_DEST,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_AJUSTA_ATEND_DEST', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ALTERAR_SP_PROC_RIM,1,2000), substr(NEW.IE_ALTERAR_SP_PROC_RIM,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_ALTERAR_SP_PROC_RIM', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_EXPORTA_CNES_SETOR,1,2000), substr(NEW.IE_EXPORTA_CNES_SETOR,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_EXPORTA_CNES_SETOR', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_FORMA_ENVIO_DATA_PROC,1,2000), substr(NEW.IE_FORMA_ENVIO_DATA_PROC,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_FORMA_ENVIO_DATA_PROC', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_MOMENTO_RATEIO_SH,1,2000), substr(NEW.IE_MOMENTO_RATEIO_SH,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_MOMENTO_RATEIO_SH', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ORDEM_TELEFONE_PAC,1,2000), substr(NEW.IE_ORDEM_TELEFONE_PAC,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_ORDEM_TELEFONE_PAC', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_VINCULAR_LAUDO_ATEND_EXT,1,2000), substr(NEW.IE_VINCULAR_LAUDO_ATEND_EXT,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_VINCULAR_LAUDO_ATEND_EXT', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_VINCULAR_LAUDO_TIPO_ATEND,1,2000), substr(NEW.IE_VINCULAR_LAUDO_TIPO_ATEND,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_VINCULAR_LAUDO_TIPO_ATEND', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.NR_NAC_SERVENTIA,1,2000), substr(NEW.NR_NAC_SERVENTIA,1,2000), NEW.nm_usuario, nr_seq_w, 'NR_NAC_SERVENTIA', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.NR_TIPO_LIVRO,1,2000), substr(NEW.NR_TIPO_LIVRO,1,2000), NEW.nm_usuario, nr_seq_w, 'NR_TIPO_LIVRO', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.VL_INCREMENTO_PNASH,1,2000), substr(NEW.VL_INCREMENTO_PNASH,1,2000), NEW.nm_usuario, nr_seq_w, 'VL_INCREMENTO_PNASH', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.QT_MAX_DIARIA_ENFERM,1,2000), substr(NEW.QT_MAX_DIARIA_ENFERM,1,2000), NEW.nm_usuario, nr_seq_w, 'QT_MAX_DIARIA_ENFERM', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MEDICO_RESPONSAVEL,1,2000), substr(NEW.CD_MEDICO_RESPONSAVEL,1,2000), NEW.nm_usuario, nr_seq_w, 'CD_MEDICO_RESPONSAVEL', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PROJ_XML_MUDANCA_PROC,1,2000), substr(NEW.CD_PROJ_XML_MUDANCA_PROC,1,2000), NEW.nm_usuario, nr_seq_w, 'CD_PROJ_XML_MUDANCA_PROC', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PROJ_XML_SOLIC_AIH,1,2000), substr(NEW.CD_PROJ_XML_SOLIC_AIH,1,2000), NEW.nm_usuario, nr_seq_w, 'CD_PROJ_XML_SOLIC_AIH', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CLINICA_LAUDO_INT_BPA,1,2000), substr(NEW.IE_CLINICA_LAUDO_INT_BPA,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_CLINICA_LAUDO_INT_BPA', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CONSIST_PROC_ONCO_PROT,1,2000), substr(NEW.IE_CONSIST_PROC_ONCO_PROT,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_CONSIST_PROC_ONCO_PROT', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_EXP_CNES_EXC_MED,1,2000), substr(NEW.IE_EXP_CNES_EXC_MED,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_EXP_CNES_EXC_MED', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_GERA_AIH_LAUDO_TRANF,1,2000), substr(NEW.IE_GERA_AIH_LAUDO_TRANF,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_GERA_AIH_LAUDO_TRANF', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_INCEMENTO_SEQ_ONCO,1,2000), substr(NEW.IE_INCEMENTO_SEQ_ONCO,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_INCEMENTO_SEQ_ONCO', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_MANTER_DOC_EXECUTOR,1,2000), substr(NEW.IE_MANTER_DOC_EXECUTOR,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_MANTER_DOC_EXECUTOR', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PROC_PRINC_RECEB_SH,1,2000), substr(NEW.IE_PROC_PRINC_RECEB_SH,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_PROC_PRINC_RECEB_SH', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_RESTRINGE_CID_PROC,1,2000), substr(NEW.IE_RESTRINGE_CID_PROC,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_RESTRINGE_CID_PROC', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TRANSF_DIAG_INTERNA_BPA,1,2000), substr(NEW.IE_TRANSF_DIAG_INTERNA_BPA,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_TRANSF_DIAG_INTERNA_BPA', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_UTILIZA_REGRA_ORDEM_SEQ,1,2000), substr(NEW.IE_UTILIZA_REGRA_ORDEM_SEQ,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_UTILIZA_REGRA_ORDEM_SEQ', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
SELECT * FROM gravar_log_alteracao(substr(OLD.IE_VINCULAR_LAUDO_ATEND_PS,1,2000), substr(NEW.IE_VINCULAR_LAUDO_ATEND_PS,1,2000), NEW.nm_usuario, nr_seq_w, 'IE_VINCULAR_LAUDO_ATEND_PS', ie_log_w, ds_w, 'SUS_PARAMETROS_AIH', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;
exception
	when others then
	ds_w:= '1';
	end;

  END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_sus_parametros_aih_tp() FROM PUBLIC;

CREATE TRIGGER sus_parametros_aih_tp
	AFTER UPDATE ON sus_parametros_aih FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_sus_parametros_aih_tp();
