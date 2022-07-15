-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cus_zerar_base_distrib ( cd_estabelecimento_p bigint, cd_sequencia_criterio_p bigint, nm_usuario_p text) AS $body$
BEGIN

update	criterio_distr_orc_dest
set	pr_distribuicao		= 0,
	qt_distribuicao		= 0,
	dt_atualizacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p
where	cd_sequencia_criterio	= cd_sequencia_criterio_p;

update	criterio_distr_orc
set	qt_base_distribuicao	= 0,
	dt_atualizacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p
where	cd_sequencia_criterio 	= cd_sequencia_criterio_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cus_zerar_base_distrib ( cd_estabelecimento_p bigint, cd_sequencia_criterio_p bigint, nm_usuario_p text) FROM PUBLIC;

