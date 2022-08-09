-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE preparar_medic_dias (nr_seq_receita_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* AO ALTERAR ESTA PROCEDURE, VERIFICAR SE NAO DEVE SER ALTERADA TAMBEM A preparar_medic_dias_item */

			      
nr_seq_medic_w		bigint;
cd_material_w		varchar(100);	
qt_dose_w		double precision;
dt_validade_w		timestamp;
dt_inicio_w		timestamp;
cd_unidade_medida_w	varchar(100);
cd_intervalo_w		varchar(10);
nr_ocorrencia_w		varchar(100);
qt_operacao_w		bigint;
qt_dias_w		double precision;
nr_dias_semanas_w	varchar(100);
ie_se_necessario_w	varchar(1);
nr_ciclo_w		integer;
qtd_w			integer;
ie_uso_continuo_w	varchar(1);
ie_controla_data_continuo_w	varchar(1);
ie_dose_diferenciada_w	varchar(1);


C01 CURSOR FOR
	SELECT 	a.nr_sequencia,
		a.cd_material,
		a.qt_dose,
		CASE WHEN a.ie_uso_continuo='S' THEN b.dt_validade_receita  ELSE a.dt_validade_receita END ,
		CASE WHEN a.ie_uso_continuo='S' THEN b.dt_inicio_receita  ELSE a.dt_inicio_receita END ,
		a.cd_unidade_medida,
		a.cd_intervalo,
		(CASE WHEN ie_domingo='S' THEN '1,'  ELSE '' END ||
		CASE WHEN ie_segunda='S' THEN '2,'  ELSE '' END ||
		CASE WHEN ie_terca='S' THEN '3,'  ELSE '' END   ||
		CASE WHEN ie_quarta='S' THEN '4,'  ELSE '' END  ||
		CASE WHEN ie_quinta='S' THEN '5,'  ELSE '' END  ||
		CASE WHEN ie_sexta='S' THEN '6,'  ELSE '' END   ||
		CASE WHEN ie_sabado='S' THEN '7,'  ELSE '' END ) dias_semana,
		coalesce(a.nr_ciclo,1),
		a.ie_uso_continuo
	from	fa_receita_farmacia_item a,
		fa_receita_farmacia b
	where	nr_seq_receita = nr_seq_receita_p
	and	a.nr_seq_receita = b.nr_sequencia;


BEGIN

open C01;
loop
fetch C01 into	
	nr_seq_medic_w,
	cd_material_w,
	qt_dose_w,
	dt_validade_w,
	dt_inicio_w,
	cd_unidade_medida_w,
	cd_intervalo_w,
	nr_dias_semanas_w,
	nr_ciclo_w,
	ie_uso_continuo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	-- Intervalo em horas
	select	coalesce(max(coalesce(qt_operacao_fa,qt_operacao)),0)
	into STRICT	qt_operacao_w
	from	intervalo_prescricao
	where	cd_intervalo = cd_intervalo_w
	and	ie_operacao = 'H';
	
	--Intervalo ie_se_necessario 
	SELECT	coalesce(ie_se_necessario,'N'),
		coalesce(ie_dose_diferenciada,'N')
	into STRICT	ie_se_necessario_w,
		ie_dose_diferenciada_w
	FROM	intervalo_prescricao
	WHERE	cd_intervalo = cd_intervalo_w;
	
	if ( ie_se_necessario_w = 'S') then
		insert into fa_receita_farm_item_hor(nr_sequencia,
			 dt_atualizacao,
			 nm_usuario,
			 dt_atualizacao_nrec,
			 nm_usuario_nrec,
			 nr_seq_fa_item,
			 dt_horario,
			 qt_dose_dispensar
			)
		values (nextval('fa_receita_farm_item_hor_seq'),
			 clock_timestamp(),
			 nm_usuario_p,
			 clock_timestamp(),
			 nm_usuario_p,
			 nr_seq_medic_w,
			 dt_inicio_w,
			 qt_dose_w
			);
	else
		qt_dias_w := 1;
		if (qt_operacao_w = 0) or (qt_operacao_w < 24) then
			if (ie_dose_diferenciada_w <> 'N') then
				nr_ocorrencia_w := 1;
			else
				nr_ocorrencia_w := Obter_ocorrencia_intervalo(cd_intervalo_w,24,'O');
			end if;
		else
			qt_dias_w := (qt_operacao_w/24);
			nr_ocorrencia_w := 1;
		end if;
		
		if (ie_uso_continuo_w	= 'S') then
		
			select 	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
			into STRICT	ie_controla_data_continuo_w
			FROM	fa_receita_farmacia_item a,
				fa_receita_farmacia b
			WHERE	nr_seq_receita 			= nr_seq_receita_p
			AND	a.nr_seq_receita 		= b.nr_sequencia
			and	a.cd_material 			= cd_material_w
			and	coalesce(ie_uso_continuo,'N') 	= 'N';
			
			if (ie_controla_data_continuo_w = 'S') then
			
				select MAX(a.DT_VALIDADE_RECEITA) +1
				into STRICT	dt_inicio_w
				FROM	fa_receita_farmacia_item a,
					fa_receita_farmacia b
				WHERE	nr_seq_receita 			= nr_seq_receita_p
				AND	a.nr_seq_receita 		= b.nr_sequencia
				and	a.cd_material 			= cd_material_w
				and	coalesce(ie_uso_continuo,'N') 	= 'N';
				
			end if;
		end if;
		
		
		while(ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_inicio_w) <= ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_validade_w)) loop
			if (Obter_Se_Contido(Obter_Cod_Dia_Semana(dt_inicio_w),nr_dias_semanas_w) = 'S') then
			
				-- verificar se ja existe o horario, pois a data de validade podera ser atualizada
				select 	count(*)
				into STRICT	qtd_w
				from 	fa_receita_farm_item_hor
				where	nr_seq_fa_item = nr_seq_medic_w
				and	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_horario) = ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_inicio_w);
			
				if (qtd_w = 0) then
					insert into fa_receita_farm_item_hor(nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_fa_item,
						dt_horario,
						qt_dose_dispensar
						)
					values (nextval('fa_receita_farm_item_hor_seq'),
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						nr_seq_medic_w,
						dt_inicio_w,
						(nr_ocorrencia_w * qt_dose_w * nr_ciclo_w)
						);
				end if;
			end if;
			dt_inicio_w := dt_inicio_w + qt_dias_w;
		end loop;
	end if;
end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE preparar_medic_dias (nr_seq_receita_p bigint, nm_usuario_p text) FROM PUBLIC;
