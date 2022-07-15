-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_alterar_feature_roadmap ( nr_feature_p bigint, nr_art_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text) AS $body$
BEGIN

update	desenv_roadmap_feature
set	dt_inicial = dt_inicial_p,
	dt_final = dt_final_p,
	dt_atualizacao = clock_timestamp(),
	nm_usuario = nm_usuario_p
where	nr_feature = nr_feature_p
and	nr_art = nr_art_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_alterar_feature_roadmap ( nr_feature_p bigint, nr_art_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text) FROM PUBLIC;

