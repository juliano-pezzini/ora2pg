-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_proced_lib_prescr (cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_exame_p bigint, nr_seq_proc_interno_p bigint, cd_perfil_p bigint, cd_setor_prescricao_p bigint, nm_usuario_p text, cd_material_exame_p text, nr_prescricao_p bigint, ie_opcao_p text, dt_prev_execucao_p timestamp) RETURNS varchar AS $body$
DECLARE



cd_area_procedimento_w		estrutura_procedimento_v.cd_area_procedimento%type;
cd_especialidade_w		estrutura_procedimento_v.cd_especialidade%type;
cd_grupo_proc_w			estrutura_procedimento_v.cd_grupo_proc%type;
cont_w						bigint := 0;
cont2_w						bigint := 0;
nr_seq_regra_w				bigint;
nr_seq_grupo_w				bigint;
cd_procedencia_w			bigint;
ie_permite_prescrever_w		varchar(1);
cd_perfil_regra_w			bigint;
ds_retorno_w				varchar(1) := 'S';
ds_retorno_ww				varchar(2000);
ds_mensagem_w				varchar(2000);
qt_idade_w					bigint;
cd_convenio_w				integer;
cd_cid_w					varchar(50);
ie_tipo_atendimento_w		smallint;
ie_clinica_w				integer;
ie_dia_semana_w				varchar(1);
ie_domingo_w				varchar(1);
ie_segunda_w				varchar(1);	
ie_terca_w					varchar(1);
ie_quarta_w					varchar(1);
ie_quinta_w					varchar(1);
ie_sexta_w					varchar(1);
ie_sabado_w					varchar(1);
hr_inicio_w					regra_prescr_procedimento.hr_inicio%type;
hr_final_w					regra_prescr_procedimento.hr_final%type;
dt_inicio_w					timestamp;
dt_fim_w					timestamp;
cd_pessoa_fisica_w			pessoa_fisica.cd_pessoa_fisica%type;
ie_considerar_w				regra_prescr_procedimento.ie_considerar%type;
dt_inicial_w				regra_prescr_procedimento.dt_inicial%type;
dt_final_w					regra_prescr_procedimento.dt_final%type;
qt_idade_meses_w			bigint;
qt_idade_dias_w				bigint;

c01 CURSOR FOR
SELECT	coalesce(ie_permite_prescrever,'S'),
	nr_sequencia,
	ds_mensagem,
	coalesce(ie_domingo,'S'),
	coalesce(ie_segunda,'S'),
	coalesce(ie_terca,'S'),
	coalesce(ie_quarta,'S'),
	coalesce(ie_quinta,'S'),
	coalesce(ie_sexta,'S'),
	coalesce(ie_sabado,'S'),
	coalesce(ie_considerar,'DI'),
	coalesce(dt_inicial, to_date('01/01/1989 00:00:01','dd/mm/yyyy hh24:mi:ss')),
	coalesce(dt_final, to_date('31/12/2999 23:59:59','dd/mm/yyyy hh24:mi:ss')),
	hr_inicio,
	hr_final		
