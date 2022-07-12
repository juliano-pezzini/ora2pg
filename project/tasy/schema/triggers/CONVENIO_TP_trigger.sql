-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS convenio_tp ON convenio CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_convenio_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.CD_CONVENIO);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.CD_INTERFACE_RETORNO,1,4000), substr(NEW.CD_INTERFACE_RETORNO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_INTERFACE_RETORNO', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_INTEGRACAO,1,4000), substr(NEW.CD_INTEGRACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_INTEGRACAO', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_CONVENIO,1,4000), substr(NEW.DS_CONVENIO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_CONVENIO', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_INTERNO,1,4000), substr(NEW.CD_INTERNO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_INTERNO', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_VALOR_CONTABIL,1,4000), substr(NEW.IE_VALOR_CONTABIL,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_VALOR_CONTABIL', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_INCLUSAO,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_INCLUSAO,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_INCLUSAO', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_CONVENIO,1,4000), substr(NEW.IE_TIPO_CONVENIO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_CONVENIO', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_EXIGE_DATA_ULT_PAGTO,1,4000), substr(NEW.IE_EXIGE_DATA_ULT_PAGTO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_EXIGE_DATA_ULT_PAGTO', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.NR_DIGITOS_CODIGO,1,4000), substr(NEW.NR_DIGITOS_CODIGO,1,4000), NEW.nm_usuario, nr_seq_w, 'NR_DIGITOS_CODIGO', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_MASCARA_CODIGO,1,4000), substr(NEW.DS_MASCARA_CODIGO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_MASCARA_CODIGO', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_EXIGE_GUIA,1,4000), substr(NEW.IE_EXIGE_GUIA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_EXIGE_GUIA', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_ROTINA_DIGITO,1,4000), substr(NEW.DS_ROTINA_DIGITO,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_ROTINA_DIGITO', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CLASSIF_CONTABIL,1,4000), substr(NEW.IE_CLASSIF_CONTABIL,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CLASSIF_CONTABIL', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TITULO_RECEBER,1,4000), substr(NEW.IE_TITULO_RECEBER,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TITULO_RECEBER', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_CONDICAO_PAGAMENTO,1,4000), substr(NEW.CD_CONDICAO_PAGAMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_CONDICAO_PAGAMENTO', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PROCESSO_ALTA,1,4000), substr(NEW.CD_PROCESSO_ALTA,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PROCESSO_ALTA', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_INTERFACE_ENVIO,1,4000), substr(NEW.CD_INTERFACE_ENVIO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_INTERFACE_ENVIO', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_SENHA,1,4000), substr(NEW.DS_SENHA,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_SENHA', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_INTERFACE_AUTORIZACAO,1,4000), substr(NEW.CD_INTERFACE_AUTORIZACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_INTERFACE_AUTORIZACAO', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(to_char(OLD.DT_CANCELAMENTO,'dd/mm/yyyy hh24:mi:ss'), to_char(NEW.DT_CANCELAMENTO,'dd/mm/yyyy hh24:mi:ss'), NEW.nm_usuario, nr_seq_w, 'DT_CANCELAMENTO', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_TIPO_ACOMODACAO,1,4000), substr(NEW.IE_TIPO_ACOMODACAO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_TIPO_ACOMODACAO', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_CGC,1,4000), substr(NEW.CD_CGC,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_CGC', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CODIGO_CONVENIO,1,4000), substr(NEW.IE_CODIGO_CONVENIO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CODIGO_CONVENIO', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PRECO_MEDIO_MATERIAL,1,4000), substr(NEW.IE_PRECO_MEDIO_MATERIAL,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_PRECO_MEDIO_MATERIAL', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_CONTA_PROTOCOLO,1,4000), substr(NEW.QT_CONTA_PROTOCOLO,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_CONTA_PROTOCOLO', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_AGRUP_ITEM_INTERF,1,4000), substr(NEW.IE_AGRUP_ITEM_INTERF,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_AGRUP_ITEM_INTERF', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_DOC_RETORNO,1,4000), substr(NEW.IE_DOC_RETORNO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_DOC_RETORNO', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_DOC_CONVENIO,1,4000), substr(NEW.IE_DOC_CONVENIO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_DOC_CONVENIO', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CONVERSAO_MAT,1,4000), substr(NEW.IE_CONVERSAO_MAT,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CONVERSAO_MAT', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CALC_PORTE,1,4000), substr(NEW.IE_CALC_PORTE,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CALC_PORTE', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_EXIGE_SENHA_ATEND,1,4000), substr(NEW.IE_EXIGE_SENHA_ATEND,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_EXIGE_SENHA_ATEND', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SOLIC_EXAME_TASYMED,1,4000), substr(NEW.IE_SOLIC_EXAME_TASYMED,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SOLIC_EXAME_TASYMED', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_ROTINA_DIGITO_GUIA,1,4000), substr(NEW.DS_ROTINA_DIGITO_GUIA,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_ROTINA_DIGITO_GUIA', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_VENC_ULTIMO_DIA,1,4000), substr(NEW.IE_VENC_ULTIMO_DIA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_VENC_ULTIMO_DIA', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_ROTINA_SENHA,1,4000), substr(NEW.DS_ROTINA_SENHA,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_ROTINA_SENHA', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_EDICAO_AMB_REFER,1,4000), substr(NEW.CD_EDICAO_AMB_REFER,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_EDICAO_AMB_REFER', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_MASCARA_COMPL,1,4000), substr(NEW.DS_MASCARA_COMPL,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_MASCARA_COMPL', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_MATRICULA_INTEG,1,4000), substr(NEW.IE_MATRICULA_INTEG,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_MATRICULA_INTEG', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_NF_CONTAB_REC_CONV,1,4000), substr(NEW.IE_NF_CONTAB_REC_CONV,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_NF_CONTAB_REC_CONV', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_REGIONAL,1,4000), substr(NEW.CD_REGIONAL,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_REGIONAL', ie_log_w, ds_w, 'CONVENIO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_convenio_tp() FROM PUBLIC;

CREATE TRIGGER convenio_tp
	AFTER UPDATE ON convenio FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_convenio_tp();
