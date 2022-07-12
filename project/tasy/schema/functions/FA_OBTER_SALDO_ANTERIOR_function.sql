-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fa_obter_saldo_anterior (nr_seq_entrega_p bigint, nr_seq_paciente_entr_p bigint, cd_material_p bigint, nm_usuario_p text, qt_dose_p bigint default 0) RETURNS varchar AS $body$
DECLARE


qt_saldo_w			double precision;
qt_dias_saldo_w			bigint;
nr_seq_receita_amb_w		bigint;
nr_seq_entrega_ant_w		bigint;
dt_periodo_inicial_w		timestamp;
dt_periodo_final_ant_w	 	timestamp;
qt_dias_intervalo_ret_w		bigint;
nr_dias_util_w			smallint;
qtd_por_dia_w			double precision;
qtd_consumida_per_w		double precision;
qt_gerado_ant_w			integer;
qt_dispensar_ant_w		integer;
dt_periodo_final_w		timestamp;
dt_periodo_inicial_ant_w	timestamp;
cd_pessoa_fisica_w		varchar(10);
qt_dose_w			double precision;
ie_saldo_anterior_w		varchar(1);
qt_material_receita_w		bigint;
qt_material_entrega_w		bigint;
ie_considera_saldo_periodo_w	varchar(1);
ie_considera_pmc_w		varchar(1);
qt_saldo_anterior_w		double precision;
qt_saldo_disponivel_w		integer;
ie_cancela_saldo_ant_w		varchar(1);


BEGIN
qt_saldo_w := 0;
ie_saldo_anterior_w := 'S';
qt_dias_saldo_w := obter_param_usuario(10015, 3, obter_perfil_ativo, nm_usuario_p, 0, qt_dias_saldo_w);
ie_cancela_saldo_ant_w := obter_param_usuario(10015, 39, obter_perfil_ativo, nm_usuario_p, coalesce(wheb_usuario_pck.get_cd_estabelecimento,0), ie_cancela_saldo_ant_w);
ie_considera_saldo_periodo_w := obter_param_usuario(10015, 72, obter_perfil_ativo, nm_usuario_p, coalesce(wheb_usuario_pck.get_cd_estabelecimento,0), ie_considera_saldo_periodo_w);
ie_considera_pmc_w := obter_param_usuario(10015, 82, obter_perfil_ativo, nm_usuario_p, coalesce(wheb_usuario_pck.get_cd_estabelecimento,0), ie_considera_pmc_w);


