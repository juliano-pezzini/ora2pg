-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fa_obter_qtd_disp_dia_periodo ( nr_seq_receita_ant_p bigint, dt_entrega_ini_ant_p timestamp, dt_entrega_fim_ant_p timestamp, cd_material_p bigint, ie_opcao_p text default 'R') RETURNS varchar AS $body$
DECLARE


/*
R - Considera período real
N - Não considera período real
*/
dt_entrega_ini_ant_w		timestamp;
dt_entrega_fim_ant_w		timestamp;
qt_dose_w			double precision;
cd_intervalo_w			varchar(10);
nr_ciclo_w			integer;
dt_inicio_real_receita_w	timestamp;
dt_validade_real_receita_w   	timestamp;
qt_dose_periodo_w		double precision;
qt_dias_periodo_w		bigint;
qt_dose_medic_w			double precision;
nr_ocorrencia_w			varchar(100);
qt_operacao_w			bigint;
qt_dias_w			double precision;
ie_se_necessario_w		varchar(1);
ie_uso_continuo_w		varchar(1);
qt_referencia_w			smallint;
ie_considera_saldo_periodo_w	varchar(1);
ie_dose_diferenciada_w		varchar(1);

C01 CURSOR FOR
	SELECT 	a.qt_dose,
		a.cd_intervalo,
		coalesce(a.nr_ciclo,1),
		dt_inicio_real_receita,
		dt_validade_real_receita,
		ie_uso_continuo
	FROM	fa_receita_farmacia_item a,
		fa_receita_farmacia b
	WHERE	nr_seq_receita 		= nr_seq_receita_ant_p
	AND	a.nr_seq_receita 	= b.nr_sequencia
	and	a.cd_material 		= cd_material_p;
	--and	rownum = 1;
BEGIN

ie_considera_saldo_periodo_w := obter_param_usuario(10015, 72, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, coalesce(wheb_usuario_pck.get_cd_estabelecimento,0), ie_considera_saldo_periodo_w);
dt_entrega_ini_ant_w :=	trunc(dt_entrega_ini_ant_p);
dt_entrega_fim_ant_w := trunc(dt_entrega_fim_ant_p);


