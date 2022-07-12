-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pre_natal_atual ON pre_natal CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pre_natal_atual() RETURNS trigger AS $BODY$
declare
 
BEGIN 
if (NEW.CD_PEDIATRA is not null) and (NEW.NM_OBSTETRA is null)then 
	NEW.NM_OBSTETRA	:= obter_nome_pf(NEW.CD_PEDIATRA );
end if;
 
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pre_natal_atual() FROM PUBLIC;

CREATE TRIGGER pre_natal_atual
	BEFORE INSERT OR UPDATE ON pre_natal FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pre_natal_atual();
