-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS agenda_paciente_envio_pesquisa ON agenda_paciente_envio CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_agenda_paciente_envio_pesquisa() RETURNS trigger AS $BODY$
declare
 
BEGIN 
 
if (NEW.nm_paciente_pesquisa is null) and (NEW.nr_seq_agenda is not null) then 
	NEW.nm_paciente_pesquisa := Elimina_Acentuacao(UPPER(obter_nome_paciente_agenda(NEW.nr_seq_agenda)));
end if;
 
 
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_agenda_paciente_envio_pesquisa() FROM PUBLIC;

CREATE TRIGGER agenda_paciente_envio_pesquisa
	BEFORE INSERT OR UPDATE ON agenda_paciente_envio FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_agenda_paciente_envio_pesquisa();
