-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_intercambio_befinsup ON pls_intercambio CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_intercambio_befinsup() RETURNS trigger AS $BODY$
BEGIN

if (regexp_replace(NEW.cd_operadora_empresa, '[^0-9]', '') <> NEW.cd_operadora_empresa) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1092701); --Código de empresa inválido!
end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_intercambio_befinsup() FROM PUBLIC;

CREATE TRIGGER pls_intercambio_befinsup
	BEFORE INSERT OR UPDATE ON pls_intercambio FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_intercambio_befinsup();
