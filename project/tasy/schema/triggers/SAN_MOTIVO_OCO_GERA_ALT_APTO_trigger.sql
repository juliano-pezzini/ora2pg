-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS san_motivo_oco_gera_alt_apto ON san_motivo_ocorrencia CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_san_motivo_oco_gera_alt_apto() RETURNS trigger AS $BODY$
declare
pragma autonomous_transaction;

BEGIN

if (NEW.ie_gera_alt_apto = 'S') then
	update	san_motivo_ocorrencia
	set	ie_gera_alt_apto = 'N'
	where	nr_sequencia <> NEW.nr_sequencia;
end if;

commit;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_san_motivo_oco_gera_alt_apto() FROM PUBLIC;

CREATE TRIGGER san_motivo_oco_gera_alt_apto
	AFTER INSERT OR UPDATE ON san_motivo_ocorrencia FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_san_motivo_oco_gera_alt_apto();
