-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS com_cliente_hist_update ON com_cliente_hist CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_com_cliente_hist_update() RETURNS trigger AS $BODY$
declare

qt_registros_w	bigint;

BEGIN
/* Trigger desabilitada
if	(:old.dt_liberacao is not null) and
	(:new.dt_liberacao is not null) then
	begin
	WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(277336);
	end;
end if;		*/
qt_registros_w := 0;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_com_cliente_hist_update() FROM PUBLIC;

CREATE TRIGGER com_cliente_hist_update
	BEFORE UPDATE ON com_cliente_hist FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_com_cliente_hist_update();

