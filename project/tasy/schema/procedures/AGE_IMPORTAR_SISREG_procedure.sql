-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE age_importar_sisreg ( dt_agenda_p timestamp, nr_crm_profissional_p text, nm_pessoa_profissional_p text, cd_especialidade_p bigint, ds_especialidade_p text, nm_pessoa_paciente_p text, dt_agendament_p timestamp, dt_hr_consulta_p timestamp, ie_tipo_destino_p text, dt_nascimento_paciente_p timestamp, nr_telefone_paciente_p text, nr_cns_paciente_p text, nr_cpf_profissional_p text, ie_tipo_agendamento_p bigint, nr_procedimento_p text, nr_cns_profissional_p text, nm_usuario_p text) AS $body$
DECLARE


cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;
nm_pessoa_paciente_w	pessoa_fisica.nm_pessoa_fisica%type;
cd_especialidade_w      especialidade_medica.cd_especialidade%type;
ds_especialidade_w		especialidade_medica.ds_especialidade%type;
cd_profissional_w		medico.cd_pessoa_fisica%type;
ds_log_w				varchar(2000) := '';
ds_log_procedimento_w	varchar(2000) := '';
cd_agenda_w				agenda.cd_agenda%type;
nr_seq_agenda_w			agenda_consulta.nr_sequencia%type;
ie_status_agenda_w		param_agenda_sisreg.ie_status_agenda%type;
cd_convenio_w 			param_agenda_sisreg.cd_convenio%type;
cd_categoria_w			param_agenda_sisreg.cd_categoria%type;
cd_procedencia_w		param_agenda_sisreg.cd_procedencia%type;
nm_medico_externo_w		param_agenda_sisreg.nm_medico_externo%type;
nr_seq_classif_ex_w		param_classif_sisreg.nr_seq_classif_age_ex%type;
ie_classif_agecon_w		param_classif_sisreg.ie_classif_age_con%type;
nr_seq_proc_interno_w	proc_interno.nr_sequencia%type;

ie_tipo_resultado_w	varchar(1);
ie_agenda_w		varchar(1);


BEGIN
	
--Verifica Pessoa Fisica
select 	max(cd_pessoa_fisica),
        max(nm_pessoa_fisica)
into STRICT	cd_pessoa_fisica_w,
	nm_pessoa_paciente_w
from 	pessoa_fisica
where 	nr_cartao_nac_sus = nr_cns_paciente_p;

if (coalesce(cd_pessoa_fisica_w::text, '') = '') then
     nm_pessoa_paciente_w	:= nm_pessoa_paciente_p;
end if;

--Verificar Especialidade
select  max(cd_especialidade),
	max(ds_especialidade)
into STRICT 	cd_especialidade_w,
	ds_especialidade_w
from 	especialidade_medica
where	cd_especialidade_externo = cd_especialidade_p;

if (coalesce(cd_especialidade_w::text, '') = '')then
	cd_especialidade_w	:= cd_especialidade_p;
	ds_especialidade_w	:= ds_especialidade_p;
end if;

-- Verifica Profissional
select 	max(a.cd_pessoa_fisica)
into STRICT	cd_profissional_w
from 	medico a,
	pessoa_fisica b
where 	a.cd_pessoa_fisica = b.cd_pessoa_fisica
and 	b.nr_cpf = nr_cpf_profissional_p;

if (coalesce(cd_profissional_w::text, '') = '') then
	select	max(cd_pessoa_fisica)
	into STRICT	cd_profissional_w
	from 	medico
	where 	nr_crm = trim(both nr_crm_profissional_p);

	if (coalesce(cd_profissional_w::text, '') = '') then
		select	max(cd_pessoa_fisica)
		into STRICT 	cd_profissional_w
		from 	pessoa_fisica
		where 	nr_cartao_nac_sus = trim(both nr_cns_profissional_p);

		if (coalesce(cd_profissional_w::text, '') = '')then
			select	max(cd_pessoa_fisica)
			into STRICT 	cd_profissional_w
			from 	pessoa_fisica
			where 	upper(nm_pessoa_fisica) = upper(nm_pessoa_profissional_p);
		end if;
	end if;
end if;

if (ie_tipo_agendamento_p = 2) then
	select  max(cd_medico)
	into STRICT 	cd_profissional_w
	from 	agenda_medico
	where   cd_medico = cd_profissional_w;
end if;

if (coalesce(cd_profissional_w::text, '') = '')then
	ds_log_w :=  ds_log_w||' '||obter_desc_expressao(779461)||'.'; -- Profissional nao encontrado
end if;

