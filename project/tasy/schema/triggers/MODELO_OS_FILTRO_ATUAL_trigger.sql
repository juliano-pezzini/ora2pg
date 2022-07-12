-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS modelo_os_filtro_atual ON modelo_os_filtro CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_modelo_os_filtro_atual() RETURNS trigger AS $BODY$
declare

BEGIN

update	modelo_os
set	dt_atualizacao = LOCALTIMESTAMP,
	nm_usuario = NEW.nm_usuario
where	nr_sequencia = NEW.nr_seq_modelo_os;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_modelo_os_filtro_atual() FROM PUBLIC;

CREATE TRIGGER modelo_os_filtro_atual
	BEFORE INSERT OR UPDATE ON modelo_os_filtro FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_modelo_os_filtro_atual();

