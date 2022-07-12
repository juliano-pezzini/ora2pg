-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_primeiro_horario ( nr_atendimento_p bigint, cd_intervalo_p text, cd_material_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type default null, ie_via_aplicacao_p text default null, ie_hor_agora_p text default 'N', si_fulltime_p text default 'N') RETURNS varchar AS $body$
DECLARE


ie_limpa_prim_hor_w			intervalo_prescricao.ie_limpa_prim_hor%type := 'N';
ds_prim_horario_ww			intervalo_prescricao.ds_prim_horario%type;
ie_prim_hor_validade_w		intervalo_prescricao.ie_prim_hor_validade%type;
ie_operacao_w				intervalo_prescricao.ie_operacao%type;
ds_horarios_w				intervalo_prescricao.ds_horarios%type;

cd_setor_atend_prescr_w		setor_atendimento.cd_setor_atendimento%type;
nr_seq_agrupamento_w		setor_atendimento.nr_seq_agrupamento%type;	

qt_peso_w					double precision;
nr_horas_validade_w			prescr_medica.nr_horas_validade%type;
dt_primeiro_horario_w		prescr_medica.dt_primeiro_horario%type;
dt_validade_prescr_w		prescr_medica.dt_validade_prescr%type;

hr_prim_horario_w			material_prescr.hr_prim_horario%type;	
cd_intervalo_w				material_prescr.cd_intervalo%type;	

ds_prim_horario_w			intervalo_setor.ds_prim_horario%type;

cd_pessoa_fisica_w			pessoa_fisica.cd_pessoa_fisica%type := cd_pessoa_fisica_p;

qt_idade_w				double precision;

nm_usuario_w			usuario.nm_usuario%type;
cd_perfil_w				perfil.cd_perfil%type;
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;

cd_unidade_basica_w		varchar(30);
hr_inicial_w			varchar(10);
ds_hora_inicio_w		varchar(10);
ds_horario_w			varchar(10);
ie_minutos_w			varchar(1);
hr_horario_setor_w		varchar(10);
ds_retorno_w			varchar(20);
ds_retorno_ww			varchar(255);

hr_ref_w				timestamp;
hr_atual_w				timestamp;
ie_regra_horario_w		prescr_horario_setor.ie_regra_horario%type;
cd_classif_setor_w		setor_atendimento.cd_classif_setor%type;
ie_primeiro_horario_w	varchar(2);
si_days_first_schedule_w varchar(1) := 'N';
si_rule_material_interval_w varchar(1) := 'N';

c01 CURSOR FOR
SELECT	hr_prim_horario,
		cd_intervalo
from	material_prescr a
where	a.cd_material = cd_material_p
and		coalesce(a.cd_setor_atendimento, coalesce(cd_setor_atend_prescr_w,0))	= coalesce(cd_setor_atend_prescr_w,0)
and		a.ie_tipo = '1'
and		coalesce(a.cd_unidade_basica,coalesce(cd_unidade_basica_w,'0'))	= coalesce(cd_unidade_basica_w,'0')
and		coalesce(qt_peso_w,1) between coalesce(a.qt_peso_min,0) and coalesce(a.qt_peso_max,999999)
and		((coalesce(nr_seq_agrupamento::text, '') = '') or (nr_seq_agrupamento = nr_seq_agrupamento_w))
and		coalesce(qt_idade_w,1) between coalesce(Obter_idade_param_prescr2(coalesce(a.qt_idade_min,0),coalesce(a.qt_idade_min_mes,0),coalesce(a.qt_idade_min_dia,0),coalesce(a.qt_idade_max,0),coalesce(a.qt_idade_max_mes,0),coalesce(a.qt_idade_max_dia,0),'MIN'),0)
and		coalesce(Obter_idade_param_prescr2(coalesce(a.qt_idade_min,0),coalesce(a.qt_idade_min_mes,0),coalesce(a.qt_idade_min_dia,0),coalesce(a.qt_idade_max,0),coalesce(a.qt_idade_max_mes,0),coalesce(a.qt_idade_max_dia,0),'MAX'),9999999)
and		not exists (	SELECT	1
					from	regra_setor_mat_prescr b
					where	a.nr_sequencia	= b.nr_seq_mat_prescr
					and		b.cd_setor_excluir	= cd_setor_atend_prescr_w)