if (nr_seq_paciente_entr_p <> 0) then

	--obter a última entrega do paciente
	select	max(dt_periodo_inicial),
		max(dt_periodo_final),
		max(cd_pessoa_fisica)
	into STRICT	dt_periodo_inicial_w,
		dt_periodo_final_w,
		cd_pessoa_fisica_w
	from	fa_entrega_medicacao
	where	nr_sequencia	= nr_seq_entrega_p
	and	coalesce(dt_cancelamento::text, '') = '';

	select 	max(f.nr_sequencia)
	into STRICT	nr_seq_entrega_ant_w
	from	fa_entrega_medicacao f,
		fa_entrega_medicacao_item i
	where	f.nr_sequencia <> nr_seq_entrega_p
	and	f.nr_sequencia = i.nr_seq_fa_entrega
	and	trunc(f.dt_periodo_final) >= trunc(clock_timestamp()) - qt_dias_saldo_w
	and	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and	i.cd_material 		= cd_material_p
	and	coalesce(f.dt_cancelamento::text, '') = ''
	and	coalesce(i.dt_cancelamento::text, '') = ''
	and (ie_cancela_saldo_ant_w <> 'T' or coalesce(i.ie_cancelar_saldo,'N') = 'N')
	AND (EXISTS ( SELECT 1
			FROM 	fa_paciente_entrega x
			WHERE	x.nr_sequencia = f.nr_seq_paciente_entrega
			AND  	coalesce(x.nr_seq_paciente_pmc::text, '') = ''
			) or (ie_considera_pmc_w = 'S'));


	if (nr_seq_entrega_ant_w IS NOT NULL AND nr_seq_entrega_ant_w::text <> '') then

		SELECT 	SUM(coalesce(qt_saldo_atual,0)),
			SUM(qt_gerado),
			SUM(qt_dispensar),
			SUM(qt_saldo_anterior),
			sum(coalesce(Fa_obter_saldo_disponivel(i.nr_sequencia),0))
		into STRICT	qt_saldo_w,
			qt_gerado_ant_w,
			qt_dispensar_ant_w,
			qt_saldo_anterior_w,
			qt_saldo_disponivel_w
		FROM	fa_entrega_medicacao f,
			fa_entrega_medicacao_item i
		WHERE	f.nr_sequencia 	= nr_seq_entrega_ant_w
		AND	f.nr_sequencia 	= i.nr_seq_fa_entrega
		and	i.cd_material	= cd_material_p
		AND	coalesce(i.dt_cancelamento::text, '') = '';

		-- Verificar se teve intervalo da primeira entrega para a segunda
		select	dt_periodo_final,
			dt_periodo_inicial,
			nr_dias_util,
			nr_seq_receita_amb
		into STRICT	dt_periodo_final_ant_w,
			dt_periodo_inicial_ant_w,
			nr_dias_util_w,
			nr_seq_receita_amb_w
		from	fa_entrega_medicacao
		where	nr_sequencia = nr_seq_entrega_ant_w;

		qtd_por_dia_w := 0;--fa_obter_qtd_dispensar_dia(nr_seq_receita_amb_w,cd_material_p);
		if (qt_saldo_w > 0) then
			--Verificar a quantidade de dias que o paciente levou para voltar para retirar a segunda entrega , pois ele pode ter tomado a qtd liberada a mais na primeira entrega
			if (dt_periodo_inicial_w > dt_periodo_final_ant_w) then
				begin
				--qt_dias_intervalo_ret_w := trunc(dt_periodo_inicial_w) - trunc(dt_periodo_final_ant_w)-1;
				--quantidade que o paciente deveria ter tomado no intervalo da primeira para a segunda entrega
				--qtd_consumida_per_w :=  qt_dias_intervalo_ret_w * qtd_por_dia_w;
				qtd_consumida_per_w := fa_obter_qtd_disp_dia_periodo(nr_seq_receita_amb_w,dt_periodo_final_ant_w, dt_periodo_inicial_w,cd_material_p,'R');
				--se o saldo for maior que a quantidade consumida, entao considera so a diferença, senão não considera o saldo
				if (qt_saldo_w > qtd_consumida_per_w) then
					qt_saldo_w := qt_saldo_w - qtd_consumida_per_w;
				else
					qt_saldo_w := 0;
				end if;
				end;
			elsif ((dt_periodo_final_ant_w > dt_periodo_inicial_w) and (trunc(dt_periodo_final_w) > trunc(dt_periodo_final_ant_w))) then
				--diferença entre a data final da 1º e a data inicial da 2º entrega - equivale a qtd de dias que o paciente tem a medicação - que foiu entregue na 1º entrega
				--qt_dias_intervalo_ret_w := trunc(dt_periodo_final_ant_w) - trunc(dt_periodo_inicial_w);
				--quantidade  que o paciente iria consumir entre o intervalo ( dat final 2º - data inicial 1º) - seria a qtd que o paciente já tem em casa
				--qtd_consumida_per_w :=  qt_dias_intervalo_ret_w * qtd_por_dia_w;
				qtd_consumida_per_w :=	fa_obter_qtd_disp_dia_periodo(nr_seq_receita_amb_w, dt_periodo_inicial_w, dt_periodo_final_ant_w, cd_material_p,'R');
				--o saldo vai ser a medicação que o paciente tem em casa no periodo + o saldo entregue a mais na primeira entrega
				qt_saldo_w := qt_saldo_w + qtd_consumida_per_w;

			elsif ((dt_periodo_final_ant_w > dt_periodo_inicial_w) and (trunc(dt_periodo_final_w) = trunc(dt_periodo_final_ant_w))) then
				begin
				--qt_dias_intervalo_ret_w := trunc(dt_periodo_inicial_w) - trunc(dt_periodo_inicial_ant_w);
				--quantidade que o paciente ainda tem casa
				--qtd_consumida_per_w :=  (qt_dias_intervalo_ret_w * qtd_por_dia_w);
				--**********************************************************************************Akiii*********************************
				qtd_consumida_per_w :=	fa_obter_qtd_disp_dia_periodo(nr_seq_receita_amb_w, dt_periodo_inicial_ant_w, dt_periodo_inicial_w, cd_material_p,'R');
				-- saldo vai ser a qtd dispensada anterior menos a diferença de dias consumida
				qt_saldo_w := qt_dispensar_ant_w - qtd_consumida_per_w;
				end;
			elsif (dt_periodo_final_ant_w > dt_periodo_inicial_w) then
				begin
				qt_dias_intervalo_ret_w := trunc(dt_periodo_final_ant_w) - trunc(dt_periodo_inicial_w);
				--quantidade que o paciente ainda tem casa
				--qtd_consumida_per_w := qt_dias_intervalo_ret_w * qtd_por_dia_w;
				qtd_consumida_per_w :=	fa_obter_qtd_disp_dia_periodo(nr_seq_receita_amb_w, dt_periodo_inicial_w, dt_periodo_final_ant_w, cd_material_p,'R');
				--soma a diferença que o paciente tem casa, pois voltou antes do prazo com o saldo anterior
				qt_saldo_w := qt_saldo_w + qtd_consumida_per_w;
				end;
			else
				qt_dias_intervalo_ret_w := 1;
			end if;
		elsif (qt_dispensar_ant_w = 0) /*or (dt_cancelamento_w is not null))*/
 then
			qt_saldo_w := 0;
		else -- verificar  a quantidade entregue na diferença do período
			if ((dt_periodo_final_ant_w > dt_periodo_inicial_w) and (trunc(dt_periodo_final_w) = trunc(dt_periodo_final_ant_w))) then
				begin
				--ie_saldo_anterior_w := 'N';
				--qt_dias_intervalo_ret_w := trunc(dt_periodo_inicial_w) - trunc(dt_periodo_inicial_ant_w);
				--quantidade que o paciente ainda tem casa
				--qtd_consumida_per_w :=  (qt_dias_intervalo_ret_w * qtd_por_dia_w);
				qtd_consumida_per_w := fa_obter_qtd_disp_dia_periodo(nr_seq_receita_amb_w, dt_periodo_inicial_ant_w, dt_periodo_inicial_w, cd_material_p,'R');
				if (qt_saldo_disponivel_w > 0) then
					qtd_consumida_per_w := qtd_consumida_per_w - 1;
				end if;
				if (ie_considera_saldo_periodo_w = 'S') then
					-- saldo vai ser a qtd dispensada anterior menos a diferença de dias consumida
					qt_saldo_w := (qt_dispensar_ant_w + qt_saldo_anterior_w) - qtd_consumida_per_w;
				else
					qt_saldo_w := qtd_consumida_per_w;
				end if;
				end;
			elsif (dt_periodo_final_ant_w > dt_periodo_inicial_w) then
				begin
				--ie_saldo_anterior_w := 'N';
				--qt_dias_intervalo_ret_w := trunc(dt_periodo_final_ant_w) - trunc(dt_periodo_inicial_w);
				--quantidade que o paciente ainda tem casa
				--qtd_consumida_per_w :=(qt_dias_intervalo_ret_w * qtd_por_dia_w);
				qtd_consumida_per_w :=  fa_obter_qtd_disp_dia_periodo(nr_seq_receita_amb_w, dt_periodo_inicial_w, dt_periodo_final_ant_w, cd_material_p,'R');

				if (qt_saldo_disponivel_w > qtd_consumida_per_w) then
					qtd_consumida_per_w := 0;
				end if;

				if (qt_dispensar_ant_w < qtd_consumida_per_w) then  -- 20 < 4
					qt_saldo_w := qtd_consumida_per_w - qt_dispensar_ant_w;
				else
					qt_saldo_w := qtd_consumida_per_w;
				end if;
				end;
			end if;
		end if;
	end if;

