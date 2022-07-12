-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS caixa_saldo_diario_delete ON caixa_saldo_diario CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_caixa_saldo_diario_delete() RETURNS trigger AS $BODY$
DECLARE

qt_caixa_estrang_w	bigint := 0;

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
BEGIN
	select	count(*)
	into STRICT	qt_caixa_estrang_w
	from	caixa_saldo_estrang
	where	nr_seq_caixa_saldo = OLD.nr_sequencia;
	
	if (coalesce(qt_caixa_estrang_w,0) > 0) then
		delete from caixa_saldo_estrang
		where nr_seq_caixa_saldo = OLD.nr_sequencia;
	end if;
end;
end if;

RETURN OLD;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_caixa_saldo_diario_delete() FROM PUBLIC;

CREATE TRIGGER caixa_saldo_diario_delete
	BEFORE DELETE ON caixa_saldo_diario FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_caixa_saldo_diario_delete();

