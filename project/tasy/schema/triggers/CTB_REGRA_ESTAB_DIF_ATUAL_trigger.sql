-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ctb_regra_estab_dif_atual ON ctb_regra_estab_dif CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ctb_regra_estab_dif_atual() RETURNS trigger AS $BODY$
declare
BEGIN

if (NEW.ie_permite = 'PCCT') and (NEW.cd_conta_contabil is null) then
	/*Para esta regra a conta transitória é obrigatória');*/

	CALL wheb_mensagem_pck.exibir_mensagem_abort(266562);
end if;

if (NEW.ie_permite <> 'PCCT') and (NEW.cd_conta_contabil is not null) then
	/*Para esta regra a conta transitória não pode ser informada');*/

	CALL wheb_mensagem_pck.exibir_mensagem_abort(266563);
end if;

if (NEW.ie_permite = 'PCCT') and (NEW.cd_historico is null) then
	/*'Para esta regra o histórico padrão é obrigatório');*/

	CALL wheb_mensagem_pck.exibir_mensagem_abort(266564);

end if;

if (NEW.ie_permite <> 'PCCT') and (NEW.cd_conta_contabil is not null) then
	/*Para esta regra o histórico padrão não pode ser informado');*/

	CALL wheb_mensagem_pck.exibir_mensagem_abort(266565);
end if;
/*Não deve ser informado regra com conta transitória para o tipo de lote de Consumo!*/

if (NEW.cd_tipo_lote_contabil = 3) and (NEW.ie_permite <> 'PSCT') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(315885);
end if;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ctb_regra_estab_dif_atual() FROM PUBLIC;

CREATE TRIGGER ctb_regra_estab_dif_atual
	BEFORE INSERT OR UPDATE ON ctb_regra_estab_dif FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ctb_regra_estab_dif_atual();

