-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageweb_se_agenda_cons_web (cd_agenda_p bigint, cd_pessoa_fisica_p text, cd_convenio_p bigint, cd_categoria_p text, cd_plano_convenio_p text, ie_marcacao_p text, dt_agenda_p timestamp, cd_especialidade_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1) := 'S';

ie_conv_liberado_w	varchar(1) := 'S';

nr_seq_regra_w		bigint;	
ie_agenda_w		varchar(1);
ie_excecao_paciente_w 	bigint;
ds_mensagem_w		varchar(255);
cd_setor_exclusivo_w	integer;
cd_medico_agenda_w	varchar(10);
qt_agendamentos_w	bigint;
ie_agendado_w		varchar(1);
cd_municipio_ibge_w	varchar(6);				
			
c01 CURSOR FOR
	SELECT 	coalesce(nr_sequencia,0)
	from	regra_agecons_convenio
	where	((cd_convenio = cd_convenio_p) or (coalesce(cd_convenio::text, '') = ''))
	and	((cd_agenda = cd_agenda_p) or (coalesce(cd_agenda::text, '') = ''))
	and	((cd_categoria = cd_categoria_p) or (coalesce(cd_categoria::text, '') = ''))
	and	((cd_plano_convenio = cd_plano_convenio_p) or (coalesce(cd_plano_convenio::text, '') = ''))
	and	((cd_medico = cd_medico_agenda_w) or (coalesce(cd_medico::text, '') = ''))
	and	((coalesce(ie_primeiro_agendamento,'N') = 'S' and ie_agendado_w = 'N') or (coalesce(ie_primeiro_agendamento,'N') = 'N'))
	and	((cd_pessoa_fisica = cd_pessoa_fisica_p) or (coalesce(cd_pessoa_fisica::text, '') = ''))
	and (trunc(dt_agenda_p) >= dt_inicial_vigencia or coalesce(dt_inicial_vigencia::text, '') = '')
	and (trunc(dt_agenda_p) <= dt_final_vigencia or coalesce(dt_final_vigencia::text, '') = '')
	and (dt_agenda_p between to_date(to_char(dt_agenda_p,'dd/mm/yyyy') ||' '|| to_char(coalesce(hr_inicial,trunc(dt_agenda_p,'dd')),'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
	and 	to_date(to_char(dt_agenda_p,'dd/mm/yyyy') ||' '|| to_char(coalesce(hr_final,trunc(dt_agenda_p)+86399/86400),'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'))
	and	((cd_setor_atendimento = cd_setor_exclusivo_w) or (coalesce(cd_setor_atendimento::text, '') = ''))
	--and	nvl(ie_forma_consiste_setor,'A') = 'E'
	and 	((cd_municipio_ibge = cd_municipio_ibge_w) or (coalesce(cd_municipio_ibge::text, '') = ''))
	and	((cd_especialidade = cd_especialidade_p) or (coalesce(cd_especialidade::text, '') = ''))	
	order 	by	coalesce(cd_convenio,0),
			coalesce(cd_pessoa_fisica,0), 
			coalesce(cd_setor_atendimento,0), 
			coalesce(cd_plano_convenio,0), 
			coalesce(cd_categoria,0),
			coalesce(cd_agenda,0),
			coalesce(cd_especialidade,0),
			coalesce(dt_inicial_vigencia,clock_timestamp()),
			coalesce(dt_final_vigencia,clock_timestamp()),
			coalesce(hr_inicial,clock_timestamp()),
			coalesce(hr_final,clock_timestamp());
			
C02 CURSOR FOR
	SELECT 	coalesce(nr_sequencia,0)
	from	regra_agecons_convenio
	where	((cd_convenio = cd_convenio_p) or (coalesce(cd_convenio::text, '') = ''))
	and	((cd_agenda = cd_agenda_p) or (coalesce(cd_agenda::text, '') = ''))
	and	((cd_categoria = cd_categoria_p) or (coalesce(cd_categoria::text, '') = ''))
	and	((cd_plano_convenio = cd_plano_convenio_p) or (coalesce(cd_plano_convenio::text, '') = ''))
	and	((cd_medico = cd_medico_agenda_w) or (coalesce(cd_medico::text, '') = ''))
	and	((coalesce(ie_primeiro_agendamento,'N') = 'S' and ie_agendado_w = 'N') or (coalesce(ie_primeiro_agendamento,'N') = 'N'))
	and	((cd_pessoa_fisica = cd_pessoa_fisica_p) or (coalesce(cd_pessoa_fisica::text, '') = ''))
	and (trunc(clock_timestamp()) >= dt_inicial_vigencia or coalesce(dt_inicial_vigencia::text, '') = '')
	and (trunc(clock_timestamp()) <= dt_final_vigencia or coalesce(dt_final_vigencia::text, '') = '')
	and	coalesce(hr_inicial::text, '') = ''
	and	coalesce(hr_final::text, '') = ''
	and	((cd_setor_atendimento = cd_setor_exclusivo_w) or (coalesce(cd_setor_atendimento::text, '') = ''))
	and 	((cd_municipio_ibge = cd_municipio_ibge_w) or (coalesce(cd_municipio_ibge::text, '') = ''))
	and	((cd_especialidade = cd_especialidade_p) or (coalesce(cd_especialidade::text, '') = ''))	
	order 	by	coalesce(cd_convenio,0),
			coalesce(cd_pessoa_fisica,0),
			coalesce(cd_setor_atendimento,0), 
			coalesce(cd_plano_convenio,0), 
			coalesce(cd_categoria,0),
			coalesce(cd_agenda,0),
			coalesce(cd_especialidade,0),
			coalesce(dt_inicial_vigencia,clock_timestamp()),
			coalesce(dt_final_vigencia,clock_timestamp()),
			coalesce(hr_inicial,clock_timestamp()),
			coalesce(hr_final,clock_timestamp());
	

BEGIN
		

select	max(cd_municipio_ibge)
into STRICT	cd_municipio_ibge_w
from	compl_pessoa_fisica
where	cd_pessoa_fisica	= cd_pessoa_fisica_p
and	ie_tipo_complemento	= 1;

select	max(cd_setor_exclusivo),
		max(cd_pessoa_fisica)
into STRICT	cd_setor_exclusivo_w,
		cd_medico_agenda_w
from	agenda
where	cd_agenda = cd_agenda_p;
	
select	count(*)
into STRICT	qt_agendamentos_w
from	agenda_consulta a,
		agenda b
where	a.cd_agenda 		= b.cd_agenda
and		b.cd_pessoa_fisica 	= cd_medico_agenda_w
and		a.cd_pessoa_fisica	= cd_pessoa_fisica_p
and (a.cd_convenio		= cd_convenio_p or (coalesce(cd_convenio_p::text, '') = '' and coalesce(a.cd_convenio::text, '') = ''))
and		a.ie_status_agenda not in ('C','F');

if (qt_agendamentos_w > 0) then
	ie_agendado_w := 'S';
else
	ie_agendado_w := 'N';
end if;		

if (ie_marcacao_p = 'S') then
	
	open c01;
	loop
	fetch c01 into	
		nr_seq_regra_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		nr_seq_regra_w := nr_seq_regra_w;
		end;
	end loop;
	close c01;

	if (nr_seq_regra_w > 0) then
		
		select	coalesce(max(ie_permite),'S'),
			coalesce(max(ds_mensagem),'')
		into STRICT	ie_agenda_w,
			ds_mensagem_w
		from	regra_agecons_convenio
		where	nr_sequencia = nr_seq_regra_w
		and	((cd_pessoa_fisica = cd_pessoa_fisica_p) or (coalesce(cd_pessoa_fisica::text, '') = ''));
				
		select 	count(*)
		into STRICT	ie_excecao_paciente_w
		from	regra_agecons_convenio
		where	((cd_convenio = cd_convenio_p) or (coalesce(cd_convenio::text, '') = ''))
		and	((cd_agenda = cd_agenda_p) or (coalesce(cd_agenda::text, '') = ''))
		and	((cd_categoria = cd_categoria_p) or (coalesce(cd_categoria::text, '') = ''))
		and	((cd_plano_convenio = cd_plano_convenio_p) or (coalesce(cd_plano_convenio::text, '') = ''))
		and	coalesce(cd_setor_atendimento::text, '') = ''
		and	((cd_medico = cd_medico_agenda_w) or (coalesce(cd_medico::text, '') = ''))
		and (trunc(dt_agenda_p) >= dt_inicial_vigencia or coalesce(dt_inicial_vigencia::text, '') = '')
		and (trunc(dt_agenda_p) <= dt_final_vigencia or coalesce(dt_final_vigencia::text, '') = '')
		and (dt_agenda_p between to_date(to_char(dt_agenda_p,'dd/mm/yyyy') ||' '|| to_char(coalesce(hr_inicial,trunc(dt_agenda_p,'dd')),'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
		and 	to_date(to_char(dt_agenda_p,'dd/mm/yyyy') ||' '|| to_char(coalesce(hr_final,trunc(dt_agenda_p)+86399/86400),'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'))
		and	cd_pessoa_fisica = cd_pessoa_fisica_p
		and	ie_permite = 'S';
		if	(ie_agenda_w = 'N' AND ie_excecao_paciente_w = 0) then		
			ds_retorno_w := 'N';
		end if;
			
	end if;
else
	ie_conv_liberado_w := obter_se_conv_lib_agenda(cd_agenda_p, cd_convenio_p);
	if (ie_conv_liberado_w = 'N') then
		ds_retorno_w := 'N';
	end if;
	
	if (ds_retorno_w = 'S') then
		open c02;
		loop
		fetch c02 into	
			nr_seq_regra_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			nr_seq_regra_w := nr_seq_regra_w;
			end;
		end loop;
		close c02;
		
		if (nr_seq_regra_w > 0) then
			select	coalesce(max(ie_permite),'S'),
				coalesce(max(ds_mensagem),'')
			into STRICT	ie_agenda_w,
				ds_mensagem_w
			from	regra_agecons_convenio
			where	nr_sequencia = nr_seq_regra_w
			and	((cd_pessoa_fisica = cd_pessoa_fisica_p) or (coalesce(cd_pessoa_fisica::text, '') = ''));
					
			select 	count(*)
			into STRICT	ie_excecao_paciente_w
			from	regra_agecons_convenio
			where	((cd_convenio = cd_convenio_p) or (coalesce(cd_convenio::text, '') = ''))
			and	((cd_agenda = cd_agenda_p) or (coalesce(cd_agenda::text, '') = ''))
			and	((cd_categoria = cd_categoria_p) or (coalesce(cd_categoria::text, '') = ''))
			and	((cd_plano_convenio = cd_plano_convenio_p) or (coalesce(cd_plano_convenio::text, '') = ''))
			and	coalesce(cd_setor_atendimento::text, '') = ''
			and	((cd_medico = cd_medico_agenda_w) or (coalesce(cd_medico::text, '') = ''))
			and (trunc(dt_agenda_p) >= dt_inicial_vigencia or coalesce(dt_inicial_vigencia::text, '') = '')
			and (trunc(dt_agenda_p) <= dt_final_vigencia or coalesce(dt_final_vigencia::text, '') = '')
			and	coalesce(hr_inicial::text, '') = ''
			and	coalesce(hr_final::text, '') = ''
			and	cd_pessoa_fisica = cd_pessoa_fisica_p
			and	ie_permite = 'S';
			if	(ie_agenda_w = 'N' AND ie_excecao_paciente_w = 0) then		
				ds_retorno_w := 'N';
			end if;
		end if;		
	end if;
	
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageweb_se_agenda_cons_web (cd_agenda_p bigint, cd_pessoa_fisica_p text, cd_convenio_p bigint, cd_categoria_p text, cd_plano_convenio_p text, ie_marcacao_p text, dt_agenda_p timestamp, cd_especialidade_p bigint) FROM PUBLIC;

