-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ctb_demo_mes_insert ON ctb_demo_mes CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ctb_demo_mes_insert() RETURNS trigger AS $BODY$
BEGIN

if (NEW.ie_valor in ('V','P')) and
	((NEW.nr_seq_col_1 is null) or (NEW.nr_seq_col_2 is null)) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(266557);
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ctb_demo_mes_insert() FROM PUBLIC;

CREATE TRIGGER ctb_demo_mes_insert
	BEFORE INSERT ON ctb_demo_mes FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ctb_demo_mes_insert();

