-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS lote_producao_update ON lote_producao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_lote_producao_update() RETURNS trigger AS $BODY$
declare

nr_sequencia_w 	bigint;

BEGIN
if (NEW.nr_seq_status is not null) and
	((OLD.nr_seq_status <> NEW.nr_seq_status) or (OLD.nr_seq_status is null)) then
	select	nextval('lote_producao_hist_status_seq')
	into STRICT	nr_sequencia_w
	;

	insert into lote_producao_hist_status(
		nr_sequencia,
		nr_seq_status,
		nr_lote_producao,
		dt_atualizacao,
		dt_alteracao,
		nm_usuario)
	values (
		nr_sequencia_w,
		NEW.nr_seq_status,
		OLD.nr_lote_producao,
		LOCALTIMESTAMP,
		LOCALTIMESTAMP,
		NEW.nm_usuario);

end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_lote_producao_update() FROM PUBLIC;

CREATE TRIGGER lote_producao_update
	BEFORE UPDATE ON lote_producao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_lote_producao_update();

