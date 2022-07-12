-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_glosa_evento_del ON pls_glosa_evento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_glosa_evento_del() RETURNS trigger AS $BODY$
declare
ie_tipo_w	pls_glosa_evento_log.ie_tipo%type;
nm_usuario_w	usuario.nm_usuario%type;
BEGIN
if (coalesce(wheb_usuario_pck.get_ie_executar_trigger,'S') = 'S')  then
	if (OLD.ie_plano_versao = 'S') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(293877);
	end if;
end if;
RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_glosa_evento_del() FROM PUBLIC;

CREATE TRIGGER pls_glosa_evento_del
	BEFORE DELETE ON pls_glosa_evento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_glosa_evento_del();

