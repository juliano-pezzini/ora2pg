-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_dados_agepac_colunas ( cd_agenda_p bigint, nr_height_p bigint, nr_width_p bigint, nm_usuario_p text) AS $body$
BEGIN

delete	FROM agepac_colunas_temp
where	nm_usuario_coluna	= nm_usuario_p
and	cd_agenda		= cd_agenda_p;

insert into agepac_colunas_temp(cd_agenda,
		nm_usuario_coluna,
		nr_height,
		nr_width,
		nm_usuario,
		dt_atualizacao)
	values (cd_agenda_p,
		nm_usuario_p,
		nr_height_p,
		nr_width_p,
		nm_usuario_p,
		clock_timestamp());

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_dados_agepac_colunas ( cd_agenda_p bigint, nr_height_p bigint, nr_width_p bigint, nm_usuario_p text) FROM PUBLIC;
