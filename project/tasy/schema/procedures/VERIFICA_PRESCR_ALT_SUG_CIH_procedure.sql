-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE verifica_prescr_alt_sug_cih (nr_prescricao_p bigint, nr_seq_material_p bigint, nr_prescr_orig_p bigint, cd_intervalo_p text, cd_unid_med_dose_p text, ie_via_aplicacao_p text, qt_dose_p bigint, cd_material_p bigint, ie_alterado_p INOUT text, nr_prescr_sug_p INOUT bigint, nr_seq_mat_p INOUT bigint) AS $body$
DECLARE

 
nr_prescricao_w			prescr_medica.nr_prescricao%type;
cd_material_w			prescr_material.cd_material%type;
cd_material_2w			prescr_material.cd_material%type;
nr_dia_util_w			prescr_material.nr_dia_util%type;
nr_dia_util_2w			prescr_material.nr_dia_util%type;
cd_estabelecimento_w	bigint;
ie_atb_pessoa_w			varchar(1);
dt_prescricao_w			prescr_medica.dt_prescricao%type;
dt_anterior_w			prescr_medica.dt_prescricao%type;
nr_atendimento_w		prescr_medica.nr_atendimento%type;
cd_pessoa_fisica_w		prescr_medica.cd_pessoa_fisica%type;
ie_prescr_sug_w			varchar(1) := 'N';
ie_existe_w				boolean := false;
ie_dias_util_medic_w	varchar(1);
qt_sug_paciente_w		bigint;

---------  Material Sugerido ------------ 
qt_dose_sug_w			medicamento_cih_sug.qt_dose%type;
cd_intervalo_sug_w		medicamento_cih_sug.cd_intervalo%type;
cd_material_sub_sug_w	medicamento_cih_sug.cd_material%type;
cd_material_sug_w		medicamento_cih_sug.cd_material%type;
cd_unid_med_sug_w		medicamento_cih_sug.cd_unidade_medida_dose%type;
ie_via_aplic_sug_w		medicamento_cih_sug.ie_via_aplicacao%type;
nr_prescricao_sug_w		medicamento_cih_sug.nr_prescricao%type;
nr_seq_mat_sug_w		medicamento_cih_sug.nr_seq_material%type;
------------------------------------------------ 
c01 CURSOR FOR 
SELECT	nr_prescricao, 
	cd_material 
from	prescr_material 
where	nr_prescricao		 = nr_prescr_orig_p 
and		cd_material			 = cd_material_w 
and 	coalesce(ie_ciclo_reprov,'N') = 'N' 
and 	(nr_dia_util IS NOT NULL AND nr_dia_util::text <> '') 
and		coalesce(ie_suspenso,'N')	<> 'S' 

union all
                                                                                                                       
SELECT	a.nr_prescricao, 
		a.cd_material 
from 	prescr_material a, 
		prescr_medica b 
where a.nr_prescricao	= b.nr_prescricao 
and		a.nr_prescricao <> nr_prescricao_p 
and		b.dt_prescricao between dt_anterior_w and dt_prescricao_w 
and 	coalesce(ie_ciclo_reprov,'N') = 'N'	 
and		coalesce(ie_atb_pessoa_w,'N') = 'N' 
and		b.nr_atendimento	   = nr_atendimento_w 
and		a.cd_material 		   = cd_material_w 
and 	(a.nr_dia_util IS NOT NULL AND a.nr_dia_util::text <> '') 
and		coalesce(a.ie_suspenso,'N')	<> 'S' 
and		((a.nr_prescricao_anterior IS NOT NULL AND a.nr_prescricao_anterior::text <> '') or (a.nr_dia_util = nr_dia_util_2w)) 

union all
 
select	a.nr_prescricao, 
		a.cd_material 
from 	prescr_material a, 
		prescr_medica b 
where 	a.nr_prescricao = b.nr_prescricao 
and		b.nr_prescricao	 <> nr_prescricao_p 
and		b.dt_prescricao between dt_anterior_w and dt_prescricao_w 
and 	coalesce(ie_ciclo_reprov,'N') = 'N'	 
and		coalesce(ie_atb_pessoa_w,'N') = 'S' 
and 	b.cd_pessoa_fisica	   = cd_pessoa_fisica_w 
and		a.cd_material 	  	   = cd_material_w 
and 	(a.nr_dia_util IS NOT NULL AND a.nr_dia_util::text <> '') 
and		coalesce(a.ie_suspenso,'N')	<> 'S' 
and		((a.nr_prescricao_anterior IS NOT NULL AND a.nr_prescricao_anterior::text <> '') or (a.nr_dia_util = nr_dia_util_2w)) 