from	regra_prescr_procedimento a
where  ((cd_procedimento = cd_procedimento_p) or (coalesce(cd_procedimento::text, '') = ''))
and	((ie_origem_proced = ie_origem_proced_p) or (coalesce(cd_procedimento::text, '') = ''))
and	((cd_grupo_proc = cd_grupo_proc_w) or (coalesce(cd_grupo_proc::text, '') = ''))
and	((cd_especialidade = cd_especialidade_w) or (coalesce(cd_especialidade::text, '') = ''))
and	coalesce(a.nr_seq_grupo_lab, coalesce(nr_seq_grupo_w,0))		= coalesce(nr_seq_grupo_w,0)
and	coalesce(a.cd_material_exame, coalesce(cd_material_exame_p,'0'))	= coalesce(cd_material_exame_p,'0')
and	((nr_seq_exame = nr_seq_exame_p) or (coalesce(nr_seq_exame::text, '') = ''))
and	((cd_area_procedimento = cd_area_procedimento_w) or (coalesce(cd_area_procedimento::text, '') = ''))
and 	((coalesce(cd_setor_atendimento::text, '') = '') or (cd_setor_atendimento = cd_setor_prescricao_p))
and 	((coalesce(nr_seq_proc_interno::text, '') = '') or (nr_seq_proc_interno = nr_seq_proc_interno_p))
and	((coalesce(cd_procedencia::text, '') = '') or (cd_procedencia = cd_procedencia_w))
and	((coalesce(cd_convenio::text, '') = '') or (cd_convenio = cd_convenio_w))
and	coalesce(qt_idade_w,0) between coalesce(qt_idade_min,0) and coalesce(qt_idade_max,999)
and 	((coalesce(cd_doenca_cid::text, '') = '') or (cd_doenca_cid = cd_cid_w))
and	((coalesce(ie_tipo_atendimento::text, '') = '') or (ie_tipo_atendimento = ie_tipo_atendimento_w))
and	((coalesce(ie_clinica::text, '') = '') or (ie_clinica = ie_clinica_w))
and	coalesce(qt_idade_meses_w,0) between coalesce(qt_idade_meses_min,0) and coalesce(qt_idade_meses_max,99999)
and	coalesce(qt_idade_dias_w,0) between coalesce(qt_idade_dias_min,0) and coalesce(qt_idade_dias_max,999999)
order by Obter_seq_ordenacao_regra(a.nr_sequencia,cd_pessoa_fisica_w,cd_perfil_p,cd_setor_prescricao_p),
	coalesce(cd_procedimento, 0),
	 coalesce(nr_seq_proc_interno, 0),
         coalesce(nr_seq_exame,0),
	 coalesce(cd_grupo_proc, 0),
	 coalesce(cd_especialidade, 0),
	 coalesce(cd_area_procedimento, 0),
	 coalesce(cd_setor_atendimento, 0),
	 coalesce(cd_convenio, 0),
	 coalesce(nr_seq_grupo_lab, 0),
	 coalesce(ie_origem_proced, 0),
	 coalesce(cd_material_exame, 'AAA'),
	 coalesce(cd_doenca_cid, 'AAA'),
	 coalesce(ie_tipo_atendimento, 0),
	 coalesce(ie_clinica, 0),
	 case ie_dia_semana_w
	 when '1' then coalesce(ie_domingo,'S')
	 when '2' then  coalesce(ie_segunda,'S')
	 when '3' then  coalesce(ie_terca,'S')
	 when '4' then  coalesce(ie_quarta,'S')
	 when '5' then  coalesce(ie_quinta,'S')
	 when '6' then  coalesce(ie_sexta,'S')
	 when '7' then  coalesce(ie_sabado,'S')
	 end,
	 to_date(coalesce(hr_inicio,'00:00')||':01', 'hh24:mi:ss');


BEGIN

ie_dia_semana_w	:= pkg_date_utils.get_weekday(dt_prev_execucao_p);

select	count(nr_sequencia)
into STRICT	cont2_w
from	regra_prescr_procedimento;

if (cont2_w = 0) then
	ds_retorno_w := 'S';
end if;

select 	max(cd_area_procedimento),
		max(cd_especialidade),
		max(cd_grupo_proc)
into STRICT	cd_area_procedimento_w,
		cd_especialidade_w,
		cd_grupo_proc_w
from	estrutura_procedimento_v
where	cd_procedimento 	= cd_procedimento_p
and		ie_origem_proced 	= ie_origem_proced_p;

select	max(a.cd_procedencia),
		max(obter_idade_pf(a.cd_pessoa_fisica,clock_timestamp(),'A')),
		max(obter_convenio_atendimento(a.nr_atendimento)),
		max(Obter_cod_Diagnostico_atend(a.nr_atendimento)),
		max(a.ie_tipo_atendimento),
		max(a.ie_clinica),
		max(obter_idade_pf(a.cd_pessoa_fisica,clock_timestamp(),'M')),
		max(obter_idade_pf(a.cd_pessoa_fisica,clock_timestamp(),'DIA'))
into STRICT	cd_procedencia_w,
		qt_idade_w,
		cd_convenio_w,
		cd_cid_w,
		ie_tipo_atendimento_w,
		ie_clinica_w,
		qt_idade_meses_w,
		qt_idade_dias_w
