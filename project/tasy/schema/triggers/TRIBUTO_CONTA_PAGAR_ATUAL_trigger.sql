-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS tributo_conta_pagar_atual ON tributo_conta_pagar CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_tributo_conta_pagar_atual() RETURNS trigger AS $BODY$
declare

BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger = 'S')  then

	if (coalesce(NEW.ie_acumulativo,'N') <> coalesce(OLD.ie_acumulativo,'N')) or (coalesce(NEW.vl_minimo,0) <> coalesce(OLD.vl_minimo,0)) or (coalesce(NEW.vl_minimo_tributo,0) <> coalesce(OLD.vl_minimo_tributo,0)) then

		if (NEW.ie_acumulativo = 'S') and (NEW.vl_minimo = 0) and (NEW.vl_minimo_tributo = 0) then
			/*Este tributo é acmumulativo!
			Informe pelo menos R$ 0,01 em um dos valores mínimos ("Valor mínimo base" ou "Valor mínimo tributo").*/
			CALL wheb_mensagem_pck.exibir_mensagem_abort(266897);
		end if;
	end if;
end if;

-- esta trigger foi criada para alimentar os campos de data referencia, isto por questões de performance
-- para que não seja necessário utilizar um or is null nas rotinas que utilizam esta tabela
-- o campo inicial ref é alimentado com o valor informado no campo inicial ou se este for nulo é alimentado
-- com a data zero do oracle 31/12/1899, já o campo fim ref é alimentado com o campo fim ou se o mesmo for nulo
-- é alimentado com a data 31/12/3000 desta forma podemos utilizar um between ou fazer uma comparação com estes campos
-- sem precisar se preocupar se o campo vai estar nulo
NEW.dt_inicio_vigencia_ref := pls_util_pck.obter_dt_vigencia_null( NEW.dt_inicio_vigencia, 'I');
NEW.dt_fim_vigencia_ref := pls_util_pck.obter_dt_vigencia_null( NEW.dt_fim_vigencia, 'F');


RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_tributo_conta_pagar_atual() FROM PUBLIC;

CREATE TRIGGER tributo_conta_pagar_atual
	BEFORE INSERT OR UPDATE ON tributo_conta_pagar FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_tributo_conta_pagar_atual();
