-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE delete_clinical_note_evo (cd_evolucao_p evolucao_paciente.cd_evolucao%type) AS $body$
BEGIN

if (cd_evolucao_p IS NOT NULL AND cd_evolucao_p::text <> '') then
delete from evolucao_paciente where cd_evolucao = cd_evolucao_p;
commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE delete_clinical_note_evo (cd_evolucao_p evolucao_paciente.cd_evolucao%type) FROM PUBLIC;