if (cd_profissional_w IS NOT NULL AND cd_profissional_w::text <> '') then

	select	max(NR_SEQ_CLASSIF_AGE_EX),
		max(IE_CLASSIF_AGE_CON)
	into STRICT	nr_seq_classif_ex_w,
		ie_classif_agecon_w
	from	param_classif_sisreg
	where	ie_tipo_classif_sisreg = ie_tipo_destino_p;

	if (ie_tipo_agendamento_p = 1)then --Agendamento de Consulta
		select 	max(b.nr_sequencia)
		into STRICT	nr_seq_agenda_w
		from    agenda a,
			agenda_consulta b,
			AGENDA_MOTIVO c
		where   a.cd_agenda = b.cd_agenda
		and     b.nr_seq_motivo_transf = c.nr_sequencia
		and     c.ie_sisreg = 'S'
		and     c.ie_motivo = 'B'
		and     a.cd_pessoa_fisica = cd_profissional_w
		and     to_date(to_char(b.dt_agenda,'dd/MM/yyyy hh24:mi'), 'dd/MM/yyyy hh24:mi') = to_date(to_char(dt_agenda_p,'dd/mm/yyyy')||' '||to_char(dt_hr_consulta_p,'hh24:mi'),'dd/MM/yyyy HH24:mi');

		if (coalesce(nr_seq_agenda_w::text, '') = '') then
			ds_log_w	:= ds_log_w||' '||wheb_mensagem_pck.get_texto(803770,'DS_HORARIO='||to_char(dt_agenda_p,'dd/mm/yyyy')||' '||to_char(dt_hr_consulta_p,'hh24:mi')||' ('||substr(obter_nome_pf(cd_profissional_w),1,60)||')');
		end if;

		begin
			select	a.cd_agenda
			into STRICT 	cd_agenda_w
			from	agenda a,
					agenda_turno b
			where	a.cd_pessoa_fisica = cd_profissional_w
			and	a.cd_agenda = b.cd_agenda
			and to_date(to_char(dt_agenda_p, 'yyyy-mm-dd') || ' ' || to_char(dt_hr_consulta_p, 'hh24:mi:ss'), 'yyyy-mm-dd HH24:mi:ss') between b.dt_inicio_vigencia and b.dt_final_vigencia
			and	a.cd_especialidade = cd_especialidade_w;

		exception
			WHEN no_data_found THEN
				ds_log_w	:= ds_log_w||' '||obter_desc_expressao(779478)||'.'; -- Nao possui agenda
			WHEN too_many_rows THEN
				ds_log_w	:= ds_log_w||' '||obter_desc_expressao(779506)||'.'; -- Possui muitas agendas
				cd_agenda_w 	:= '';
			WHEN OTHERS then
				ds_log_w	:= ds_log_w||obter_desc_expressao(726446)||': '||sqlerrm(SQLSTATE)||'.'; -- Erro: || sqlerr
		end;

		if ( ds_log_w = '' or coalesce(ds_log_w::text, '') = '') then
			begin

			select  max(ie_status_agenda),
				max(cd_convenio),
				max(cd_categoria),
				max(cd_procedencia),
				max(nm_medico_externo)
			into STRICT 	ie_status_agenda_w,
				cd_convenio_w,
				cd_categoria_w,
				cd_procedencia_w,
				nm_medico_externo_w
			from	param_agenda_sisreg
			where 	ie_agenda in ('C','A');

			update 	agenda_consulta
			set	ie_classif_agenda = ie_classif_agecon_w,
				ie_status_agenda  = ie_status_agenda_w,
				cd_pessoa_fisica  = cd_pessoa_fisica_w,
				nm_paciente	  = nm_pessoa_paciente_w,
				cd_convenio	  = cd_convenio_w,
				cd_categoria	  = cd_categoria_w,
				cd_procedencia    = cd_procedencia_w,
				nm_medico_externo = nm_medico_externo_w,
				dt_nascimento_pac = dt_nascimento_paciente_p,
				nr_telefone = nr_telefone_paciente_p
			where 	nr_sequencia	  = nr_seq_agenda_w;


		exception
			WHEN OTHERS then
				ds_log_w	:= ds_log_w||' Erro: '||sqlerrm(SQLSTATE)||'.'; -- Erro: || sqlerr
			end;
		end if;

	elsif (ie_tipo_agendamento_p = 2) then -- Agendamento de Exame
		select 	max(b.nr_sequencia)
		into STRICT	nr_seq_agenda_w
		from    agenda a,
			agenda_paciente b
		where   a.cd_agenda = b.cd_agenda
		and	b.IE_STATUS_AGENDA = 'B'
		and     a.cd_pessoa_fisica = cd_profissional_w
		and     to_date(to_char(b.dt_agenda,'dd/MM/yyyy')||' '||to_char(b.hr_inicio,'hh24:mi'), 'dd/MM/yyyy hh24:mi') = to_date(to_char(dt_agenda_p,'dd/mm/yyyy')||' '||to_char(dt_hr_consulta_p,'hh24:mi'),'dd/MM/yyyy HH24:mi');

		if (coalesce(nr_seq_agenda_w::text, '') = '') then
			ds_log_w	:= ds_log_w||' '||wheb_mensagem_pck.get_texto(803770,'DS_HORARIO='||to_char(dt_agenda_p,'dd/mm/yyyy')||' '||to_char(dt_hr_consulta_p,'hh24:mi'));
		end if;

		begin
			select  a.cd_agenda
			into STRICT 	cd_agenda_w
			from 	agenda a,
					agenda_horario b
			where	b.cd_medico = cd_profissional_w
			and		a.cd_agenda = b.cd_agenda
			and 	to_date(to_char(dt_agenda_p, 'yyyy-mm-dd') || ' ' || to_char(dt_hr_consulta_p, 'hh24:mi:ss'), 'yyyy-mm-dd HH24:mi:ss') between b.dt_inicio_vigencia and b.dt_final_vigencia;
		exception
			WHEN no_data_found THEN
				ds_log_w	:= ds_log_w||' '||obter_desc_expressao(779478)||'.'; -- Nao possui agenda
			WHEN too_many_rows THEN
				ds_log_w	:= ds_log_w||' '||obter_desc_expressao(779506)||'.'; -- Possui muitas agendas
				cd_agenda_w     := '';
			WHEN OTHERS then
				ds_log_w	:= ds_log_w||obter_desc_expressao(726446)||': '||sqlerrm(SQLSTATE)||'.'; -- Erro: || sqlerr
		end;

		if ( ds_log_w = '' or coalesce(ds_log_w::text, '') = '')then
		begin
				select  nr_sequencia
				into STRICT 	nr_seq_proc_interno_w
				from 	proc_interno
				where	cd_integracao = trim(both nr_procedimento_p);

			exception
				WHEN no_data_found THEN
					ds_log_procedimento_w	:= ds_log_procedimento_w||' '||wheb_mensagem_pck.get_texto(807676,'NR_PROCEDIMENTO='||to_char(nr_procedimento_p)); -- Procedimento NR_PROCEDIMENTO_P nao encontrado
				WHEN too_many_rows THEN
					ds_log_procedimento_w	:= ds_log_procedimento_w||' '||wheb_mensagem_pck.get_texto(807677,'NR_PROCEDIMENTO='||to_char(nr_procedimento_p)); -- Procedimento NR_PROCEDIMENTO_P nao importado
					nr_seq_proc_interno_w   := '';
				WHEN OTHERS then
					ds_log_procedimento_w	:= ds_log_procedimento_w||' '||obter_desc_expressao(726446)||': '||sqlerrm(SQLSTATE)||'.'; -- Erro: || sqlerr
		end;

		begin
			select  max(ie_status_agenda),
				max(cd_convenio),
				max(cd_categoria),
				max(cd_procedencia),
				max(nm_medico_externo)
			into STRICT 	ie_status_agenda_w,
				cd_convenio_w,
				cd_categoria_w,
				cd_procedencia_w,
				nm_medico_externo_w
			from	param_agenda_sisreg
			where 	ie_agenda in ('E','A');

			update 	agenda_paciente
			set	nr_seq_classif_agenda	= nr_seq_classif_ex_w,
				ie_status_agenda 	= ie_status_agenda_w,
				cd_pessoa_fisica  	= cd_pessoa_fisica_w,
				nm_paciente	  	= nm_pessoa_paciente_w,
				cd_convenio	 	= cd_convenio_w,
				cd_categoria	  	= cd_categoria_w,
				cd_procedencia    	= cd_procedencia_w,
				nm_medico_externo 	= nm_medico_externo_w,
				nr_seq_proc_interno	= nr_seq_proc_interno_w,
				dt_nascimento_pac   = dt_nascimento_paciente_p,
				nr_telefone = nr_telefone_paciente_p
			where 	nr_sequencia 		= nr_seq_agenda_w;
			exception
			WHEN OTHERS then
				ds_log_w	:= ds_log_w||obter_desc_expressao(726446)||': '||sqlerrm(SQLSTATE)||'.'; -- Erro: || sqlerr
			end;
		end if;
	end if;

