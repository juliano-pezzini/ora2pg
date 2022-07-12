-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS tasy_log_acesso_atual ON tasy_log_acesso CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_tasy_log_acesso_atual() RETURNS trigger AS $BODY$
DECLARE
BEGIN
	NEW.DS_UTC_ATUALIZACAO := OBTER_DATA_UTC(LOCALTIMESTAMP,'HV');
	NEW.DS_UTC := OBTER_DATA_UTC(NEW.DT_ACESSO,'HV');
	NEW.IE_HORARIO_VERAO := OBTER_SE_HORARIO_VERAO(NEW.DT_ACESSO);
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_tasy_log_acesso_atual() FROM PUBLIC;

CREATE TRIGGER tasy_log_acesso_atual
	BEFORE INSERT OR UPDATE ON tasy_log_acesso FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_tasy_log_acesso_atual();

