-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_conta_mat_monit_ins ON pls_conta_mat CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_conta_mat_monit_ins() RETURNS trigger AS $BODY$
declare

qt_reg_monit_w		integer;

BEGIN

if (coalesce(wheb_usuario_pck.get_ie_executar_trigger,'S') = 'S') and (NEW.ie_status <> 'M') then
	select	count(1)
	into STRICT	qt_reg_monit_w
	from	pls_monitor_tiss_guia
	where	nr_seq_conta = NEW.nr_seq_conta;

	if (qt_reg_monit_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(819672, 'CONTA=' || NEW.nr_seq_conta);
	end if;
end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_conta_mat_monit_ins() FROM PUBLIC;

CREATE TRIGGER pls_conta_mat_monit_ins
	BEFORE INSERT ON pls_conta_mat FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_conta_mat_monit_ins();
