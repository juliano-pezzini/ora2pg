-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_horario_especial ( CD_ESTABELECIMENTO_P bigint, CD_PROCEDIMENTO_P bigint, IE_ORIGEM_PROCED_P bigint, CD_CONVENIO_P bigint, CD_CATEGORIA_P text, CD_SETOR_ATENDIMENTO_P bigint, IE_TIPO_ATENDIMENTO_P bigint, IE_CARATER_INTER_SUS_P text, DT_PROCEDIMENTO_P timestamp, NR_CIRURGIA_P bigint, ie_video_p text) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w			varchar(1) 	:= 'N';
cd_edicao_w			integer	:= 0;
cd_area_w			bigint	:= 0;
cd_especialidade_w		bigint	:= 0;
cd_grupo_w			bigint	:= 0;
dia_semana_w			smallint	:= 0;
dia_feriado_w			varchar(1) 	:= 'N';
ie_prioridade_w 		smallint;
ie_carater_cirurgia_w		varchar(1)	:= '';

C01 CURSOR FOR 
	SELECT 		ie_prioridade			 
   	from 		proc_criterio_horario 
   	where 		cd_estabelecimento			 	= cd_estabelecimento_p 
	and		coalesce(cd_procedimento,cd_procedimento_p) 	 	= cd_procedimento_p 
	and		coalesce(ie_origem_proced,ie_origem_proced_p)	= ie_origem_proced_p 
	and		coalesce(cd_area_proced,cd_area_w)			= cd_area_w	 
	and		coalesce(cd_especial_proced,cd_especialidade_w)	= cd_especialidade_w 
	and		coalesce(cd_grupo_proced,cd_grupo_w)			= cd_grupo_w 
	and		coalesce(cd_edicao_amb, coalesce(cd_edicao_w,0))		= coalesce(cd_edicao_w,0) 
	and		coalesce(cd_convenio, cd_convenio_p)			= cd_convenio_p 
	and 		coalesce(cd_categoria, coalesce(CD_CATEGORIA_P, '0')) 	= coalesce(CD_CATEGORIA_P, '0') 
   	and 		coalesce(ie_tipo_atendimento,ie_tipo_atendimento_p) 	= ie_tipo_atendimento_p 
	and		((coalesce(ie_carater_inter_sus::text, '') = '') or (ie_carater_inter_sus = coalesce(ie_carater_inter_sus_p,ie_carater_inter_sus))) 
	and		((coalesce(ie_carater_cirurgia::text, '') = '') or (ie_carater_cirurgia = coalesce(ie_carater_cirurgia_w, ie_carater_cirurgia))) 
	and		coalesce(cd_setor_exclusivo, cd_setor_atendimento_p) = cd_setor_atendimento_p 
	and		coalesce(ie_feriado,'N')				= dia_feriado_w 
	and		((coalesce(dt_dia_semana, dia_semana_w) = dia_semana_w) or (dt_dia_semana = 9)) 
	and (dt_procedimento_p between 
				to_date(to_char(dt_procedimento_p,'dd/mm/yyyy') || ' ' || 
					coalesce(to_char(hr_inicial,'hh24:mi:ss'), '00:00:01'), 
					'dd/mm/yyyy hh24:mi:ss') 
						and 
				to_date(to_char(dt_procedimento_p,'dd/mm/yyyy') || ' ' || 
					coalesce(to_char(hr_final,'hh24:mi:ss'), '23:59:59'), 
					'dd/mm/yyyy hh24:mi:ss')) 
	and		((ie_video = 'A') or (ie_video = ie_video_p)) 
	order by 
			coalesce(cd_procedimento,0), 
			coalesce(cd_grupo_proced,0), 
			coalesce(cd_especial_proced,0), 
			coalesce(cd_area_proced,0), 
			coalesce(cd_setor_exclusivo,0), 
			coalesce(ie_tipo_atendimento,0), 
			coalesce(ie_carater_inter_sus,0), 
			coalesce(cd_convenio,0), 
			coalesce(ie_prioridade,0), 
			coalesce(cd_edicao_amb,0);

BEGIN
 
dia_semana_w := pkg_date_utils.get_WeekDay(DT_PROCEDIMENTO_P);
 
/* Obter Feriado */
 
begin 
select 		'S' 
into STRICT 		dia_feriado_w 
from 		feriado 
where 		cd_estabelecimento 			= cd_estabelecimento_p 
and 		to_char(dt_feriado,'dd/mm/yyyy') 	= to_char(DT_PROCEDIMENTO_P,'dd/mm/yyyy');
exception 
      when others then 
		dia_feriado_w	:= 'N';
end;
 
/* Obter Estrutura do procedimento */
 
begin 
select 		cd_grupo_proc, 
		cd_especialidade, 
		cd_area_procedimento 
into STRICT		cd_grupo_w, 
		cd_especialidade_w, 
		cd_area_w 
from		Estrutura_Procedimento_V 
where		cd_procedimento 	= cd_procedimento_p 
and		ie_origem_proced	= ie_origem_proced_p;
exception 
   		when others then 
		begin 
		cd_grupo_w		:= 0;
		cd_especialidade_w	:= 0;
		cd_area_w		:= 0;
		end;
end;
 
/* Obter o carater da cirurgia */
 
begin 
select 	coalesce(max(ie_carater_cirurgia),'E') 
into STRICT	ie_carater_cirurgia_w 
from 	cirurgia 
where 	nr_cirurgia = nr_cirurgia_p;
exception 
	when others then 
		ie_carater_cirurgia_w:= '';
end;	
 
/* Obter a edição AMB */
 
begin 
select	obter_edicao(cd_estabelecimento_p, cd_convenio_p, cd_categoria_p, dt_procedimento_p, cd_procedimento_p) 
into STRICT	cd_edicao_w
;
exception 
		when others then 
   		cd_edicao_w 	:= 0;
end;
 
ds_retorno_w:= 'N';
 
OPEN C01;
LOOP 
FETCH C01 into 
	ie_prioridade_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	ds_retorno_w:= 'S';
	exit;
	end;
END LOOP;
CLOSE C01;
 
 
return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_horario_especial ( CD_ESTABELECIMENTO_P bigint, CD_PROCEDIMENTO_P bigint, IE_ORIGEM_PROCED_P bigint, CD_CONVENIO_P bigint, CD_CATEGORIA_P text, CD_SETOR_ATENDIMENTO_P bigint, IE_TIPO_ATENDIMENTO_P bigint, IE_CARATER_INTER_SUS_P text, DT_PROCEDIMENTO_P timestamp, NR_CIRURGIA_P bigint, ie_video_p text) FROM PUBLIC;
