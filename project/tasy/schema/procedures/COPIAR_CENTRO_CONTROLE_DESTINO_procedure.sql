-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_centro_controle_destino ( cd_estabelecimento_p bigint, cd_seq_criterio_origem_p bigint, cd_seq_criterio_destino_p bigint, nm_usuario_p text) AS $body$
DECLARE



cd_centro_controle_dest_w	integer;
qt_distribuicao_w		double precision;
pr_distribuicao_w		double precision;
cd_natureza_gasto_dest_w	numeric(20);
qt_peso_w		double precision;
nr_seq_ng_dest_w		bigint;
cd_estabelecimento_w		bigint;

c01 CURSOR FOR
SELECT	cd_estabelecimento,
	cd_centro_controle_dest,
	qt_distribuicao,
	pr_distribuicao,
	cd_natureza_gasto_dest,
	nr_seq_ng_dest,
	qt_peso
from 	criterio_distr_orc_dest
where 	cd_sequencia_criterio	= cd_seq_criterio_origem_p;


BEGIN

delete	from criterio_distr_orc_dest
where	cd_sequencia_criterio	= cd_seq_criterio_destino_p;

open c01;
loop
fetch c01 into
	cd_estabelecimento_w,
	cd_centro_controle_dest_w,
	qt_distribuicao_w,
	pr_distribuicao_w,
	cd_natureza_gasto_dest_w,
	nr_seq_ng_dest_w,
	qt_peso_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	insert into criterio_distr_orc_dest(
		cd_sequencia_criterio,
		cd_estabelecimento,
		cd_centro_controle_dest,
		qt_distribuicao,
		pr_distribuicao,
		cd_natureza_gasto_dest,
		nr_seq_ng_dest,
		dt_atualizacao,
		nm_usuario,
		qt_peso,
		dt_atualizacao_nrec,
		nm_usuario_nrec)
	values (cd_seq_criterio_destino_p,
		cd_estabelecimento_w,
		cd_centro_controle_dest_w,
		qt_distribuicao_w,
		pr_distribuicao_w,
		cd_natureza_gasto_dest_w,
		nr_seq_ng_dest_w,
		clock_timestamp(),
		nm_usuario_p,
		qt_peso_w,
		clock_timestamp(),
		nm_usuario_p);

	end;
end loop;
close c01;


commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_centro_controle_destino ( cd_estabelecimento_p bigint, cd_seq_criterio_origem_p bigint, cd_seq_criterio_destino_p bigint, nm_usuario_p text) FROM PUBLIC;
