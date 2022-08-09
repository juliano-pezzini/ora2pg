-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ins_atencao_paciente_painel ( nr_seq_agenda_p bigint) AS $body$
BEGIN


if (nr_seq_agenda_p >  0) THEN
	UPDATE	agenda_paciente
	SET 	ie_atencao = 'S'
	WHERE 	nr_sequencia = nr_seq_agenda_p;

END IF;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ins_atencao_paciente_painel ( nr_seq_agenda_p bigint) FROM PUBLIC;
