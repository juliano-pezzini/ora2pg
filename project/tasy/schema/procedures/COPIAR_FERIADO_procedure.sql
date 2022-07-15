-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_feriado ( cd_estabelecimento_p bigint, dt_ano_ant_p timestamp, dt_ano_gerar_p timestamp, nm_usuario_p text) AS $body$
DECLARE


dt_ano_w	varchar(2);


C01 CURSOR FOR
SELECT	cd_estabelecimento_p,
	to_date(to_char(a.dt_feriado,'dd/mm') || '/' || to_char(dt_ano_gerar_p,'yyyy'),'dd/mm/yyyy') dt_feriado,
	a.ds_motivo_feriado,
	a.ie_tipo_feriado
from	feriado a
where	a.cd_estabelecimento	= cd_estabelecimento_p
and	trunc(a.dt_feriado,'yyyy') = trunc(dt_ano_ant_p,'yyyy')
and	not exists (	select	1
		from	feriado y
		where	a.cd_estabelecimento	= y.cd_estabelecimento
		and	y.dt_feriado		= to_date(to_char(a.dt_feriado,'dd/mm') || '/' || to_char(dt_ano_gerar_p,'yyyy'),'dd/mm/yyyy'));

vet01	C01%RowType;


BEGIN

open C01;
loop
fetch C01 into
	vet01;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	insert into feriado(
		cd_estabelecimento,
		dt_feriado,
		ds_motivo_feriado,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_tipo_feriado)
	values (cd_estabelecimento_p,
		vet01.dt_feriado,
		vet01.ds_motivo_feriado,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		vet01.ie_tipo_feriado);

	end;

end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_feriado ( cd_estabelecimento_p bigint, dt_ano_ant_p timestamp, dt_ano_gerar_p timestamp, nm_usuario_p text) FROM PUBLIC;

