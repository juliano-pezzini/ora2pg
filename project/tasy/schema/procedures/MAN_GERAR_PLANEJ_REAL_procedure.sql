-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_gerar_planej_real ( dt_mes_referencia_p timestamp, nm_usuario_p text) AS $body$
DECLARE


nr_seq_gerencia_w		bigint;
nr_seq_grupo_w			bigint;
qt_total_os_w			bigint;
qt_ordem_planejamento_w		bigint;
qt_usuario_grupo_w		bigint;
qt_ordem_colab_w		double precision;
qt_horas_ordens_w		double precision;
qt_hora_extra_w			double precision;
qt_horas_produtivas_w		double precision;
qt_total_os_antiga_w		double precision;
qt_ordem_planej_real_w		bigint;
dt_fim_mes_w			timestamp;
qt_total_pendente_w		bigint;
dt_mes_referencia_w		timestamp;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	gerencia_wheb
	where	ie_situacao = 'A';

C02 CURSOR FOR
	SELECT	nr_sequencia
	from	grupo_desenvolvimento
	where	nr_seq_gerencia	= nr_seq_gerencia_w
	and	nr_sequencia <> 76;


BEGIN
dt_mes_referencia_w := trunc(dt_mes_referencia_p,'month');
open C01;
loop
fetch C01 into
	nr_seq_gerencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	open C02;
	loop
	fetch C02 into
		nr_seq_grupo_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		/* Qt. ordens de serviço no mês */

		if (nr_seq_gerencia_w = 9) then
			select 	count(distinct nr_sequencia)
			into STRICT	qt_ordem_planej_real_w
			from	os_recebida_gerencia_desenv_v a
			where	trunc(dt_ordem_servico,'month') = dt_mes_referencia_w
			and	nr_seq_gerencia		= nr_seq_gerencia_w;
		else
			select 	count(distinct nr_sequencia)
			into STRICT	qt_ordem_planej_real_w
			from	os_recebida_gerencia_desenv_v a
			where	trunc(dt_ordem_servico,'month') = dt_mes_referencia_w
			and	nr_seq_gerencia		= nr_seq_gerencia_w
			and	nr_seq_grupo_des	= nr_seq_grupo_w;
		end if;

		/* Qt. usuários no grupo de desenvolvimento */

		if (nr_seq_gerencia_w = 9) then
			begin
			select	count(distinct(u.nm_usuario_grupo))
			into STRICT	qt_usuario_grupo_w
			from	usuario_grupo_des u,
				grupo_desenvolvimento g
			where	u.nr_seq_grupo = g.nr_sequencia
			and	g.nr_seq_gerencia = nr_seq_gerencia_w;
			end;
		else
			begin
			select	count(*)
			into STRICT	qt_usuario_grupo_w
			from	usuario_grupo_des
			where	nr_seq_grupo	= nr_seq_grupo_w;
			end;
		end if;

		/* Quantidade de ordens pendentes no fim do mês >>> ou no momento atual caso ainda não tenha chegado o final do mês <<< (Rafael Portuga)  */

		if (trunc(clock_timestamp(),'month') = trunc(dt_mes_referencia_w,'month')) and (trunc(clock_timestamp()) <> trunc(last_day(dt_mes_referencia_w))) then
			begin
			dt_fim_mes_w	:= trunc(clock_timestamp());
			end;
		else
			begin
			dt_fim_mes_w	:= last_day(dt_mes_referencia_w);
			end;
		end if;

		if (nr_seq_gerencia_w = 9) then
			begin
			select	sum(qt)
			into STRICT	qt_total_pendente_w
			from (
				SELECT	coalesce(max(a.qt_total),0) qt
				from 	grupo_desenvolvimento d,
					gerencia_wheb c,
					man_posicao_diaria b,
					man_posicao_diaria_resumo a
				where 	a.nr_seq_gerencia	= c.nr_sequencia
				and	a.nr_seq_posicao	= b.nr_sequencia
				and	a.nr_seq_grupo_des	= d.nr_sequencia
				and	b.dt_posicao		= dt_fim_mes_w
				and	c.nr_sequencia		= nr_seq_gerencia_w
				and	coalesce(a.ie_tipo,'P') 	= 'P'
				and	coalesce(b.ie_tipo,'P') 	= 'P'
				group by
					d.nr_sequencia
				) alias6;
			end;
		else
			begin
			select	max(a.qt_total)
			into STRICT	qt_total_pendente_w
			from 	grupo_desenvolvimento d,
				gerencia_wheb c,
				man_posicao_diaria b,
				man_posicao_diaria_resumo a
			where 	a.nr_seq_gerencia	= c.nr_sequencia
			and	a.nr_seq_posicao	= b.nr_sequencia
			and	a.nr_seq_grupo_des	= d.nr_sequencia
			and	b.dt_posicao		= dt_fim_mes_w
			and	d.nr_sequencia		= nr_seq_grupo_w
			and	c.nr_sequencia		= nr_seq_gerencia_w
			and	coalesce(a.ie_tipo,'P') 	= 'P'
			and	coalesce(b.ie_tipo,'P') 	= 'P';
			end;
		end if;

		if	(nr_seq_gerencia_w = 9 AND nr_seq_grupo_w =57) or (nr_seq_gerencia_w <> 9) then
			update	man_planejamento_meta
			set	qt_ordem_planej_real			= qt_ordem_planej_real_w,
				--qt_colaborador_planej_real		= qt_usuario_grupo_w, --decode(nvl(qt_colaborador_planej_real,0),0,nvl(qt_usuario_grupo_w,0),qt_colaborador_planej_real),
				qt_colaborador_planej_real		= CASE WHEN coalesce(qt_colaborador_planej_real,0)=0 THEN coalesce(qt_usuario_grupo_w,0)  ELSE qt_colaborador_planej_real END ,
				--qt_ordem_colaborador			= round(dividir(qt_ordem_planej_real_w,qt_usuario_grupo_w),2), --round(dividir(qt_ordem_planej_real_w,decode(nvl(qt_colaborador_planej_real,0),0,nvl(qt_usuario_grupo_w,0),qt_colaborador_planej_real)),2),
				qt_ordem_colaborador			= round((dividir(qt_ordem_planej_real_w,CASE WHEN coalesce(qt_colaborador_planej_real,0)=0 THEN coalesce(qt_usuario_grupo_w,0)  ELSE qt_colaborador_planej_real END ))::numeric,2),
				qt_media_ordem_antiga			= coalesce(qt_total_pendente_w,0)
			where	trunc(dt_mes_referencia,'month')	= dt_mes_referencia_w
			and	nr_seq_gerencia		= nr_seq_gerencia_w
			and	nr_seq_grupo_desenv	= nr_seq_grupo_w;
		end if;

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
-- REVOKE ALL ON PROCEDURE man_gerar_planej_real ( dt_mes_referencia_p timestamp, nm_usuario_p text) FROM PUBLIC;
