-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS cheque_insert ON cheque CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_cheque_insert() RETURNS trigger AS $BODY$
declare

ie_dia_fechado_w		varchar(1);
nr_seq_banco_saldo_w	bigint;

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
if (coalesce(NEW.nr_seq_conta_banco,0) > 0) then

	select	max(nr_sequencia)
	into STRICT	nr_seq_banco_saldo_w
	from	banco_saldo
	where	nr_seq_conta			= NEW.nr_seq_conta_banco
	and	trunc(dt_referencia, 'month')	= trunc(NEW.dt_emissao, 'month')
	and	dt_fechamento			is not null;
	
	if (nr_seq_banco_saldo_w is not null) then
		/* O mes de referencia desta transacao ja tem saldo bancario fechado! */


		CALL wheb_mensagem_pck.exibir_mensagem_abort(207890);
	end if;	


	select	substr(obter_se_banco_fechado(NEW.nr_seq_conta_banco,NEW.dt_emissao),1,1)
	into STRICT	ie_dia_fechado_w
	;

	if (coalesce(ie_dia_fechado_w,'N')	= 'S') then
		/* O dia dt_transacao ja foi fechado no banco!
		Consulte o fechamento na pasta Fechamento banco do Controle Bancario.
		Parametro [72] */

		CALL wheb_mensagem_pck.exibir_mensagem_abort(231442,'DT_TRANSACAO='||NEW.dt_emissao);
	end if;
end if;

end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_cheque_insert() FROM PUBLIC;

CREATE TRIGGER cheque_insert
	BEFORE INSERT ON cheque FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_cheque_insert();
