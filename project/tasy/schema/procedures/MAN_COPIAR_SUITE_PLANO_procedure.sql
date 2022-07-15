-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_copiar_suite_plano ( nr_art_p bigint, nr_release_p bigint, nr_sprint_p bigint, nr_feature_p bigint, nr_epic_p bigint, nr_story_p bigint, nr_time_p bigint, nr_plano_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_suite_w	desenv_suite_teste.nr_sequencia%type;

c01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.ds_objetivo,
		a.ds_premissa,
		a.nm_suite
	from	desenv_suite_teste a,
		desenv_story b,
		desenv_story_sprint c,
		desenv_sprint d,
		desenv_release e,
		desenv_art f,
		desenv_feature g,
		desenv_epic h
	where	a.nr_story = b.nr_sequencia
	and	b.nr_sequencia = c.nr_story
	and	c.nr_sprint = d.nr_sequencia
	and	d.nr_release = e.nr_sequencia
	and	e.nr_art = f.nr_sequencia
	and	b.nr_feature = g.nr_sequencia
	and	g.nr_epic = h.nr_sequencia
	and	((coalesce(nr_art_p::text, '') = '') or (f.nr_sequencia = nr_art_p))
	and	((coalesce(nr_release_p::text, '') = '') or (e.nr_sequencia = nr_release_p))
	and	((coalesce(nr_sprint_p::text, '') = '') or (d.nr_sequencia = nr_sprint_p))
	and	((coalesce(nr_feature_p::text, '') = '') or (g.nr_sequencia = nr_feature_p))
	and	((coalesce(nr_epic_p::text, '') = '') or (h.nr_sequencia = nr_epic_p))
	and	((coalesce(nr_story_p::text, '') = '') or (b.nr_sequencia = nr_story_p))
	and	((coalesce(nr_time_p::text, '') = '') or (b.nr_team = nr_time_p))
	group by a.nr_sequencia,
		a.ds_objetivo,
		a.ds_premissa,
		a.nm_suite;

v_01	c01%rowtype;


BEGIN

open c01;
loop
fetch c01 into
	v_01;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select	nextval('desenv_suite_teste_seq')
	into STRICT	nr_suite_w
	;

	insert into desenv_suite_teste(
		ds_objetivo,
		ds_premissa,
		dt_atualizacao,
		dt_atualizacao_nrec,
		nm_suite,
		nm_usuario,
		nm_usuario_nrec,
		nr_plano,
		nr_sequencia)
	values (	v_01.ds_objetivo,
		v_01.ds_premissa,
		clock_timestamp(),
		clock_timestamp(),
		v_01.nm_suite,
		nm_usuario_p,
		nm_usuario_p,
		nr_plano_p,
		nr_suite_w);

	insert into desenv_caso_teste(
		ds_acao,
		ds_observacao,
		ds_resultado,
		dt_atualizacao,
		dt_atualizacao_nrec,
		ie_resultado,
		nm_usuario,
		nm_usuario_nrec,
		nr_ordem,
		nr_sequencia,
		nr_suite)
	SELECT	ds_acao,
		ds_observacao,
		ds_resultado,
		clock_timestamp(),
		clock_timestamp(),
		ie_resultado,
		nm_usuario_p,
		nm_usuario_p,
		nr_ordem,
		nextval('desenv_caso_teste_seq'),
		nr_suite_w
	from	desenv_caso_teste
	where	nr_suite = v_01.nr_sequencia;

	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_copiar_suite_plano ( nr_art_p bigint, nr_release_p bigint, nr_sprint_p bigint, nr_feature_p bigint, nr_epic_p bigint, nr_story_p bigint, nr_time_p bigint, nr_plano_p bigint, nm_usuario_p text) FROM PUBLIC;

