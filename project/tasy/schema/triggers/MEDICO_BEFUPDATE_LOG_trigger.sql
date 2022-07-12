-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS medico_befupdate_log ON medico CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_medico_befupdate_log() RETURNS trigger AS $BODY$
declare

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
	insert into medico_log(
		nr_sequencia,
		cd_pessoa_fisica,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_crm,
		nm_guerra,
		ie_vinculo_medico,
		cd_cgc,
		ie_cobra_pf_pj,
		ie_conveniado_sus,
		ie_auditor_sus,
		ie_origem_inf,
		uf_crm,
		ie_situacao,
		ie_corpo_clinico,
		dt_admissao,
		dt_desligamento,
		ie_corpo_assist,
		dt_efetivacao,
		nr_seq_categoria,
		ie_tipo_compl_corresp,
		nr_rqe,
		ie_ama,
		ds_senha,
		ie_tsa,
		ds_orientacao_medico,
		ie_retaguarda)
	values ( nextval('medico_log_seq'),
		NEW.cd_pessoa_fisica,
		LOCALTIMESTAMP,
		NEW.nm_usuario,
		LOCALTIMESTAMP,
		NEW.nm_usuario,
		OLD.nr_crm,
		OLD.nm_guerra,
		OLD.ie_vinculo_medico,
		OLD.cd_cgc,
		OLD.ie_cobra_pf_pj,
		OLD.ie_conveniado_sus,
		OLD.ie_auditor_sus,
		OLD.ie_origem_inf,
		OLD.uf_crm,
		OLD.ie_situacao,
		OLD.ie_corpo_clinico,
		OLD.dt_admissao,
		OLD.dt_desligamento,
		OLD.ie_corpo_assist,
		OLD.dt_efetivacao,
		OLD.nr_seq_categoria,
		OLD.ie_tipo_compl_corresp,
		OLD.nr_rqe,
		OLD.ie_ama,
		CASE WHEN coalesce(pkg_i18n.get_user_locale, 'pt_BR')='pt_BR' THEN  OLD.ds_senha  ELSE null END ,
		OLD.ie_tsa,
		OLD.ds_orientacao_medico,
		OLD.ie_retaguarda);
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_medico_befupdate_log() FROM PUBLIC;

CREATE TRIGGER medico_befupdate_log
	BEFORE UPDATE ON medico FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_medico_befupdate_log();

