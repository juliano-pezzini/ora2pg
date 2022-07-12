-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS anexo_agenda_update ON anexo_agenda CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_anexo_agenda_update() RETURNS trigger AS $BODY$
declare

BEGIN

if (OLD.nr_seq_status <> NEW.nr_seq_status) or
	((coalesce(OLD.ds_observacao,'*') = coalesce(NEW.ds_observacao,'*')) and (OLD.nr_seq_status = NEW.nr_seq_status)) or
	(OLD.nr_seq_status is null AND NEW.nr_seq_status is not null) or
	(OLD.nr_seq_status is not null AND NEW.nr_seq_status is null) then

	insert into anexo_agenda_hist(
		nr_sequencia,
		nr_seq_anexo,
		nm_usuario,
		dt_atualizacao,
		nr_seq_status_ant,
		nr_seq_status_atual,
		ds_observacao,
		nm_usuario_nrec,
		dt_atualizacao_nrec)
	values (	nextval('anexo_agenda_hist_seq'),
		NEW.nr_sequencia,
		'tasy',
		LOCALTIMESTAMP,
		OLD.nr_seq_status,
		NEW.nr_seq_status,
		OLD.ds_observacao,
		NEW.nm_usuario,
		LOCALTIMESTAMP);
end if;


RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_anexo_agenda_update() FROM PUBLIC;

CREATE TRIGGER anexo_agenda_update
	BEFORE UPDATE ON anexo_agenda FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_anexo_agenda_update();

