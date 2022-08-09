-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE controle_soro_glic_npt ( nr_seq_nut_pac_p nut_pac.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


nr_seq_pac_elemento_w		nut_pac_elemento.nr_sequencia%type;
nr_seq_pac_elem_agua_w		nut_pac_elemento.nr_sequencia%type;
nr_seq_elemento_w			nut_pac_elemento.nr_seq_elemento%type;
cd_material_w				nut_elem_material.cd_material%type;
qt_conversao_ml_w			nut_elem_material.qt_conversao_ml%type;
qt_conv_unid_cons_w			nut_elem_material.qt_conv_unid_cons%type;
qt_aporte_hidrico_diario_w	nut_pac.qt_aporte_hidrico_diario%type;
qt_peso_w					nut_pac.qt_peso%type;
nr_seq_elem_mat_w			nut_elem_material.nr_sequencia%type;
nr_seq_elem_mat_5_w			nut_elem_material.nr_sequencia%type;
nr_seq_elem_mat_10_w		nut_elem_material.nr_sequencia%type;
nr_seq_elem_mat_50_w		nut_elem_material.nr_sequencia%type;
qt_conv_ml_5_w				nut_elem_material.qt_conversao_ml%type;
qt_conv_ml_10_w				nut_elem_material.qt_conversao_ml%type;
qt_conv_ml_50_w				nut_elem_material.qt_conversao_ml%type;
qt_conv_un_cons_5_w			nut_elem_material.qt_conv_unid_cons%type;
qt_conv_un_cons_10_w		nut_elem_material.qt_conv_unid_cons%type;
qt_conv_un_cons_50_w		nut_elem_material.qt_conv_unid_cons%type;
qt_vol_final_sem_glic_w		nut_pac_elemento.qt_volume_final%type;
qt_kcal_elem_w				nut_pac_elemento.qt_kcal%type;
pr_total_w					nut_pac_elemento.pr_total%type;
qt_vel_inf_glicose_w		nut_pac.qt_vel_inf_glicose%type;
qt_vol_1_fase_w				nut_pac_elem_mat.qt_vol_1_fase%type;
qt_vol_2_fase_w				nut_pac_elem_mat.qt_vol_1_fase%type;
qt_vol_3_fase_w				nut_pac_elem_mat.qt_vol_1_fase%type;
qt_vol_4_fase_w				nut_pac_elem_mat.qt_vol_1_fase%type;
qt_fase_npt_w				nut_pac.qt_fase_npt%type;
qt_equipo_w					nut_pac.qt_equipo%type;
qt_diaria_w					nut_pac_elemento.qt_diaria%type;
qt_diaria_5_w				nut_pac_elemento.qt_diaria%type;
qt_diaria_10_w				nut_pac_elemento.qt_diaria%type;
qt_diaria_50_w				nut_pac_elemento.qt_diaria%type;
qt_kcal_total_w				nut_pac.qt_kcal_total%type;
qt_kcal_lipideo_w			nut_pac_elemento.qt_kcal%type;
qt_kcal_glicose_w			nut_pac_elemento.qt_kcal%type;
qt_kcal_proteina_w			nut_pac_elemento.qt_kcal%type;
qt_hora_inf_w				nut_pac.qt_hora_inf%type;
qt_volume_diario_w			nut_pac.qt_volume_diario%type;
qt_vol_cor_5_w				nut_pac_elem_mat.qt_vol_cor%type;
qt_vol_cor_10_w				nut_pac_elem_mat.qt_vol_cor%type;
qt_vol_cor_50_w				nut_pac_elem_mat.qt_vol_cor%type;
qt_vol_total_5_w			nut_pac_elem_mat.qt_volume%type;
qt_vol_total_10_w			nut_pac_elem_mat.qt_volume%type;
qt_vol_total_50_w			nut_pac_elem_mat.qt_volume%type;
qt_min_inf_w				nut_pac.qt_min_inf%type;
qt_elem_kg_dia_w			nut_pac_elemento.qt_elem_kg_dia%type;
qt_mult_glic_w				double precision;
qt_reg_w					bigint;
qt_fator_glic_w				double precision;
qt_grama_glic_w				double precision;
qt_soro_npt_w				double precision;
qt_vol_correcao_w			double precision;
pr_conc_5_w					double precision := 0;
pr_conc_10_w				double precision := 0;
pr_conc_50_w				double precision := 0;

ie_conc_volume_w			varchar(1);

c01 CURSOR FOR
SELECT	nr_sequencia,
		qt_conversao_ml,
		qt_conv_unid_cons
from	nut_elem_material
where	nr_seq_elemento = nr_seq_elemento_w
and		coalesce(ie_padrao,'N') = 'S'
and		coalesce(ie_situacao,'A') = 'A';

c02 CURSOR FOR
SELECT	a.nr_sequencia,
		coalesce(a.qt_kcal,0),
		coalesce(b.qt_kcal_total,0)
from	nut_pac_elemento a,
		nut_pac b
where	a.nr_seq_nut_pac = b.nr_sequencia
and		b.nr_sequencia = nr_seq_nut_pac_p;


BEGIN
ie_conc_volume_w := 'N';

CALL Wheb_assist_pck.set_informacoes_usuario(wheb_usuario_pck.get_cd_estabelecimento, obter_perfil_ativo, nm_usuario_p);
qt_fator_glic_w				:= (Wheb_assist_pck.obterParametroFuncao(924,1009))::numeric;

select	max(qt_aporte_hidrico_diario),
		max(qt_peso),
		max(qt_vel_inf_glicose),
		max(qt_fase_npt),
		max(qt_equipo),
		max(coalesce(qt_hora_inf,24)),
		max(coalesce(qt_min_inf,0))
into STRICT	qt_aporte_hidrico_diario_w,
		qt_peso_w,
		qt_vel_inf_glicose_w,
		qt_fase_npt_w,
		qt_equipo_w,
		qt_hora_inf_w,
		qt_min_inf_w
from	nut_pac
where	nr_sequencia = nr_seq_nut_pac_p;

qt_mult_glic_w := dividir_sem_round(((coalesce(qt_hora_inf_w,24) * 60) + coalesce(qt_min_inf_w,0)),1000);

--- Busca o elemento glicose dentro da NPT pediátrica
select	max(nr_sequencia),
		max(nr_seq_elemento),
		coalesce(max(qt_elem_kg_dia),0)
into STRICT	nr_seq_pac_elemento_w,
		nr_seq_elemento_w,
		qt_elem_kg_dia_w
from	nut_pac_elemento
where	nr_seq_nut_pac =  nr_seq_nut_pac_p
and		obter_tipo_elemento(nr_seq_elemento) = 'C';

--- Busca o elemento agua
select	max(nr_sequencia)
into STRICT	nr_seq_pac_elem_agua_w
from	nut_pac_elemento
where	nr_seq_nut_pac = nr_seq_nut_pac_p
and		obter_tipo_elemento(nr_seq_elemento) = 'A';

--- Busca a quantidade dos outros elementos para ser descontada do aporte
select	coalesce(sum(qt_volume_final),0)
into STRICT	qt_vol_final_sem_glic_w
from	nut_pac_elemento
where	nr_seq_nut_pac = nr_seq_nut_pac_p
and		obter_tipo_elemento(nr_seq_elemento) <> 'C'
and		obter_tipo_elemento(nr_seq_elemento) <> 'A';

qt_grama_glic_w 	:= round((qt_peso_w * qt_vel_inf_glicose_w) * coalesce(qt_mult_glic_w,1.44),2); -- Quantidade em gramas que pode se ter de glicose na NPT
qt_soro_npt_w 		:= (qt_aporte_hidrico_diario_w - qt_vol_final_sem_glic_w); -- Quantidade faltante de soro glicosado para o aporte, já descontando os outros elementos
qt_vol_correcao_w	:= dividir((qt_aporte_hidrico_diario_w + qt_equipo_w),qt_aporte_hidrico_diario_w); -- Valor de correção do equipo
open c01;
loop
fetch c01 into	nr_seq_elem_mat_w,
				qt_conversao_ml_w,
				qt_conv_unid_cons_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select	count(*)
	into STRICT	qt_reg_w
	from	nut_pac_elem_mat
	where	nr_seq_pac_elem = nr_seq_pac_elemento_w
	and		nr_seq_elem_mat = nr_seq_elem_mat_w;

	if (qt_reg_w = 0) then
		insert into nut_pac_elem_mat(
						nr_sequencia,
						nr_seq_pac_elem,
						dt_atualizacao,
						nm_usuario,
						qt_volume,
						qt_vol_1_fase,
						qt_vol_2_fase,
						qt_vol_3_fase,
						qt_vol_4_fase,
						nr_seq_elem_mat)
					values (
						nextval('nut_pac_elem_mat_seq'),
						nr_seq_pac_elemento_w,
						clock_timestamp(),
						nm_usuario_p,
						null,
						null,
						null,
						null,
						null,
						nr_seq_elem_mat_w);
		commit;
	end if;

	if ((dividir(qt_conv_unid_cons_w,qt_conversao_ml_w) * 100) = 5) then
		pr_conc_5_w := 5;
		qt_conv_ml_5_w := qt_conversao_ml_w;
		qt_conv_un_cons_5_w := qt_conv_unid_cons_w;
		nr_seq_elem_mat_5_w := nr_seq_elem_mat_w;
	elsif ((dividir(qt_conv_unid_cons_w,qt_conversao_ml_w) * 100) = 10) then
		pr_conc_10_w := 10;
		qt_conv_ml_10_w := qt_conversao_ml_w;
		qt_conv_un_cons_10_w := qt_conv_unid_cons_w;
		nr_seq_elem_mat_10_w := nr_seq_elem_mat_w;
	elsif ((dividir(qt_conv_unid_cons_w,qt_conversao_ml_w) * 100) = 50) then
		pr_conc_50_w := 50;
		qt_conv_ml_50_w := qt_conversao_ml_w;
		qt_conv_un_cons_50_w := qt_conv_unid_cons_w;
		nr_seq_elem_mat_50_w := nr_seq_elem_mat_w;
	end if;

	end;
end loop;
close c01;

if (pr_conc_10_w > 0) then

	--- Volume total utilizando soro 10% para atingir a quantidade de gramas
	qt_vol_total_10_w := dividir(qt_grama_glic_w,dividir(qt_conv_un_cons_10_w,qt_conv_ml_10_w));
	if (coalesce(qt_vol_total_10_w,0) = qt_soro_npt_w) and (ie_conc_volume_w = 'N') then  --- Verifica se somente com soro de 10% fecha o aporte hidrico
		qt_vol_cor_10_w := (qt_vol_total_10_w * qt_vol_correcao_w);
		if (qt_fase_npt_w = 1) then
			qt_vol_1_fase_w := qt_vol_cor_10_w / qt_fase_npt_w;
			qt_vol_2_fase_w := null;
			qt_vol_3_fase_w := null;
			qt_vol_4_fase_w := null;
		elsif (qt_fase_npt_w = 2) then
			qt_vol_1_fase_w := qt_vol_cor_10_w / qt_fase_npt_w;
			qt_vol_2_fase_w := qt_vol_cor_10_w / qt_fase_npt_w;
			qt_vol_3_fase_w := null;
			qt_vol_4_fase_w := null;
		elsif (qt_fase_npt_w = 3) then
			qt_vol_1_fase_w := qt_vol_cor_10_w / qt_fase_npt_w;
			qt_vol_2_fase_w := qt_vol_cor_10_w / qt_fase_npt_w;
			qt_vol_3_fase_w := qt_vol_cor_10_w / qt_fase_npt_w;
			qt_vol_4_fase_w := null;
		elsif (qt_fase_npt_w > 3) then
			qt_vol_1_fase_w := qt_vol_cor_10_w / qt_fase_npt_w;
			qt_vol_2_fase_w := qt_vol_cor_10_w / qt_fase_npt_w;
			qt_vol_3_fase_w := qt_vol_cor_10_w / qt_fase_npt_w;
			qt_vol_4_fase_w := qt_vol_cor_10_w / qt_fase_npt_w;
		end if;

		qt_diaria_w 		:= (qt_vol_total_10_w * dividir(qt_conv_un_cons_10_w,qt_conv_ml_10_w));
		qt_kcal_glicose_w	:= qt_diaria_w * qt_fator_glic_w;

		update	nut_pac_elem_mat
		set		qt_volume  		= qt_vol_total_10_w,
				qt_vol_cor 		= qt_vol_cor_10_w,
				qt_vol_1_fase	= qt_vol_1_fase_w,
				qt_vol_2_fase	= qt_vol_2_fase_w,
				qt_vol_3_fase	= qt_vol_3_fase_w,
				qt_vol_4_fase	= qt_vol_4_fase_w
		where	nr_seq_elem_mat	= nr_seq_elem_mat_10_w
		and		nr_seq_pac_elem = nr_seq_pac_elemento_w;

		update	nut_pac_elemento
		set		qt_volume_final = qt_vol_total_10_w,
				qt_diaria 		= qt_diaria_w,
				qt_kcal			= qt_kcal_glicose_w
		where	nr_sequencia 	= nr_seq_pac_elemento_w;

		select	sum(qt_kcal)
		into STRICT	qt_kcal_total_w
		from	nut_pac_elemento
		where	nr_seq_nut_pac = nr_seq_nut_pac_p
		and		obter_tipo_elemento(nr_seq_elemento) in ('C','P','L');

		select	max(qt_kcal)
		into STRICT	qt_kcal_lipideo_w
		from	nut_pac_elemento
		where	nr_seq_nut_pac = nr_seq_nut_pac_p
		and		obter_tipo_elemento(nr_seq_elemento) = 'L';

		select	max(qt_diaria)
		into STRICT	qt_kcal_proteina_w
		from	nut_pac_elemento
		where	nr_seq_nut_pac = nr_seq_nut_pac_p
		and		obter_tipo_elemento(nr_seq_elemento) = 'P';

		select	sum(qt_volume_final)
		into STRICT	qt_volume_diario_w
		from	nut_pac_elemento
		where	nr_seq_nut_pac = nr_seq_nut_pac_p;

		update	nut_pac
		set		pr_conc_glic_solucao	= (qt_diaria_w * 100) / qt_aporte_hidrico_diario_w,
				qt_kcal_total 			= qt_kcal_total_w,
				qt_kcal_kg_ped			= qt_kcal_total_w / qt_peso_w,
				qt_rel_cal_nit			= dividir((qt_kcal_glicose_w + qt_kcal_lipideo_w),(qt_kcal_proteina_w * 0.16)),
				qt_volume_diario		= qt_volume_diario_w,
				qt_gotejo_npt			= round((qt_volume_diario_w/qt_hora_inf_w)::numeric,0),
				pr_proteina				= dividir((qt_kcal_proteina_w * 100),qt_kcal_total_w),
				pr_lipidio				= dividir((qt_kcal_lipideo_w * 100),qt_kcal_total_w),
				pr_carboidrato			= dividir((qt_kcal_glicose_w * 100),qt_kcal_total_w)
		where	nr_sequencia = nr_seq_nut_pac_p;

		delete	from nut_pac_elem_mat
		where	nr_seq_elem_mat in (nr_seq_elem_mat_5_w,nr_seq_elem_mat_50_w)
		and		nr_seq_pac_elem = nr_seq_pac_elemento_w;

		ie_conc_volume_w := 'S';
		commit;
	end if;
end if;

if (pr_conc_10_w > 0) and (pr_conc_50_w > 0) and (ie_conc_volume_w = 'N') then

	--- Volume total utilizando soro 10% para atingir a quantidade de gramas
	qt_vol_total_10_w := dividir(qt_grama_glic_w,dividir(qt_conv_un_cons_10_w,qt_conv_ml_10_w));
	if (qt_vol_total_10_w > qt_soro_npt_w) then

		--- Soro Glicosado de 50%
		qt_vol_total_50_w	:= (qt_vol_total_10_w - qt_soro_npt_w) / ((pr_conc_50_w/pr_conc_10_w) - (pr_conc_10_w/pr_conc_10_w));
		qt_diaria_50_w 		:= (qt_vol_total_50_w * dividir(qt_conv_un_cons_50_w,qt_conv_ml_50_w));
		--- Soro Glicosado de 10%
		qt_vol_total_10_w 	:= (qt_soro_npt_w - qt_vol_total_50_w);
		qt_diaria_10_w 		:= (qt_vol_total_10_w * dividir(qt_conv_un_cons_10_w,qt_conv_ml_10_w));

		--- Verifica se os volumes e a quantidade diaria em g de glicose fica como deveria com os soros de 10% e 50%
		if (round((qt_vol_total_50_w + qt_vol_total_10_w)::numeric,2) = round((qt_soro_npt_w)::numeric,2)) and (round((qt_diaria_50_w + qt_diaria_10_w)::numeric,2) = round((qt_grama_glic_w)::numeric,2)) and (qt_vol_total_50_w > 0) and (qt_vol_total_10_w > 0) then
		--- Soro Glicosado de 50%
			qt_vol_cor_50_w  		  := (qt_vol_total_50_w * qt_vol_correcao_w);
			if (qt_fase_npt_w = 1) then
				qt_vol_1_fase_w := qt_vol_cor_50_w / qt_fase_npt_w;
				qt_vol_2_fase_w := null;
				qt_vol_3_fase_w := null;
				qt_vol_4_fase_w := null;
			elsif (qt_fase_npt_w = 2) then
				qt_vol_1_fase_w := qt_vol_cor_50_w / qt_fase_npt_w;
				qt_vol_2_fase_w := qt_vol_cor_50_w / qt_fase_npt_w;
				qt_vol_3_fase_w := null;
				qt_vol_4_fase_w := null;
			elsif (qt_fase_npt_w = 3) then
				qt_vol_1_fase_w := qt_vol_cor_50_w / qt_fase_npt_w;
				qt_vol_2_fase_w := qt_vol_cor_50_w / qt_fase_npt_w;
				qt_vol_3_fase_w := qt_vol_cor_50_w / qt_fase_npt_w;
				qt_vol_4_fase_w := null;
			elsif (qt_fase_npt_w > 3) then
				qt_vol_1_fase_w := qt_vol_cor_50_w / qt_fase_npt_w;
				qt_vol_2_fase_w := qt_vol_cor_50_w / qt_fase_npt_w;
				qt_vol_3_fase_w := qt_vol_cor_50_w / qt_fase_npt_w;
				qt_vol_4_fase_w := qt_vol_cor_50_w / qt_fase_npt_w;
			end if;

			update	nut_pac_elem_mat
			set		qt_volume  		= qt_vol_total_50_w,
					qt_vol_cor 		= qt_vol_cor_50_w,
					qt_vol_1_fase	= qt_vol_1_fase_w,
					qt_vol_2_fase	= qt_vol_2_fase_w,
					qt_vol_3_fase	= qt_vol_3_fase_w,
					qt_vol_4_fase	= qt_vol_4_fase_w
			where	nr_seq_elem_mat	= nr_seq_elem_mat_50_w
			and		nr_seq_pac_elem = nr_seq_pac_elemento_w;

			--- Soro Glicosado de 10%
			qt_vol_cor_10_w  		  := (qt_vol_total_10_w * qt_vol_correcao_w);
			if (qt_fase_npt_w = 1) then
				qt_vol_1_fase_w := qt_vol_cor_10_w / qt_fase_npt_w;
				qt_vol_2_fase_w := null;
				qt_vol_3_fase_w := null;
				qt_vol_4_fase_w := null;
			elsif (qt_fase_npt_w = 2) then
				qt_vol_1_fase_w := qt_vol_cor_10_w / qt_fase_npt_w;
				qt_vol_2_fase_w := qt_vol_cor_10_w / qt_fase_npt_w;
				qt_vol_3_fase_w := null;
				qt_vol_4_fase_w := null;
			elsif (qt_fase_npt_w = 3) then
				qt_vol_1_fase_w := qt_vol_cor_10_w / qt_fase_npt_w;
				qt_vol_2_fase_w := qt_vol_cor_10_w / qt_fase_npt_w;
				qt_vol_3_fase_w := qt_vol_cor_10_w / qt_fase_npt_w;
				qt_vol_4_fase_w := null;
			elsif (qt_fase_npt_w > 3) then
				qt_vol_1_fase_w := qt_vol_cor_10_w / qt_fase_npt_w;
				qt_vol_2_fase_w := qt_vol_cor_10_w / qt_fase_npt_w;
				qt_vol_3_fase_w := qt_vol_cor_10_w / qt_fase_npt_w;
				qt_vol_4_fase_w := qt_vol_cor_10_w / qt_fase_npt_w;
			end if;
			update	nut_pac_elem_mat
			set		qt_volume  		= qt_vol_total_10_w,
					qt_vol_cor 		= qt_vol_cor_10_w,
					qt_vol_1_fase	= qt_vol_1_fase_w,
					qt_vol_2_fase	= qt_vol_2_fase_w,
					qt_vol_3_fase	= qt_vol_3_fase_w,
					qt_vol_4_fase	= qt_vol_4_fase_w
			where	nr_seq_elem_mat = nr_seq_elem_mat_10_w
			and		nr_seq_pac_elem = nr_seq_pac_elemento_w;

			qt_diaria_w 		:= (qt_diaria_50_w + qt_diaria_10_w);
			qt_kcal_glicose_w	:= qt_diaria_w * qt_fator_glic_w;

			update	nut_pac_elemento
			set		qt_volume_final = (qt_vol_total_50_w + qt_vol_total_10_w),
					qt_diaria 		= qt_diaria_w,
					qt_kcal			= qt_kcal_glicose_w
			where	nr_sequencia 	= nr_seq_pac_elemento_w;

			select	sum(qt_kcal)
			into STRICT	qt_kcal_total_w
			from	nut_pac_elemento
			where	nr_seq_nut_pac = nr_seq_nut_pac_p
			and		obter_tipo_elemento(nr_seq_elemento) in ('C','P','L');

			select	max(qt_kcal)
			into STRICT	qt_kcal_lipideo_w
			from	nut_pac_elemento
			where	nr_seq_nut_pac = nr_seq_nut_pac_p
			and		obter_tipo_elemento(nr_seq_elemento) = 'L';

			select	max(qt_diaria)
			into STRICT	qt_kcal_proteina_w
			from	nut_pac_elemento
			where	nr_seq_nut_pac = nr_seq_nut_pac_p
			and		obter_tipo_elemento(nr_seq_elemento) = 'P';

			select	sum(qt_volume_final)
			into STRICT	qt_volume_diario_w
			from	nut_pac_elemento
			where	nr_seq_nut_pac = nr_seq_nut_pac_p;

			update	nut_pac
			set		pr_conc_glic_solucao	= (qt_diaria_w * 100) / qt_aporte_hidrico_diario_w,
					qt_kcal_total 			= qt_kcal_total_w,
					qt_kcal_kg_ped			= qt_kcal_total_w / qt_peso_w,
					qt_rel_cal_nit			= dividir((qt_kcal_glicose_w + qt_kcal_lipideo_w),(qt_kcal_proteina_w * 0.16)),
					qt_volume_diario		= qt_volume_diario_w,
					qt_gotejo_npt			= round((qt_volume_diario_w/qt_hora_inf_w)::numeric,0),
					pr_proteina				= dividir((qt_kcal_proteina_w * 100),qt_kcal_total_w),
					pr_lipidio				= dividir((qt_kcal_lipideo_w * 100),qt_kcal_total_w),
					pr_carboidrato			= dividir((qt_kcal_glicose_w * 100),qt_kcal_total_w)
			where	nr_sequencia = nr_seq_nut_pac_p;

			delete	from nut_pac_elem_mat
			where	nr_seq_elem_mat = nr_seq_elem_mat_5_w
			and		nr_seq_pac_elem = nr_seq_pac_elemento_w;

			ie_conc_volume_w := 'S';
			commit;
		end if;
	end if;
end if;

if (pr_conc_5_w > 0) and (pr_conc_50_w > 0) and (ie_conc_volume_w = 'N') then
	--- Volume total utilizando soro 10% para atingir a quantidade de gramas
	qt_vol_total_5_w  := dividir(qt_grama_glic_w,dividir(qt_conv_un_cons_5_w,qt_conv_ml_5_w));
	if (qt_vol_total_5_w > qt_soro_npt_w) then
		--- Soro Glicosado de 50%
		qt_vol_total_50_w	:= (qt_vol_total_5_w - qt_soro_npt_w) / ((pr_conc_50_w/pr_conc_5_w) - (pr_conc_5_w/pr_conc_5_w));
		qt_diaria_50_w 		:= (qt_vol_total_50_w * dividir(qt_conv_un_cons_50_w,qt_conv_ml_50_w));
		--- Soro Glicosado de 5%
		qt_vol_total_5_w 	:= (qt_soro_npt_w - qt_vol_total_50_w);
		qt_diaria_5_w 		:= (qt_vol_total_5_w * dividir(qt_conv_un_cons_5_w,qt_conv_ml_5_w));

		--- Verifica se os volumes e a quantidade diaria em g de glicose fica como deveria com os soros de 5% e 50%
		if (round((qt_vol_total_50_w + qt_vol_total_5_w)::numeric,2) = round((qt_soro_npt_w)::numeric,2)) and (round((qt_diaria_50_w + qt_diaria_5_w)::numeric,2) = round((qt_grama_glic_w)::numeric,2))  and (qt_vol_total_50_w > 0) and (qt_vol_total_5_w > 0) then
		--- Soro Glicosado de 50%
			qt_vol_cor_50_w  		  := (qt_vol_total_50_w * qt_vol_correcao_w);
			if (qt_fase_npt_w = 1) then
				qt_vol_1_fase_w := qt_vol_cor_50_w / qt_fase_npt_w;
				qt_vol_2_fase_w := null;
				qt_vol_3_fase_w := null;
				qt_vol_4_fase_w := null;
			elsif (qt_fase_npt_w = 2) then
				qt_vol_1_fase_w := qt_vol_cor_50_w / qt_fase_npt_w;
				qt_vol_2_fase_w := qt_vol_cor_50_w / qt_fase_npt_w;
				qt_vol_3_fase_w := null;
				qt_vol_4_fase_w := null;
			elsif (qt_fase_npt_w = 3) then
				qt_vol_1_fase_w := qt_vol_cor_50_w / qt_fase_npt_w;
				qt_vol_2_fase_w := qt_vol_cor_50_w / qt_fase_npt_w;
				qt_vol_3_fase_w := qt_vol_cor_50_w / qt_fase_npt_w;
				qt_vol_4_fase_w := null;
			elsif (qt_fase_npt_w > 3) then
				qt_vol_1_fase_w := qt_vol_cor_50_w / qt_fase_npt_w;
				qt_vol_2_fase_w := qt_vol_cor_50_w / qt_fase_npt_w;
				qt_vol_3_fase_w := qt_vol_cor_50_w / qt_fase_npt_w;
				qt_vol_4_fase_w := qt_vol_cor_50_w / qt_fase_npt_w;
			end if;

			update	nut_pac_elem_mat
			set		qt_volume  		= qt_vol_total_50_w,
					qt_vol_cor 		= qt_vol_cor_50_w,
					qt_vol_1_fase	= qt_vol_1_fase_w,
					qt_vol_2_fase	= qt_vol_2_fase_w,
					qt_vol_3_fase	= qt_vol_3_fase_w,
					qt_vol_4_fase	= qt_vol_4_fase_w
			where	nr_seq_elem_mat	= nr_seq_elem_mat_50_w
			and		nr_seq_pac_elem = nr_seq_pac_elemento_w;

			--- Soro Glicosado de 5%
			qt_vol_cor_5_w  		  := (qt_vol_total_5_w * qt_vol_correcao_w);
			if (qt_fase_npt_w = 1) then
				qt_vol_1_fase_w := qt_vol_cor_5_w / qt_fase_npt_w;
				qt_vol_2_fase_w := null;
				qt_vol_3_fase_w := null;
				qt_vol_4_fase_w := null;
			elsif (qt_fase_npt_w = 2) then
				qt_vol_1_fase_w := qt_vol_cor_5_w / qt_fase_npt_w;
				qt_vol_2_fase_w := qt_vol_cor_5_w / qt_fase_npt_w;
				qt_vol_3_fase_w := null;
				qt_vol_4_fase_w := null;
			elsif (qt_fase_npt_w = 3) then
				qt_vol_1_fase_w := qt_vol_cor_5_w / qt_fase_npt_w;
				qt_vol_2_fase_w := qt_vol_cor_5_w / qt_fase_npt_w;
				qt_vol_3_fase_w := qt_vol_cor_5_w / qt_fase_npt_w;
				qt_vol_4_fase_w := null;
			elsif (qt_fase_npt_w > 3) then
				qt_vol_1_fase_w := qt_vol_cor_5_w / qt_fase_npt_w;
				qt_vol_2_fase_w := qt_vol_cor_5_w / qt_fase_npt_w;
				qt_vol_3_fase_w := qt_vol_cor_5_w / qt_fase_npt_w;
				qt_vol_4_fase_w := qt_vol_cor_5_w / qt_fase_npt_w;
			end if;
			update	nut_pac_elem_mat
			set		qt_volume  		= qt_vol_total_5_w,
					qt_vol_cor 		= qt_vol_cor_5_w,
					qt_vol_1_fase	= qt_vol_1_fase_w,
					qt_vol_2_fase	= qt_vol_2_fase_w,
					qt_vol_3_fase	= qt_vol_3_fase_w,
					qt_vol_4_fase	= qt_vol_4_fase_w
			where	nr_seq_elem_mat = nr_seq_elem_mat_5_w
			and		nr_seq_pac_elem = nr_seq_pac_elemento_w;

			qt_diaria_w 		:= (qt_diaria_50_w + qt_diaria_5_w);
			qt_kcal_glicose_w	:= qt_diaria_w * qt_fator_glic_w;

			update	nut_pac_elemento
			set		qt_volume_final = (qt_vol_total_50_w + qt_vol_total_5_w),
					qt_diaria 		= qt_diaria_w,
					qt_kcal			= qt_kcal_glicose_w
			where	nr_sequencia 	= nr_seq_pac_elemento_w;

			select	sum(qt_kcal)
			into STRICT	qt_kcal_total_w
			from	nut_pac_elemento
			where	nr_seq_nut_pac = nr_seq_nut_pac_p
			and		obter_tipo_elemento(nr_seq_elemento) in ('C','P','L');

			select	max(qt_kcal)
			into STRICT	qt_kcal_lipideo_w
			from	nut_pac_elemento
			where	nr_seq_nut_pac = nr_seq_nut_pac_p
			and		obter_tipo_elemento(nr_seq_elemento) = 'L';

			select	max(qt_diaria)
			into STRICT	qt_kcal_proteina_w
			from	nut_pac_elemento
			where	nr_seq_nut_pac = nr_seq_nut_pac_p
			and		obter_tipo_elemento(nr_seq_elemento) = 'P';

			select	sum(qt_volume_final)
			into STRICT	qt_volume_diario_w
			from	nut_pac_elemento
			where	nr_seq_nut_pac = nr_seq_nut_pac_p;

			update	nut_pac
			set		pr_conc_glic_solucao	= (qt_diaria_w * 100) / qt_aporte_hidrico_diario_w,
					qt_kcal_total 			= qt_kcal_total_w,
					qt_kcal_kg_ped			= qt_kcal_total_w / qt_peso_w,
					qt_rel_cal_nit			= dividir((qt_kcal_glicose_w + qt_kcal_lipideo_w),(qt_kcal_proteina_w * 0.16)),
					qt_volume_diario		= qt_volume_diario_w,
					qt_gotejo_npt			= round((qt_volume_diario_w/qt_hora_inf_w)::numeric,0),
					pr_proteina				= dividir((qt_kcal_proteina_w * 100),qt_kcal_total_w),
					pr_lipidio				= dividir((qt_kcal_lipideo_w * 100),qt_kcal_total_w),
					pr_carboidrato			= dividir((qt_kcal_glicose_w * 100),qt_kcal_total_w)
			where	nr_sequencia = nr_seq_nut_pac_p;

			delete	from nut_pac_elem_mat
			where	nr_seq_elem_mat = nr_seq_elem_mat_10_w
			and		nr_seq_pac_elem = nr_seq_pac_elemento_w;

			ie_conc_volume_w := 'S';
			commit;
		end if;
	end if;
end if;

if (pr_conc_5_w > 0) and (pr_conc_10_w > 0) and (ie_conc_volume_w = 'N') then
	--- Volume total utilizando soro 10% para atingir a quantidade de gramas
	qt_vol_total_10_w  := dividir(qt_grama_glic_w,dividir(qt_conv_un_cons_10_w,qt_conv_ml_10_w));
	if (qt_vol_total_10_w < qt_soro_npt_w) then
		--- Volume total utilizando soro 5% para atingir a quantidade de gramas
		qt_vol_total_5_w  := dividir(qt_grama_glic_w,dividir(qt_conv_un_cons_5_w,qt_conv_ml_5_w));
		--- Soro Glicosado de 10%
		qt_vol_total_10_w	:= (qt_vol_total_5_w - qt_soro_npt_w) / ((pr_conc_10_w/pr_conc_5_w) - (pr_conc_5_w/pr_conc_5_w));
		qt_diaria_10_w 		:= (qt_vol_total_10_w * dividir(qt_conv_un_cons_10_w,qt_conv_ml_10_w));
		--- Soro Glicosado de 5%
		qt_vol_total_5_w 	:= (qt_soro_npt_w - qt_vol_total_10_w);
		qt_diaria_5_w 		:= (qt_vol_total_5_w * dividir(qt_conv_un_cons_5_w,qt_conv_ml_5_w));

		--- Verifica se os volumes e a quantidade diaria em g de glicose fica como deveria com os soros de 5% e 10%
		if (round((qt_vol_total_10_w + qt_vol_total_5_w)::numeric,2) = round((qt_soro_npt_w)::numeric,2)) and (round((qt_diaria_10_w + qt_diaria_5_w)::numeric,2) = round((qt_grama_glic_w)::numeric,2)) and (qt_vol_total_10_w > 0) and (qt_vol_total_5_w > 0) then
		--- Soro Glicosado de 10%
			qt_vol_cor_10_w  		  := (qt_vol_total_10_w * qt_vol_correcao_w);
			if (qt_fase_npt_w = 1) then
				qt_vol_1_fase_w := qt_vol_cor_10_w / qt_fase_npt_w;
				qt_vol_2_fase_w := null;
				qt_vol_3_fase_w := null;
				qt_vol_4_fase_w := null;
			elsif (qt_fase_npt_w = 2) then
				qt_vol_1_fase_w := qt_vol_cor_10_w / qt_fase_npt_w;
				qt_vol_2_fase_w := qt_vol_cor_10_w / qt_fase_npt_w;
				qt_vol_3_fase_w := null;
				qt_vol_4_fase_w := null;
			elsif (qt_fase_npt_w = 3) then
				qt_vol_1_fase_w := qt_vol_cor_10_w / qt_fase_npt_w;
				qt_vol_2_fase_w := qt_vol_cor_10_w / qt_fase_npt_w;
				qt_vol_3_fase_w := qt_vol_cor_10_w / qt_fase_npt_w;
				qt_vol_4_fase_w := null;
			elsif (qt_fase_npt_w > 3) then
				qt_vol_1_fase_w := qt_vol_cor_10_w / qt_fase_npt_w;
				qt_vol_2_fase_w := qt_vol_cor_10_w / qt_fase_npt_w;
				qt_vol_3_fase_w := qt_vol_cor_10_w / qt_fase_npt_w;
				qt_vol_4_fase_w := qt_vol_cor_10_w / qt_fase_npt_w;
			end if;

			update	nut_pac_elem_mat
			set		qt_volume  		= qt_vol_total_10_w,
					qt_vol_cor 		= qt_vol_cor_10_w,
					qt_vol_1_fase	= qt_vol_1_fase_w,
					qt_vol_2_fase	= qt_vol_2_fase_w,
					qt_vol_3_fase	= qt_vol_3_fase_w,
					qt_vol_4_fase	= qt_vol_4_fase_w
			where	nr_seq_elem_mat	= nr_seq_elem_mat_10_w
			and		nr_seq_pac_elem = nr_seq_pac_elemento_w;

			--- Soro Glicosado de 5%
			qt_vol_cor_5_w  		  := (qt_vol_total_5_w * qt_vol_correcao_w);
			if (qt_fase_npt_w = 1) then
				qt_vol_1_fase_w := qt_vol_cor_5_w / qt_fase_npt_w;
				qt_vol_2_fase_w := null;
				qt_vol_3_fase_w := null;
				qt_vol_4_fase_w := null;
			elsif (qt_fase_npt_w = 2) then
				qt_vol_1_fase_w := qt_vol_cor_5_w / qt_fase_npt_w;
				qt_vol_2_fase_w := qt_vol_cor_5_w / qt_fase_npt_w;
				qt_vol_3_fase_w := null;
				qt_vol_4_fase_w := null;
			elsif (qt_fase_npt_w = 3) then
				qt_vol_1_fase_w := qt_vol_cor_5_w / qt_fase_npt_w;
				qt_vol_2_fase_w := qt_vol_cor_5_w / qt_fase_npt_w;
				qt_vol_3_fase_w := qt_vol_cor_5_w / qt_fase_npt_w;
				qt_vol_4_fase_w := null;
			elsif (qt_fase_npt_w > 3) then
				qt_vol_1_fase_w := qt_vol_cor_5_w / qt_fase_npt_w;
				qt_vol_2_fase_w := qt_vol_cor_5_w / qt_fase_npt_w;
				qt_vol_3_fase_w := qt_vol_cor_5_w / qt_fase_npt_w;
				qt_vol_4_fase_w := qt_vol_cor_5_w / qt_fase_npt_w;
			end if;
			update	nut_pac_elem_mat
			set		qt_volume  		= qt_vol_total_5_w,
					qt_vol_cor 		= qt_vol_cor_5_w,
					qt_vol_1_fase	= qt_vol_1_fase_w,
					qt_vol_2_fase	= qt_vol_2_fase_w,
					qt_vol_3_fase	= qt_vol_3_fase_w,
					qt_vol_4_fase	= qt_vol_4_fase_w
			where	nr_seq_elem_mat = nr_seq_elem_mat_5_w
			and		nr_seq_pac_elem = nr_seq_pac_elemento_w;

			qt_diaria_w 		:= (qt_diaria_10_w + qt_diaria_5_w);
			qt_kcal_glicose_w	:= qt_diaria_w * qt_fator_glic_w;

			update	nut_pac_elemento
			set		qt_volume_final = (qt_vol_total_10_w + qt_vol_total_5_w),
					qt_diaria 		= qt_diaria_w,
					qt_kcal			= qt_kcal_glicose_w
			where	nr_sequencia 	= nr_seq_pac_elemento_w;

			select	sum(qt_kcal)
			into STRICT	qt_kcal_total_w
			from	nut_pac_elemento
			where	nr_seq_nut_pac = nr_seq_nut_pac_p
			and		obter_tipo_elemento(nr_seq_elemento) in ('C','P','L');

			select	max(qt_kcal)
			into STRICT	qt_kcal_lipideo_w
			from	nut_pac_elemento
			where	nr_seq_nut_pac = nr_seq_nut_pac_p
			and		obter_tipo_elemento(nr_seq_elemento) = 'L';

			select	max(qt_diaria)
			into STRICT	qt_kcal_proteina_w
			from	nut_pac_elemento
			where	nr_seq_nut_pac = nr_seq_nut_pac_p
			and		obter_tipo_elemento(nr_seq_elemento) = 'P';

			select	sum(qt_volume_final)
			into STRICT	qt_volume_diario_w
			from	nut_pac_elemento
			where	nr_seq_nut_pac = nr_seq_nut_pac_p;

			update	nut_pac
			set		pr_conc_glic_solucao	= (qt_diaria_w * 100) / qt_aporte_hidrico_diario_w,
					qt_kcal_total 			= qt_kcal_total_w,
					qt_kcal_kg_ped			= qt_kcal_total_w / qt_peso_w,
					qt_rel_cal_nit			= dividir((qt_kcal_glicose_w + qt_kcal_lipideo_w),(qt_kcal_proteina_w * 0.16)),
					qt_volume_diario		= qt_volume_diario_w,
					qt_gotejo_npt			= round((qt_volume_diario_w/qt_hora_inf_w)::numeric,0),
					pr_proteina				= dividir((qt_kcal_proteina_w * 100),qt_kcal_total_w),
					pr_lipidio				= dividir((qt_kcal_lipideo_w * 100),qt_kcal_total_w),
					pr_carboidrato			= dividir((qt_kcal_glicose_w * 100),qt_kcal_total_w)
			where	nr_sequencia = nr_seq_nut_pac_p;

			delete	from nut_pac_elem_mat
			where	nr_seq_elem_mat = nr_seq_elem_mat_50_w
			and		nr_seq_pac_elem = nr_seq_pac_elemento_w;

			ie_conc_volume_w := 'S';
			commit;
		end if;
	end if;
end if;

if (pr_conc_50_w > 0) and (ie_conc_volume_w = 'N') then

	--- Volume total utilizando soro 10% para atingir a quantidade de gramas
	qt_vol_total_50_w := dividir(qt_grama_glic_w,dividir(qt_conv_un_cons_50_w,qt_conv_ml_50_w));

	qt_vol_cor_50_w := (qt_vol_total_50_w * qt_vol_correcao_w);
	if (qt_fase_npt_w = 1) then
		qt_vol_1_fase_w := qt_vol_cor_50_w / qt_fase_npt_w;
		qt_vol_2_fase_w := null;
		qt_vol_3_fase_w := null;
		qt_vol_4_fase_w := null;
	elsif (qt_fase_npt_w = 2) then
		qt_vol_1_fase_w := qt_vol_cor_50_w / qt_fase_npt_w;
		qt_vol_2_fase_w := qt_vol_cor_50_w / qt_fase_npt_w;
		qt_vol_3_fase_w := null;
		qt_vol_4_fase_w := null;
	elsif (qt_fase_npt_w = 3) then
		qt_vol_1_fase_w := qt_vol_cor_50_w / qt_fase_npt_w;
		qt_vol_2_fase_w := qt_vol_cor_50_w / qt_fase_npt_w;
		qt_vol_3_fase_w := qt_vol_cor_50_w / qt_fase_npt_w;
		qt_vol_4_fase_w := null;
	elsif (qt_fase_npt_w > 3) then
		qt_vol_1_fase_w := qt_vol_cor_50_w / qt_fase_npt_w;
		qt_vol_2_fase_w := qt_vol_cor_50_w / qt_fase_npt_w;
		qt_vol_3_fase_w := qt_vol_cor_50_w / qt_fase_npt_w;
		qt_vol_4_fase_w := qt_vol_cor_50_w / qt_fase_npt_w;
	end if;

	qt_diaria_w 		:= (qt_vol_total_50_w * dividir(qt_conv_un_cons_50_w,qt_conv_ml_50_w));
	qt_kcal_glicose_w	:= qt_diaria_w * qt_fator_glic_w;

	update	nut_pac_elem_mat
	set		qt_volume  		= qt_vol_total_50_w,
			qt_vol_cor 		= qt_vol_cor_50_w,
			qt_vol_1_fase	= qt_vol_1_fase_w,
			qt_vol_2_fase	= qt_vol_2_fase_w,
			qt_vol_3_fase	= qt_vol_3_fase_w,
			qt_vol_4_fase	= qt_vol_4_fase_w
	where	nr_seq_elem_mat	= nr_seq_elem_mat_50_w
	and		nr_seq_pac_elem = nr_seq_pac_elemento_w;

	update	nut_pac_elemento
	set		qt_volume_final = qt_vol_total_50_w,
			qt_diaria 		= qt_diaria_w,
			qt_kcal			= qt_kcal_glicose_w
	where	nr_sequencia 	= nr_seq_pac_elemento_w;

	select	sum(qt_kcal)
	into STRICT	qt_kcal_total_w
	from	nut_pac_elemento
	where	nr_seq_nut_pac = nr_seq_nut_pac_p
	and		obter_tipo_elemento(nr_seq_elemento) in ('C','P','L');

	select	max(qt_kcal)
	into STRICT	qt_kcal_lipideo_w
	from	nut_pac_elemento
	where	nr_seq_nut_pac = nr_seq_nut_pac_p
	and		obter_tipo_elemento(nr_seq_elemento) = 'L';

	select	max(qt_diaria)
	into STRICT	qt_kcal_proteina_w
	from	nut_pac_elemento
	where	nr_seq_nut_pac = nr_seq_nut_pac_p
	and		obter_tipo_elemento(nr_seq_elemento) = 'P';

	select	sum(qt_volume_final)
	into STRICT	qt_volume_diario_w
	from	nut_pac_elemento
	where	nr_seq_nut_pac = nr_seq_nut_pac_p;

	update	nut_pac
	set		pr_conc_glic_solucao	= (qt_diaria_w * 100) / qt_aporte_hidrico_diario_w,
			qt_kcal_total 			= qt_kcal_total_w,
			qt_kcal_kg_ped			= qt_kcal_total_w / qt_peso_w,
			qt_rel_cal_nit			= dividir((qt_kcal_glicose_w + qt_kcal_lipideo_w),(qt_kcal_proteina_w * 0.16)),
			qt_volume_diario		= qt_volume_diario_w,
			qt_gotejo_npt			= round((qt_volume_diario_w/qt_hora_inf_w)::numeric,0),
			pr_proteina				= dividir((qt_kcal_proteina_w * 100),qt_kcal_total_w),
			pr_lipidio				= dividir((qt_kcal_lipideo_w * 100),qt_kcal_total_w),
			pr_carboidrato			= dividir((qt_kcal_glicose_w * 100),qt_kcal_total_w)
	where	nr_sequencia = nr_seq_nut_pac_p;

	delete	from nut_pac_elem_mat
	where	nr_seq_elem_mat in (nr_seq_elem_mat_5_w,nr_seq_elem_mat_10_w)
	and		nr_seq_pac_elem = nr_seq_pac_elemento_w;

	ie_conc_volume_w := 'S';
	commit;
end if;

open c02;
loop
fetch c02 into
		nr_seq_elemento_w,
      	qt_kcal_elem_w,
		qt_kcal_total_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	begin
	pr_total_w := dividir(qt_kcal_elem_w * 100, qt_kcal_total_w);
	update	nut_pac_elemento
	set		pr_total		= coalesce(pr_total_w,0)
	where	nr_sequencia	= nr_seq_elemento_w;
	end;
end loop;
close c02;
commit;

CALL calcula_osmolaridade_npt_ped(nr_seq_nut_pac_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE controle_soro_glic_npt ( nr_seq_nut_pac_p nut_pac.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
