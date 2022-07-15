-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_adicionar_epic_roadmap ( nr_art_p bigint, nr_epic_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text) AS $body$
BEGIN

insert into desenv_roadmap_epic(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	dt_inicial,
	dt_final,
	nr_art,
	nr_epic)
values (	nextval('desenv_roadmap_epic_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	dt_inicial_p,
	dt_final_p,
	nr_art_p,
	nr_epic_p);

insert into desenv_roadmap_feature(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_art,
	nr_feature,
	dt_inicial,
	dt_final)
SELECT	nextval('desenv_roadmap_feature_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_art_p,
	nr_sequencia,
	dt_inicial_p,
	dt_final_p
from	desenv_feature
where	nr_epic = nr_epic_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_adicionar_epic_roadmap ( nr_art_p bigint, nr_epic_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text) FROM PUBLIC;

