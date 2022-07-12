-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_volume_total_dil ( NR_SEQUENCIA_P bigint, NR_PRESCRICAO_P bigint) RETURNS varchar AS $body$
DECLARE


cd_material_w			integer;
cd_medic_w			integer;
qt_dose_w			double precision;
qt_dose_ml_w			double precision;
cd_unid_med_dose_w		varchar(30) := '';
ds_material_w			varchar(100);
ds_material_ww			varchar(100);
ds_reduzida_w			varchar(100);
ds_diluir_w			varchar(255) := '';
ds_rediluir_w			varchar(255) := '';
ds_retorno_w			varchar(2000) := '';
ds_reconstituir_w		varchar(2000) := '';
ie_agrupador_w			smallint;
qt_dose_mat_w			double precision;
qt_dose_mat_str_w		varchar(20) := '';
cd_unid_med_dose_mat_w		varchar(30) := '';
qt_solucao_w			double precision := 0;
qt_solucao_str_w		varchar(10) :='';
qt_solucao_ww			double precision := 0;
qt_min_aplicacao_w		smallint  := 0;
qt_min_aplicacao_ant_w		smallint  := 0;
qt_hora_aplicacao_ant_w		smallint  := 0;
qt_hora_aplicacao_w		smallint  := 0;
ds_min_aplicacao_w		varchar(255) := '';
cd_volume_final_w		double precision := 0;
mascara_w			smallint := 0;
qt_dose_str_w			varchar(20) := '';
cd_volume_final_str_w		varchar(20) := '';
qt_diluicao_w			double precision := 0;
cd_diluente_w			integer  := 0;
ds_diluente_w			varchar(100) := '';
nr_sequencia_composto_w		bigint;
qt_diluicao_str_w		varchar(20) := '';
ds_intervalo_w			varchar(50) := '';
cd_unidade_medida_w		varchar(30);
ds_conv_ml_w			varchar(20) := '';
qt_conv_ml_w			double precision;
cd_estabelecimento_w		smallint;
ie_descr_redu_dil_w		varchar(1);

ds_aux_diluir_w			varchar(30);
ie_via_aplicacao_w		varchar(5);
cd_intervalo_w			varchar(7);
qt_ml_diluente_w		double precision;
ds_volume_w			varchar(100);
ds_tempo_w			varchar(100);
qt_dose_medic_ml_w		double precision;
ds_aplicar_w			varchar(200);
ds_diluicao_edit_w		varchar(2000);
ie_aplicar_w			varchar(1);
ds_dose_diluicao_w		varchar(100);
qt_dose_unid_med_cons_w		double precision;
qt_vol_adic_reconst_w		double precision;
nr_agrupamento_w		double precision;
qt_agrupamento_w		bigint;
nr_sequencia_princ_w		bigint;
qt_totalml_reconst_w		double precision;
ds_material_princ_w		varchar(100);
qt_dose_ml_diluicao_w		double precision := 0;
ds_material_composto_w		varchar(100);
qt_dose_composto_w		double precision;
cd_um_dose_composto_w		varchar(30);
ds_materiais_compostos_w	varchar(500);

qt_dose_mat_comp_w		double precision;
qt_min_aplicacao_comp_w		smallint := 0;
qt_hora_aplicacao_comp_w	smallint := 0;
cd_unid_med_dose_mat_comp_w	varchar(30);
qt_solucao_comp_ww		double precision := 0;
cd_unidade_medida_comp_w	varchar(30);
cd_medic_comp_w			integer;
cd_estabelecimento_comp_w	smallint;
cd_intervalo_comp_w		varchar(7);
ie_via_aplicacao_comp_w		varchar(5);

cd_material_comp_w		integer;
qt_dose_comp_w			double precision;
qt_vol_adic_reconst_comp_w	double precision;
qt_min_aplicacao_ant_comp_w	smallint := 0;
qt_hora_aplicacao_ant_comp_w	smallint := 0;
cd_unid_med_dose_comp_w		varchar(30);
ie_agrupador_comp_w		smallint;
qt_solucao_comp_w		double precision;
qt_dose_ml_comp_w		double precision;
ds_material_comp_ww		varchar(100);
ds_reduzida_comp_w		varchar(100);
ds_reconstituir_comp_w		varchar(2000);
ds_intervalo_comp_w		varchar(50);
qt_conv_ml_comp_w		double precision;
ds_conv_ml_comp_w		varchar(20) := '';
qt_dose_unid_med_cons_comp_w	double precision;
ds_material_comp_w		varchar(100);
cd_volume_final_comp_w		double precision;
cd_volume_final_str_comp_w	varchar(20) := '';
ds_aplicar_todos_comp_w		varchar(300);
ds_tempo_comp_w			varchar(100);
ds_aplicar_comp_w		varchar(200);
ds_volume_comp_w		varchar(100);
qt_conv_ml_tot_comp_w		double precision;
ie_soma_total_w			varchar(2);
ds_volume_total_w		varchar(255);

c01 CURSOR FOR
	SELECT	a.cd_material,
		a.qt_dose,
		coalesce(a.qt_vol_adic_reconst,0),
		a.qt_min_aplicacao,
		a.qt_hora_aplicacao,
		a.cd_unidade_medida_dose,
		a.ie_agrupador,
		a.qt_solucao,
		obter_conversao_ml(a.cd_material,a.qt_dose,a.cd_unidade_medida_dose),
		substr(b.ds_material,1,100),
		substr(b.ds_reduzida,1,100)
	from 	material b,
		prescr_material a
	where 	((a.nr_sequencia_diluicao = nr_sequencia_p) or (a.nr_sequencia = nr_sequencia_p))
	  and 	a.nr_prescricao = nr_prescricao_p
	  and	a.cd_material = b.cd_material
	  and	a.ie_agrupador IN (3,7,9)
	  and	coalesce(a.dt_suspensao::text, '') = ''
	order by a.ie_agrupador desc;

