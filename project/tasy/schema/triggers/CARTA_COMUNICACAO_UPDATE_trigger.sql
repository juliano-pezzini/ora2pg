-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS carta_comunicacao_update ON carta_comunicacao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_carta_comunicacao_update() RETURNS trigger AS $BODY$
declare
 
BEGIN 
 
if (NEW.ds_mensagem <> OLD.ds_mensagem) and (OLD.ie_leitura = 'S') then 
	NEW.ie_leitura := 'N';
	NEW.nm_usuario_leitura := null;
end if;	
 
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_carta_comunicacao_update() FROM PUBLIC;

CREATE TRIGGER carta_comunicacao_update
	BEFORE UPDATE ON carta_comunicacao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_carta_comunicacao_update();

