-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION verifica_hor_visita_disp ( dt_entrada_p timestamp, cd_setor_atendimento_p bigint, nr_atendimento_p bigint, ie_tipo_visita_p text, nr_seq_tipo_visitante_p bigint default 0, nr_chamada_p bigint default 0) RETURNS bigint AS $body$
DECLARE

 
dt_inicio_visita_w	  	timestamp;
dt_fim_visita_w	        timestamp;
qt_horario_visita_w		bigint;
cd_tipo_acomod_w		integer;
qt_cont_visit_w			bigint;
qt_cont_visit_h_w		bigint;
qt_cont_visit_s_w		bigint;
qt_cont_visit_d_w		bigint;
qt_cont_visit_m_w		bigint;
qt_cont_acomp_w			bigint;
qt_cont_acomp_h_w		bigint;
qt_cont_acomp_s_w		bigint;
qt_cont_acomp_d_w		bigint;
qt_cont_acomp_m_w		bigint;
cd_setor_atendimento_w		bigint;
cd_unidade_basica_w		varchar(10);
cd_unidade_compl_w		varchar(10);
qt_max_diario_un		bigint;
qt_max_simult_un		bigint;
qt_max_visitante_un		bigint;
qt_visit_disponivel_h_w		bigint;
qt_visit_disponivel_d_w		bigint;
qt_visit_disponivel_s_w		bigint;
qt_visit_disponivel_m_w		bigint;
ie_visita_fora_horario_w 	varchar(5);
qt_visitantes_possiveis_w	bigint;
qt_visitantes_totais_w		bigint;
ie_considera_acompanhante_w	varchar(1);
ie_simultaneo_w			varchar(1);

/* ie_tipo_visita_p - possíveis valores 
 P - Visita paciente 
 S - Visita Setor 
*/
 
 
/*  ie_visita_fora_horario_w -  possíveis valores: 
 S - Visita fora de horário. Ver em Estrutura atendimento > Horários de visita. 
 N - Visita dentro do horário. Ver em Estrutura atendimento > Horários de visita. 
 LH - Visita ultrapassa limite de visitas por período no setor. Ver em Estrutura atendimento > Horários de visita. 
 LS - Limite simultâneo de visitas para o leito ultrapassado. Ver em Estrutura atendimento > Unidades. 
 LD - Limite diário de visitas para o leito ultrapassado. Ver em Estrutura atendimento > Unidades. 
 LM - Limite máximo de visitas para a unidade ultrapassado. Ver em Estrutura Atendimento > Unidades. 
 */
 
 
C01 CURSOR FOR 
	SELECT	dt_inicio_visita, 
		dt_fim_visita, 
		coalesce(qt_total_visitantes,0), 
		coalesce(ie_simultaneo,'S') 
	from	setor_atend_hor_visita 
	where	cd_setor_atendimento = cd_setor_atendimento_p 
	and	((coalesce(cd_tipo_acomodacao::text, '') = '') or (cd_tipo_acomodacao = cd_tipo_acomod_w)) 
	and	( ((ie_dia_semana = pkg_date_utils.get_WeekDay(clock_timestamp())) or 
		 ((ie_dia_semana = 9) and (pkg_date_utils.is_business_day(clock_timestamp()) = 1))) or coalesce(ie_dia_semana::text, '') = '') 
	and	((coalesce(nr_seq_tipo::text, '') = '') or (nr_seq_tipo_visitante_p = nr_seq_tipo)) 
	and	((coalesce(ie_isolamento,'N') = 'N') or (obter_se_pac_isolamento(nr_atendimento_p) = 'S')) 
	and	((coalesce(cd_convenio::text, '') = '') or (obter_convenio_atendimento(nr_atendimento_p) = cd_convenio)) 
	order by CASE WHEN coalesce(ie_isolamento,'N')='S' THEN 0  ELSE 1 END , CASE WHEN coalesce(cd_convenio::text, '') = '' THEN 1  ELSE 0 END , nr_sequencia;


BEGIN 
 
ie_considera_acompanhante_w := Obter_Param_Usuario(8014, 55, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_considera_acompanhante_w);
 
qt_visit_disponivel_h_w := -1;
qt_visit_disponivel_d_w := -1;
qt_visit_disponivel_s_w := -1;
 
