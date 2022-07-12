-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS protocolo_convenio_befinsert ON protocolo_convenio CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_protocolo_convenio_befinsert() RETURNS trigger AS $BODY$
declare
BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
/* Campo obrigatorio removido do DBPanel OS 2286124 */

NEW.nr_seq_lote_repasse := coalesce(NEW.nr_seq_lote_repasse,0);
end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_protocolo_convenio_befinsert() FROM PUBLIC;

CREATE TRIGGER protocolo_convenio_befinsert
	BEFORE INSERT ON protocolo_convenio FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_protocolo_convenio_befinsert();

