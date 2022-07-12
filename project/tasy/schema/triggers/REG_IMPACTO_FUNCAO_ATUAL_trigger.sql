-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS reg_impacto_funcao_atual ON reg_impacto_funcao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_reg_impacto_funcao_atual() RETURNS trigger AS $BODY$
BEGIN

if (NEW.ie_situacao = 'I') then

    if (NEW.ds_motivo_inativacao is not null) then

        NEW.dt_inativacao := LOCALTIMESTAMP;
        NEW.nm_usuario_inativacao := NEW.nm_usuario;

    elsif (NEW.ds_motivo_inativacao is null) then
        CALL Wheb_mensagem_pck.exibir_mensagem_abort(1114265);

    end if;

end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_reg_impacto_funcao_atual() FROM PUBLIC;

CREATE TRIGGER reg_impacto_funcao_atual
	BEFORE UPDATE ON reg_impacto_funcao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_reg_impacto_funcao_atual();

