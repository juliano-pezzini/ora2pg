-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS banco_saldo_atual ON banco_saldo CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_banco_saldo_atual() RETURNS trigger AS $BODY$
declare

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger	= 'S')  then

	if (NEW.dt_referencia <> OLD.dt_referencia) and (NEW.DT_REFERENCIA < to_date('01/01/1980','dd/mm/yyyy')) then
		/* Nao e possivel gerar um saldo com data de :new.DT_REFERENCIA */


		CALL wheb_mensagem_pck.exibir_mensagem_abort(262162,'DT_REFERENCIA_W='||to_char(NEW.DT_REFERENCIA, 'dd/mm/yyyy'));
	end if;

	if (TG_OP = 'INSERT') then
		NEW.DS_STACK := substr('CallStack Insert: ' || substr(dbms_utility.format_call_stack,1,3980),1,4000);
	end if;
	
	NEW.dt_referencia := trunc(NEW.dt_referencia, 'dd');
	
end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_banco_saldo_atual() FROM PUBLIC;

CREATE TRIGGER banco_saldo_atual
	BEFORE INSERT OR UPDATE ON banco_saldo FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_banco_saldo_atual();
