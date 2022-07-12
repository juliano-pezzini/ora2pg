-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS banco_extrato_lanc_delete ON banco_extrato_lanc CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_banco_extrato_lanc_delete() RETURNS trigger AS $BODY$
declare

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
if (OLD.nr_seq_concil is not null) or (OLD.ie_conciliacao = 'S') then
	-- Este extrato ja esta conciliado!

	CALL wheb_mensagem_pck.exibir_mensagem_abort(266906);
end if;
end if;

RETURN OLD;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_banco_extrato_lanc_delete() FROM PUBLIC;

CREATE TRIGGER banco_extrato_lanc_delete
	BEFORE DELETE ON banco_extrato_lanc FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_banco_extrato_lanc_delete();

