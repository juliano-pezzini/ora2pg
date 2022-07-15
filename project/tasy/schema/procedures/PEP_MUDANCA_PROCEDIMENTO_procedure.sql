-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pep_mudanca_procedimento ( ds_justificativa_p text, nr_seq_interno_p bigint) AS $body$
BEGIN
if (nr_seq_interno_p IS NOT NULL AND nr_seq_interno_p::text <> '') then 
	update 	sus_laudo_paciente 
	set 	ds_justificativa = ds_justificativa_p 
	where 	nr_seq_interno = nr_seq_interno_p;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pep_mudanca_procedimento ( ds_justificativa_p text, nr_seq_interno_p bigint) FROM PUBLIC;

