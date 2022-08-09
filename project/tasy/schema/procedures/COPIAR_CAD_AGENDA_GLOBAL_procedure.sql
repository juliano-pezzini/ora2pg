-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_cad_agenda_global ( cd_agenda_origem_p bigint, cd_agenda_destino_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert into agenda_global(	nr_sequencia,
	cd_agenda,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	cd_area_proc,
	cd_especialidade,
	cd_grupo_proc,
	cd_procedimento,
	ie_origem_proced,
	nr_seq_proc_interno,
	hr_inicio,
	hr_final,
	nr_seq_classif)
SELECT	nextval('agenda_global_seq'),
	cd_agenda_destino_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	cd_area_proc,
	cd_especialidade,
	cd_grupo_proc,
	cd_procedimento,
	ie_origem_proced,
	nr_seq_proc_interno,
	hr_inicio,
	hr_final,
	nr_seq_classif
from	agenda_global
where	cd_agenda = cd_agenda_origem_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_cad_agenda_global ( cd_agenda_origem_p bigint, cd_agenda_destino_p bigint, nm_usuario_p text) FROM PUBLIC;
