-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION com_obter_ativos_mes ( dt_mes_referencia_p timestamp, nr_seq_canal_p bigint) RETURNS bigint AS $body$
DECLARE


dt_dia_w		timestamp;
dt_inicial_prospect_w	timestamp;
nr_seq_cliente_w	bigint;
qt_cliente_dia_w	bigint;
qt_dias_w		bigint;
qt_total_ativo_w	bigint;
dt_final_prospect_w	timestamp;
ds_retorno_w		double precision;
dt_abertura_canal_w	timestamp;
dt_fechamento_canal_w	timestamp;

C01 CURSOR FOR
	SELECT	trunc(dt_dia,'dd')
	from	dia_v
	where	trunc(dt_dia,'month')	= dt_mes_referencia_p;

C02 CURSOR FOR
	SELECT	a.nr_sequencia
	from	com_cliente a
	where	exists (	SELECT	1
				from	com_cliente_log x
				where	a.nr_sequencia	= x.nr_seq_cliente
				and	x.ie_log	= 2);


BEGIN

qt_dias_w		:= 0;
qt_total_ativo_w	:= 0;

open C01;
loop
fetch C01 into
	dt_dia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	qt_cliente_dia_w	:= 0;
	qt_dias_w	:= qt_dias_w + 1;

	open C02;
	loop
	fetch C02 into
		nr_seq_cliente_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		/* Data inicial do prospect */

		select	max(a.dt_log)
		into STRICT	dt_inicial_prospect_w
		from	com_cliente_log a
		where	a.ie_log		= 2
		and	a.ie_classificacao	= 'P'
		and	a.nr_seq_cliente	= nr_seq_cliente_w;

		if (dt_inicial_prospect_w IS NOT NULL AND dt_inicial_prospect_w::text <> '') then
			/* Data final do prospect */

			select	coalesce(max(a.dt_log),clock_timestamp())
			into STRICT	dt_final_prospect_w
			from	com_cliente_log a
			where	a.ie_log		= 2
			and	coalesce(a.dt_log,clock_timestamp())	>= dt_inicial_prospect_w
			and	a.ie_classificacao	<> 'P'
			and	a.nr_seq_cliente	= nr_seq_cliente_w;

			if (nr_seq_canal_p <> 0) then
				/* Data de abertura do canal */

				select	max(a.dt_log)
				into STRICT	dt_abertura_canal_w
				from	com_cliente_log a
				where	a.nr_seq_canal	= nr_seq_canal_p
				and	a.ie_log	= 3
				and	a.nr_seq_cliente	= nr_seq_cliente_w;

				if (coalesce(dt_abertura_canal_w::text, '') = '') then
					select	max(a.dt_inicio_atuacao)
					into STRICT	dt_abertura_canal_w
					from	com_canal_cliente a
					where	a.nr_seq_canal	= nr_seq_canal_p
					and	a.nr_seq_cliente	= nr_seq_cliente_w;
				end if;

				/* Data de fechamento do canal */

				select	max(a.dt_log)
				into STRICT	dt_fechamento_canal_w
				from	com_cliente_log a
				where	a.nr_seq_canal	= nr_seq_canal_p
				and	a.ie_log	= 4
				and	a.nr_seq_cliente	= nr_seq_cliente_w;

				if (coalesce(dt_fechamento_canal_w::text, '') = '') then
					select	coalesce(max(a.dt_fim_atuacao),clock_timestamp())
					into STRICT	dt_fechamento_canal_w
					from	com_canal_cliente a
					where	a.nr_seq_canal	= nr_seq_canal_p
					and	a.nr_seq_cliente	= nr_seq_cliente_w;
				end if;
			end if;

			if (dt_dia_w between trunc(dt_inicial_prospect_w,'dd') and fim_dia(dt_final_prospect_w)) then
				if ((nr_seq_canal_p <> 0) and (dt_dia_w between trunc(dt_abertura_canal_w,'dd') and fim_dia(dt_fechamento_canal_w))) or (nr_seq_canal_p = 0) then
					qt_cliente_dia_w	:= qt_cliente_dia_w + 1;
				end if;
			end if;
		end if;

		end;
	end loop;
	close C02;
	qt_total_ativo_w	:= qt_total_ativo_w + qt_cliente_dia_w;
	end;
end loop;
close C01;

ds_retorno_w	:= (qt_total_ativo_w/qt_dias_w);

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION com_obter_ativos_mes ( dt_mes_referencia_p timestamp, nr_seq_canal_p bigint) FROM PUBLIC;

