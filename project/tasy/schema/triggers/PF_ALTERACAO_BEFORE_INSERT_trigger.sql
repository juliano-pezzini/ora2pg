-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pf_alteracao_before_insert ON pessoa_fisica_alteracao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pf_alteracao_before_insert() RETURNS trigger AS $BODY$
BEGIN
    if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
        if (coalesce(pkg_i18n.get_user_locale,'pt_BR') <> 'pt_BR') and (NEW.ds_senha is not null) then
            NEW.ds_senha := ' ';
        end if;
    end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pf_alteracao_before_insert() FROM PUBLIC;

CREATE TRIGGER pf_alteracao_before_insert
	BEFORE INSERT OR UPDATE ON pessoa_fisica_alteracao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pf_alteracao_before_insert();

