-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS gpt_hist_analise_plano_delete ON gpt_hist_analise_plano CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_gpt_hist_analise_plano_delete() RETURNS trigger AS $BODY$
declare

ds_alteracao_rastre_w		log_tasy.ds_log%type;
ie_info_rastre_prescr_w		varchar(1);

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then

	ie_info_rastre_prescr_w 	:= 'N';

	ie_info_rastre_prescr_w := obter_se_info_rastre_prescr('AG', wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_perfil, wheb_usuario_pck.get_cd_estabelecimento);

		if (ie_info_rastre_prescr_w = 'S') then

			ds_alteracao_rastre_w := substr('gpt_hist_analise_plano_delete trigger - '|| pls_util_pck.enter_w ||
											'cd_pessoa_fisica: '||OLD.cd_pessoa_fisica|| pls_util_pck.enter_w ||
											'cd_resp_analise: '||OLD.cd_resp_analise|| pls_util_pck.enter_w ||
											'dt_atualizacao: '||OLD.dt_atualizacao|| pls_util_pck.enter_w ||
											'dt_atualizacao_nrec: '||OLD.dt_atualizacao_nrec|| pls_util_pck.enter_w ||
											'dt_fim_analise: '||OLD.dt_fim_analise|| pls_util_pck.enter_w ||
											'dt_inicio_analise: '||OLD.dt_inicio_analise|| pls_util_pck.enter_w ||
											'ie_status_analise_farm: '||OLD.ie_status_analise_farm|| pls_util_pck.enter_w ||
											'ie_tipo_usuario: '||OLD.ie_tipo_usuario|| pls_util_pck.enter_w ||
											'nm_resp_analise: '||OLD.nm_resp_analise|| pls_util_pck.enter_w ||
											'nm_usuario: '||OLD.nm_usuario|| pls_util_pck.enter_w ||
											'nm_usuario_nrec: '||OLD.nm_usuario_nrec|| pls_util_pck.enter_w ||
											'nr_atendimento: '||OLD.nr_atendimento|| pls_util_pck.enter_w ||
											'nr_sequencia: '||OLD.nr_sequencia|| pls_util_pck.enter_w ||
											'ds_stack: '||substr(dbms_utility.format_call_stack,1,1800), 1,2000);
			CALL gravar_log_tasy(50, ds_alteracao_rastre_w, wheb_usuario_pck.get_nm_usuario);

		end if;

end if;

RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_gpt_hist_analise_plano_delete() FROM PUBLIC;

CREATE TRIGGER gpt_hist_analise_plano_delete
	BEFORE DELETE ON gpt_hist_analise_plano FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_gpt_hist_analise_plano_delete();
