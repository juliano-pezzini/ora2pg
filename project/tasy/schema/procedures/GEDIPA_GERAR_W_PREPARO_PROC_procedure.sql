-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gedipa_gerar_w_preparo_proc ( nr_seq_etapa_p bigint, nr_seq_area_prep_p bigint, nr_sequencia_proc_p bigint, dt_horario_p timestamp, nr_seq_etapa_hor_p gedipa_etapa_hor.nr_sequencia%type ) AS $body$
DECLARE


nr_sequencia_w 				bigint;
nr_seq_gedipa_cabine_w 		bigint;
cd_material_w 				bigint;
nr_seq_lote_fornec_w 		bigint;
cd_unidade_medida_w 		varchar(30);
qt_dose_w					double precision;
cd_unidade_medida_dose_w	varchar(30);
qt_dose_util_w              double precision;
ie_setar_qt_util_w 			varchar(1);
nm_usuario_w				usuario.nm_usuario%type;
nr_seq_ficha_tecnica_w		material.nr_seq_ficha_tecnica%type;
cd_material_ant_w			material.cd_material%type;
nr_seq_ficha_tecnica_ant_w  material.nr_seq_ficha_tecnica%type;

c01 CURSOR FOR
	SELECT 	a.nr_sequencia,
			a.cd_material,			
			a.nr_seq_lote_fornec,
			b.cd_unidade_medida_consumo,
			b.nr_seq_ficha_tecnica
	from 	gedipa_estoque_cabine a,
			material b
	where 	a.cd_material = b.cd_material
	and 	a.cd_material in (	SELECT 	w.cd_material
								from 	prescr_material w,
										prescr_procedimento x,
										prescr_mat_hor y,
										gedipa_etapa_hor z
								where 	z.nr_seq_etapa_gedipa = nr_seq_etapa_p
								and		z.dt_horario = dt_horario_p								
								and     y.nr_sequencia = z.nr_seq_horario
								and		y.nr_seq_material = w.nr_sequencia
								and		y.nr_prescricao = w.nr_prescricao
								and		w.nr_sequencia_proc = x.nr_sequencia								
								and		w.nr_prescricao = x.nr_prescricao
								and		w.nr_sequencia_proc = nr_sequencia_proc_p)
	and 	a.nr_seq_area_prep = nr_seq_area_prep_p
	and		qt_estoque > 0
	
union

	select 	a.nr_sequencia,
			a.cd_material,			
			a.nr_seq_lote_fornec,
			b.cd_unidade_medida_consumo,
			b.nr_seq_ficha_tecnica
	from 	gedipa_estoque_cabine a,
			material b
	where 	a.cd_material = b.cd_material
	and 	b.nr_seq_ficha_tecnica in (	select 	coalesce(v.nr_seq_ficha_tecnica, 0)
								   	  	from	material v,
												prescr_material w,
												prescr_procedimento x,
												prescr_mat_hor y,
												gedipa_etapa_hor z
										where 	v.cd_material = w.cd_material
										and		z.nr_seq_etapa_gedipa = nr_seq_etapa_p
										and		z.dt_horario = dt_horario_p										
										and     y.nr_sequencia = z.nr_seq_horario
										and		y.nr_seq_material = w.nr_sequencia
										and		y.nr_prescricao = w.nr_prescricao
										and		w.nr_sequencia_proc = x.nr_sequencia								
										and		w.nr_prescricao = x.nr_prescricao
										and		w.nr_sequencia_proc = nr_sequencia_proc_p)
	and 	a.nr_seq_area_prep = nr_seq_area_prep_p
	and		qt_estoque > 0;


BEGIN

nm_usuario_w := wheb_usuario_pck.get_nm_usuario;

ie_setar_qt_util_w := 'S';

delete 	FROM w_gedipa_preparo
where 	nm_usuario = nm_usuario_w
and		coalesce(ie_tipo_material,'M') in ('A', 'M');

open c01;
loop
fetch c01 into
	nr_seq_gedipa_cabine_w,
	cd_material_w,
	nr_seq_lote_fornec_w,
	cd_unidade_medida_w,
	nr_seq_ficha_tecnica_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select	max(a.qt_dose),
			max(a.cd_unidade_medida_dose)
	into STRICT	qt_dose_w,
			cd_unidade_medida_dose_w
	from	gedipa_etapa_hor a,
			material b
	where 	a.cd_material = b.cd_material
	and		a.nr_seq_etapa_gedipa = nr_seq_etapa_p
	and 	a.dt_horario	= dt_horario_p	
	and		((b.cd_material = cd_material_w) or (b.nr_seq_ficha_tecnica = nr_seq_ficha_tecnica_w));

	select 	nextval('w_gedipa_preparo_seq')
	into STRICT	nr_sequencia_w
	;

	qt_dose_util_w := 0;
	if  ((coalesce(cd_material_ant_w::text, '') = '') or ((cd_material_w <> cd_material_ant_w) or (nr_seq_ficha_tecnica_w <> nr_seq_ficha_tecnica_ant_w))) then
		qt_dose_util_w := obter_dose_convertida_quimio(cd_material_w, qt_dose_w, cd_unidade_medida_dose_w, cd_unidade_medida_w);
	end if;

	insert 	into w_gedipa_preparo(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_gedipa_cabine,
			cd_material,
			nr_seq_lote_fornec,
			qt_dose_util,
			cd_unidade_medida,
			ie_tipo_material,
			nr_seq_etapa_hor)
		values (nr_sequencia_w,
			clock_timestamp(),
			nm_usuario_w,
			clock_timestamp(),
			nm_usuario_w,
			nr_seq_gedipa_cabine_w,
			cd_material_w,
			nr_seq_lote_fornec_w,
			qt_dose_util_w,
			cd_unidade_medida_w,
			'M',
			nr_seq_etapa_hor_p);
			
	cd_material_ant_w			:= cd_material_w;
	nr_seq_ficha_tecnica_ant_w	:= nr_seq_ficha_tecnica_w;

	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gedipa_gerar_w_preparo_proc ( nr_seq_etapa_p bigint, nr_seq_area_prep_p bigint, nr_sequencia_proc_p bigint, dt_horario_p timestamp, nr_seq_etapa_hor_p gedipa_etapa_hor.nr_sequencia%type ) FROM PUBLIC;

