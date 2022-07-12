-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_email_before_insert ON pls_email CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_email_before_insert() RETURNS trigger AS $BODY$
declare

BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
	NEW.ie_confirmacao_leitura := coalesce(obter_valor_param_usuario(0, 44, obter_perfil_ativo, NEW.nm_usuario_nrec, obter_estabelecimento_ativo), 'N');

	if (NEW.cd_perfil is null) and (coalesce(obter_perfil_ativo,0) <> 0 ) then
		NEW.cd_perfil := obter_perfil_ativo;
	end if;
end if;
	
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_email_before_insert() FROM PUBLIC;

CREATE TRIGGER pls_email_before_insert
	BEFORE INSERT ON pls_email FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_email_before_insert();