and		((coalesce(a.cd_estabelecimento::text, '') = '')	or (a.cd_estabelecimento = cd_estabelecimento_p))
and		((coalesce(a.cd_intervalo_filtro::text, '') = '') or (a.cd_intervalo_filtro = cd_intervalo_p))
and		((coalesce(cd_doenca_cid::text, '') = '') or (obter_se_cid_atendimento(nr_atendimento_p,cd_doenca_cid) = 'S'))
order by
		coalesce(a.cd_setor_atendimento,99999) desc,
		a.qt_idade_min,
		a.qt_idade_max,
		coalesce(a.ie_via_aplicacao, 'zzzzzzzz') desc,
		coalesce(a.qt_peso_min, 99999999) desc,
		a.nr_sequencia;
		
C02 CURSOR FOR
	SELECT	ie_regra_horario
	from	prescr_horario_setor
	where	coalesce(cd_setor_atendimento, coalesce(cd_setor_atend_prescr_w,0))	= coalesce(cd_setor_atend_prescr_w,0)
	and	coalesce(nm_usuario_regra, coalesce(nm_usuario_p, 0))			= coalesce(nm_usuario_p, 0)
	and	coalesce(cd_estabelecimento,cd_estabelecimento_w)	= cd_estabelecimento_w
	and	coalesce(cd_perfil, cd_perfil_w)			= cd_perfil_w
	and coalesce(ie_funcao,'A') in ('R','A')
	and	clock_timestamp() between	obter_prim_hor_prescr_regra(clock_timestamp(),
						coalesce(hr_inicio,pkg_date_utils.get_dateTime(1900, 1, 1, 00, 00, 01)), 
						coalesce(hr_fim,pkg_date_utils.get_dateTime(1900,01,01,23,59,59)), 'I') and
					obter_prim_hor_prescr_regra(clock_timestamp(), 
						coalesce(hr_inicio,pkg_date_utils.get_dateTime(1900, 1, 1, 00, 00, 01)), 
						coalesce(hr_fim,pkg_date_utils.get_dateTime(1900,01,01,23,59,59)), 'F')
	order by coalesce(nr_seq_prioridade,0),
		coalesce(cd_setor_atendimento,99999999) desc,
		coalesce(cd_perfil,9999999) desc,
		coalesce(nm_usuario_regra, 'XXXX') desc,
		hr_fixa desc;
	
BEGIN

cd_perfil_w				:=  coalesce(cd_perfil_p, wheb_usuario_pck.get_cd_perfil);
nm_usuario_w			:=  coalesce(nm_usuario_p, wheb_usuario_pck.get_nm_usuario);
cd_estabelecimento_w	:=  coalesce(cd_estabelecimento_p, wheb_usuario_pck.get_cd_estabelecimento);

if (coalesce(nr_atendimento_p::text, '') = '') then
	cd_pessoa_fisica_w		:= cd_pessoa_fisica_p;
	qt_peso_w				:= obter_peso_pf(cd_pessoa_fisica_p);
	cd_unidade_basica_w		:= null;
	cd_setor_atend_prescr_w	:= null;
else
	
	qt_peso_w				:= round((obter_sinal_vital(nr_atendimento_p,'Peso'))::numeric, 3);
	
	select	max(a.cd_pessoa_fisica),
			max(b.cd_unidade_basica)
	into STRICT	cd_pessoa_fisica_w,
			cd_unidade_basica_w
	from	atendimento_paciente a,
			atend_paciente_unidade b
	where	a.nr_atendimento = b.nr_atendimento
	and		a.nr_atendimento = nr_atendimento_p
	and		b.nr_seq_interno = obter_atepacu_paciente(a.nr_atendimento, 'A');
			
	
	cd_setor_atend_prescr_w := cpoe_obter_setor_atend_prescr(nr_atendimento_p,cd_estabelecimento_p,cd_perfil_p,nm_usuario_p);
end if;

qt_idade_w	:= obter_idade_pf(cd_pessoa_fisica_w, clock_timestamp(), 'DIA');

select	coalesce(obter_dados_apraz_interv(max(cd_intervalo),cd_setor_atend_prescr_w,'1'), coalesce(max(ie_limpa_prim_hor),'N')),
		max(ds_prim_horario),
		coalesce(max(ie_prim_hor_validade),'N'),
		max(ie_operacao),
		max(ds_horarios)