union all
 
select	a.nr_prescricao, 
		a.cd_material 
from 	prescr_material a, 
		prescr_medica b 
where 	a.nr_prescricao = b.nr_prescricao 
and		b.nr_prescricao	 	<> nr_prescricao_p 
and 	coalesce(ie_ciclo_reprov,'N') = 'N'	 
and		coalesce(a.ie_suspenso,'N')	<> 'S' 
and 	(a.nr_dia_util IS NOT NULL AND a.nr_dia_util::text <> '') 
and		coalesce(ie_atb_pessoa_w,'N') = 'N' 
and 	b.nr_atendimento = nr_atendimento_w 
and		exists (	select	x.nr_prescricao 
				from 	prescr_material x, 
						prescr_medica z 
				where 	x.nr_prescricao = z.nr_prescricao 
				and		x.nr_prescricao	 = nr_prescricao_p 
				and		x.cd_material	<> a.cd_material 
				and		x.nr_dia_util	 = nr_dia_util_2w 
				and		z.dt_prescricao between dt_anterior_w and dt_prescricao_w 
				and		(x.qt_dias_solicitado IS NOT NULL AND x.qt_dias_solicitado::text <> '') 
				and		(x.qt_dias_liberado IS NOT NULL AND x.qt_dias_liberado::text <> '') 
				and		(x.qt_total_dias_lib IS NOT NULL AND x.qt_total_dias_lib::text <> '') 
				and		x.cd_material in (	select	m.cd_material_substituicao 
											from	medicamento_cih_sug m 
											where	m.cd_material  = a.cd_material 
											and	 	m.nr_prescricao = a.nr_prescricao 
											and	 	m.ie_concordo = 'X')) 

union all
 
select	a.nr_prescricao, 
		a.cd_material 
from 	prescr_material a, 
		prescr_medica b 
where 	a.nr_prescricao = b.nr_prescricao 
and		b.nr_prescricao	 	<> nr_prescricao_p 
and 	coalesce(ie_ciclo_reprov,'N') = 'N'	 
and		coalesce(a.ie_suspenso,'N')	<> 'S' 
and 	(a.nr_dia_util IS NOT NULL AND a.nr_dia_util::text <> '') 
and		coalesce(ie_atb_pessoa_w,'N') = 'S' 
and		b.cd_pessoa_fisica = cd_pessoa_fisica_w 
and		exists (	select	x.nr_prescricao 
				from 	prescr_material x, 
						prescr_medica z 
				where 	x.nr_prescricao = z.nr_prescricao 
				and		x.nr_prescricao	 = nr_prescricao_p 
				and		x.cd_material	<> a.cd_material 
				and		x.nr_dia_util	 = nr_dia_util_2w 
				and		z.dt_prescricao between dt_anterior_w and dt_prescricao_w 
				and		(x.qt_dias_solicitado IS NOT NULL AND x.qt_dias_solicitado::text <> '') 
				and		(x.qt_dias_liberado IS NOT NULL AND x.qt_dias_liberado::text <> '') 
				and		(x.qt_total_dias_lib IS NOT NULL AND x.qt_total_dias_lib::text <> '') 
				and		x.cd_material in (	select	m.cd_material_substituicao 
											from	medicamento_cih_sug m 
											where	m.cd_material  = a.cd_material 
											and	 	m.nr_prescricao = a.nr_prescricao 
											and	 	m.ie_concordo = 'X')) 
order by 1 desc;


BEGIN 
cd_estabelecimento_w	:= coalesce(wheb_usuario_pck.get_cd_estabelecimento,0);
 
select	max(cd_material), 
		max(nr_dia_util) 
into STRICT 	cd_material_w,                                                                                                                 
		nr_dia_util_w 
from 	prescr_material                                                                                                                
where 	nr_sequencia 	= nr_seq_material_p                                                                                                      
and		nr_prescricao 		= nr_prescricao_p                                                                                                       
and		(qt_total_dias_lib IS NOT NULL AND qt_total_dias_lib::text <> '');
 
