-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS lab_parametro_tp ON lab_parametro CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_lab_parametro_tp() RETURNS trigger AS $BODY$
DECLARE nr_seq_w bigint;ds_s_w   varchar(1);ds_c_w   varchar(1);ds_w	   varchar(1);ie_log_w varchar(1);BEGIN BEGIN ds_s_w := to_char(OLD.CD_ESTABELECIMENTO);  ds_c_w:=null;SELECT * FROM gravar_log_alteracao(substr(OLD.IE_STATUS_POS_ENVIO,1,4000), substr(NEW.IE_STATUS_POS_ENVIO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_STATUS_POS_ENVIO', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_STATUS_BAIXA_INTEG,1,4000), substr(NEW.IE_STATUS_BAIXA_INTEG,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_STATUS_BAIXA_INTEG', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_STATUS_ENVIO,1,4000), substr(NEW.IE_STATUS_ENVIO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_STATUS_ENVIO', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ARQUIVO_INTERF,1,4000), substr(NEW.IE_ARQUIVO_INTERF,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_ARQUIVO_INTERF', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_PADRAO_AMOSTRA,1,4000), substr(NEW.IE_PADRAO_AMOSTRA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_PADRAO_AMOSTRA', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_DATA_CONTA,1,4000), substr(NEW.IE_DATA_CONTA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_DATA_CONTA', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_GERAR_RESULT_PRESCR,1,4000), substr(NEW.IE_GERAR_RESULT_PRESCR,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_GERAR_RESULT_PRESCR', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_STATUS_CONTA,1,4000), substr(NEW.IE_STATUS_CONTA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_STATUS_CONTA', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_STATUS_RECEB,1,4000), substr(NEW.IE_STATUS_RECEB,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_STATUS_RECEB', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_URL_PERG_FLEURY,1,4000), substr(NEW.DS_URL_PERG_FLEURY,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_URL_PERG_FLEURY', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_URL_CONT_FLEURY,1,4000), substr(NEW.DS_URL_CONT_FLEURY,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_URL_CONT_FLEURY', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_UNID_RESULT_ANT,1,4000), substr(NEW.IE_UNID_RESULT_ANT,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_UNID_RESULT_ANT', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_RET_EXAME_LOTE,1,4000), substr(NEW.IE_RET_EXAME_LOTE,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_RET_EXAME_LOTE', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_REPLICAR_ARQ_EQUIP,1,4000), substr(NEW.IE_REPLICAR_ARQ_EQUIP,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_REPLICAR_ARQ_EQUIP', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_STATUS_LOTE_EXT,1,4000), substr(NEW.IE_STATUS_LOTE_EXT,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_STATUS_LOTE_EXT', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_INTEGRA_FLEURY,1,4000), substr(NEW.IE_INTEGRA_FLEURY,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_INTEGRA_FLEURY', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_UNIDADE_FLEURY,1,4000), substr(NEW.CD_UNIDADE_FLEURY,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_UNIDADE_FLEURY', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_URL_SERV_FLEURY,1,4000), substr(NEW.DS_URL_SERV_FLEURY,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_URL_SERV_FLEURY', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_STATUS_RECOLETA,1,4000), substr(NEW.IE_STATUS_RECOLETA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_STATUS_RECOLETA', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_CONTA_LAB_EXT,1,4000), substr(NEW.IE_CONTA_LAB_EXT,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_CONTA_LAB_EXT', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_ESTABELECIMENTO,1,4000), substr(NEW.CD_ESTABELECIMENTO,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_ESTABELECIMENTO', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_LAUDO_TEXTO,1,4000), substr(NEW.IE_LAUDO_TEXTO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_LAUDO_TEXTO', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_SALVA_ETAPA,1,4000), substr(NEW.IE_SALVA_ETAPA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_SALVA_ETAPA', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ATUALIZAR_LOTE_EXT,1,4000), substr(NEW.IE_ATUALIZAR_LOTE_EXT,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_ATUALIZAR_LOTE_EXT', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ATUAL_RESULT_APROV,1,4000), substr(NEW.IE_ATUAL_RESULT_APROV,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_ATUAL_RESULT_APROV', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_MOTIVO_BAIXA,1,4000), substr(NEW.CD_MOTIVO_BAIXA,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_MOTIVO_BAIXA', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_MICRO_POSITIVO,1,4000), substr(NEW.IE_MICRO_POSITIVO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_MICRO_POSITIVO', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_STATUS_BAIXA,1,4000), substr(NEW.IE_STATUS_BAIXA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_STATUS_BAIXA', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_DESAPROVA_EXCLUIR_PROCED,1,4000), substr(NEW.IE_DESAPROVA_EXCLUIR_PROCED,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_DESAPROVA_EXCLUIR_PROCED', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_GERAR_SEQUENCIA,1,4000), substr(NEW.IE_GERAR_SEQUENCIA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_GERAR_SEQUENCIA', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ATUAL_EQUIP_RESULTADO,1,4000), substr(NEW.IE_ATUAL_EQUIP_RESULTADO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_ATUAL_EQUIP_RESULTADO', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.QT_RESULT_ANTERIOR,1,4000), substr(NEW.QT_RESULT_ANTERIOR,1,4000), NEW.nm_usuario, nr_seq_w, 'QT_RESULT_ANTERIOR', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_STATUS_INTERNET,1,4000), substr(NEW.IE_STATUS_INTERNET,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_STATUS_INTERNET', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.CD_PERFIL_INTERNET,1,4000), substr(NEW.CD_PERFIL_INTERNET,1,4000), NEW.nm_usuario, nr_seq_w, 'CD_PERFIL_INTERNET', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_EXCLUIR_LAUDO,1,4000), substr(NEW.IE_EXCLUIR_LAUDO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_EXCLUIR_LAUDO', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_EXIGE_FORMATO,1,4000), substr(NEW.IE_EXIGE_FORMATO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_EXIGE_FORMATO', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ATUALIZAR_RESULT_APROV,1,4000), substr(NEW.IE_ATUALIZAR_RESULT_APROV,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_ATUALIZAR_RESULT_APROV', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_APROVAR_TODOS_INTERF,1,4000), substr(NEW.IE_APROVAR_TODOS_INTERF,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_APROVAR_TODOS_INTERF', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_MONTA_OBS_LAUDO,1,4000), substr(NEW.IE_MONTA_OBS_LAUDO,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_MONTA_OBS_LAUDO', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_ATUAL_BIOQUIMICO_CONTA,1,4000), substr(NEW.IE_ATUAL_BIOQUIMICO_CONTA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_ATUAL_BIOQUIMICO_CONTA', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_STATUS_RECEB_LOTE_EXT,1,4000), substr(NEW.IE_STATUS_RECEB_LOTE_EXT,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_STATUS_RECEB_LOTE_EXT', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_GERA_XML_ETIQ_FLEURY,1,4000), substr(NEW.IE_GERA_XML_ETIQ_FLEURY,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_GERA_XML_ETIQ_FLEURY', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_STATUS_COLETA,1,4000), substr(NEW.IE_STATUS_COLETA,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_STATUS_COLETA', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_GERA_FICHA_FLEURY,1,4000), substr(NEW.IE_GERA_FICHA_FLEURY,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_GERA_FICHA_FLEURY', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.DS_URL_PERG_PAR_FLEURY,1,4000), substr(NEW.DS_URL_PERG_PAR_FLEURY,1,4000), NEW.nm_usuario, nr_seq_w, 'DS_URL_PERG_PAR_FLEURY', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w; SELECT * FROM gravar_log_alteracao(substr(OLD.IE_GERAR_LOTE_SETOR,1,4000), substr(NEW.IE_GERAR_LOTE_SETOR,1,4000), NEW.nm_usuario, nr_seq_w, 'IE_GERAR_LOTE_SETOR', ie_log_w, ds_w, 'LAB_PARAMETRO', ds_s_w, ds_c_w) INTO STRICT nr_seq_w, ie_log_w;   exception when others then ds_w:= '1'; end;   END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_lab_parametro_tp() FROM PUBLIC;

CREATE TRIGGER lab_parametro_tp
	AFTER UPDATE ON lab_parametro FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_lab_parametro_tp();

