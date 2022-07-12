-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_diarias_feriado (dt_inicial_p timestamp, dt_final_p timestamp, cd_estabelecimento_p bigint, cd_setor_atendimento_p bigint, ie_tipo_p text) RETURNS bigint AS $body$
DECLARE

 
/* Função criada especificamente para as OS 16867 e 31063*/
 
 
/* IE_TIPO_P 
 S - SUS (16867) 
 G - Geral (31063) 
*/
 
 
dt_aux_w	timestamp;
qt_diarias_w	bigint	:= 0;
qt_pacientes_w	bigint	:= 0;
ie_dia_semana_w	varchar(01);
ie_feriado_w	varchar(01);


BEGIN 
 
dt_aux_w	:= trunc(dt_inicial_p, 'dd');
 
while(dt_aux_w <= dt_final_p) loop 
	begin 
 
	select	pkg_date_utils.get_WeekDay(dt_aux_w) 
	into STRICT	ie_dia_semana_w 
	;
 
	select	coalesce(max('S'), 'N') 
	into STRICT	ie_feriado_w 
	from 	feriado 
	where 	dt_feriado = dt_aux_w 
	and	cd_estabelecimento = cd_estabelecimento_p;
 
 
	If (ie_feriado_w = 'N') and (ie_dia_semana_w in ('2', '3', '4', '5', '6')) then 
		begin 
		 
		if (cd_setor_atendimento_p	<> 0) then 
			select	sum(1) 
			into STRICT	qt_pacientes_w  
			from 	paciente_internado_v2 
			where	dt_saida_interno	>= trunc(dt_aux_w) + 83699/86400  	 
			and	dt_entrada_unidade 	<= trunc(dt_aux_w) + 83699/86400 
			and	cd_setor_atendimento	= cd_setor_atendimento_p;
		 
		elsif (cd_setor_atendimento_p	= 0) then 
			if (ie_tipo_p	= 'S') then 
				select	sum(1) 
				into STRICT	qt_pacientes_w  
				from 	paciente_internado_v2 
				where	dt_saida_interno	>= trunc(dt_aux_w) + 83699/86400  	 
				and	dt_entrada_unidade	<= trunc(dt_aux_w) + 83699/86400 
				and	cd_setor_atendimento	in (8,20,22,23);
			 
			elsif (ie_tipo_p	= 'G') then 
				select	sum(1) 
				into STRICT	qt_pacientes_w  
				from 	paciente_internado_v2 
				where	dt_saida_interno	>= trunc(dt_aux_w) + 83699/86400  	 
				and  	dt_entrada_unidade	<= trunc(dt_aux_w) + 83699/86400 
				and	cd_setor_atendimento	in (6,8,9,20,22,23);
			end if;
		end if;
 
		qt_diarias_w	:= qt_diarias_w + qt_pacientes_w;
		 
		end;
 
 
	end if;
		 
	dt_aux_w	:= dt_aux_w + 1;
	 
	end;
end loop;
 
RETURN qt_diarias_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_diarias_feriado (dt_inicial_p timestamp, dt_final_p timestamp, cd_estabelecimento_p bigint, cd_setor_atendimento_p bigint, ie_tipo_p text) FROM PUBLIC;
