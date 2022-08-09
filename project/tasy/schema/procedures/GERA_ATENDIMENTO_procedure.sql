-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gera_atendimento (nr_atendimento_p bigint, nr_seq_atendimento_p bigint) AS $body$
BEGIN

update 	paciente_atendimento
set 	nr_atendimento 		= nr_atendimento_p
where 	nr_seq_atendimento 	= nr_seq_atendimento_p;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gera_atendimento (nr_atendimento_p bigint, nr_seq_atendimento_p bigint) FROM PUBLIC;