select 	max(dt_prescricao), 
		max(nr_atendimento), 
		max(cd_pessoa_fisica) 
into STRICT  dt_prescricao_w, 
		nr_atendimento_w, 
		cd_pessoa_fisica_w 
from  	prescr_medica 
where 	nr_prescricao = nr_prescricao_p;
 
select	coalesce(max(ie_atb_pessoa),'N') 
into STRICT	ie_atb_pessoa_w 
from	parametro_medico 
where	cd_estabelecimento	= cd_estabelecimento_w;
 
if (coalesce(nr_dia_util_w,0) = 0) then 
	nr_dia_util_w := 1;
end if;
 
if (nr_dia_util_w > 7) then /*Problema de performance quando é maior que 7 dias*/
 
	nr_dia_util_w := 7;
end if;
 
dt_anterior_w	:= trunc(dt_prescricao_w,'dd') - nr_dia_util_w;
 
select	coalesce(max(ie_dias_util_medic),'N') 
into STRICT	ie_dias_util_medic_w 
from	material 
where	cd_material	= cd_material_w;
 
if (ie_dias_util_medic_w = 'O') then 
	nr_dia_util_2w	:= 0;
else 
	nr_dia_util_2w	:= 1;
end if;	
 
 
select count(*) 
into STRICT	 qt_sug_paciente_w 
from 	 medicamento_cih_sug 
where dt_atualizacao between dt_anterior_w and dt_prescricao_w 
and	 Obter_dados_prescricao(nr_prescricao,'P') = cd_pessoa_fisica_w 
and	 cd_material = cd_material_w;
 
if (qt_sug_paciente_w < 1) then 
	select count(*) 
	into STRICT  qt_sug_paciente_w 
	from  medicamento_cih_sug 
	where dt_atualizacao_nrec between dt_anterior_w and dt_prescricao_w 
	and	 Obter_dados_prescricao(nr_prescricao,'P') = cd_pessoa_fisica_w 
	and	 cd_material_substituicao = cd_material_w 
	and  ie_concordo = 'X';
end if;
 
if (qt_sug_paciente_w > 0) then 
 
	open C01;
	loop 
	fetch C01 into	 
		nr_prescricao_w, 
		cd_material_2w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		nr_prescricao_w := nr_prescricao_w;
		cd_material_2w	:= cd_material_2w;
	end loop;
	close C01;
 
 
	select	max(qt_dose), 
			max(cd_intervalo), 
			max(cd_material_substituicao), 
			max(cd_unidade_medida_dose), 
			max(ie_via_aplicacao), 
			max(nr_prescricao), 
			max(nr_seq_material) 
	into STRICT	qt_dose_sug_w, 
			cd_intervalo_sug_w, 
			cd_material_sub_sug_w, 
			cd_unid_med_sug_w, 
			ie_via_aplic_sug_w, 
			nr_prescricao_sug_w, 
			nr_seq_mat_sug_w 
	from 	medicamento_cih_sug 
	where 	nr_prescricao = nr_prescricao_w 
	and		cd_material 	= cd_material_2w 
	and		ie_concordo		= 'X';
 
	if (cd_material_sub_sug_w <> 0) then 
		ie_existe_w	:= true;
	end if;
		 
	if (ie_existe_w) then 
		if (qt_dose_sug_w <> qt_dose_p) or (cd_intervalo_sug_w <> cd_intervalo_p) or (cd_material_sub_sug_w <> cd_material_p) or (cd_unid_med_sug_w <> cd_unid_med_dose_p) or (ie_via_aplic_sug_w <> ie_via_aplicacao_p) then 
			ie_alterado_p 	:= 'S';
			nr_prescr_sug_p := nr_prescricao_sug_w;
			nr_seq_mat_p	:= nr_seq_mat_sug_w;
		else 
			ie_alterado_p 	:= 'N';
			nr_prescr_sug_p := 0;
			nr_seq_mat_p	:= 0;
		end if;	
	end if;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE verifica_prescr_alt_sug_cih (nr_prescricao_p bigint, nr_seq_material_p bigint, nr_prescr_orig_p bigint, cd_intervalo_p text, cd_unid_med_dose_p text, ie_via_aplicacao_p text, qt_dose_p bigint, cd_material_p bigint, ie_alterado_p INOUT text, nr_prescr_sug_p INOUT bigint, nr_seq_mat_p INOUT bigint) FROM PUBLIC;

