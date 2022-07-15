-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_anamnese ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE

nr_atendimento_w	bigint;
cd_medico_w		varchar(10);
ie_medico_w		varchar(01);
ie_preencher_dt_autom_w	varchar(01);
hr_inicio_consulta_w	varchar(5);
hr_fim_consulta_w	varchar(5);
qt_anamnse_paciente_w	integer;
ie_medico_resp_w	integer;
ie_permite_cons_sem_enf_w varchar(1);


BEGIN 
ie_preencher_dt_autom_w := Obter_Param_Usuario(935, 169, Obter_perfil_Ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_preencher_dt_autom_w);
--Obter_Param_Usuario(935, 3, Obter_perfil_Ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_permite_cons_sem_enf_w); 
 
if (nr_sequencia_p > 0) then 
	update	anamnese_paciente 
	set	dt_liberacao	=	clock_timestamp() 
	where	nr_sequencia	=	nr_sequencia_p 
	and	coalesce(dt_liberacao::text, '') = '';
	 
	select	max(nr_atendimento), 
		max(cd_medico) 
	into STRICT	nr_atendimento_w, 
		cd_medico_w 
	from	anamnese_paciente 
	where	nr_sequencia	=	nr_sequencia_p;
	 
	select 	coalesce(max('S'),'N') 
	into STRICT	ie_medico_w 
	from	Medico 
	where 	cd_pessoa_fisica	= cd_medico_w;
	 
	if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then	 
		if (ie_medico_w = 'S') then 
			CALL gerar_lancamento_automatico(nr_atendimento_w,null,241,nm_usuario_p,nr_sequencia_p,cd_medico_w,null,null,null,null);
		else 
			CALL gerar_lancamento_automatico(nr_atendimento_w,null,241,nm_usuario_p,nr_sequencia_p,null,null,null,null,null);
		end if;
		 
		CALL executar_evento_agenda_atend(nr_atendimento_w,'LAN',obter_estab_atend(nr_atendimento_w),nm_usuario_p);
	end if;
	 
	if (ie_preencher_dt_autom_w = 'S') then --and 
		--(ie_permite_cons_sem_enf_w = 'S') then 
		begin 
		select	max(hr_fim_consulta), 
			max(hr_inicio_consulta) 
		into STRICT	hr_fim_consulta_w, 
			hr_inicio_consulta_w 
		from	atendimento_ps_v 
		where	nr_atendimento = nr_atendimento_w;
 
		 
		select	count(*) 
		into STRICT	ie_medico_resp_w 
		from	atendimento_ps_v 
		where	cd_medico_resp = cd_medico_w 
		and	nr_atendimento	= nr_atendimento_w;
 
		if ((trim(both hr_inicio_consulta_w) IS NOT NULL AND (trim(both hr_inicio_consulta_w))::text <> '')) and (coalesce(trim(both hr_fim_consulta_w)::text, '') = '') and (ie_medico_w = 'S') and (ie_medico_resp_w > 0) then 
			begin 
			update	atendimento_paciente 
			set	dt_fim_consulta = clock_timestamp() 
			where	nr_atendimento = nr_atendimento_w;
			end;
		end if;
		end;
	end if;
	 
	commit;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_anamnese ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

