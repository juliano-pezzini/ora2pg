-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION plt_obter_inicio_extensao ( cd_pessoa_fisica_p text, nm_usuario_p text, cd_setor_atendimento_p bigint, dt_quebra_p timestamp, hr_quebra_p text, cd_perfil_p bigint, nr_atendimento_p bigint) RETURNS timestamp AS $body$
DECLARE

 
dt_inicio_plano_w		timestamp;					
dt_extensao_w			timestamp;
dt_validade_prescr_w		timestamp;
qt_horas_atraso_w		bigint;
cd_estabelecimento_w		smallint;
dt_atraso_w			timestamp;
ie_atend_alta_w			varchar(1);
nr_atendimento_w		bigint;
dt_prim_hor_prescr_w		timestamp;
cd_setor_atendimento_w		integer;
cd_setor_prescr_w			integer;
nr_prescricao_w			bigint;
cd_classif_setor_param_w varchar(2);
cd_classif_setor_prescr_w	varchar(2);
ie_buscar_regra_setor_w		varchar(1);
ie_considera_atraso_w		varchar(1);
					
c01 CURSOR FOR 
SELECT	trunc(a.dt_extensao), 
		trunc(b.dt_validade_prescr), 
		coalesce(b.cd_setor_atendimento,0) 
from	w_rep_t a, 
	prescr_medica b 
where	coalesce(a.nr_prescricao,plt_Obter_Max_Nr_Prescricao(a.nr_prescricoes)) = b.nr_prescricao 
and	b.cd_pessoa_fisica = cd_pessoa_fisica_p 
and	coalesce(a.dt_atualizacao,clock_timestamp()) between(clock_timestamp() - interval '1 days') and (clock_timestamp() + interval '1 days') 
and	a.ie_copiar = 'S' 
and	((b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '') or (b.dt_liberacao_medico IS NOT NULL AND b.dt_liberacao_medico::text <> ''));
					

BEGIN 
 
select	coalesce(max(cd_estabelecimento),1), 
		coalesce(max(cd_classif_setor),0) 
into STRICT	cd_estabelecimento_w, 
		cd_classif_setor_param_w 
from	setor_atendimento 
where	cd_setor_atendimento	= cd_setor_atendimento_p;
 
qt_horas_atraso_w := Obter_Param_Usuario(950, 78, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, qt_horas_atraso_w);
ie_buscar_regra_setor_w := Obter_Param_Usuario(950, 191, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_buscar_regra_setor_w);
ie_considera_atraso_w := Obter_Param_Usuario(950, 195, cd_perfil_p, nm_usuario_p, cd_estabelecimento_w, ie_considera_atraso_w);
 
if (ie_buscar_regra_setor_w = 'S') then 
	qt_horas_atraso_w := plt_obter_inf_setor(cd_setor_atendimento_p,78,nm_usuario_p);
end if;
 
dt_atraso_w	:=	((dt_quebra_p - 1) + (qt_horas_atraso_w * 1/24));
 
open C01;
loop 
fetch C01 into	 
	dt_extensao_w, 
	dt_validade_prescr_w, 
	cd_setor_prescr_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	select	coalesce(max(cd_classif_setor),0) 
	into STRICT	cd_classif_setor_prescr_w 
	from	setor_atendimento 
	where	cd_setor_atendimento	= cd_setor_prescr_w;
	 
	if (ie_considera_atraso_w = 'N') or (cd_classif_setor_param_w = '1') or 
		((cd_classif_setor_prescr_w	<> '1') or 
		 ((cd_classif_setor_prescr_w = 1) and (dt_validade_prescr_w = trunc(dt_quebra_p)))) then 
	 
		if (dt_extensao_w IS NOT NULL AND dt_extensao_w::text <> '') and 
			((coalesce(dt_inicio_plano_w::text, '') = '') or (dt_inicio_plano_w >= dt_extensao_w)) then 
			 
			dt_inicio_plano_w	:= dt_extensao_w;
			 
		elsif	((coalesce(dt_inicio_plano_w::text, '') = '') or (dt_inicio_plano_w > dt_validade_prescr_w)) then 
		 
			dt_inicio_plano_w	:= dt_validade_prescr_w;
			 
		end if;
		 
	end if;	
	 
	end;