from	Atendimento_paciente a,
		prescr_medica b
where	b.nr_prescricao		= nr_prescricao_p
and		a.nr_atendimento	= b.nr_atendimento;

select	max(cd_pessoa_fisica)
into STRICT	cd_pessoa_fisica_w
from	usuario
where	nm_usuario = nm_usuario_p;

if (nr_seq_exame_p IS NOT NULL AND nr_seq_exame_p::text <> '') then
	begin
	select	nr_seq_grupo
	into STRICT	nr_seq_grupo_w
	from	exame_laboratorio
	where	nr_seq_exame	= nr_seq_exame_p;
	exception
		when others then
			nr_seq_grupo_w	:= null;
	end;
end if;	

open C01;
loop
fetch C01 into	
	ie_permite_prescrever_w,
	nr_seq_regra_w,
	ds_mensagem_w,
	ie_domingo_w,
	ie_segunda_w,
	ie_terca_w,
	ie_quarta_w,
	ie_quinta_w,
	ie_sexta_w,
	ie_sabado_w,
	ie_considerar_w,
	dt_inicial_w,
	dt_final_w,
	hr_inicio_w,
	hr_final_w;
EXIT WHEN NOT FOUND; /* apply on C01 */


		
	select	count(*)
	into STRICT	cont_w
	from	regra_prescr_proc_perfil
	where	nr_seq_regra	= nr_seq_regra_w;
		
	if (cont_w = 0) then
		ds_retorno_w	:= ie_permite_prescrever_w;
	else
		select	count(*)
		into STRICT	cont2_w
		from	regra_prescr_proc_perfil
		where	nr_seq_regra	= nr_seq_regra_w
		and		coalesce(cd_perfil, cd_perfil_p)	= cd_perfil_p
		and		coalesce(cd_pessoa_fisica, cd_pessoa_fisica_w) = cd_pessoa_fisica_w
		and		coalesce(cd_setor_atendimento, cd_setor_prescricao_p) = cd_setor_prescricao_p;
		
		if (cont2_w > 0) then
			ds_retorno_w	:= ie_permite_prescrever_w;
		end if;
	end if;
	
	--Verifica dias da semana e horario	

	-- Mesmo que o ie_permite_prescrever_w for "N" devera ser feita a validacao abaixo

	--Pois pode existir uma restricao p/ nao permitir prescrever o procedimento em apenas um determinado dia/hora

	--Implicitamente os demais dias/horarios o procedimento podera ser prescrito,..
	
	if (ie_considerar_w <> 'DI') then
		if (clock_timestamp() between dt_inicial_w and dt_final_w) then
			ds_retorno_w := ie_permite_prescrever_w;
		else
			ds_retorno_w := 'S';
		end if;
	elsif (cont_w  = 0 or cont2_w > 0) then
			
		--Verifica se a regra de dias da semana		
		if	((ie_dia_semana_w	= '1' AND ie_domingo_w = 'N') or
			(ie_dia_semana_w	= '2' AND ie_segunda_w = 'N') or
			(ie_dia_semana_w	= '3' AND ie_terca_w	= 'N') or
			(ie_dia_semana_w	= '4' AND ie_quarta_w	= 'N') or
			(ie_dia_semana_w	= '5' AND ie_quinta_w	= 'N') or
			(ie_dia_semana_w	= '6' AND ie_sexta_w	= 'N') or
			(ie_dia_semana_w	= '7' AND ie_sabado_w	= 'N')) then
			
			ds_retorno_w := 'N';
			
		elsif  	((ie_dia_semana_w	= '1' AND ie_domingo_w = 'S') or
			(ie_dia_semana_w	= '2' AND ie_segunda_w = 'S') or
			(ie_dia_semana_w	= '3' AND ie_terca_w	= 'S') or
			(ie_dia_semana_w	= '4' AND ie_quarta_w	= 'S') or
			(ie_dia_semana_w	= '5' AND ie_quinta_w	= 'S') or
			(ie_dia_semana_w	= '6' AND ie_sexta_w	= 'S') or
			(ie_dia_semana_w	= '7' AND ie_sabado_w	= 'S')) then
			
			ds_retorno_w := 'S';
			
		end if;

							
		--Caso o ds_retorno_w for "S" devera verificar as restricoes de horario (caso existir)

		-- Se retornar "N" o item nao pode ser prescrito neste dia da semana..
		if	(((hr_inicio_w IS NOT NULL AND hr_inicio_w::text <> '') or (hr_final_w IS NOT NULL AND hr_final_w::text <> '')) and (ds_retorno_w = 'S')) then				
			begin		
											
			if (hr_inicio_w IS NOT NULL AND hr_inicio_w::text <> '') and (coalesce(hr_final_w::text, '') = '') then
				dt_inicio_w := ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_prev_execucao_p, hr_inicio_w);
				--Se a regra permite presrever o item, verificar se a dt. execucao do item e menor que a dt. de inicio da regra, caso for retorna N.
				if	(ie_permite_prescrever_w = 'S' AND dt_prev_execucao_p < dt_inicio_w) then
					ds_retorno_w := 'N';
				-- Se a regra nao permitir prescrever o item, verifica se a dt. execucao do item e  maior que a dt. de inicio da regra, caso for retorna N.
				elsif	(ie_permite_prescrever_w = 'N' AND dt_prev_execucao_p > dt_inicio_w) then
					ds_retorno_w := 'N';
				else
					ds_retorno_w := 'S';
				end if;
			end if;		
			
			if (hr_final_w IS NOT NULL AND hr_final_w::text <> '') and (coalesce(hr_inicio_w::text, '') = '') then			
				dt_fim_w := to_date(to_char(dt_prev_execucao_p, 'dd/mm/yyyy')||' '||hr_final_w||':00', 'dd/mm/yyyy hh24:mi:ss');										
				--Se a regra permite prescrever o item, verifica se a dt. execucao do item e maior que a dt, final da regra, caso for retorna N.
				if	(ie_permite_prescrever_w = 'S' AND dt_prev_execucao_p > dt_fim_w) then				
					ds_retorno_w := 'N';		
				----Se a regra nao permite prescrever o item, verifica se a dt. execucao do item e menor que a dt, final da regra, caso for retorna N.
				elsif	(ie_permite_prescrever_w = 'N' AND dt_prev_execucao_p > dt_fim_w) then				
					ds_retorno_w := 'N';		
				else
					ds_retorno_w := 'S';	
				end if;							
			end if;	
			
			
			--Se o horario inicial e final estiver preenchido "devera"  fazer a comparacao atraves do between p/ nao dar problema.							
			if (hr_inicio_w IS NOT NULL AND hr_inicio_w::text <> '' AND hr_final_w IS NOT NULL AND hr_final_w::text <> '') then
				dt_inicio_w := ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_prev_execucao_p, hr_inicio_w);
				dt_fim_w := ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_prev_execucao_p, hr_final_w);
				if	((ie_permite_prescrever_w = 'S') and (not(dt_prev_execucao_p between dt_inicio_w and dt_fim_w))) then
					ds_retorno_w := 'N';
				elsif	(ie_permite_prescrever_w = 'N' AND dt_prev_execucao_p between dt_inicio_w and dt_fim_w) then
					ds_retorno_w := 'N';		
				else
					ds_retorno_w := 'S';	
				end if;
			end if;
			
			exception
			when others then
				ds_retorno_w := 'S';									
			end;	

		elsif (ds_retorno_w = 'S') then
			ds_retorno_w := 'S';
			
		end if;	
		
	end if;
	--fim validacao dias da semana e horario
	
end loop;
close C01;

if (ie_opcao_p = 'C') then
	ds_retorno_ww	:= ds_retorno_w;
else
	ds_retorno_ww	:= ds_mensagem_w;
end if;


return	ds_retorno_ww;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_proced_lib_prescr (cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_exame_p bigint, nr_seq_proc_interno_p bigint, cd_perfil_p bigint, cd_setor_prescricao_p bigint, nm_usuario_p text, cd_material_exame_p text, nr_prescricao_p bigint, ie_opcao_p text, dt_prev_execucao_p timestamp) FROM PUBLIC;

