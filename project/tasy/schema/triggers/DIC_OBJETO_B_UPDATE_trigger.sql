-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS dic_objeto_b_update ON dic_objeto CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_dic_objeto_b_update() RETURNS trigger AS $BODY$
declare
ds_user_w varchar(100);

BEGIN
select max(USERNAME)
 into STRICT ds_user_w
 from v$session
 where  audsid = (SELECT userenv('sessionid') );
if (ds_user_w = 'TASY') then
if	((NEW.ie_tipo_objeto = 'AC') and (NEW.qt_largura > 0) and (NEW.qt_largura_ios is null)) then
	BEGIN

	NEW.qt_largura_ios := NEW.qt_largura;

	end;
end if;
end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_dic_objeto_b_update() FROM PUBLIC;

CREATE TRIGGER dic_objeto_b_update
	BEFORE UPDATE ON dic_objeto FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_dic_objeto_b_update();
