-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS cirurgia_tec_anestesica_insert ON cirurgia_tec_anestesica CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_cirurgia_tec_anestesica_insert() RETURNS trigger AS $BODY$
declare
nm_usuario_w   usuario.nm_usuario%type := wheb_usuario_pck.get_nm_usuario;
qt_reg_w		   smallint;
BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto Final;
end if;

if (NEW.dt_atualizacao_nrec is null) then
   NEW.dt_atualizacao_nrec := LOCALTIMESTAMP;
end if;

if (NEW.nm_usuario_nrec is null) then
   NEW.nm_usuario_nrec := nm_usuario_w;
end if;
	
<<Final>>
qt_reg_w	:= 0;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_cirurgia_tec_anestesica_insert() FROM PUBLIC;

CREATE TRIGGER cirurgia_tec_anestesica_insert
	BEFORE INSERT ON cirurgia_tec_anestesica FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_cirurgia_tec_anestesica_insert();

