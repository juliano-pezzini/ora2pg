-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_param_prop_onl_afterupdate ON pls_param_proposta_online CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_param_prop_onl_afterupdate() RETURNS trigger AS $BODY$
declare

BEGIN

if (NEW.ds_dia_vencimento <> OLD.ds_dia_vencimento) then
	CALL pls_gerar_log_alt_parametros(	'PLS_PARAM_PROPOSTA_ONLINE', 'DS_DIA_VENCIMENTO', OLD.ds_dia_vencimento,
					NEW.ds_dia_vencimento, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);
end if;

if (NEW.qt_dia_cancelamento <> OLD.qt_dia_cancelamento) then
	CALL pls_gerar_log_alt_parametros(	'PLS_PARAM_PROPOSTA_ONLINE', 'QT_DIA_CANCELAMENTO', OLD.qt_dia_cancelamento,
					NEW.qt_dia_cancelamento, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);
end if;

if (NEW.ds_url_manual_instrucao <> OLD.ds_url_manual_instrucao) then
	CALL pls_gerar_log_alt_parametros(	'PLS_PARAM_PROPOSTA_ONLINE', 'DS_URL_MANUAL_INSTRUCAO', OLD.ds_url_manual_instrucao,
					NEW.ds_url_manual_instrucao, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);
end if;

if (NEW.nr_seq_modelo <> OLD.nr_seq_modelo) then
	CALL pls_gerar_log_alt_parametros(	'PLS_PARAM_PROPOSTA_ONLINE', 'NR_SEQ_MODELO', OLD.nr_seq_modelo,
					NEW.nr_seq_modelo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);
end if;

if (NEW.nr_seq_termo_dec_saude <> OLD.nr_seq_termo_dec_saude) then
	CALL pls_gerar_log_alt_parametros(	'PLS_PARAM_PROPOSTA_ONLINE', 'NR_SEQ_TERMO_DEC_SAUDE', OLD.nr_seq_termo_dec_saude,
					NEW.nr_seq_termo_dec_saude, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);
end if;

if (NEW.nr_seq_motivo_inclusao <> OLD.nr_seq_motivo_inclusao) then
	CALL pls_gerar_log_alt_parametros(	'PLS_PARAM_PROPOSTA_ONLINE', 'NR_SEQ_MOTIVO_INCLUSAO', OLD.nr_seq_motivo_inclusao,
					NEW.nr_seq_motivo_inclusao, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);
end if;

if (NEW.ds_url_manual_mps <> OLD.ds_url_manual_mps) then
	CALL pls_gerar_log_alt_parametros(	'PLS_PARAM_PROPOSTA_ONLINE', 'DS_URL_MANUAL_MPS', OLD.ds_url_manual_mps,
					NEW.ds_url_manual_mps, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);
end if;

if (NEW.ds_diretorio_anexo <> OLD.ds_diretorio_anexo) then
	CALL pls_gerar_log_alt_parametros(	'PLS_PARAM_PROPOSTA_ONLINE', 'DS_DIRETORIO_ANEXO', OLD.ds_diretorio_anexo,
					NEW.ds_diretorio_anexo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);
end if;

if (NEW.qt_dias_vigencia <> OLD.qt_dias_vigencia) then
	CALL pls_gerar_log_alt_parametros(	'PLS_PARAM_PROPOSTA_ONLINE', 'QT_DIAS_VIGENCIA', OLD.qt_dias_vigencia,
					NEW.qt_dias_vigencia, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);
end if;

if (NEW.nr_seq_vendedor_canal <> OLD.nr_seq_vendedor_canal) then
	CALL pls_gerar_log_alt_parametros(	'PLS_PARAM_PROPOSTA_ONLINE', 'NR_SEQ_VENDEDOR_CANAL', OLD.nr_seq_vendedor_canal,
					NEW.nr_seq_vendedor_canal, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);
end if;

if (NEW.ie_declaracao_saude <> OLD.ie_declaracao_saude) then
	CALL pls_gerar_log_alt_parametros(	'PLS_PARAM_PROPOSTA_ONLINE', 'IE_DECLARACAO_SAUDE', OLD.ie_declaracao_saude,
					NEW.ie_declaracao_saude, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);
end if;

if (NEW.ie_gerar_proposta <> OLD.ie_gerar_proposta) then
	CALL pls_gerar_log_alt_parametros(	'PLS_PARAM_PROPOSTA_ONLINE', 'IE_GERAR_PROPOSTA', OLD.ie_gerar_proposta,
					NEW.ie_gerar_proposta, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);
end if;

if (NEW.ds_observacao_finalizar <> OLD.ds_observacao_finalizar) then
	CALL pls_gerar_log_alt_parametros(	'PLS_PARAM_PROPOSTA_ONLINE', 'DS_OBSERVACAO_FINALIZAR', OLD.ds_observacao_finalizar,
					NEW.ds_observacao_finalizar, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_param_prop_onl_afterupdate() FROM PUBLIC;

CREATE TRIGGER pls_param_prop_onl_afterupdate
	AFTER UPDATE ON pls_param_proposta_online FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_param_prop_onl_afterupdate();