qt_visitantes_possiveis_w := 9999;
qt_visitantes_totais_w   := 9999;
 
select	coalesce(max(cd_tipo_acomodacao),0) 
into STRICT	cd_tipo_acomod_w 
from	atend_paciente_unidade 
where	nr_seq_interno = obter_atepacu_paciente(nr_atendimento_p,'A');
 
select	count(*) 
into STRICT	qt_horario_visita_w 
from	setor_atend_hor_visita 
where	cd_setor_atendimento = cd_setor_atendimento_p 
and	((coalesce(cd_tipo_acomodacao::text, '') = '') or (cd_tipo_acomodacao = cd_tipo_acomod_w));
 
if (qt_horario_visita_w > 0) then 
	ie_visita_fora_horario_w := 'S';
else 
	ie_visita_fora_horario_w := 'N';
end if;
 
open C01;
loop 
fetch C01 into 
	dt_inicio_visita_w, 
	dt_fim_visita_w, 
	qt_cont_visit_w, 
	ie_simultaneo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	if (ie_visita_fora_horario_w = 'S') then 
		if (to_char(dt_entrada_p,'hh24:mi') > to_char(dt_inicio_visita_w,'hh24:mi')) and (to_char(dt_entrada_p,'hh24:mi') < to_char(dt_fim_visita_w,'hh24:mi')) then 
 
			select	count(*) 
			into STRICT	qt_cont_visit_h_w 
			from	atendimento_visita 
			where	nr_atendimento = nr_atendimento_p 
			and 	((coalesce(dt_saida::text, '') = '' and ie_simultaneo_w = 'S') 
					or (ie_simultaneo_w = 'N' 
						and (trunc(dt_saida) = trunc(clock_timestamp()) or coalesce(dt_saida::text, '') = ''))) 
			and	coalesce(ie_paciente,'N') = 'N' 
			and	to_char(dt_entrada,'hh24:mi') > to_char(dt_inicio_visita_w,'hh24:mi') 
			and	to_char(dt_entrada,'hh24:mi') < to_char(dt_fim_visita_w,'hh24:mi');
			 
			qt_visitantes_totais_w := qt_cont_visit_w;
			 
			If (qt_cont_visit_w > 0) and (qt_cont_visit_h_w >= qt_cont_visit_w) then 
				qt_visitantes_possiveis_w := 0;
				ie_visita_fora_horario_w := 'LH';
			Else 
				qt_visit_disponivel_h_w := qt_cont_visit_w - qt_cont_visit_h_w;
				If (qt_visit_disponivel_h_w < qt_visitantes_possiveis_w) 
				And (qt_visit_disponivel_h_w > -1) then 
					qt_visitantes_possiveis_w := qt_visit_disponivel_h_w;
				End if;
				ie_visita_fora_horario_w := 'N';
			end if;
		end if;
	end if;
	end;