end loop;
close C01;
 
if (qt_horas_atraso_w > 0) and (ie_considera_atraso_w = 'N') and (dt_atraso_w		> clock_timestamp()) then 
	dt_inicio_plano_w	:= '';
elsif (dt_inicio_plano_w IS NOT NULL AND dt_inicio_plano_w::text <> '') then 
	dt_inicio_plano_w	:= to_date(to_char(dt_inicio_plano_w,'dd/mm/yyyy')||' '||hr_quebra_p,'dd/mm/yyyy hh24:mi:ss');	
end if;
 
if (dt_inicio_plano_w	< dt_quebra_p) or (coalesce(dt_inicio_plano_w::text, '') = '') then 
	if (qt_horas_atraso_w 	> 0) and (dt_atraso_w		> clock_timestamp()) then 
		dt_inicio_plano_w	:= trunc(clock_timestamp() + interval '1 days'/24,'hh');
		if (dt_inicio_plano_w	> dt_atraso_w) then 
			dt_inicio_plano_w	:= dt_atraso_w;
		end if;
	else	 
		dt_inicio_plano_w	:= dt_quebra_p;
	end if;	
end if;	
 
ie_atend_alta_w		:= obter_se_atendimento_alta(nr_atendimento_p);
 
if (coalesce(nr_atendimento_p,0)	> 0) and (ie_atend_alta_w		= 'S') then 
	 
	nr_atendimento_w	:= obter_atendimento_paciente(cd_pessoa_fisica_p, cd_estabelecimento_w);
	 
	if (coalesce(nr_atendimento_w,0)	> 0) then 
		 
		select	max(plt_obter_prescricao(nr_prescricao,nr_prescricoes,nr_prescr_titulo,nm_usuario_p,cd_pessoa_fisica_p,'U')) 
		into STRICT	nr_prescricao_w 
		from	w_rep_t_v 
		where	nm_usuario		= nm_usuario_p 
		and	ie_copiar		= 'S' 
		and	coalesce(nr_prescr_titulo::text, '') = '' 
		and	ie_tipo_item		<> 'DI';
		 
		select	max(dt_validade_prescr) 
		into STRICT	dt_validade_prescr_w 
		from	prescr_medica 
		where	nr_prescricao	= nr_prescricao_w;
		 
		if	((dt_inicio_plano_w - 1)	> dt_validade_prescr_w) then 
		 
			cd_setor_atendimento_w	:= Obter_Setor_nova_prescr(nr_atendimento_w,nm_usuario_p,cd_perfil_p,cd_estabelecimento_w);
		 
			dt_prim_hor_prescr_w	:= to_date(	to_char(clock_timestamp(),'dd/mm/yyyy')||' '|| 
								to_char(PLT_Obter_Prim_Hor_Plano(nr_atendimento_w,cd_setor_atendimento_w,clock_timestamp(),nm_usuario_p), 
								'hh24:mi')||':00','dd/mm/yyyy hh24:mi:ss');
			if (dt_inicio_plano_w	> dt_prim_hor_prescr_w) then 
				dt_inicio_plano_w	:= dt_prim_hor_prescr_w;
			end if;
		 
		end if;
	end if;
end if;
 
dt_inicio_plano_w	:= round(dt_inicio_plano_w,'mi');
 
return	dt_inicio_plano_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION plt_obter_inicio_extensao ( cd_pessoa_fisica_p text, nm_usuario_p text, cd_setor_atendimento_p bigint, dt_quebra_p timestamp, hr_quebra_p text, cd_perfil_p bigint, nr_atendimento_p bigint) FROM PUBLIC;
