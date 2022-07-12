-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_aldrete_delete ON escala_aldrete CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_aldrete_delete() RETURNS trigger AS $BODY$
declare

qt_reg_w		smallint;
ie_tipo_w		varchar(10);

BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto Final;
end if;

goto Final;

<<Final>>
qt_reg_w	:= 0;
RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_aldrete_delete() FROM PUBLIC;

CREATE TRIGGER escala_aldrete_delete
	AFTER DELETE ON escala_aldrete FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_aldrete_delete();

