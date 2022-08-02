-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_exclui_anexo_laudo ( nr_seq_laudo_p sus_laudo_paciente_anexo.nr_seq_laudo%type) AS $body$
BEGIN

delete FROM sus_laudo_paciente_anexo
where nr_seq_laudo = nr_seq_laudo_p;

commit;			

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_exclui_anexo_laudo ( nr_seq_laudo_p sus_laudo_paciente_anexo.nr_seq_laudo%type) FROM PUBLIC;

