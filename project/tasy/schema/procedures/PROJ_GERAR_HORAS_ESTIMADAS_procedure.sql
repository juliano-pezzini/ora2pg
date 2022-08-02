-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_gerar_horas_estimadas ( cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_cliente_w	bigint;
nr_seq_prop_w		bigint;
dt_min_prev_w		timestamp;
nr_seq_estim_w		bigint;
nr_seq_modulo_w		bigint;
qt_hora_w			double precision;
cd_consultor_w		varchar(10);
nr_predecessora_w	bigint;
cd_coordenador_w	varchar(10);
dt_ini_prev_w		timestamp;
i					smallint;
j					smallint;
cont_w				bigint;
dt_ref_laco_w		timestamp;
dt_prev_aux_w		timestamp;
qt_dias_mes_w		bigint;
dia_util_w			varchar(1);
qt_horas_w			double precision;
qt_hora_dia_w		double precision;
ie_gerar_prev_w		varchar(1);

/*Cliente*/

C01 CURSOR FOR
SELECT	a.nr_sequencia
from	com_cliente a
where	a.ie_classificacao in ('C','P')
and	exists (	select	1
		from	com_canal_cliente x
		where	x.nr_seq_cliente = a.nr_sequencia
		and	x.ie_tipo_atuacao = 'V'
		and	coalesce(x.dt_fim_atuacao::text, '') = ''
		and	coalesce(x.ie_situacao,'A') = 'A'
		and	x.nr_seq_canal = 3)
		and	exists(	select	1
				from	com_cliente_proposta x
				where	(x.dt_liberacao IS NOT NULL AND x.dt_liberacao::text <> '')
				and	((x.dt_vencimento >= clock_timestamp()) or (coalesce(x.dt_vencimento::text, '') = ''))
				and	coalesce(x.dt_cancelamento::text, '') = ''
				and	coalesce(x.IE_ESCRITORIO_ATUAL,'N') = 'S'
				and	x.nr_seq_cliente = a.nr_sequencia
				and	coalesce(x.dt_aprovacao::text, '') = ''
				and	pkg_date_utils.start_of(x.dt_prev_fechamento, 'DD', 0) >= pkg_date_utils.start_of(clock_timestamp() - interval '30 days', 'DD', 0)
				and	exists (	select	1
						from	com_cliente_prop_estim y
						where	x.nr_sequencia = y.nr_seq_proposta));

/*Proposta*/

C02 CURSOR FOR
SELECT	a.nr_sequencia
from	com_cliente_proposta a
where	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
and	((a.dt_vencimento >= clock_timestamp()) or (coalesce(a.dt_vencimento::text, '') = ''))
and	coalesce(a.dt_cancelamento::text, '') = ''
and	a.nr_seq_cliente = nr_seq_cliente_w
and	coalesce(a.IE_ESCRITORIO_ATUAL,'N') = 'S'
and	coalesce(a.dt_aprovacao::text, '') = ''
and	pkg_date_utils.start_of(a.dt_prev_fechamento, 'DD', 0) >= pkg_date_utils.start_of(clock_timestamp() - interval '30 days', 'DD', 0)
and	exists (	select	1
		from	com_cliente_prop_estim y
		where	a.nr_sequencia = y.nr_seq_proposta);

/*Estimativa*/

C03 CURSOR FOR
SELECT	coalesce(a.nr_sequencia,0) nr_seq_estim,
	coalesce(a.nr_seq_mod_impl,0) nr_seq_modulo,
	coalesce(a.qt_hora,0) qt_hora,
	coalesce(a.cd_consultor,null) cd_consultor,
	coalesce(a.nr_predecessora,null) nr_predecessora,
	coalesce(a.cd_coordenador,null) cd_coordenador,
	coalesce(a.dt_ini_prev_estim,null) dt_ini_prev
from	com_cliente_prop_estim a
where	a.nr_seq_proposta = nr_seq_prop_w;


BEGIN

select	min(coalesce(a.dt_ini_prev_estim,null)) dt_min_prev
into STRICT	dt_min_prev_w
from	com_cliente_prop_estim a
where	a.nr_seq_proposta in (	SELECT   b.nr_sequencia
         			from	   com_cliente_proposta b
				where	   (b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
				and	   ((b.dt_vencimento >= clock_timestamp()) or (coalesce(b.dt_vencimento::text, '') = ''))
				and	   coalesce(b.dt_cancelamento::text, '') = ''
				and	   pkg_date_utils.start_of(b.dt_prev_fechamento, 'DD',0) >= pkg_date_utils.start_of(clock_timestamp() - interval '30 days', 'DD', 0)
				and	   b.nr_seq_cliente in  (SELECT   c.nr_sequencia
								FROM	   com_cliente c
								WHERE	   c.ie_classificacao in ('C','P')
								AND	   exists (	SELECT   1
											FROM	   com_canal_cliente x
											WHERE	   x.nr_seq_cliente = c.nr_sequencia
											AND	   x.ie_tipo_atuacao = 'V'
											AND	   coalesce(x.dt_fim_atuacao::text, '') = ''
											AND	   coalesce(x.ie_situacao,'A') = 'A'
											AND	   x.nr_seq_canal = 3)
											AND	   exists(	SELECT	1
														FROM	   com_cliente_proposta x
														WHERE	   (x.dt_liberacao IS NOT NULL AND x.dt_liberacao::text <> '')
														AND	   ((x.dt_vencimento >= clock_timestamp()) OR (coalesce(x.dt_vencimento::text, '') = ''))
														AND	   coalesce(x.dt_cancelamento::text, '') = ''
														AND	   x.nr_seq_cliente = c.nr_sequencia
														and	   coalesce(x.dt_aprovacao::text, '') = ''
														and	   pkg_date_utils.start_of(x.dt_prev_fechamento,'DD',0) >= pkg_date_utils.start_of(clock_timestamp() - interval '30 days','DD',0)
														and	   exists (	select   1
																	from	   com_cliente_prop_estim z
																	WHERE	   x.nr_sequencia = z.nr_seq_proposta)))
																	and	   coalesce(b.dt_aprovacao::text, '') = ''
																	and	exists (	select	1
																			from     com_cliente_prop_estim y
																			where    b.nr_sequencia = y.nr_seq_proposta));

open C01;
loop
fetch C01 into
	nr_seq_cliente_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	open C02;
	loop
	fetch C02 into
		nr_seq_prop_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		open C03;
		loop
		fetch C03 into
			nr_seq_estim_w,
			nr_seq_modulo_w,
			qt_hora_w,
			cd_consultor_w,
			nr_predecessora_w,
			cd_coordenador_w,
			dt_ini_prev_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin
			dt_prev_aux_w	:= dt_ini_prev_w;
			ie_gerar_prev_w	:= 'S';
			i := 1;
			for i in 1..12 loop
				begin
				dt_ref_laco_w	:= PKG_DATE_UTILS.ADD_MONTH(dt_min_prev_w, i-1, 0);

				select	count(*)
				into STRICT	cont_w
				
				where	dt_prev_aux_w < PKG_DATE_UTILS.ADD_MONTH(dt_min_prev_w,12, 0);

				if (cont_w > 0) then

					select	count(1)
					into STRICT	cont_w
					
					where	PKG_DATE_UTILS.extract_field('YEAR', dt_ref_laco_w) = PKG_DATE_UTILS.extract_field('YEAR', dt_prev_aux_w)
					and	PKG_DATE_UTILS.extract_field('MONTH', dt_ref_laco_w) = PKG_DATE_UTILS.extract_field('MONTH', dt_prev_aux_w);

					if (cont_w > 0) then

						select	obter_dias_entre_datas(dt_prev_aux_w, PKG_DATE_UTILS.end_of(dt_prev_aux_w, 'MONTH', 0))
						into STRICT	qt_dias_mes_w
						;

						j := 0;
						for j in 0..qt_dias_mes_w loop
							begin
							select	Obter_Se_Dia_Util(dt_prev_aux_w, cd_estabelecimento_p)
							into STRICT	dia_util_w
							;

							if (dia_util_w = 'S') then
								if (qt_hora_w < 6.4) then
									qt_hora_dia_w	:= qt_hora_w;
									qt_horas_w	:= 0;
								else
									qt_horas_w	:= qt_hora_w - 6.4;
									qt_hora_dia_w	:= 6.4;
								end if;

								if (ie_gerar_prev_w = 'S') then
									CALL gerar_w_estimativa_proj_com(	nr_seq_cliente_w,
																	cd_consultor_w,
																	dt_prev_aux_w,
																	'C',
																	i,
																	qt_hora_dia_w,
																	nr_seq_modulo_w,
																	nm_usuario_p);
								end if;

								if (qt_horas_w = 0) then
									ie_gerar_prev_w := 'N';
								end if;

							end if;

							end;
						end loop;

					end if;

				end if;
				end;
			end loop;

			end;
		end loop;
		close C03;

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
-- REVOKE ALL ON PROCEDURE proj_gerar_horas_estimadas ( cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