end loop;
close C01;
 
 
If (ie_visita_fora_horario_w = 'N') 
And (ie_tipo_visita_p = 'P') then 
 
	select	max(cd_setor_atendimento), 
		max(cd_unidade_basica), 
		max(cd_unidade_compl) 
	into STRICT	cd_setor_atendimento_w, 
		cd_unidade_basica_w, 
		cd_unidade_compl_w 
	from	atend_paciente_unidade 
	where	nr_seq_interno = obter_atepacu_paciente(nr_atendimento_p,'A');
 
	select	max(qt_max_diario), 
		max(qt_max_simultaneo), 
		max(qt_max_visitante) 
	into STRICT	qt_max_diario_un, 
		qt_max_simult_un, 
		qt_max_visitante_un 
	from	unidade_atendimento 
	where	cd_setor_Atendimento = cd_setor_Atendimento_w 
	and	cd_unidade_basica = cd_unidade_basica_w 
	and	cd_unidade_compl = cd_unidade_compl_w;
 
	select	count(*) 
	into STRICT	qt_cont_visit_s_w 
	from	atendimento_visita 
	where	nr_atendimento = nr_atendimento_p 
	and	coalesce(ie_paciente,'N') = 'N' 
	and	coalesce(dt_saida::text, '') = '';
	 
	select	count(*) 
	into STRICT	qt_cont_acomp_s_w 
	from	atendimento_acompanhante 
	where	nr_atendimento = nr_atendimento_p 
	and	coalesce(dt_saida::text, '') = '';
 
	select	count(*) 
	into STRICT	qt_cont_visit_d_w 
	from	atendimento_visita 
	where	nr_atendimento = nr_atendimento_p 
	and	coalesce(ie_paciente,'N') = 'N' 
	and	trunc(dt_entrada) = trunc(dt_entrada_p);
	 
	select	count(*) 
	into STRICT	qt_cont_acomp_d_w 
	from	atendimento_acompanhante 
	where	nr_atendimento = nr_atendimento_p 
	and	trunc(dt_acompanhante) = trunc(dt_entrada_p);
	 
	select	count(*) 
	into STRICT	qt_cont_visit_m_w 
	from	atendimento_visita 
	where	nr_atendimento = nr_atendimento_p 
	and	coalesce(ie_paciente,'N') = 'N';
	 
	select	count(*) 
	into STRICT	qt_cont_acomp_m_w 
	from	atendimento_acompanhante 
	where	nr_atendimento = nr_atendimento_p;
 
	If (ie_considera_acompanhante_w = 'S') then 
		qt_cont_visit_s_w := qt_cont_visit_s_w + qt_cont_acomp_s_w;
		qt_cont_visit_d_w := qt_cont_visit_d_w + qt_cont_acomp_d_w;
		qt_cont_visit_m_w := qt_cont_visit_m_w + qt_cont_acomp_m_w;
	End if;
	 
	if (qt_max_diario_un > 0) and 
		((qt_cont_visit_d_w + 1) > qt_max_diario_un) then 
		qt_visitantes_possiveis_w := 0;
		qt_visitantes_totais_w := qt_max_diario_un;
		ie_visita_fora_horario_w := 'LD';
	elsif (qt_max_simult_un > 0) and 
		((qt_cont_visit_s_w + 1) > qt_max_simult_un) then 
		qt_visitantes_possiveis_w := 0;
		qt_visitantes_totais_w := qt_max_simult_un;
		ie_visita_fora_horario_w := 'LS';
	elsif (qt_max_visitante_un > 0) and 
		((qt_cont_visit_m_w + 1) > qt_max_visitante_un) then 
		qt_visitantes_possiveis_w := 0;
		qt_visitantes_totais_w := qt_max_visitante_un;
		ie_visita_fora_horario_w := 'LM';
	else 
		if (qt_max_diario_un > 0) then 
			qt_visit_disponivel_d_w := qt_max_diario_un - qt_cont_visit_d_w;
			If (qt_visit_disponivel_d_w < qt_visitantes_possiveis_w) 
			And (qt_visit_disponivel_d_w > -1) then 
				qt_visitantes_possiveis_w := qt_visit_disponivel_d_w;
				qt_visitantes_totais_w  := qt_max_diario_un;
			End if;
		end if;
		if (qt_max_simult_un > 0) then 
			qt_visit_disponivel_s_w := qt_max_simult_un - qt_cont_visit_s_w;
			If (qt_visit_disponivel_s_w < qt_visitantes_possiveis_w) 
			And (qt_visit_disponivel_s_w > -1) then 
				qt_visitantes_possiveis_w := qt_visit_disponivel_s_w;
				qt_visitantes_totais_w := qt_max_simult_un;
			End if;
		end if;
		if (qt_max_visitante_un > 0) then 
			qt_visit_disponivel_m_w := qt_max_visitante_un - qt_cont_visit_m_w;
			If (qt_visit_disponivel_m_w < qt_visitantes_possiveis_w) 
			And (qt_visit_disponivel_m_w > -1) then 
				qt_visitantes_possiveis_w := qt_visit_disponivel_m_w;
				qt_visitantes_totais_w  := qt_max_visitante_un;
			End if;
		end if;
		ie_visita_fora_horario_w := 'N';
	end if;
End if;
 
if nr_chamada_p = 2 then 
	return qt_visitantes_totais_w;
else 
	return qt_visitantes_possiveis_w;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION verifica_hor_visita_disp ( dt_entrada_p timestamp, cd_setor_atendimento_p bigint, nr_atendimento_p bigint, ie_tipo_visita_p text, nr_seq_tipo_visitante_p bigint default 0, nr_chamada_p bigint default 0) FROM PUBLIC;