select	CASE WHEN coalesce(ds_log_w::text, '') = '' THEN '1'  ELSE '2' END ,
	CASE WHEN ie_tipo_agendamento_p=1 THEN  'C' WHEN ie_tipo_agendamento_p=2 THEN  'E'  ELSE '' END
into STRICT	ie_tipo_resultado_w,
	ie_agenda_w
;

	if (trim(both ds_log_w) = '' or coalesce(ds_log_w::text, '') = '') then
		ds_log_w	:= obter_desc_expressao(706826)||' '||ds_log_procedimento_w; --'Importacao realizada com sucesso'
	end if;
end if;

CALL gerar_log_sisreg(ds_log_w, ie_tipo_resultado_w, to_date(to_char(dt_agenda_p,'dd/mm/yyyy')||' '||to_char(dt_hr_consulta_p,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'), ie_agenda_w, nm_usuario_p);

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE age_importar_sisreg ( dt_agenda_p timestamp, nr_crm_profissional_p text, nm_pessoa_profissional_p text, cd_especialidade_p bigint, ds_especialidade_p text, nm_pessoa_paciente_p text, dt_agendament_p timestamp, dt_hr_consulta_p timestamp, ie_tipo_destino_p text, dt_nascimento_paciente_p timestamp, nr_telefone_paciente_p text, nr_cns_paciente_p text, nr_cpf_profissional_p text, ie_tipo_agendamento_p bigint, nr_procedimento_p text, nr_cns_profissional_p text, nm_usuario_p text) FROM PUBLIC;