into STRICT	ie_limpa_prim_hor_w,
		ds_prim_horario_ww,
		ie_prim_hor_validade_w,
		ie_operacao_w,
		ds_horarios_w
from	intervalo_prescricao
where	cd_intervalo = cd_intervalo_p;

--if	(cd_setor_atend_prescr_w is not null) then
	select	max(nr_seq_agrupamento),
			max(cd_classif_setor)
	into STRICT	nr_seq_agrupamento_w,
			cd_classif_setor_w
	from	setor_atendimento
	where	cd_setor_atendimento	= cd_setor_atend_prescr_w;

--end if;

-- INICIO: Rotina para calcular a validade da prescricao
nr_horas_validade_w	:= 24;
	
dt_primeiro_horario_w	:= trunc(clock_timestamp() + interval '1 days'/24,'hh24');
	
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
	nr_horas_validade_w	:= coalesce(Obter_Horas_Validade_Prescr( dt_primeiro_horario_w, nr_atendimento_p, 'N', 'A', trunc(clock_timestamp(),'mi'), null),24) + 24;
	
	if (cd_setor_atend_prescr_w IS NOT NULL AND cd_setor_atend_prescr_w::text <> '') then
		select	max(to_char(hr_inicio_prescricao,'hh24:mi'))
		into STRICT	hr_horario_setor_w
		from	setor_atendimento
		where	cd_setor_atendimento = cd_setor_atend_prescr_w;

		if (hr_horario_setor_w IS NOT NULL AND hr_horario_setor_w::text <> '') and (hr_horario_setor_w <> to_char((dt_primeiro_horario_w + 1/nr_horas_validade_w),'hh24:mi')) then
			nr_horas_validade_w	:= nr_horas_validade_w + 1;
		end if;
	end if;
	
	dt_validade_prescr_w := clock_timestamp() + coalesce(nr_horas_validade_w,24) / 24;
