-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS perda_contas_receber_bf ON perda_contas_receber CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_perda_contas_receber_bf() RETURNS trigger AS $BODY$
declare

BEGIN

if coalesce(OLD.IE_TIPO_PERDA,'X') <> coalesce(NEW.IE_TIPO_PERDA,'X') then
	CALL gravar_log_perdas(NEW.nr_sequencia,1,NEW.nm_usuario,OLD.IE_TIPO_PERDA,NEW.IE_TIPO_PERDA);
end if;


if coalesce(OLD.NR_SEQ_MOTIVO_PERDA,-1) <> coalesce(NEW.NR_SEQ_MOTIVO_PERDA,-1) then
	CALL gravar_log_perdas(NEW.nr_sequencia,2,NEW.nm_usuario,OLD.NR_SEQ_MOTIVO_PERDA,NEW.NR_SEQ_MOTIVO_PERDA);
end if;


RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_perda_contas_receber_bf() FROM PUBLIC;

CREATE TRIGGER perda_contas_receber_bf
	BEFORE UPDATE ON perda_contas_receber FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_perda_contas_receber_bf();
