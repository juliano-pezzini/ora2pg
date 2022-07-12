-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fa_obter_dias_intervalo ( cd_intervalo_p text, nr_seq_entrega_p bigint, nr_seq_horario_p bigint, dt_validade_p timestamp) RETURNS varchar AS $body$
DECLARE



qt_operacao_w		bigint;
qt_dias_w		double precision;
dt_retorno_w		timestamp;
dt_retorno_final_w	timestamp;
dt_periodo_inicial_w	timestamp;
dt_periodo_final_w	timestamp;
ie_retorno_w		varchar(1);
dt_horario_w		timestamp;
nr_seq_receita_amb_w	bigint;
nr_seq_ant_w		bigint;
dt_inicial_ant_w	timestamp;
cd_material_w		bigint;
qt_receitada_w		bigint;
nr_dias_util_w		smallint;
ie_dias_uteis_w		varchar(1);


BEGIN

ie_retorno_w := 'N';

if (cd_intervalo_p IS NOT NULL AND cd_intervalo_p::text <> '') then

	ie_dias_uteis_w := obter_valor_param_usuario(10015, 111, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);

	select 	dt_periodo_inicial,
		dt_periodo_final,
		nr_seq_receita_amb,
		nr_dias_util
	into STRICT	dt_periodo_inicial_w,
		dt_periodo_final_w,
		nr_seq_receita_amb_w,
		nr_dias_util_w
	from	fa_entrega_medicacao
	where	nr_sequencia	= nr_seq_entrega_p;

	select	coalesce(max(coalesce(qt_operacao_fa,qt_operacao)),0)
	into STRICT	qt_operacao_w
	from	intervalo_prescricao
	where	cd_intervalo = cd_intervalo_p
	and	ie_operacao = 'H';

	if (qt_operacao_w >= 720) then -- mensal
		--buscar a entrega enterior para comparar se a data horário é maior que a data inicial da entrega enterior
		select 	max(nr_sequencia)
		into STRICT	nr_seq_ant_w
		from    fa_entrega_medicacao x
		where   x.nr_seq_receita_amb = nr_seq_receita_amb_w
		and	x.dt_cancelamento is  null
		and	x.nr_sequencia <> nr_seq_entrega_p;

		dt_inicial_ant_w := clock_timestamp() - interval '30 days';
		if (nr_seq_ant_w IS NOT NULL AND nr_seq_ant_w::text <> '') then

			select 	dt_periodo_inicial
			into STRICT	dt_inicial_ant_w
			from    fa_entrega_medicacao x
			where   nr_sequencia = nr_seq_ant_w;

		end if;

		select	max(f.cd_material)
		into STRICT	cd_material_w
		from	fa_receita_farm_item_hor h,
			fa_receita_farmacia_item f
		where	f.nr_sequencia = h.nr_seq_fa_item
		and	h.nr_sequencia = nr_seq_horario_p;

		select	sum(h.qt_dose_dispensar)
		into STRICT	qt_receitada_w
		from	fa_receita_farm_item_hor h,
			fa_receita_farmacia_item f
		where	f.nr_sequencia = h.nr_seq_fa_item
		and	f.nr_seq_receita = nr_seq_receita_amb_w;

		select	min(a.dt_horario)
		into STRICT	dt_horario_w
		from   	fa_receita_farm_item_hor a
		where  	a.nr_sequencia = nr_seq_horario_p
		and (not exists (SELECT	1
				from    fa_entrega_medicacao x
				where   x.nr_seq_receita_amb = nr_seq_receita_amb_w
				and	trunc(a.dt_horario) between trunc(x.dt_periodo_inicial) and trunc(x.dt_periodo_final) - 10
				and	x.dt_cancelamento is  null
				and	x.nr_sequencia <> nr_seq_entrega_p)
		or (exists (select	1
				from	fa_entrega_medicacao y,
					fa_receita_farmacia z
				where	y.nr_seq_receita_amb = z.nr_sequencia
				and	y.nr_sequencia = nr_seq_entrega_p
				and	trunc(z.dt_validade_receita) = trunc(y.dt_periodo_final)
				and (select	sum(c.qt_dispensar)
					from	fa_entrega_medicacao_item c,
						fa_entrega_medicacao d
					where	c.nr_seq_fa_entrega = d.nr_sequencia
					and	d.nr_seq_receita_amb = z.nr_sequencia
					and	c.cd_material = cd_material_w
					and	coalesce(d.nr_seq_motivo_canc::text, '') = '') < qt_receitada_w)))
		and (trunc(a.dt_horario) >= trunc(dt_inicial_ant_w));

		qt_dias_w 		:= (qt_operacao_w/24);
		dt_retorno_w 		:= dt_horario_w;
		dt_retorno_final_w	:= dt_horario_w + qt_dias_w -1;

		if (ie_dias_uteis_w = 'S') then
			dt_periodo_final_w	:= dt_periodo_inicial_w + ((qt_dias_w * ceil(nr_dias_util_w/qt_dias_w)) - 1);
		end if;

		if (trunc(dt_retorno_final_w) > trunc(dt_validade_p)) then
			dt_retorno_w := trunc(dt_validade_p);
		end if;
	else
		select  dt_horario
		into STRICT	dt_retorno_w
		from	fa_receita_farm_item_hor
		where 	nr_sequencia = nr_seq_horario_p;

		dt_retorno_final_w := dt_retorno_w;
	end if;

	if (trunc(dt_retorno_w) between trunc(dt_periodo_inicial_w) and trunc(dt_periodo_final_w)) or
		((trunc(dt_retorno_final_w) between trunc(dt_periodo_inicial_w) and trunc(dt_periodo_final_w)) and
		((ie_dias_uteis_w <> 'S') or (dt_periodo_final_w >= trunc(dt_validade_p)))) then
		ie_retorno_w := 'S';
	end if;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fa_obter_dias_intervalo ( cd_intervalo_p text, nr_seq_entrega_p bigint, nr_seq_horario_p bigint, dt_validade_p timestamp) FROM PUBLIC;
