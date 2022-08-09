-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cus_copiar_base_criterio ( cd_estabelecimento_p bigint, cd_sequencia_criterio_p bigint, nr_seq_criterio_ref_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_centro_controle_w				integer;
qt_base_distribuicao_w			double precision;
qt_distribuicao_w				double precision;

/* centros do criterio ref que estão informados no criterio de abrangência */

c01 CURSOR FOR
SELECT	a.cd_centro_controle_dest,
	coalesce(a.qt_distribuicao,0)
from	criterio_distr_orc_dest a
where	a.cd_estabelecimento	= cd_estabelecimento_p
and	a.cd_sequencia_criterio	= nr_seq_criterio_ref_p
and	a.cd_centro_controle_dest in (	select	x.cd_centro_controle_dest
						from	criterio_distr_orc_dest x
						where	x.cd_estabelecimento = a.cd_estabelecimento
						and	x.cd_sequencia_criterio = cd_sequencia_criterio_p);

BEGIN

qt_base_distribuicao_w	:= 0;

open c01;
loop
fetch c01 into
	cd_centro_controle_w,
	qt_distribuicao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	/* Somar quantidade a distribuir*/

	qt_base_distribuicao_w	:= qt_base_distribuicao_w + qt_distribuicao_w;

	update	criterio_distr_orc_dest
	set	qt_distribuicao		= qt_distribuicao_w
	where	cd_estabelecimento		= cd_estabelecimento_p
	and	cd_sequencia_criterio	= cd_sequencia_criterio_p
	and	cd_centro_controle_dest	= cd_centro_controle_w;
end loop;
close c01;

/* Atualizar a base do crit referencia com a soma da quantidade escolhida*/

update	criterio_distr_orc
set	qt_base_distribuicao		= qt_base_distribuicao_w,
	nm_usuario			= nm_usuario_p,
	dt_atualizacao		= clock_timestamp()
where	cd_estabelecimento		= cd_estabelecimento_p
and	cd_sequencia_criterio	= cd_sequencia_criterio_p;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cus_copiar_base_criterio ( cd_estabelecimento_p bigint, cd_sequencia_criterio_p bigint, nr_seq_criterio_ref_p bigint, nm_usuario_p text) FROM PUBLIC;
