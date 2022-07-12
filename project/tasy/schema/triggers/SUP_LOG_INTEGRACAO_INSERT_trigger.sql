-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS sup_log_integracao_insert ON sup_log_integracao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_sup_log_integracao_insert() RETURNS trigger AS $BODY$
declare
 
ie_envio_w 	varchar(1) := 'N';
 
BEGIN 
if (coalesce(NEW.ds_consistencia,'X') <> 'X') then 
	BEGIN 
	ie_envio_w := sup_enviar_email_int(	NEW.ie_evento, 'ME', NEW.nr_documento, wheb_usuario_pck.get_cd_estabelecimento, NEW.nm_usuario, ie_envio_w, NEW.ie_tipo_doc, NEW.ie_acao, NEW.ds_consistencia);
				 
	if (ie_envio_w = 'S') then 
		BEGIN 
		NEW.dt_envio_email := LOCALTIMESTAMP;
		end;
	end if;
	end;
end if; 	
 
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_sup_log_integracao_insert() FROM PUBLIC;

CREATE TRIGGER sup_log_integracao_insert
	BEFORE INSERT ON sup_log_integracao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_sup_log_integracao_insert();