qt_dose_periodo_w := 0;
open C01;
loop
fetch C01 into
	qt_dose_w,
	cd_intervalo_w,
	nr_ciclo_w,
	dt_inicio_real_receita_w,
	dt_validade_real_receita_w,
	ie_uso_continuo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	-- Intervalo em horas
	select	coalesce(MAX(coalesce(qt_operacao_fa,qt_operacao)),0)
	into STRICT	qt_operacao_w
	from	intervalo_prescricao
	where	cd_intervalo = cd_intervalo_w
	and	ie_operacao = 'H';

	--Intervalo ie_se_necessário
	SELECT	max(coalesce(ie_se_necessario,'N')),
		max(coalesce(ie_dose_diferenciada,'N'))
	into STRICT	ie_se_necessario_w,
		ie_dose_diferenciada_w
	FROM	intervalo_prescricao
	WHERE	cd_intervalo = cd_intervalo_w;

	if ( ie_se_necessario_w = 'S') then
		qt_dose_medic_w := qt_dose_w;
	else
		if (qt_operacao_w = 0) or (qt_operacao_w < 24) then
			if (ie_dose_diferenciada_w <> 'N') then
				nr_ocorrencia_w := 1;
			else
				nr_ocorrencia_w := Obter_ocorrencia_intervalo(cd_intervalo_w,24,'O');
			end if;
		else
			begin
			qt_dias_w 	:= (qt_operacao_w/24);
			nr_ocorrencia_w := 1;
			end;
		end if;
		qt_dose_medic_w	:= nr_ocorrencia_w * qt_dose_w * nr_ciclo_w;
	end if;
	exception
		when no_data_found then
		qt_dose_medic_w := 0;
	end;

	if (ie_uso_continuo_w = 'S') then

		select 	max(dt_validade_real_receita)
		into STRICT	dt_validade_real_receita_w
		FROM	fa_receita_farmacia_item a,
			fa_receita_farmacia b
		WHERE	nr_seq_receita 			= nr_seq_receita_ant_p
		AND	a.nr_seq_receita 		= b.nr_sequencia
		and	a.cd_material 			= cd_material_p
		and	coalesce(ie_uso_continuo,'N') 	= 'N';

		if (coalesce(dt_validade_real_receita_w::text, '') = '') then
			dt_inicio_real_receita_w := trunc(dt_entrega_ini_ant_w);
		elsif (dt_entrega_ini_ant_w > dt_validade_real_receita_w) then
			dt_inicio_real_receita_w := dt_entrega_ini_ant_w;
		else
			dt_inicio_real_receita_w := trunc(dt_validade_real_receita_w) + 1;
		end if;

		dt_validade_real_receita_w 	:= trunc(dt_entrega_fim_ant_w);

	end if;

	--Irá considerar o período da receita. Esta opção foi criada para ser utilizada no campo 'Qt dispensar', da pasta 'Receita ambulatorial' do PEP
	if (ie_opcao_p = 'N') then
		qt_dias_periodo_w := TRUNC(dt_entrega_fim_ant_w) - TRUNC(dt_entrega_ini_ant_w);
	--Não encaixa no período
	elsif (dt_entrega_fim_ant_w < dt_inicio_real_receita_w ) or (dt_entrega_ini_ant_w > dt_validade_real_receita_w) then
		qt_dias_periodo_w := 0;
	--dentro do período
	elsif (dt_entrega_ini_ant_w >= dt_inicio_real_receita_w ) and (dt_entrega_ini_ant_w <=  dt_validade_real_receita_w) and (dt_entrega_fim_ant_w  <=  dt_validade_real_receita_w) then
		qt_dias_periodo_w := TRUNC(dt_entrega_fim_ant_w ) - TRUNC(dt_entrega_ini_ant_w);
	--se ambos estão dentro do período
	elsif (dt_entrega_ini_ant_w <= dt_inicio_real_receita_w) and (dt_entrega_fim_ant_w >= dt_validade_real_receita_w) then
		qt_dias_periodo_w := trunc(dt_validade_real_receita_w) - trunc(dt_inicio_real_receita_w);
	-- se somente a data real da receita está no período
	elsif (dt_inicio_real_receita_w >= dt_entrega_ini_ant_w) and (dt_inicio_real_receita_w <= dt_entrega_fim_ant_w) and (dt_validade_real_receita_w <= dt_entrega_fim_ant_w) then
		qt_dias_periodo_w := TRUNC(dt_entrega_fim_ant_w) - TRUNC(dt_inicio_real_receita_w);
	--se a data de fim real da receita estiver dentro do período
	elsif (dt_validade_real_receita_w >= dt_entrega_ini_ant_w) and (dt_validade_real_receita_w <= dt_entrega_fim_ant_w) and (dt_inicio_real_receita_w <= dt_entrega_ini_ant_w) then
		qt_dias_periodo_w := trunc(dt_validade_real_receita_w) - trunc(dt_entrega_ini_ant_w);
	else
		qt_dias_periodo_w := 0;
	end if;

	if (qt_dias_w IS NOT NULL AND qt_dias_w::text <> '') and (qt_dias_w <> 1) then
		qt_dias_periodo_w := qt_dias_periodo_w/qt_dias_w;
		qt_referencia_w := 0;
	else
		qt_referencia_w := 1;
	end if;

	if (qt_dias_periodo_w <> 0) or (ie_opcao_p = 'N') then
		qt_dose_periodo_w := qt_dose_periodo_w + ((qt_dias_periodo_w+qt_referencia_w) * qt_dose_medic_w);
	end if;

end loop;
close C01;

--Se parâmetro 72 = 'N' - não deve considerar o saldo por período
if (ie_considera_saldo_periodo_w = 'N') and (ie_opcao_p = 'R') then
	qt_dose_periodo_w := 0;
end if;

return qt_dose_periodo_w;
--return dt_entrega_ini_ant_w ||'-'|| dt_inicio_real_receita_w||'-'||dt_entrega_fim_ant_w ||'-'|| dt_validade_real_receita_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fa_obter_qtd_disp_dia_periodo ( nr_seq_receita_ant_p bigint, dt_entrega_ini_ant_p timestamp, dt_entrega_fim_ant_p timestamp, cd_material_p bigint, ie_opcao_p text default 'R') FROM PUBLIC;

