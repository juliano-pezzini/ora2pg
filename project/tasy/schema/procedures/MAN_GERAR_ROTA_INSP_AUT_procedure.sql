-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_gerar_rota_insp_aut ( nm_usuario_p text) AS $body$
DECLARE


c01 CURSOR FOR
SELECT	a.nr_sequencia,
	a.cd_estabelecimento
from	man_plano_inspecao a
where	a.ie_situacao = 'A'
and	exists (select	1
		from	man_plano_insp_regra b
		where	b.nr_seq_plano_inspecao = a.nr_sequencia
		and	coalesce(b.dt_inicial,clock_timestamp()) - coalesce(b.qt_dias_geracao,0) <= clock_timestamp()
		and	coalesce(ie_dia_semana, pkg_date_utils.get_WeekDay(clock_timestamp())) = pkg_date_utils.get_WeekDay(clock_timestamp())
		)

union

/*Se não existir regra de tempo, gera sempre*/

select	a.nr_sequencia,
	a.cd_estabelecimento
from	man_plano_inspecao a
where	a.ie_situacao = 'A'
and	not exists (	select	1
			from	man_plano_insp_regra b
			where	b.nr_seq_plano_inspecao = a.nr_sequencia);


nr_seq_plano_w		bigint;
nr_seq_rota_w		bigint;
cd_estabelecimento_w	smallint;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_plano_w,
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	man_gerar_rota_inspecao(nr_seq_plano_w, nr_seq_rota_w, nm_usuario_p, cd_estabelecimento_w);
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_gerar_rota_insp_aut ( nm_usuario_p text) FROM PUBLIC;

