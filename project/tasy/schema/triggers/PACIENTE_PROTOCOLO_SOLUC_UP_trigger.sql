-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS paciente_protocolo_soluc_up ON paciente_protocolo_soluc CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_paciente_protocolo_soluc_up() RETURNS trigger AS $BODY$
declare

BEGIN

if (coalesce(NEW.pr_reducao,0) <> coalesce(OLD.pr_reducao,0)) then
	update	PACIENTE_PROTOCOLO_MEDIC
	set	pr_reducao = NEW.pr_reducao
	where	nr_seq_paciente = NEW.nr_seq_paciente
	and	nr_seq_solucao = NEW.NR_SEQ_SOLUCAO;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_paciente_protocolo_soluc_up() FROM PUBLIC;

CREATE TRIGGER paciente_protocolo_soluc_up
	BEFORE UPDATE ON paciente_protocolo_soluc FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_paciente_protocolo_soluc_up();
