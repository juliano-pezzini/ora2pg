-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS dic_objeto_update ON dic_objeto CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_dic_objeto_update() RETURNS trigger AS $BODY$
declare
ds_user_w varchar(100);

BEGIN
select max(USERNAME)
 into STRICT ds_user_w
 from v$session
 where  audsid = (SELECT userenv('sessionid') );
if (ds_user_w = 'TASY') then

if (NEW.ie_tipo_objeto = 'P') and (NEW.ds_texto <> OLD.ds_texto) then
	BEGIN
	update	dic_objeto_idioma
	set	ds_descricao = NEW.ds_texto,
		ie_necessita_revisao = 'S',
		dt_atualizacao = LOCALTIMESTAMP,
		nm_usuario = NEW.nm_usuario
	where	nr_seq_objeto = NEW.nr_sequencia
	and	nm_atributo = 'DS_TEXTO';
	end;
elsif (NEW.ie_tipo_objeto = 'AC') and (NEW.nm_campo_tela <> OLD.nm_campo_tela) then
	BEGIN
	update	dic_objeto_idioma
	set	ds_descricao = NEW.ds_texto,
		ie_necessita_revisao = 'S',
		dt_atualizacao = LOCALTIMESTAMP,
		nm_usuario = NEW.nm_usuario
	where	nr_seq_objeto = NEW.nr_sequencia
	and	nm_atributo = 'NM_CAMPO_TELA';
	end;
end if;
end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_dic_objeto_update() FROM PUBLIC;

CREATE TRIGGER dic_objeto_update
	AFTER UPDATE ON dic_objeto FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_dic_objeto_update();
