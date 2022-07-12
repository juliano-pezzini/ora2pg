-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS gpi_cron_etapa_coment_delete ON gpi_cron_etapa_coment CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_gpi_cron_etapa_coment_delete() RETURNS trigger AS $BODY$
BEGIN
if (OLD.dt_liberacao is not null) then
	--Não é possível excluir um registro liberado!
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(308361);
end if;

RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_gpi_cron_etapa_coment_delete() FROM PUBLIC;

CREATE TRIGGER gpi_cron_etapa_coment_delete
	BEFORE DELETE ON gpi_cron_etapa_coment FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_gpi_cron_etapa_coment_delete();
