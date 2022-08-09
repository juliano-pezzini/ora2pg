-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_medico_laudo ( nm_usuario_p text, nr_seq_laudo_p bigint, cd_medico_p text) AS $body$
BEGIN


update	laudo_paciente
set	cd_medico_resp	=	cd_medico_p
where	nr_sequencia	=	nr_seq_laudo_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_medico_laudo ( nm_usuario_p text, nr_seq_laudo_p bigint, cd_medico_p text) FROM PUBLIC;
