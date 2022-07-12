-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_dt_prev_futura_equip ( nr_seq_equipamento_p bigint, nr_seq_planej_prev_p bigint, nr_data_p bigint, ie_tipo_data_p text) RETURNS timestamp AS $body$
DECLARE


/*	ie_tipo_data_p
	P - Preventiva
	I - Início desejado	*/
dt_preventiva_w			timestamp := null;
cd_estabelecimento_w		smallint := wheb_usuario_pck.get_cd_estabelecimento;
ie_freq_primeira_prev_w		varchar(15);
nr_seq_equipamento_w		bigint;
qt_dia_gerar_ordem_w		smallint;
qt_dia_freq_w			smallint;
qt_controle_loop_w			integer := 0;
qt_dias_ordem_w			integer := 0;
dt_inicial_w			timestamp;
dt_ordem_servico_w		timestamp;
ie_dia_util_planej_w			varchar(15);
ie_dia_nao_util_planej_w		varchar(15);
ie_dia_ultima_verif_w		varchar(1);
ie_converter_mes_w		varchar(1);


BEGIN
ie_freq_primeira_prev_w := obter_param_usuario(298, 80, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, cd_estabelecimento_w, ie_freq_primeira_prev_w);

if (coalesce(nr_seq_equipamento_p,0) > 0) and (coalesce(nr_seq_planej_prev_p,0) > 0) and
	((coalesce(nr_data_p,0) > 0) and (coalesce(nr_data_p,0) < 13)) and (coalesce(ie_tipo_data_p,'X') <> 'X') then
	begin
	select	max(a.nr_sequencia),
		max(c.dt_inicial),
		max(c.qt_dia_gerar_ordem),
		coalesce(max(c.ie_dia_util),'M'),
		coalesce(max(c.ie_dia_nao_util),'M'),
		coalesce(max(c.ie_dia_ultima_verif),'E'),
		max(d.qt_dia),
		max(d.ie_converter_mes)
	into STRICT	nr_seq_equipamento_w,
		dt_inicial_w,
		qt_dia_gerar_ordem_w,
		ie_dia_util_planej_w,
		ie_dia_nao_util_planej_w,
		ie_dia_ultima_verif_w,
		qt_dia_freq_w,
		ie_converter_mes_w
	from	man_freq_planej d,
		man_planej_prev c,
		man_localizacao b,
		man_equipamento a
	where	b.nr_sequencia = a.nr_seq_local
	and	d.nr_sequencia = c.nr_seq_frequencia
	and	a.nr_seq_tipo_equip = c.nr_seq_tipo_equip
	and	a.nr_sequencia = coalesce(c.nr_seq_equip,a.nr_sequencia)
	and	b.cd_setor = coalesce(c.cd_setor_atendimento,b.cd_setor)
	and	coalesce(a.cd_estab_contabil,coalesce(cd_estabelecimento_w,0)) = coalesce(cd_estabelecimento_w,0)
	and	coalesce(a.nr_seq_marca,0) = coalesce(c.nr_seq_marca,coalesce(a.nr_seq_marca,0))
	and	coalesce(a.nr_seq_modelo,0) = coalesce(c.nr_seq_modelo,coalesce(a.nr_seq_modelo,0))
	and	coalesce(a.ie_situacao,'A') = 'A'
	and	coalesce(c.ie_situacao,'A') = 'A'
	and	a.nr_sequencia = nr_seq_equipamento_p
	and	c.nr_sequencia = nr_seq_planej_prev_p;

	if (coalesce(nr_seq_equipamento_w,0) > 0) then
		begin
		select	CASE WHEN ie_dia_ultima_verif_w='G' THEN max(dt_ordem_servico) WHEN ie_dia_ultima_verif_w='E' THEN max(dt_fim_real) WHEN ie_dia_ultima_verif_w='I' THEN max(dt_inicio_desejado) END
		into STRICT	dt_ordem_servico_w
		from	man_ordem_servico
		where	nr_seq_planej = nr_seq_planej_prev_p
		and	ie_tipo_ordem = 2
		and	nr_seq_equipamento = nr_seq_equipamento_w;

		while	(qt_controle_loop_w <= (nr_data_p - 1)) loop
			begin
			qt_controle_loop_w := qt_controle_loop_w + 1;

			if (ie_tipo_data_p = 'P') then
				begin
				if (coalesce(ie_freq_primeira_prev_w,'S') = 'N') and (coalesce(dt_ordem_servico_w::text, '') = '') and (dt_inicial_w > clock_timestamp()) then
					begin
					qt_dias_ordem_w	:= qt_dias_ordem_w + 1;
					dt_preventiva_w := obter_data_prev_futura(coalesce(coalesce(dt_ordem_servico_w,dt_inicial_w),clock_timestamp()), (qt_dia_freq_w * (qt_dias_ordem_w - 1)), ie_converter_mes_w);
					end;
				else
					begin
					qt_dias_ordem_w	:= qt_dias_ordem_w + 1;
					dt_preventiva_w := obter_data_prev_futura(coalesce(coalesce(dt_ordem_servico_w,dt_inicial_w),clock_timestamp()), (qt_dia_freq_w * qt_dias_ordem_w), ie_converter_mes_w);
					end;
				end if;
				end;
			elsif (ie_tipo_data_p = 'I') then
				begin
				if (coalesce(ie_freq_primeira_prev_w,'S') = 'N') and (coalesce(dt_ordem_servico_w::text, '') = '') and (dt_inicial_w > clock_timestamp()) then
					begin
					qt_dias_ordem_w := qt_dias_ordem_w + 1;
					dt_preventiva_w := obter_data_prev_futura(coalesce(coalesce(dt_ordem_servico_w,dt_inicial_w),clock_timestamp()), (qt_dia_freq_w * (qt_dias_ordem_w - 1)), ie_converter_mes_w);
					end;
				else
					begin
					qt_dias_ordem_w := qt_dias_ordem_w + 1;
					dt_preventiva_w := obter_data_prev_futura(coalesce(coalesce(dt_ordem_servico_w,dt_inicial_w),clock_timestamp()), (qt_dia_freq_w * qt_dias_ordem_w), ie_converter_mes_w);
					end;
				end if;

				dt_preventiva_w := dt_preventiva_w + qt_dia_gerar_ordem_w;
				if (coalesce(ie_dia_nao_util_planej_w,'M') <> 'M') then
					if (obter_se_feriado(cd_estabelecimento_w, dt_preventiva_w) > 0) or (pkg_date_utils.IS_BUSINESS_DAY(dt_preventiva_w) = 0) then
						if (ie_dia_nao_util_planej_w = 'A') then /* Antecipar */
							dt_preventiva_w := obter_dia_anterior_util(cd_estabelecimento_w, dt_preventiva_w);
						elsif (ie_dia_nao_util_planej_w = 'P') then /*Postergar */
							dt_preventiva_w := obter_proximo_dia_util(cd_estabelecimento_w, dt_preventiva_w);
						end if;
					end if;
				end if;

				if (coalesce(ie_dia_util_planej_w,'M') <> 'M') then
					if (obter_se_feriado(cd_estabelecimento_w, dt_preventiva_w) = 0) or (pkg_date_utils.IS_BUSINESS_DAY(dt_preventiva_w) = 1) then
						if (ie_dia_util_planej_w = 'A') then /* Antecipar */
							dt_preventiva_w := obter_dia_anterior_util(cd_estabelecimento_w, dt_preventiva_w);
						elsif (ie_dia_util_planej_w = 'P') then /*Postergar */
							dt_preventiva_w := obter_dia_anterior_nao_util(cd_estabelecimento_w, dt_preventiva_w);
						end if;
					end if;
				end if;
				end;
			end if;
			end;

		end loop;
		end;
	end if;
	end;
end if;

return	dt_preventiva_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_dt_prev_futura_equip ( nr_seq_equipamento_p bigint, nr_seq_planej_prev_p bigint, nr_data_p bigint, ie_tipo_data_p text) FROM PUBLIC;
