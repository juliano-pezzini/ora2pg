-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS regra_numeracao_dec_item_up ON regra_numeracao_dec_item CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_regra_numeracao_dec_item_up() RETURNS trigger AS $BODY$
declare

BEGIN
if	((OLD.IE_DISPONIVEL = 'S') or (OLD.IE_DISPONIVEL = 'N')) and (NEW.IE_DISPONIVEL = 'C')then
	NEW.dt_cancelamento := LOCALTIMESTAMP;
elsif (NEW.IE_DISPONIVEL <> 'C') then
	NEW.dt_cancelamento := null;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_regra_numeracao_dec_item_up() FROM PUBLIC;

CREATE TRIGGER regra_numeracao_dec_item_up
	BEFORE INSERT OR UPDATE ON regra_numeracao_dec_item FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_regra_numeracao_dec_item_up();
