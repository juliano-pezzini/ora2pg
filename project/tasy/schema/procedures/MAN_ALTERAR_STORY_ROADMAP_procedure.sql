-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_alterar_story_roadmap ( nr_story_p bigint, nr_art_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text) AS $body$
BEGIN

update	desenv_roadmap_story
set	dt_inicial = dt_inicial_p,
	dt_final = dt_final_p,
	dt_atualizacao = clock_timestamp(),
	nm_usuario = nm_usuario_p
where	nr_story = nr_story_p
and	nr_art = nr_art_p;
if (NOT FOUND) then
	insert into desenv_roadmap_story(
		dt_atualizacao,
		dt_atualizacao_nrec,
		dt_final,
		dt_inicial,
		nm_usuario,
		nm_usuario_nrec,
		nr_art,
		nr_story,
		nr_sequencia)
	values (	clock_timestamp(),
		clock_timestamp(),
		dt_final_p,
		dt_inicial_p,
		nm_usuario_p,
		nm_usuario_p,
		nr_art_p,
		nr_story_p,
		nextval('desenv_roadmap_story_seq'));
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_alterar_story_roadmap ( nr_story_p bigint, nr_art_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text) FROM PUBLIC;
