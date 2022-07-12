-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_poss_atual ON escala_possum CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_poss_atual() RETURNS trigger AS $BODY$
declare
   qt_reg_w               smallint;

BEGIN
    if (wheb_usuario_pck.get_ie_executar_trigger	= 'S')  then
        CALL Consiste_Liberacao_Escala(181);
    end if;

  qt_reg_w	:= 0;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_poss_atual() FROM PUBLIC;

CREATE TRIGGER escala_poss_atual
	BEFORE INSERT OR UPDATE ON escala_possum FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_poss_atual();

