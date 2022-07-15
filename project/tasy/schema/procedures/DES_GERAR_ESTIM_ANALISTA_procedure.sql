-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE des_gerar_estim_analista ( dt_referencia_p timestamp, pr_padrao_prev_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_cliente_teste_w			timestamp;
dt_inicial_w			timestamp;
dt_final_w			timestamp;
ie_gerar_w			varchar(01);
nm_usuario_analista_w		varchar(15);
nm_usuario_delegacao_w		varchar(15);
nr_seq_gerencia_w			bigint;
nr_seq_grupo_des_w		bigint;
nr_sequencia_w			bigint;
qt_min_prev_w			double precision;
qt_min_real_w			double precision;
qt_min_prog_w			double precision;
qt_min_analise_w			double precision;
qt_min_teste_w			double precision;
qt_prev_faixa_w			bigint;
qt_prev_total_w			bigint;
qt_total_min_prev_w		double precision;
qt_total_min_real_w			double precision;
qt_total_min_prog_w		double precision;
qt_total_min_analise_w		double precision;
qt_total_min_teste_w		double precision;
pr_acerto_prev_w		double precision;
pr_acerto_tempo_w		double precision;
pr_padrao_prev_w		double precision;

nr_Seq_prev_W			double precision;


c00 CURSOR FOR
SELECT distinct nr_Sequencia, nr_Seq_Gerencia, nm_usuario_grupo
from (
	SELECT	a.nr_sequencia,
		a.nr_seq_gerencia,
		b.nm_usuario_grupo
	from	grupo_desenvolvimento a,
		usuario_grupo_des b
	where	a.nr_sequencia = b.nr_seq_grupo
	and	b.ie_funcao_usuario = 'S'
	and	a.ie_situacao	= 'A'
	
union

	select	a.nr_sequencia,
		a.nr_seq_gerencia,
		b.nm_usuario_delegacao
	from	grupo_desenvolvimento a,
		grupo_des_delegacao b
	where	a.ie_situacao	= 'A'
	and	a.nr_Sequencia = b.nr_Seq_grupo_des
) alias0;


C01 CURSOR FOR
SELECT	a.nr_sequencia
from	man_ordem_servico a
where	a.nr_seq_grupo_des	= nr_seq_grupo_des_w
and	exists (	select	1
		from	man_ordem_serv_estagio y
		where	a.nr_sequencia	= y.nr_seq_ordem
		and	y.dt_atualizacao between dt_inicial_w and dt_final_w
		and	y.nr_seq_estagio(2,1511,791,9,41));

c02 CURSOR FOR
SELECT	a.qt_min_prev,
	a.nr_sequencia
from	man_ordem_ativ_prev a
where	a.nr_seq_ordem_serv	= nr_sequencia_w
and		a.nm_usuario_nrec	= nm_usuario_analista_w
and		a.DT_PREVISTA between dt_inicial_w and dt_final_w
and	exists (	select	1
		from	usuario_grupo_des y
		where	y.nr_seq_grupo		= nr_seq_grupo_des_w
		and	y.nm_usuario_grupo	= a.nm_usuario_prev);



BEGIN

dt_inicial_w		:= trunc(dt_referencia_p,'mm');
dt_final_w		:= fim_mes(dt_inicial_w);
pr_padrao_prev_w	:= coalesce(pr_padrao_prev_p, 10);

delete	from des_ind_estim_analista
where	dt_referencia	= dt_referencia_p
and	nm_usuario	= nm_usuario_p;

open C00;
loop
fetch C00 into
	nr_seq_grupo_des_w,
	nr_seq_gerencia_w,
	nm_usuario_analista_w;
EXIT WHEN NOT FOUND; /* apply on C00 */
	begin

	ie_gerar_w		:= 'N';
	qt_prev_faixa_w		:= 0;
	qt_prev_total_w		:= 0;
	qt_total_min_prev_w	:= 0;
	qt_total_min_real_w	:= 0;
	qt_total_min_prog_w	:= 0;
	qt_total_min_analise_w	:= 0;
	qt_total_min_teste_w	:= 0;

	open C01;
	loop
	fetch C01 into
		nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		select	max(dt_atualizacao)
		into STRICT	dt_cliente_teste_w
		from	man_ordem_serv_estagio a
		where	a.nr_seq_estagio	in (2,1511,791,9,41)
		and	a.nr_seq_ordem		= nr_sequencia_w;

		if (dt_cliente_teste_w >= dt_inicial_w) and (dt_cliente_teste_w <= dt_final_w) then

			if (ie_gerar_w = 'N') then
				ie_gerar_w	:= 'S';
			end if;

			open C02;
			loop
			fetch C02 into
				qt_min_prev_w,
				nr_seq_prev_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
			begin

			qt_total_min_prev_w	:= qt_total_min_prev_w + qt_min_prev_w;

			select	coalesce(sum(a.qt_minuto),0)
			into STRICT	qt_min_real_w
			from	man_ordem_serv_ativ a
			where	a.nr_seq_ordem_serv	= nr_sequencia_w
			and	a.nr_Seq_ativ_prev	= nr_Seq_prev_w
			and	exists (	SELECT	1
					from	usuario_grupo_des y
					where	y.nr_seq_grupo		= nr_seq_grupo_des_w
					and	y.nm_usuario_grupo	= a.nm_usuario_exec);

			qt_total_min_real_w	:= qt_total_min_real_w + qt_min_real_w;

			pr_acerto_tempo_w	:= ((dividir(qt_min_real_w, qt_min_prev_w) -1)* 100);

			if (abs(pr_acerto_tempo_w) <= pr_padrao_prev_w) then
				qt_prev_faixa_w	:= qt_prev_faixa_w + 1;
			end if;

			qt_prev_total_w	:= qt_prev_total_w + 1;

			end;
			end loop;
			close C02;

			/* Tempo de análise */

			select	coalesce(sum(a.qt_minuto),0)
			into STRICT	qt_min_analise_w
			from	man_ordem_serv_ativ a
			where	a.nr_seq_ordem_serv	= nr_sequencia_w
			and		a.DT_ATIVIDADE    between dt_inicial_w and dt_final_w
			and		a.nm_usuario_exec	= nm_usuario_analista_w
			and		a.nr_seq_funcao		in (31,332)
			and		a.nm_usuario_exec = nm_usuario_analista_w;

			/* Programação */

			select	coalesce(sum(a.qt_minuto),0)
			into STRICT	qt_min_prog_w
			from	man_ordem_serv_ativ a
			where	a.nr_seq_ordem_serv	= nr_sequencia_w
			and		a.DT_ATIVIDADE    between dt_inicial_w and dt_final_w
			and		a.nr_seq_funcao		in (11,441)
			and		a.nm_usuario_exec = nm_usuario_analista_w;

			/* Testes */

			select	coalesce(sum(a.qt_minuto),0)
			into STRICT	qt_min_teste_w
			from	man_ordem_serv_ativ a
			where	a.nr_seq_ordem_serv	= nr_sequencia_w
			and		a.DT_ATIVIDADE    between dt_inicial_w and dt_final_w
			and		a.nr_seq_funcao		= 132
			and		a.nm_usuario_exec = nm_usuario_analista_w;

			qt_total_min_analise_w	:= qt_total_min_analise_w + qt_min_analise_w;
			qt_total_min_prog_w	:= qt_total_min_prog_w    + qt_min_prog_w;
			qt_total_min_teste_w	:= qt_total_min_teste_w   + qt_min_teste_w;

		end if;

		end;
	end loop;
	close C01;

	if (ie_gerar_w = 'S') then
		begin
		pr_acerto_prev_w	:= (dividir(qt_prev_faixa_w, qt_prev_total_w) * 100);

		if (qt_total_min_prev_w = 0) then
			pr_acerto_tempo_w	:= 0;
		else
			pr_acerto_tempo_w	:= (dividir(qt_total_min_prev_w, qt_total_min_Real_w)* 100);
		end if;

		insert into des_ind_estim_analista(
			nr_sequencia,
			nm_usuario,
			dt_atualizacao,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			dt_referencia,
			nm_usuario_exec,
			nr_seq_gerencia,
			qt_os_total,
			qt_min_prev,
			qt_min_real,
			qt_os_faixa,
			qt_min_prog,
			qt_min_analise,
			qt_min_teste,
			pr_acerto_os,
			pr_acerto_tempo)
		values (	nextval('des_ind_estim_analista_seq'),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			dt_referencia_p,
			nm_usuario_analista_w,
			nr_seq_gerencia_w,
			qt_prev_total_w,
			qt_total_min_prev_w,
			qt_total_min_real_w,
			qt_prev_faixa_w,
			qt_total_min_prog_w,
			qt_total_min_analise_w,
			qt_total_min_teste_w,
			pr_acerto_prev_w,
			pr_acerto_tempo_w);
		end;
	end if;

	end;
end loop;
close C00;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE des_gerar_estim_analista ( dt_referencia_p timestamp, pr_padrao_prev_p bigint, nm_usuario_p text) FROM PUBLIC;

