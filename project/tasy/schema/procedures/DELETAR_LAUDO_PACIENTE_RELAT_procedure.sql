-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE deletar_laudo_paciente_relat ( nr_seq_laudo_p bigint) AS $body$
BEGIN

delete
from	laudo_paciente_relat
where	nr_seq_laudo = nr_seq_laudo_p;

commit;

END	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE deletar_laudo_paciente_relat ( nr_seq_laudo_p bigint) FROM PUBLIC;