c02 CURSOR FOR
	SELECT	substr(CASE WHEN 'N'='S' THEN a.ds_reduzida  ELSE a.ds_material END ,1,100),
		b.qt_dose,
		b.cd_unidade_medida_dose,
		b.nr_sequencia
	from	material a,
		prescr_material b
	where	a.cd_material = b.cd_material
	and	b.nr_prescricao = nr_prescricao_p
	and	nr_agrupamento = nr_agrupamento_w
	and	b.nr_sequencia <> nr_sequencia_p
	and	coalesce(b.dt_suspensao::text, '') = ''
	and	b.ie_agrupador = 1;

c03 CURSOR FOR
SELECT	a.cd_material,
	a.qt_dose,
	coalesce(a.qt_vol_adic_reconst,0),
	a.qt_min_aplicacao,
	a.qt_hora_aplicacao,
	a.cd_unidade_medida_dose,
	a.ie_agrupador,
	a.qt_solucao,
	obter_conversao_ml(a.cd_material,a.qt_dose,a.cd_unidade_medida_dose),
	substr(b.ds_material,1,100),
	substr(b.ds_reduzida,1,100),
	'S' ie_soma_total
from 	material b,
	prescr_material a
where 	a.nr_sequencia_diluicao	= nr_sequencia_composto_w
and 	a.nr_prescricao = nr_prescricao_p
and	a.cd_material = b.cd_material
and	coalesce(a.dt_suspensao::text, '') = ''
and	a.ie_agrupador in (3,7,9)

union

select	b.cd_material,
	b.qt_dose,
	coalesce(b.qt_vol_adic_reconst,0),
	b.qt_min_aplicacao,
	b.qt_hora_aplicacao,
	b.cd_unidade_medida_dose,
	b.ie_agrupador,
	b.qt_solucao,
	obter_conversao_ml(b.cd_material,b.qt_dose,b.cd_unidade_medida_dose),
	substr(a.ds_material,1,100),
	substr(a.ds_reduzida,1,100),
	'S' ie_soma_total
from	material a,
	prescr_material b
where	a.cd_material = b.cd_material
and	b.nr_prescricao = nr_prescricao_p
and	nr_agrupamento = nr_agrupamento_w
and	b.nr_sequencia = nr_sequencia_composto_w
and	b.ie_agrupador = 1
and	coalesce(b.dt_suspensao::text, '') = ''
and 	not exists (	select	1
			from	prescr_material x
			where	x.nr_prescricao = b.nr_prescricao
			and	x.nr_sequencia_diluicao = b.nr_sequencia
			and	coalesce(x.dt_suspensao::text, '') = ''
			and	ie_agrupador in (3,7,9))

union

select	b.cd_material,
	b.qt_dose,
	coalesce(b.qt_vol_adic_reconst,0),
	b.qt_min_aplicacao,
	b.qt_hora_aplicacao,
	b.cd_unidade_medida_dose,
	b.ie_agrupador,
	b.qt_solucao,
	obter_conversao_ml(b.cd_material,b.qt_dose,b.cd_unidade_medida_dose),
	substr(a.ds_material,1,100),
	substr(a.ds_reduzida,1,100),
	'N' ie_soma_total
from	material a,
	prescr_material b
where	a.cd_material = b.cd_material
and	b.nr_prescricao = nr_prescricao_p
and	nr_agrupamento = nr_agrupamento_w
and	1 = 2
and	b.nr_sequencia = nr_sequencia_p
and	coalesce(b.dt_suspensao::text, '') = ''
and	b.ie_agrupador = 1;


BEGIN

select	max(nr_agrupamento)
into STRICT	nr_agrupamento_w
from	prescr_material
where	nr_prescricao	= nr_prescricao_p
and	nr_sequencia	= nr_sequencia_p
and	coalesce(dt_suspensao::text, '') = '';

select	count(*)
into STRICT	qt_agrupamento_w
from	prescr_material b
where	b.nr_prescricao = nr_prescricao_p
and	nr_agrupamento = nr_agrupamento_w
and	b.nr_sequencia <> nr_sequencia_p
and	coalesce(b.dt_suspensao::text, '') = ''
and	b.ie_agrupador = 1;

select	min(nr_sequencia)
into STRICT	nr_sequencia_princ_w
from	prescr_material
where	ie_agrupador	= 1
and	nr_agrupamento	= nr_agrupamento_w
and	ie_item_superior = 'S'
and	coalesce(dt_suspensao::text, '') = ''
and	nr_prescricao	= nr_prescricao_p;

if (coalesce(nr_sequencia_princ_w,0) = 0) then
	select	min(nr_sequencia)
	into STRICT	nr_sequencia_princ_w
	from	prescr_material
	where	ie_agrupador	= 1
	and	nr_agrupamento	= nr_agrupamento_w
	and	nr_prescricao	= nr_prescricao_p
	and	coalesce(dt_suspensao::text, '') = '';
end if;

