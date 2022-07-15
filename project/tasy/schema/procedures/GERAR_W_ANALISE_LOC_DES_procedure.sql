-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_analise_loc_des (nr_seq_localizacao_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text) AS $body$
DECLARE


qt_ordem_receb_w				bigint;
qt_ordem_exec_w				bigint;
qt_hora_exec_w				bigint;
qt_pendente_w				bigint;
qt_erro_wheb_w				bigint;
qt_erro_cliente_w				bigint;
qt_total_os_w				bigint;
dt_mes_referencia_w			timestamp;
dt_ano_referencia_w			timestamp;
nr_sequencia_w				bigint;


C01 CURSOR FOR
	SELECT	trunc(dt_ordem_servico, 'month'),
		count(*) qt_ordem
	from 	man_localizacao b,
		man_ordem_servico a
	where 	a.dt_ordem_servico between dt_inicial_p and dt_final_p
	and 	a.nr_seq_localizacao = coalesce(nr_seq_localizacao_p, a.nr_seq_localizacao)
	and 	a.nr_seq_localizacao = b.nr_sequencia
	and 	exists (	SELECT 	1
			from 	man_ordem_serv_estagio x,
				man_estagio_processo y
			where 	x.nr_seq_estagio = y.nr_sequencia
			and 	y.ie_desenv = 'S'
			and 	x.nr_seq_ordem = a.nr_sequencia)
	group by trunc(dt_ordem_servico, 'month')
	order by trunc(dt_ordem_servico, 'month');


BEGIN

if (nr_seq_localizacao_p IS NOT NULL AND nr_seq_localizacao_p::text <> '') then
	delete 	from w_analise_localizacao_des
	where	nr_seq_localizacao	= nr_seq_localizacao_p;
else
	delete 	from w_analise_localizacao_des;
end if;

open C01;
loop
fetch C01 into
	dt_mes_referencia_w,
	qt_ordem_receb_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	dt_ano_referencia_w	:= trunc(dt_mes_referencia_w, 'year');

	select	nextval('w_analise_localizacao_des_seq')
	into STRICT	nr_sequencia_w
	;

	select	count(*)
	into STRICT	qt_ordem_exec_w
	from	man_ordem_servico a
	where	a.nr_seq_localizacao	= coalesce(nr_seq_localizacao_p, nr_seq_localizacao)
	and	trunc(dt_ordem_servico, 'month') = dt_mes_referencia_w
	and 	exists (SELECT 1
			from 	man_ordem_serv_estagio x,
				man_estagio_processo y
			where 	x.nr_seq_estagio = y.nr_sequencia
			and 	y.ie_desenv = 'S'
			and 	x.nr_seq_ordem = a.nr_sequencia)
	and 	exists (select 1
			from 	man_ordem_serv_estagio x
			where 	x.nr_seq_estagio in (2,1511)
			and 	x.nr_seq_ordem = a.nr_sequencia);

	select	round(dividir(sum(b.qt_min_prev), 60))
	into STRICT	qt_hora_exec_w
	from	usuario_grupo_des c,
		man_ordem_servico_exec b,
		man_ordem_servico a
	where	a.nr_seq_localizacao	= coalesce(nr_seq_localizacao_p, a.nr_seq_localizacao)
	and	b.nr_seq_ordem		= a.nr_sequencia
	and	b.nm_usuario_exec		= c.nm_usuario_grupo
	and	trunc(dt_ordem_servico, 'month') = dt_mes_referencia_w
	and 	exists (SELECT 1
			from 	man_ordem_serv_estagio x,
				man_estagio_processo y
			where 	x.nr_seq_estagio = y.nr_sequencia
			and 	y.ie_desenv = 'S'
			and 	x.nr_seq_ordem = a.nr_sequencia);

	select	count(*)
	into STRICT	qt_pendente_w
	from	man_estagio_processo b,
		man_ordem_servico a
	where	a.nr_seq_localizacao		= coalesce(nr_seq_localizacao_p, a.nr_seq_localizacao)
	and	trunc(dt_ordem_servico, 'month') = dt_mes_referencia_w
	and	a.nr_seq_estagio		= b.nr_sequencia
	and	b.ie_desenv		= 'S'
	and (a.nr_seq_estagio in (4,731,732,741))
	and	a.ie_status_ordem <> 3
	and 	exists (SELECT 1
			from 	man_ordem_serv_estagio x,
				man_estagio_processo y
			where 	x.nr_seq_estagio = y.nr_sequencia
			and 	y.ie_desenv = 'S'
			and 	x.nr_seq_ordem = a.nr_sequencia);

	select	count(*)
	into STRICT	qt_erro_wheb_w
	from	man_doc_erro b,
		man_ordem_servico a
	where	a.nr_seq_localizacao	= coalesce(nr_seq_localizacao_p, a.nr_seq_localizacao)
	and	a.nr_sequencia		= b.nr_seq_ordem
	and	b.ie_origem_erro		= 'W'
	and	trunc(dt_ordem_servico, 'month') = dt_mes_referencia_w;

	select	count(*)
	into STRICT	qt_erro_cliente_w
	from	man_doc_erro b,
		man_ordem_servico a
	where	a.nr_seq_localizacao	= coalesce(nr_seq_localizacao_p, a.nr_seq_localizacao)
	and	a.nr_sequencia		= b.nr_seq_ordem
	and	b.ie_origem_erro		= 'C'
	and	trunc(dt_ordem_servico, 'month') = dt_mes_referencia_w;

	select	count(*)
	into STRICT	qt_total_os_w
	from	man_ordem_servico a
	where	a.nr_seq_localizacao	= coalesce(nr_seq_localizacao_p, a.nr_seq_localizacao)
	and	trunc(dt_ordem_servico, 'month') = dt_mes_referencia_w;

	insert	into w_analise_localizacao_des(nr_sequencia,
			nr_seq_localizacao,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			dt_ano_referencia,
			dt_mes_referencia,
			qt_ordem_recebida,
			qt_ordem_executada,
			qt_hora_trabalhada,
			qt_pendente,
			QT_TOTAL_OS,
			QT_ERRO_WHEB,
			QT_ERRO_CLIENTE)
	values (nr_sequencia_w,
			coalesce(nr_seq_localizacao_p,0),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			dt_ano_referencia_w,
			dt_mes_referencia_w,
			qt_ordem_receb_w,
			qt_ordem_exec_w,
			qt_hora_exec_w,
			qt_pendente_w,
			qt_total_os_w,
			qt_erro_wheb_w,
			qt_erro_cliente_w);

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_analise_loc_des (nr_seq_localizacao_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text) FROM PUBLIC;

