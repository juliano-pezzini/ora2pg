-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS qua_nao_conform_setor_insert ON qua_nao_conform_setor CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_qua_nao_conform_setor_insert() RETURNS trigger AS $BODY$
DECLARE

BEGIN

if (NEW.nr_seq_grupo_usuario_dest is null) and (NEW.nm_usuario_destino is null) and (NEW.cd_setor_atendimento is null) then
	/*(-20011, ' Deve-se pelo menos preencher um dos campos !');*/

	CALL wheb_mensagem_pck.exibir_mensagem_abort(263179);
end if;

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_qua_nao_conform_setor_insert() FROM PUBLIC;

CREATE TRIGGER qua_nao_conform_setor_insert
	BEFORE INSERT ON qua_nao_conform_setor FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_qua_nao_conform_setor_insert();