/*if	(nr_sequencia_princ_w = nr_sequencia_p) and
	(qt_agrupamento_w > 0) then */
if (nr_sequencia_princ_w = nr_sequencia_p) then

	select	b.qt_dose,
		b.qt_min_aplicacao,
		b.qt_hora_aplicacao,
		b.cd_unidade_medida_dose,
		b.qt_solucao,
		b.cd_unidade_medida,
		b.cd_material,
		a.cd_estabelecimento,
		b.cd_intervalo,
		b.ie_via_aplicacao,
		substr(CASE WHEN 'N'='S' THEN c.ds_reduzida  ELSE c.ds_material END ,1,100)
	into STRICT	qt_dose_mat_w,
		qt_min_aplicacao_w,
		qt_hora_aplicacao_w,
		cd_unid_med_dose_mat_w,
		qt_solucao_ww,
		cd_unidade_medida_w,
		cd_medic_w,
		cd_estabelecimento_w,
		cd_intervalo_w,
		ie_via_aplicacao_w,
		ds_material_princ_w
	from 	material c,
		prescr_material b,
		prescr_medica a
	where 	a.nr_prescricao	= b.nr_prescricao
	and	c.cd_material = b.cd_material
	and	b.nr_sequencia	= nr_sequencia_p
	and	a.nr_prescricao	= nr_prescricao_p
	and	coalesce(b.dt_suspensao::text, '') = ''
	and	b.ie_agrupador	in (1, 14);

	select	coalesce(max(ie_aplicar),'N')
	into STRICT	ie_aplicar_w
	from	parametro_medico
	where	cd_estabelecimento	= cd_estabelecimento_w;

	if (cd_intervalo_w IS NOT NULL AND cd_intervalo_w::text <> '') then
		select	max(ds_prescricao)
		into STRICT	ds_intervalo_w
		from	intervalo_prescricao
		where	cd_intervalo	= cd_intervalo_w;

		if (ie_via_aplicacao_w IS NOT NULL AND ie_via_aplicacao_w::text <> '') then
			ds_intervalo_w	:= ds_intervalo_w ||' '||ie_via_aplicacao_w;
		end if;
	end if;

	select	obter_conversao_ml(cd_medic_w,qt_dose_mat_w,cd_unid_med_dose_mat_w)
	into STRICT	qt_conv_ml_w
	;

	if (qt_conv_ml_w > 0) and (upper(cd_unid_med_dose_mat_w) <> upper(obter_unid_med_usua('ML'))) then
		if (qt_conv_ml_w >= 1) then
			ds_conv_ml_w	:= to_char(qt_conv_ml_w)||' '||obter_unid_med_usua('ml');
		else
			ds_conv_ml_w	:= '0'||to_char(qt_conv_ml_w)||' '||obter_unid_med_usua('ml');
		end if;
	end if;

	qt_dose_mat_str_w	:= qt_dose_mat_w;

	open	c01;
	loop
	fetch	c01 into
		cd_material_w,
		qt_dose_w,
		qt_vol_adic_reconst_w,
		qt_min_aplicacao_ant_w,
		qt_hora_aplicacao_ant_w,
		cd_unid_med_dose_w,
		ie_agrupador_w,
		qt_solucao_w,
		qt_dose_ml_w,
		ds_material_ww,
		ds_reduzida_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin

		qt_totalml_reconst_w	:= coalesce(qt_totalml_reconst_w,0) + coalesce(qt_dose_ml_w,0);

		if (cd_material_w IS NOT NULL AND cd_material_w::text <> '') and (qt_dose_w IS NOT NULL AND qt_dose_w::text <> '') and (cd_unid_med_dose_w IS NOT NULL AND cd_unid_med_dose_w::text <> '') and (ie_agrupador_w = 9) then
			begin

			select	obter_conversao_ml(cd_material_w,qt_dose_w + qt_vol_adic_reconst_w,cd_unid_med_dose_w)
			into STRICT	qt_conv_ml_w
			;

			if (upper(cd_unid_med_dose_mat_w) = upper(obter_unid_med_usua('ML'))) then
				begin
				qt_conv_ml_w	:= qt_dose_mat_w;
				end;
			else
				begin
				qt_dose_unid_med_cons_w	:= obter_conversao_unid_med_cons(cd_medic_w,cd_unid_med_dose_mat_w,qt_dose_mat_w);
				qt_conv_ml_w		:= qt_dose_unid_med_cons_w * qt_conv_ml_w;
				end;
			end if;

			if (qt_conv_ml_w > 0) then
				if (qt_conv_ml_w >= 1) then
					ds_conv_ml_w	:= to_char(qt_conv_ml_w)||' '||obter_unid_med_usua('ml');
				else
					ds_conv_ml_w	:= '0'||to_char(qt_conv_ml_w)||' '||obter_unid_med_usua('ml');
				end if;
			end if;

			select 	CASE WHEN 'N'='S' THEN ds_reduzida_w  ELSE ds_material_ww END
		   	into STRICT	ds_material_w
		   	;

			if (qt_dose_w < 1) or (mod(qt_dose_w, trunc(qt_dose_w)) <> 0) then
				mascara_w	:= 0;
			else
				mascara_w	:= 1;
			end if;

			select 	CASE WHEN mascara_w=0 THEN  campo_mascara(qt_dose_w, 2)  ELSE campo_mascara(qt_dose_w, 0) END
			into STRICT	qt_dose_str_w
			;

			ds_reconstituir_w := 	ds_reconstituir_w || obter_desc_expressao(346565) ||cd_unidade_medida_w|| obter_desc_expressao(310214) || ds_material_princ_w ||
					' em '||replace(qt_dose_str_w,'.',',')||' '||cd_unid_med_dose_w||
					' de '||ds_material_w || chr(13) || chr(10);
			end;
		end if;

		if (cd_material_w IS NOT NULL AND cd_material_w::text <> '') and (qt_dose_w IS NOT NULL AND qt_dose_w::text <> '') and (cd_unid_med_dose_w IS NOT NULL AND cd_unid_med_dose_w::text <> '') and (ie_agrupador_w = 3) then
		   	begin
			qt_ml_diluente_w	:= qt_dose_ml_w;
			select 	CASE WHEN 'N'='S' THEN ds_reduzida_w  ELSE ds_material_ww END
		   	into STRICT	ds_material_w
		   	;

			ds_aux_diluir_w	:= obter_desc_expressao(346572);
			if (ds_reconstituir_w IS NOT NULL AND ds_reconstituir_w::text <> '') then
				ds_aux_diluir_w	:= ''; --' da reconstituição';
			end if;

			ds_dose_diluicao_w	:= replace(qt_dose_ml_w,'.',',') ||' '||obter_unid_med_usua('ml');
			qt_dose_ml_diluicao_w	:= coalesce(qt_dose_ml_w,0);
			if (qt_dose_ml_w = 0) then
				begin
				ds_dose_diluicao_w	:= replace(qt_dose_w,'.',',') ||' '||cd_unid_med_dose_w;
				qt_dose_ml_diluicao_w	:= coalesce(qt_dose_ml_w,0);
				end;
			end if;

			if (coalesce(ds_conv_ml_w::text, '') = '') and (coalesce(ds_diluir_w::text, '') = '') then
				ds_diluir_w := 	ds_diluir_w || obter_desc_expressao(347715)|| ds_dose_diluicao_w || obter_desc_expressao(310214) ||ds_material_w || chr(13) || chr(10);
			elsif (coalesce(ds_diluir_w::text, '') = '') then
		   		ds_diluir_w := 	ds_diluir_w ||obter_desc_expressao(347715)|| ds_dose_diluicao_w|| obter_desc_expressao(310214)||ds_material_w || chr(13) || chr(10);
			else
				ds_diluir_w := 	ds_diluir_w || obter_desc_expressao(347716)|| ds_dose_diluicao_w || obter_desc_expressao(310214) ||ds_material_w || chr(13) || chr(10); --e Diluir a solução em
			end if;


		   	end;
		end if;

		if (cd_material_w IS NOT NULL AND cd_material_w::text <> '') and (qt_dose_w IS NOT NULL AND qt_dose_w::text <> '') and (cd_unid_med_dose_w IS NOT NULL AND cd_unid_med_dose_w::text <> '') and (ie_agrupador_w = 7) then
		   	begin
			select 	CASE WHEN 'N'='S' THEN ds_reduzida_w  ELSE ds_material_ww END
		   	into STRICT	ds_material_w
		   	;

			cd_volume_final_w := qt_dose_ml_w + qt_solucao_w;

			if (qt_solucao_w < 1) or (mod(qt_solucao_w, trunc(qt_solucao_w)) <> 0) then
				mascara_w	:= 0;
			else
				mascara_w	:= 1;
			end if;

			ds_dose_diluicao_w	:= replace(qt_dose_ml_w,'.',',') ||' '||obter_unid_med_usua('ml');
			if (qt_dose_ml_w = 0) then
				begin
				ds_dose_diluicao_w	:= replace(qt_dose_w,'.',',') ||' '||cd_unid_med_dose_w;
				end;
			end if;

			select 	CASE WHEN mascara_w=0 THEN  campo_mascara(qt_solucao_w, 2)  ELSE campo_mascara(qt_solucao_w, 0) END
			into STRICT	qt_solucao_str_w
			;

		   	ds_rediluir_w := ds_rediluir_w|| obter_desc_expressao(346570)||replace(qt_solucao_str_w,'.',',')||' '||obter_unid_med_usua('ml')|| obter_desc_expressao(347717)||
					 ds_dose_diluicao_w || obter_desc_expressao(345994)||ds_material_w || chr(13) || chr(10);
		   	end;
		end if;
		end;
	end loop;
	close c01;

	open C02;
	loop
	fetch C02 into
		ds_material_composto_w,
		qt_dose_composto_w,
		cd_um_dose_composto_w,
		nr_sequencia_composto_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		if (coalesce(ds_materiais_compostos_w::text, '') = '') then
			ds_materiais_compostos_w	:= 'ITENS COMPOSTOS:';
		end if;

		ds_materiais_compostos_w	:=	substr(	ds_materiais_compostos_w || chr(13) || chr(10) ||
								ds_material_composto_w || ' Dose: ' || to_char(qt_dose_composto_w) || ' ' || cd_um_dose_composto_w,1,500);

		select	b.qt_dose,
			b.qt_min_aplicacao,
			b.qt_hora_aplicacao,
			b.cd_unidade_medida_dose,
			b.qt_solucao,
			b.cd_unidade_medida,
			b.cd_material,
			a.cd_estabelecimento,
			b.cd_intervalo,
			b.ie_via_aplicacao
		into STRICT	qt_dose_mat_comp_w,
			qt_min_aplicacao_comp_w,
			qt_hora_aplicacao_comp_w,
			cd_unid_med_dose_mat_comp_w,
			qt_solucao_comp_ww,
			cd_unidade_medida_comp_w,
			cd_medic_comp_w,
			cd_estabelecimento_comp_w,
			cd_intervalo_comp_w,
			ie_via_aplicacao_comp_w
		from 	prescr_material b,
			prescr_medica a
		where 	a.nr_prescricao	= b.nr_prescricao
		and	b.nr_sequencia	= nr_sequencia_composto_w
		and	a.nr_prescricao	= nr_prescricao_p
		and	coalesce(b.dt_suspensao::text, '') = ''
		and	b.ie_agrupador	in (1, 14);

		if (cd_intervalo_comp_w IS NOT NULL AND cd_intervalo_comp_w::text <> '') then
			select	max(ds_prescricao)
			into STRICT	ds_intervalo_comp_w
			from	intervalo_prescricao
			where	cd_intervalo	= cd_intervalo_comp_w;

			if (ie_via_aplicacao_comp_w IS NOT NULL AND ie_via_aplicacao_comp_w::text <> '') then
				ds_intervalo_comp_w	:= ds_intervalo_comp_w ||' '||ie_via_aplicacao_comp_w;
			end if;
		end if;

		select	obter_conversao_ml(cd_medic_comp_w,qt_dose_mat_comp_w,cd_unid_med_dose_mat_comp_w)
		into STRICT	qt_conv_ml_comp_w
		;

		if (qt_conv_ml_comp_w > 0) and (upper(cd_unid_med_dose_mat_comp_w) <> upper(obter_unid_med_usua('ML'))) then
			if (qt_conv_ml_comp_w >= 1) then
				ds_conv_ml_comp_w	:= to_char(qt_conv_ml_comp_w)||' '||obter_unid_med_usua('ml');
			else
				ds_conv_ml_comp_w	:= '0'||to_char(qt_conv_ml_comp_w)||' '||obter_unid_med_usua('ml');
			end if;
		end if;

		qt_dose_mat_str_w	:= qt_dose_mat_w;

		open C03;
		loop
		fetch C03 into
			cd_material_comp_w,
			qt_dose_comp_w,
			qt_vol_adic_reconst_comp_w,
			qt_min_aplicacao_ant_comp_w,
			qt_hora_aplicacao_ant_comp_w,
			cd_unid_med_dose_comp_w,
			ie_agrupador_comp_w,
			qt_solucao_comp_w,
			qt_dose_ml_comp_w,
			ds_material_comp_ww,
			ds_reduzida_comp_w,
			ie_soma_total_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin

			if (cd_material_comp_w IS NOT NULL AND cd_material_comp_w::text <> '') and (qt_dose_comp_w IS NOT NULL AND qt_dose_comp_w::text <> '') and (cd_unid_med_dose_comp_w IS NOT NULL AND cd_unid_med_dose_comp_w::text <> '') and (ie_agrupador_comp_w in (1,3,9)) then
				begin

				select	obter_conversao_ml(cd_material_comp_w,qt_dose_comp_w + qt_vol_adic_reconst_comp_w,cd_unid_med_dose_comp_w)
				into STRICT	qt_conv_ml_comp_w
				;

				if (ie_agrupador_comp_w <> 1) then
					if (upper(cd_unid_med_dose_mat_comp_w) = upper(obter_unid_med_usua('ML'))) then
						begin
						qt_conv_ml_comp_w	:= qt_dose_mat_comp_w;
						end;
					else
						begin
						qt_dose_unid_med_cons_comp_w	:= obter_conversao_unid_med_cons(cd_medic_comp_w,cd_unid_med_dose_mat_comp_w,qt_dose_mat_comp_w);
						qt_conv_ml_comp_w		:= qt_dose_unid_med_cons_comp_w * qt_conv_ml_comp_w;
						end;
					end if;
				end if;

				if (qt_conv_ml_comp_w > 0) then
					if (qt_conv_ml_comp_w >= 1) then
						ds_conv_ml_comp_w	:= to_char(qt_conv_ml_comp_w)||' '||obter_unid_med_usua('ml');
					else
						ds_conv_ml_comp_w	:= '0'||to_char(qt_conv_ml_comp_w)||' '||obter_unid_med_usua('ml');
					end if;
				end if;

				select 	CASE WHEN 'N'='S' THEN ds_reduzida_comp_w  ELSE ds_material_comp_ww END
			   	into STRICT	ds_material_comp_w
			   	;

				if (qt_dose_comp_w < 1) or (mod(qt_dose_w, trunc(qt_dose_comp_w)) <> 0) then
					mascara_w	:= 0;
				else
					mascara_w	:= 1;
				end if;

				select 	CASE WHEN mascara_w=0 THEN  campo_mascara(qt_dose_comp_w, 2)  ELSE campo_mascara(qt_dose_comp_w, 0) END
				into STRICT	qt_dose_str_w
				;

				if (ie_agrupador_comp_w = 9) then
					ds_reconstituir_comp_w := 	ds_reconstituir_comp_w || obter_desc_expressao(346565) ||cd_unidade_medida_comp_w|| obter_desc_expressao(729548)|| ds_material_composto_w ||
									obter_desc_expressao(341615)||replace(qt_dose_str_w,'.',',')||' '||cd_unid_med_dose_comp_w||
									obter_desc_expressao(729548) ||ds_material_comp_w || chr(13) || chr(10);
				end if;

				if (ie_soma_total_w	= 'S') then
					qt_conv_ml_tot_comp_w	:= coalesce(qt_conv_ml_tot_comp_w,0) + coalesce(qt_conv_ml_comp_w,0);
				else
					ds_material_composto_w	:= ds_material_comp_ww;
				end if;

				cd_volume_final_comp_w	:= coalesce(qt_dose_ml_comp_w,0) + coalesce(qt_solucao_comp_w,0);

				if (cd_volume_final_comp_w < 1) or (mod(cd_volume_final_comp_w, trunc(cd_volume_final_comp_w)) <> 0) then
					mascara_w	:= 0;
				else
					mascara_w	:= 1;
				end if;

				select 	CASE WHEN mascara_w=0 THEN  campo_mascara(cd_volume_final_comp_w, 2)  ELSE campo_mascara(cd_volume_final_comp_w, 0) END
				into STRICT	cd_volume_final_str_comp_w
				;

				if (qt_solucao_comp_ww IS NOT NULL AND qt_solucao_comp_ww::text <> '') then
					ds_volume_comp_w	:= ' '||to_char(qt_solucao_comp_ww) ||' '||obter_unid_med_usua('ml');
				else
					begin
					if (ds_conv_ml_comp_w IS NOT NULL AND ds_conv_ml_comp_w::text <> '') then
						ds_volume_comp_w	:= ' '||ds_conv_ml_comp_w;
					end if;
					end;
				end if;

				if (ds_volume_comp_w IS NOT NULL AND ds_volume_comp_w::text <> '') then
					ds_aplicar_comp_w	:= obter_desc_expressao(347720) || replace(ds_volume_comp_w,'.',',') || ds_tempo_comp_w || obter_desc_expressao(310214) || ds_material_composto_w;
				elsif (ds_tempo_comp_w IS NOT NULL AND ds_tempo_comp_w::text <> '') then
					ds_aplicar_comp_w	:= obter_desc_expressao(347720) || ds_tempo_comp_w || obter_desc_expressao(310214) || ds_material_composto_w;
				end if;

				ds_aplicar_todos_comp_w := ds_aplicar_todos_comp_w  || ' - ' || ds_aplicar_comp_w;

				end;
			end if;

			end;
		end loop;
		close C03;

		end;
	end loop;
	close C02;

	if (cd_volume_final_w < 1) or (mod(cd_volume_final_w, trunc(cd_volume_final_w)) <> 0) then
		mascara_w	:= 0;
	else
		mascara_w	:= 1;
	end if;

	select 	CASE WHEN mascara_w=0 THEN  campo_mascara(cd_volume_final_w, 2)  ELSE campo_mascara(cd_volume_final_w, 0) END
	into STRICT	cd_volume_final_str_w
	;

	if (qt_solucao_ww IS NOT NULL AND qt_solucao_ww::text <> '') then
		ds_volume_w	:= ' '||to_char(qt_solucao_ww) ||' '||obter_unid_med_usua('ml');
	elsif (ie_aplicar_w = 'S') then
		begin
		if (ds_conv_ml_w IS NOT NULL AND ds_conv_ml_w::text <> '') then
			ds_volume_w	:= ' '||ds_conv_ml_w;
		end if;
		end;
	end if;

	if (ds_volume_w IS NOT NULL AND ds_volume_w::text <> '') then
		ds_aplicar_w	:= obter_desc_expressao(347720)|| replace(ds_volume_w,'.',',') || obter_desc_expressao(310214) || ds_material_princ_w;
	end if;

	ds_volume_total_w := null;

	if	((coalesce(qt_conv_ml_tot_comp_w,0) + coalesce(qt_conv_ml_w,0) + coalesce(qt_dose_ml_diluicao_w,0)) > 0) then
		ds_volume_total_w := coalesce(qt_conv_ml_tot_comp_w,0) + coalesce(qt_conv_ml_w,0) + coalesce(qt_dose_ml_diluicao_w,0);
	elsif (coalesce(qt_totalml_reconst_w,0) > 0) then
		ds_volume_total_w := coalesce(qt_totalml_reconst_w,0);
	else
		ds_volume_total_w := qt_conv_ml_w;
	end if;

	if (ds_volume_total_w IS NOT NULL AND ds_volume_total_w::text <> '') then
		ds_retorno_w := ds_volume_total_w;
		ds_retorno_w	:= replace(ds_retorno_w,' ,',' 0,');
		ds_retorno_w	:= replace(ds_retorno_w,' .',' 0,');
	end if;

