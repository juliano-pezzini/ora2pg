-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS fila_visualizacao_senha_update ON fila_visualizacao_senha CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_fila_visualizacao_senha_update() RETURNS trigger AS $BODY$
BEGIN

if (OLD.ie_situacao = 'A' AND NEW.ie_situacao = 'I') then
	CALL limpar_fila_visualizacao_senha(NEW.nr_seq_monitor, NEW.nr_seq_pac_senha_fila, NEW.nr_sequencia);
end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_fila_visualizacao_senha_update() FROM PUBLIC;

CREATE TRIGGER fila_visualizacao_senha_update
	BEFORE UPDATE ON fila_visualizacao_senha FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_fila_visualizacao_senha_update();