end if;
-- FIM: Rotina para calcular a validade da prescricao
begin
	if (coalesce(ie_limpa_prim_hor_w,'N') = 'N') then	
		if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then
			open C01;
			loop
			fetch C01 into	
				hr_prim_horario_w,
				cd_intervalo_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				hr_prim_horario_w	:= hr_prim_horario_w;
				cd_intervalo_w		:= cd_intervalo_w;
				si_rule_material_interval_w := 'S';
			end loop;
			close C01;
		end if;
		
		hr_inicial_w		:= to_char(trunc(clock_timestamp(),'hh24') + 1/24,'hh24:mi');
		
		select	coalesce(max(a.ds_prim_horario) || max(reordenar_horarios(clock_timestamp(),a.ds_horarios)) || ' ', ' '),
                coalesce(max(a.ds_horarios), ds_horarios_w)
		into STRICT	ds_prim_horario_w,
                ds_horarios_w
		from	intervalo_material a
		where	a.cd_intervalo	= cd_intervalo_p
		and		a.cd_material		= cd_material_p;
		
		if (ds_prim_horario_w = ' ') then
			select	coalesce(max(b.ds_prim_horario) || ' ', ' '),
                    coalesce(max(b.ds_horarios), ds_horarios_w)
			into STRICT	ds_prim_horario_w,
                    ds_horarios_w
			from	intervalo_setor b
			where	b.cd_intervalo = cd_intervalo_p
			and		((coalesce(b.cd_setor_atendimento::text, '') = '') or (b.cd_setor_atendimento = cd_setor_atend_prescr_w))
			and		((coalesce(b.cd_estab::text, '') = '') or (b.cd_estab = cd_estabelecimento_p))
			and		((b.cd_material = cd_material_p) or (coalesce(b.cd_material::text, '') = ''))
			and		((coalesce(b.cd_unidade_basica::text, '') = '') or (b.cd_unidade_basica = cd_unidade_basica_w))
			and		((coalesce(ie_via_aplicacao::text, '') = '') or (b.ie_via_aplicacao = ie_via_aplicacao_p));

			if (ds_prim_horario_w = ' ') then
				select	coalesce(max(a.ds_prim_horario) || ' ', ' '),
                        coalesce(max(a.ds_horarios), ds_horarios_w)
				into STRICT	ds_prim_horario_w,
                        ds_horarios_w
				from	intervalo_prescricao a
				where	a.cd_intervalo = cd_intervalo_p;
			end if;
		end if;

		if (ds_prim_horario_w <> ' ') then
			si_rule_material_interval_w := 'S';
		end if;

		begin
			if (substr(hr_inicial_w,1,2) = '24') then
				hr_ref_w	:= ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(clock_timestamp()) + 1;
			else
				hr_ref_w	:= to_date(hr_inicial_w,'hh24:mi');
			end if;
		exception when others then
			-- A data inicial nao e valida
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(184005);
		end;
		
		if (hr_ref_w < clock_timestamp()) then
			hr_ref_w	:= hr_ref_w + 1;
		end if;

		ds_horario_w		:= '';
		
		FOR i 	IN 1.. length(ds_prim_horario_w) LOOP
			begin
			if (substr(ds_prim_horario_w,i,1) = ' ') then
				begin
				if (coalesce(ds_hora_inicio_w::text, '') = '') then
					ds_hora_inicio_w	:= ds_horario_w;
				end if;
				if (substr(ds_horario_w,1,2) = '00') or (substr(ds_horario_w,1,2) = '24') then
					hr_atual_w	:= ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(clock_timestamp()) + 1;
				else
					ie_minutos_w	:= 'N';
					if (length(ds_horario_w) = 0) then
						ds_horario_w	:= '00';
					elsif	((length(ds_horario_w) > 2) and (length(ds_horario_w) <> 5)) or
						((length(ds_horario_w) = 5) and
						 ((substr(ds_horario_w,3,1) <> ':') or (substr(ds_horario_w,4,1) > '5'))) then
						ds_horario_w	:= substr(ds_horario_w,1,2);
					end if;

					if (length(ds_horario_w) = 1) then
						ds_horario_w	:= '0' || ds_horario_w;
					elsif (length(ds_horario_w) = 5) then
						ie_minutos_w	:= 'S';
					end if;			
					if (ds_horario_w <> 'SN') then
						if (ie_minutos_w	= 'S') then
							hr_atual_w	:= to_date(ds_horario_w,'hh24:mi');
						else
							hr_atual_w	:= to_date(ds_horario_w,'hh24');
						end if;					
					end if;
				end if;

				if (hr_atual_w < clock_timestamp()) then
					hr_atual_w	:= hr_atual_w + 1;
				end if;
				if (ds_horario_w <> 'SN') then
					if (length(ds_horario_w) = 2) then
						ds_horario_w	:= ds_horario_w || ':00';
					end if;
					if (ds_horario_w >= to_char(clock_timestamp(),'hh24:mi')) then
						begin
						hr_inicial_w	:= ds_horario_w;
						ds_hora_inicio_w:= ds_horario_w;
						exit;
						end;
					end if;
				end if;
				ds_horario_w		:= '';
				end;
			else
				begin
				ds_horario_w	:= substr(ds_horario_w || substr(ds_prim_horario_w,i,1),1,5);
				end;
			end if;
			end;
		END LOOP;

		begin
		if	((hr_inicial_w <> ds_hora_inicio_w) or
			((coalesce(ds_hora_inicio_w::text, '') = '') and (hr_inicial_w IS NOT NULL AND hr_inicial_w::text <> ''))) then
			if	((to_date(coalesce(ds_hora_inicio_w,hr_inicial_w),'dd/mm/yyyy hh24:mi') < clock_timestamp()) or (to_date(coalesce(ds_hora_inicio_w,hr_inicial_w),'dd/mm/yyyy hh24:mi') > dt_validade_prescr_w)) and (to_date(coalesce(ds_hora_inicio_w,hr_inicial_w),'dd/mm/yyyy hh24:mi') + 1 > dt_validade_prescr_w) then
				hr_inicial_w	:= to_char(clock_timestamp(),'hh24:mi');		
			else
				hr_inicial_w	:= ds_hora_inicio_w;
			end if;
		end if;
		exception when others then
			hr_inicial_w	:= ds_hora_inicio_w;
		end;

		if (hr_prim_horario_w IS NOT NULL AND hr_prim_horario_w::text <> '') and
			((cd_intervalo_w = cd_intervalo_p) or (coalesce(cd_intervalo_w::text, '') = '')) then
			hr_inicial_w	:= hr_prim_horario_w;
		end if;

		if (length(hr_inicial_w) = 2) then
			hr_inicial_w	:= hr_inicial_w || ':00';
		end if;
		
		ie_primeiro_horario_w := obter_param_usuario(924, 351, cd_perfil_w, nm_usuario_p, cd_estabelecimento_w, ie_primeiro_horario_w);

		if (ie_hor_agora_p = 'S') and (coalesce(hr_inicial_w::text, '') = '') and
			(not ((cd_classif_setor_w  = '1') and (coalesce(ie_primeiro_horario_w,'A')	= 'A'))) then

			for w_C02 in C02 loop
        	begin
				ie_regra_horario_w := w_C02.ie_regra_horario;
        	end;
			end loop;

			if (coalesce(ie_regra_horario_w,'XPTO') = 'A') then
				ds_retorno_w := 'AGORA';
			else
				ds_retorno_w := to_char(obter_prim_horario_prescricao(nr_atendimento_p,
																	cd_setor_atend_prescr_w,
																	(to_date(to_char(clock_timestamp(),'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')),
																	nm_usuario_p,'R'),'hh24:mi');
			end if;
		else
			ds_retorno_w	:= coalesce(hr_inicial_w, TO_CHAR(Obter_Prim_Horario_Prescricao(nr_atendimento_p,
																	cd_setor_atend_prescr_w,
																	(to_date(to_char(clock_timestamp(),'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')),
																	nm_usuario_p,'R'),'hh24:mi'));
		end if;

		if (ds_retorno_w = '24:00') or (ds_retorno_w = '24') then
			ds_retorno_w	:= '00:00';
		end if;
	end if;

	if (coalesce(ds_prim_horario_ww::text, '') = '') and (ie_prim_hor_validade_w = 'S') then
		if (mod((to_char(clock_timestamp(),'hh24'))::numeric ,2) = 0) then
			ds_retorno_w	:= to_char(trunc(clock_timestamp(),'hh24') + 2/24,'hh24:mi');	
		else	
			ds_retorno_w	:= to_char(trunc(clock_timestamp(),'hh24') + 3/24,'hh24:mi');
		end if;
	end if;

	if	((ie_operacao_w in ('V', 'D', 'F')) and (ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '')) then
		begin
			if (ie_operacao_w in ('D', 'F')) then
				ds_retorno_ww := ds_horarios_w;
			else
				ds_retorno_ww := cpoe_reordenar_horarios(clock_timestamp(), ds_horarios_w);
			end if;
			
			if (position(' ' in ds_retorno_ww) > 0) then
				ds_retorno_w := substr(ds_retorno_ww, 0, position(' ' in ds_retorno_ww) -1);
			else
				ds_retorno_w := ds_retorno_ww;
			end if;
			
			if (length(ds_retorno_w) = 2) then
				ds_retorno_w	:= ds_retorno_w || ':00';
			end if;		
		end;
	else
		si_days_first_schedule_w := GET_IF_DAYS_ADD_FIRST_SCHEDULE(nr_atendimento_p, cd_estabelecimento_w, clock_timestamp(), nm_usuario_w, cd_perfil_w, 'R', ie_via_aplicacao_p);

		if (si_days_first_schedule_w = 'S' and si_fulltime_p = 'S') then
			if (si_rule_material_interval_w = 'S') then
				ds_retorno_w := pkg_date_utils.get_ISOFormat(pkg_date_utils.get_time(obter_prim_horario_prescricao(nr_atendimento_p,
											cd_setor_atend_prescr_w,
											(to_date(to_char(clock_timestamp(),'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')),
											nm_usuario_w, 'R', ie_via_aplicacao_p), hr_inicial_w)); --concatenar se existe hora
			else
				ds_retorno_w := pkg_date_utils.get_ISOFormat(obter_prim_horario_prescricao(nr_atendimento_p,
											cd_setor_atend_prescr_w,
											(to_date(to_char(clock_timestamp(),'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')),
											nm_usuario_w, 'R', ie_via_aplicacao_p)); --concatenar se existe hora
			end if;
		end if;

	end if;

	return ds_retorno_w;
	
exception when others then
		return null;
end;	
	

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_primeiro_horario ( nr_atendimento_p bigint, cd_intervalo_p text, cd_material_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type default null, ie_via_aplicacao_p text default null, ie_hor_agora_p text default 'N', si_fulltime_p text default 'N') FROM PUBLIC;

