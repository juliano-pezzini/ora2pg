-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS opme_regra_procedimento_atual ON opme_regra_procedimento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_opme_regra_procedimento_atual() RETURNS trigger AS $BODY$
declare
qt_reg_w	bigint;

BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger	= 'S')  then

	select 	count(*)
	into STRICT	qt_reg_w
	from 	procedimento
	where 	cd_procedimento  = NEW.cd_procedimento
	and 	ie_origem_proced = NEW.ie_origem_proced
	and	ie_situacao	 = 'A';

	if (qt_reg_w = 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(266262);
		--' A origem do procedimento não está correta. Verificar a origem no cadastro do procedimento!');
	end if;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_opme_regra_procedimento_atual() FROM PUBLIC;

CREATE TRIGGER opme_regra_procedimento_atual
	BEFORE INSERT OR UPDATE ON opme_regra_procedimento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_opme_regra_procedimento_atual();
