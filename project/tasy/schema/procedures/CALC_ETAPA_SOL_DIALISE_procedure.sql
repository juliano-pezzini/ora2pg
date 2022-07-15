-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calc_etapa_sol_dialise ( nr_prescricao_p bigint, nr_seq_hd_prescricao_p bigint, nr_seq_solucao_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_inicio_prescr_w			prescr_medica.dt_inicio_prescr%type;
ie_unid_vel_inf_w			prescr_solucao.ie_unid_vel_inf%type;
qt_dosagem_w				prescr_solucao.qt_dosagem%type;
ie_categoria_w 				hd_prescricao.ie_categoria%type;
qt_hora_sessao_w			hd_prescricao.qt_hora_sessao%type;
qt_min_sessao_w				hd_prescricao.qt_min_sessao%type;
cont_w						bigint;
volTotal_w					double precision;
qtTotalDose_w				double precision;
nr_ocorrencia_w				bigint;
cd_estabelecimento_w 		prescr_medica.cd_estabelecimento%type;
nr_sequencia_w				prescr_material.nr_sequencia%type;
cd_material_w				prescr_material.cd_material%type;
qt_unitaria_w				prescr_material.qt_unitaria%type;
cd_unidade_medida_dose_w 	prescr_material.cd_unidade_medida_dose%type;
qt_material_w				prescr_material.qt_material%type;
qt_total_dispensar_w 		prescr_material.qt_total_dispensar%type;
ie_regra_disp_w				varchar(15);
ds_erro_w					varchar(255);
ds_horarios_w				varchar(255);
ds_horarios_w2				varchar(255);

C01 CURSOR FOR
	SELECT	a.cd_estabelecimento,
			b.nr_sequencia,
			b.cd_material,
			b.qt_unitaria,
			b.cd_unidade_medida_dose,
			b.qt_material
	from	prescr_medica a,
			prescr_material b
	where	a.nr_prescricao = b.nr_prescricao
	and		a.nr_prescricao = nr_prescricao_p
	and		b.nr_sequencia_solucao = nr_seq_solucao_p;


BEGIN

select	max(dt_inicio_prescr)
into STRICT	dt_inicio_prescr_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p;

select 	count(nr_sequencia)
into STRICT	cont_w
from	prescr_material
where 	nr_prescricao = nr_prescricao_p
and 	nr_sequencia_solucao = nr_seq_solucao_p  LIMIT 1;

if (cont_w > 0) then

	select	max(ie_unid_vel_inf),
			max(qt_dosagem)
	into STRICT	ie_unid_vel_inf_w,
			qt_dosagem_w
	from	prescr_solucao
	where	nr_seq_solucao = nr_seq_solucao_p
	and		nr_prescricao = nr_prescricao_p;

	select	max(coalesce(ie_categoria,'N')),
			max(qt_hora_sessao),
			max(qt_min_sessao)
	into STRICT	ie_categoria_w,
			qt_hora_sessao_w,
			qt_min_sessao_w
	from	hd_prescricao
	where	nr_sequencia = nr_seq_hd_prescricao_p
	and		nr_prescricao = nr_prescricao_p;

	if (ie_categoria_w = 'C') and
		((qt_hora_sessao_w IS NOT NULL AND qt_hora_sessao_w::text <> '') or (qt_min_sessao_w IS NOT NULL AND qt_min_sessao_w::text <> '')) and (qt_dosagem_w IS NOT NULL AND qt_dosagem_w::text <> '') then

		if (coalesce(qt_hora_sessao_w,0) > 0) then

			if (ie_unid_vel_inf_w = 'mlm') then
				volTotal_w := qt_hora_sessao_w * (qt_dosagem_w * 60);
			else
				volTotal_w := qt_hora_sessao_w * qt_dosagem_w;
			end if;
		elsif (coalesce(qt_min_sessao_w,0) > 0) then

			if (ie_unid_vel_inf_w = 'mlm') then
				volTotal_w := qt_min_sessao_w * qt_dosagem_w;
			else
				volTotal_w := round(qt_min_sessao_w/60) * (qt_dosagem_w * 60);
			end if;
		end if;

		select 	sum(qt_solucao)
		into STRICT	qtTotalDose_w
		from	prescr_material
		where	nr_prescricao = nr_prescricao_p
		and		nr_sequencia_solucao = nr_seq_solucao_p;

		if (coalesce(volTotal_w,0) > 0) then

			nr_ocorrencia_w := coalesce(ceil(dividir(volTotal_w,qtTotalDose_w)),0);

			update  prescr_material
			set		nr_ocorrencia = nr_ocorrencia_w
			where	nr_prescricao = nr_prescricao_p
			and 	nr_sequencia_solucao = nr_seq_solucao_p;

			update	prescr_solucao
			set		nr_etapas = nr_ocorrencia_w
			where	nr_prescricao = nr_prescricao_p
			and 	nr_seq_solucao = nr_seq_solucao_p;

			open C01;
			loop
			fetch C01 into
				cd_estabelecimento_w,
				nr_sequencia_w,
				cd_material_w,
				qt_unitaria_w,
				cd_unidade_medida_dose_w,
				qt_material_w;
				EXIT WHEN NOT FOUND; /* apply on C01 */
				begin

					SELECT * FROM obter_quant_dispensar(cd_estabelecimento_w, cd_material_w, nr_prescricao_p, 0, null, null, qt_unitaria_w, 0, nr_ocorrencia_w, null, null, cd_unidade_medida_dose_w, null, qt_material_w, qt_total_dispensar_w, ie_regra_disp_w, ds_erro_w, 'N', 'N') INTO STRICT qt_material_w, qt_total_dispensar_w, ie_regra_disp_w, ds_erro_w;

					update 	prescr_material
					set		qt_total_dispensar = qt_total_dispensar_w
					where	nr_prescricao = nr_prescricao_p
					and		nr_sequencia = nr_sequencia_w;
				end;
			end loop;
			close C01;

			ds_horarios_w := null;
			ds_horarios_w2 := null;

			SELECT * FROM Calcula_Horarios_Etapas(dt_inicio_prescr_w, nr_ocorrencia_w, dividir(qt_hora_sessao_w,nr_ocorrencia_w), nm_usuario_p, null, qt_hora_sessao_w, ds_horarios_w, ds_horarios_w2, 'N', 'S') INTO STRICT ds_horarios_w, ds_horarios_w2;

			if (ds_horarios_w2 IS NOT NULL AND ds_horarios_w2::text <> '') and (substr(ds_horarios_w2,length(ds_horarios_w2),1) = 'N') then

				ds_horarios_w2 := substr(ds_horarios_w2,1,length(ds_horarios_w2) - 1);
			end if;

			update 	prescr_solucao
			set 	ds_horarios = ds_horarios_w || ds_horarios_w2,
					hr_prim_horario = obter_prim_dshorarios(ds_horarios_w || ds_horarios_w2)
			where	nr_prescricao = nr_prescricao_p
			and 	nr_seq_solucao = nr_seq_solucao_p;
		end if;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calc_etapa_sol_dialise ( nr_prescricao_p bigint, nr_seq_hd_prescricao_p bigint, nr_seq_solucao_p bigint, nm_usuario_p text) FROM PUBLIC;