else	/*meio*/
	select	b.qt_dose,
		b.qt_min_aplicacao,
		b.qt_hora_aplicacao,
		b.cd_unidade_medida_dose,
		b.qt_solucao,
		b.cd_unidade_medida,
		b.cd_material,
		a.cd_estabelecimento,
		b.cd_intervalo,
		b.ie_via_aplicacao
	into STRICT	qt_dose_mat_w,
		qt_min_aplicacao_w,
		qt_hora_aplicacao_w,
		cd_unid_med_dose_mat_w,
		qt_solucao_ww,
		cd_unidade_medida_w,
		cd_medic_w,
		cd_estabelecimento_w,
		cd_intervalo_w,
		ie_via_aplicacao_w
	from 	prescr_material b,
		prescr_medica a
	where 	a.nr_prescricao	= b.nr_prescricao
	and	b.nr_sequencia	= nr_sequencia_p
	and	a.nr_prescricao	= nr_prescricao_p
	and	coalesce(b.dt_suspensao::text, '') = ''
	and	b.ie_agrupador	in (1,8,14);

	select	coalesce(max(ie_aplicar),'N')
	into STRICT	ie_aplicar_w
	from	parametro_medico
	where	cd_estabelecimento	= cd_estabelecimento_w;

	if (cd_intervalo_w IS NOT NULL AND cd_intervalo_w::text <> '') then
		select	max(ds_prescricao)
		into STRICT	ds_intervalo_w
		from	intervalo_prescricao
		where	cd_intervalo	= cd_intervalo_w;

		if (ie_via_aplicacao_w IS NOT NULL AND ie_via_aplicacao_w::text <> '') then
			ds_intervalo_w	:= ds_intervalo_w ||' '||ie_via_aplicacao_w;
		end if;
	end if;

	select	coalesce(max(ie_descr_redu_dil),'N')
	into STRICT	ie_descr_redu_dil_w
	from	parametro_medico
	where	cd_estabelecimento	= cd_estabelecimento_w;

	select	obter_conversao_ml(cd_medic_w,qt_dose_mat_w,cd_unid_med_dose_mat_w)
	into STRICT	qt_conv_ml_w
	;

	if (qt_conv_ml_w > 0) and (upper(cd_unid_med_dose_mat_w) <> upper(obter_unid_med_usua('ML'))) then
		if (qt_conv_ml_w >= 1) then
			ds_conv_ml_w	:= to_char(qt_conv_ml_w)||' '||obter_unid_med_usua('ml');
		else
			ds_conv_ml_w	:= '0'||to_char(qt_conv_ml_w)||' '||obter_unid_med_usua('ml');
		end if;
	end if;

	qt_dose_mat_str_w	:= qt_dose_mat_w;

	open c01;
	loop
	fetch c01 into
		cd_material_w,
		qt_dose_w,
		qt_vol_adic_reconst_w,
		qt_min_aplicacao_ant_w,
		qt_hora_aplicacao_ant_w,
		cd_unid_med_dose_w,
		ie_agrupador_w,
		qt_solucao_w,
		qt_dose_ml_w,
		ds_material_ww,
		ds_reduzida_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin

		if (cd_material_w IS NOT NULL AND cd_material_w::text <> '') and (qt_dose_w IS NOT NULL AND qt_dose_w::text <> '') and (cd_unid_med_dose_w IS NOT NULL AND cd_unid_med_dose_w::text <> '') and (ie_agrupador_w = 9) then
			begin

			select	obter_conversao_ml(cd_material_w,qt_dose_w + qt_vol_adic_reconst_w,cd_unid_med_dose_w)
			into STRICT	qt_conv_ml_w
			;

			if (upper(cd_unid_med_dose_mat_w) = upper(obter_unid_med_usua('ML'))) then
				begin
				qt_conv_ml_w	:= qt_dose_mat_w;
				end;
			else
				begin
				qt_dose_unid_med_cons_w	:= obter_conversao_unid_med_cons(cd_medic_w,cd_unid_med_dose_mat_w,qt_dose_mat_w);
				qt_conv_ml_w		:= qt_dose_unid_med_cons_w * qt_conv_ml_w;
				end;
			end if;

			if (qt_conv_ml_w > 0) then
				if (qt_conv_ml_w >= 1) then
					ds_conv_ml_w	:= to_char(qt_conv_ml_w)||' '||obter_unid_med_usua('ml');
				else
					ds_conv_ml_w	:= '0'||to_char(qt_conv_ml_w)||' '||obter_unid_med_usua('ml');
				end if;
			end if;

			select 	CASE WHEN ie_descr_redu_dil_w='S' THEN ds_reduzida_w  ELSE ds_material_ww END
			into STRICT	ds_material_w
			;

			if (qt_dose_w < 1) or (mod(qt_dose_w, trunc(qt_dose_w)) <> 0) then
				mascara_w	:= 0;
			else
				mascara_w	:= 1;
			end if;

			Select 	CASE WHEN mascara_w=0 THEN  campo_mascara(qt_dose_w, 2)  ELSE campo_mascara(qt_dose_w, 0) END
			into STRICT	qt_dose_str_w
			;

			ds_reconstituir_w := 	ds_reconstituir_w ||wheb_mensagem_pck.get_texto(306838) ||' ' ||cd_unidade_medida_w||
					' ' || wheb_mensagem_pck.get_texto(306840) || ' '||replace(qt_dose_str_w,'.',',')||' '||cd_unid_med_dose_w||
					' ' || wheb_mensagem_pck.get_texto(306844) || ' '||ds_material_w || chr(13) || chr(10);
			end;
		end if;

		if (cd_material_w IS NOT NULL AND cd_material_w::text <> '') and (qt_dose_w IS NOT NULL AND qt_dose_w::text <> '') and (cd_unid_med_dose_w IS NOT NULL AND cd_unid_med_dose_w::text <> '') and (ie_agrupador_w = 3) then
			begin
			qt_ml_diluente_w	:= qt_dose_ml_w;
			select 	CASE WHEN ie_descr_redu_dil_w='S' THEN ds_reduzida_w  ELSE ds_material_ww END
			into STRICT	ds_material_w
			;

			ds_aux_diluir_w	:= wheb_mensagem_pck.get_texto(306852);
			if (ds_reconstituir_w IS NOT NULL AND ds_reconstituir_w::text <> '') then
				ds_aux_diluir_w	:= wheb_mensagem_pck.get_texto(306853);
			end if;

			ds_dose_diluicao_w	:= replace(qt_dose_ml_w,'.',',') ||' '||obter_unid_med_usua('ml');
			if (qt_dose_ml_w = 0) then
				begin
				ds_dose_diluicao_w	:= replace(qt_dose_w,'.',',') ||' '||cd_unid_med_dose_w;
				end;
			end if;

			if (coalesce(ds_conv_ml_w::text, '') = '') and (coalesce(ds_diluir_w::text, '') = '') then
				ds_diluir_w := 	ds_diluir_w ||wheb_mensagem_pck.get_texto(306860) || ' '||replace(qt_dose_mat_str_w,'.',',')||' '||cd_unid_med_dose_mat_w|| ds_aux_diluir_w||' ' || wheb_mensagem_pck.get_texto(306840) || ' '||
					ds_dose_diluicao_w||' ' || wheb_mensagem_pck.get_texto(306844) || ' '||ds_material_w || chr(13) || chr(10);
			elsif (coalesce(ds_diluir_w::text, '') = '') then
				ds_diluir_w := 	ds_diluir_w ||wheb_mensagem_pck.get_texto(306860) || ' '||ds_conv_ml_w ||ds_aux_diluir_w||' ' || wheb_mensagem_pck.get_texto(306840) || ' '||
					ds_dose_diluicao_w||' ' || wheb_mensagem_pck.get_texto(306844) || ' '||ds_material_w || chr(13) || chr(10);
			else
				ds_diluir_w := 	ds_diluir_w ||wheb_mensagem_pck.get_texto(306860) || ' '||  wheb_mensagem_pck.get_texto(306869)|| ' '||
					ds_dose_diluicao_w ||' ' || wheb_mensagem_pck.get_texto(306844) || ' '||ds_material_w || chr(13) || chr(10);
			end if;
			end;
		end if;

		if (cd_material_w IS NOT NULL AND cd_material_w::text <> '') and (qt_dose_w IS NOT NULL AND qt_dose_w::text <> '') and (cd_unid_med_dose_w IS NOT NULL AND cd_unid_med_dose_w::text <> '') and (ie_agrupador_w = 7) then
			begin
			select 	CASE WHEN ie_descr_redu_dil_w='S' THEN ds_reduzida_w  ELSE ds_material_ww END
			into STRICT	ds_material_w
			;

			cd_volume_final_w := qt_dose_ml_w + qt_solucao_w;

			if (qt_solucao_w < 1) or (mod(qt_solucao_w, trunc(qt_solucao_w)) <> 0) then
				mascara_w	:= 0;
			else
				mascara_w	:= 1;
			end if;

			ds_dose_diluicao_w	:= replace(qt_dose_ml_w,'.',',') ||' '||obter_unid_med_usua('ml');
			if (qt_dose_ml_w = 0) then
				begin
				ds_dose_diluicao_w	:= replace(qt_dose_w,'.',',') ||' '||cd_unid_med_dose_w;
				end;
			end if;

			Select 	CASE WHEN mascara_w=0 THEN  campo_mascara(qt_solucao_w, 2)  ELSE campo_mascara(qt_solucao_w, 0) END
			into STRICT	qt_solucao_str_w
			;

			ds_rediluir_w := ds_rediluir_w||wheb_mensagem_pck.get_texto(306848) || ' '||replace(qt_solucao_str_w,'.',',')||' '||obter_unid_med_usua('ml')||' ' || wheb_mensagem_pck.get_texto(309596) || ' '||
					 ds_dose_diluicao_w ||' ' || wheb_mensagem_pck.get_texto(306844) || ' '||ds_material_w || chr(13) || chr(10);
			end;
		end if;
		end;
	end loop;
	close c01;

	if (cd_volume_final_w < 1) or (mod(cd_volume_final_w, trunc(cd_volume_final_w)) <> 0) then
		mascara_w	:= 0;
	else
		mascara_w	:= 1;
	end if;

	Select 	CASE WHEN mascara_w=0 THEN  campo_mascara(cd_volume_final_w, 2)  ELSE campo_mascara(cd_volume_final_w, 0) END
	into STRICT	cd_volume_final_str_w
	;

	if (qt_solucao_ww IS NOT NULL AND qt_solucao_ww::text <> '') then
		ds_volume_w	:= ' '||to_char(qt_solucao_ww) ||' '||obter_unid_med_usua('ml');
	elsif (ie_aplicar_w = 'S') then
		begin
		if (ds_rediluir_w IS NOT NULL AND ds_rediluir_w::text <> '') then
			ds_volume_w	:= ' '||cd_volume_final_str_w ||' '||obter_unid_med_usua('ml');
		elsif (ds_diluir_w IS NOT NULL AND ds_diluir_w::text <> '') then
			ds_volume_w	:= ' '||to_char(qt_conv_ml_w + qt_ml_diluente_w) ||' '||obter_unid_med_usua('ml');
		elsif (ds_conv_ml_w IS NOT NULL AND ds_conv_ml_w::text <> '') then
			ds_volume_w	:= ' '||ds_conv_ml_w;
		end if;
		end;
	end if;

	ds_volume_w	:= replace(ds_volume_w,'.',',');
	ds_retorno_w	:= replace(ds_volume_w,' ,',' 0,');

end if;

RETURN	substr(ds_retorno_w,1,2000);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_volume_total_dil ( NR_SEQUENCIA_P bigint, NR_PRESCRICAO_P bigint) FROM PUBLIC;

