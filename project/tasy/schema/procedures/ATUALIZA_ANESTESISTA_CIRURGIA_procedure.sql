-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_anestesista_cirurgia ( cd_medico_anestesista_p text, nr_sequencia_p bigint) AS $body$
BEGIN

update	pepo_cirurgia
set	cd_medico_anestesista 	= cd_medico_anestesista_p
where	nr_sequencia 		= nr_sequencia_p;

update	cirurgia
set	cd_medico_anestesista 	= cd_medico_anestesista_p
where	nr_seq_pepo 		= nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_anestesista_cirurgia ( cd_medico_anestesista_p text, nr_sequencia_p bigint) FROM PUBLIC;

