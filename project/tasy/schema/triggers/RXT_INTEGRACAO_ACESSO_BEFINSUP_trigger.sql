-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS rxt_integracao_acesso_befinsup ON rxt_integracao_acesso CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_rxt_integracao_acesso_befinsup() RETURNS trigger AS $BODY$
BEGIN

if (NEW.cd_perfil		is null) and (NEW.nm_usuario_acesso	is null) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(389692);
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_rxt_integracao_acesso_befinsup() FROM PUBLIC;

CREATE TRIGGER rxt_integracao_acesso_befinsup
	BEFORE INSERT OR UPDATE ON rxt_integracao_acesso FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_rxt_integracao_acesso_befinsup();