end if;

--verificar se já foi descontado do saldo se tiver o mesmo medicamento na entrega
if (qt_saldo_w > 0)  and (ie_saldo_anterior_w = 'S') then
	select 	COUNT(distinct f.nr_sequencia)
	into STRICT	qt_material_receita_w
	from	fa_receita_farm_item_hor h,
		fa_receita_farmacia_item f,
		fa_entrega_medicacao e,
		fa_receita_farmacia r
	where	e.nr_seq_receita_amb = f.nr_seq_receita
	and	r.nr_sequencia = f.nr_seq_receita
	and	f.nr_sequencia = h.nr_seq_fa_item
	and	e.nr_sequencia = nr_seq_entrega_p
	and	f.cd_material = cd_material_p
	and	trunc(h.dt_horario) between trunc(e.dt_periodo_inicial) and trunc(e.dt_periodo_final)
	and	coalesce(r.dt_cancelamento::text, '') = ''
	and	(r.dt_liberacao IS NOT NULL AND r.dt_liberacao::text <> '')
	and	obter_se_intervalo_prescricao(f.cd_intervalo,'S') = 'N';

	select	count(*)
	into STRICT	qt_material_entrega_w
	from   	fa_entrega_medicacao_item
	where  	nr_seq_fa_entrega       = nr_seq_entrega_p
	and	cd_material		= cd_material_p;

	if (qt_material_receita_w > 1) and (qt_material_entrega_w < qt_material_receita_w - 1) then
		select 	coalesce(SUM(qt_dose),0)
		into STRICT	qt_dose_w
		from   	fa_entrega_medicacao_item
		where  	nr_seq_fa_entrega       = nr_seq_entrega_p
		and	cd_material		= cd_material_p;

		if (qt_saldo_w < qt_dose_p + qt_dose_w) then
			qt_saldo_w := qt_saldo_w - qt_dose_w;
		else
			qt_saldo_w := qt_dose_p;
		end if;
	else
		select 	coalesce(SUM(qt_dose),0)
		into STRICT	qt_dose_w
		from   	fa_entrega_medicacao_item
		where  	nr_seq_fa_entrega       = nr_seq_entrega_p
		and	cd_material		= cd_material_p;
		qt_saldo_w	:= qt_saldo_w - qt_dose_w;
	end if;
end if;
/*
--verificar se já foi descontado do saldo se tiver o mesmo medicamento na entrega
if (qt_saldo_w > 0)  and (ie_saldo_anterior_w = 'S') then
	select 	nvl(SUM(qt_dose),0)
	into	qt_dose_w
	from   	fa_entrega_medicacao_item
	where  	nr_seq_fa_entrega       = nr_seq_entrega_p
	and	cd_material		= cd_material_p;
	qt_saldo_w	:= qt_saldo_w - qt_dose_w;
end if;*/
if (qt_saldo_w < 0) then
	qt_saldo_w := 0;
end if;

return qt_saldo_w;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fa_obter_saldo_anterior (nr_seq_entrega_p bigint, nr_seq_paciente_entr_p bigint, cd_material_p bigint, nm_usuario_p text, qt_dose_p bigint default 0) FROM PUBLIC;
