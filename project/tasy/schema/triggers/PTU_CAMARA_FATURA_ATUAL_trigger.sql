-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ptu_camara_fatura_atual ON ptu_camara_fatura CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ptu_camara_fatura_atual() RETURNS trigger AS $BODY$
declare

qt_registro_w	integer;

BEGIN
if (NEW.nr_fatura is not null) then
	select	count(1)
	into STRICT	qt_registro_w
	from	titulo_receber
	where	nr_titulo = NEW.nr_fatura;

	if (qt_registro_w = 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1013976);
	end if;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ptu_camara_fatura_atual() FROM PUBLIC;

CREATE TRIGGER ptu_camara_fatura_atual
	BEFORE INSERT OR UPDATE ON ptu_camara_fatura FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ptu_camara_fatura_atual();
