-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_gerar_relat_ordem_serv_dia ( dt_mesano_referencia_p timestamp, nr_grupo_trabalho_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_dia_w			timestamp;
dt_mesano_referencia_w	timestamp;
qt_ordem_serv_w		bigint := 0;
qt_ordem_encerrada_w	bigint := 0;
qt_ordem_aberta_w		bigint := 0;
nr_grupo_trabalho_w	bigint;

/*
Procedure utilizada de base no relatório CMAN391 - Ordens de serviço diárias
*/
c01 CURSOR FOR
SELECT	dt_dia
from	dia_v
where	trunc(dt_dia,'mm') = dt_mesano_referencia_w
order by 1;

c02 CURSOR FOR
SELECT	nr_sequencia
from	man_grupo_trabalho
where	ie_situacao = 'A'
and (nr_sequencia = coalesce(nr_grupo_trabalho_p,0) or coalesce(nr_grupo_trabalho_p,0) = 0);



BEGIN
dt_mesano_referencia_w	:= trunc(dt_mesano_referencia_p,'mm');

delete from w_man_relat_os_diaria
where trunc(dt_dia,'mm') = dt_mesano_referencia_w;

open C01;
loop
fetch C01 into
	dt_dia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	open C02;
	loop
	fetch C02 into
		nr_grupo_trabalho_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		select	count(*)
		into STRICT	qt_ordem_serv_w
		from	man_ordem_servico
		where	trunc(dt_ordem_servico,'dd') 	= dt_dia_w
		and	nr_grupo_trabalho		= nr_grupo_trabalho_w
		and	coalesce(dt_fim_real::text, '') = '';

		select	count(*)
		into STRICT	qt_ordem_encerrada_w
		from	man_ordem_servico
		where	trunc(dt_fim_real,'dd') 	= dt_dia_w
		and	nr_grupo_trabalho		= nr_grupo_trabalho_w;

		select	count(*)
		into STRICT	qt_ordem_aberta_w
		from	man_ordem_servico
		where	trunc(dt_ordem_servico,'dd') 	= dt_dia_w
		and	nr_grupo_trabalho		= nr_grupo_trabalho_w;

		insert into w_man_relat_os_diaria(
					nr_sequencia,
					nm_usuario,
					dt_atualizacao,
					nm_usuario_nrec,
					dt_atualizacao_nrec,
					dt_dia,
					nr_grupo_trabalho,
					qt_encerrada,
					qt_aberta,
					ie_dia_semana)
				values (	nextval('w_man_relat_os_diaria_seq'),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					dt_dia_w,
					nr_grupo_trabalho_w,
					qt_ordem_encerrada_w,
					qt_ordem_aberta_w,
					CASE WHEN pkg_date_utils.IS_BUSINESS_DAY(clock_timestamp())=0 THEN 'N'  ELSE 'S' END );
		end;
	end loop;
	close C02;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_gerar_relat_ordem_serv_dia ( dt_mesano_referencia_p timestamp, nr_grupo_trabalho_p bigint, nm_usuario_p text) FROM PUBLIC;
