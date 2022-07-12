-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS equipe_lista_espera_insbefore ON equipe_lista_espera CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_equipe_lista_espera_insbefore() RETURNS trigger AS $BODY$
declare
nr_seq_equipe_cpoe_w	cpoe_equipe_cirurgia.nr_seq_equipe%type;
pragma autonomous_transaction;
BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
	select 	max(a.nr_seq_equipe)
	into STRICT	nr_seq_equipe_cpoe_w
	from 	cpoe_equipe_cirurgia a,
			agenda_lista_espera b,
			equipe_lista_espera c
	where 	a.nr_seq_proc_cpoe = b.nr_seq_cpoe_procedimento
	and		c.nr_seq_lista_espera = b.nr_sequencia
	and		c.nr_seq_lista_espera = NEW.nr_seq_lista_espera;
end if;

if (nr_seq_equipe_cpoe_w is not null) then
	NEW.nr_seq_equipe_cpoe := nr_seq_equipe_cpoe_w;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_equipe_lista_espera_insbefore() FROM PUBLIC;

CREATE TRIGGER equipe_lista_espera_insbefore
	BEFORE INSERT ON equipe_lista_espera FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_equipe_lista_espera_insbefore();

