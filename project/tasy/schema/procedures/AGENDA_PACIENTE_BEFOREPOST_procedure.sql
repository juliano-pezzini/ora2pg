-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE agenda_paciente_beforepost ( nr_seq_agenda_p bigint, cd_agenda_p bigint, cd_pessoa_fisica_p text, hr_inicio_p timestamp, dt_agenda_p timestamp, cd_medico_exec_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, nr_min_duracao_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, ie_consistir_obito_paciente_p text, nm_usuario_p text, ie_se_pac_agendamento_p INOUT text, ie_se_perm_pf_classif_p INOUT text, ie_procedimento_p INOUT text, ds_medico_exec_p INOUT text, ds_consistencia_p INOUT text) AS $body$
DECLARE


ie_se_pac_agendamento_w		varchar(1);
ie_se_perm_pf_classif_w		varchar(80);
ie_medico_executor_w		varchar(1);
ie_procedimento_w		varchar(1);
ds_medico_exec_w		varchar(255);
ie_calc_min_dur_w		varchar(255);
ds_consistencia_w		varchar(4000);
ie_consiste_horario_w		varchar(255);
ie_obito_w			varchar(1);


BEGIN

if (cd_agenda_p > 0) and (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	begin
	ie_se_pac_agendamento_w	:= substr(Obter_Se_Pac_Agendamento(nr_seq_agenda_p, cd_pessoa_fisica_p, cd_agenda_p, hr_inicio_p),1,1);
	ie_se_perm_pf_classif_w	:= substr(Obter_Se_Perm_PF_Classif(820, cd_agenda_p, cd_pessoa_fisica_p, coalesce(hr_inicio_p,dt_agenda_p), 'DS'),1,80);
	
	select	coalesce(ie_medico_executor, 'S'),
		coalesce(ie_procedimento,'S')
	into STRICT	ie_medico_executor_w,
		ie_procedimento_w
	from	agenda
	where	cd_agenda = cd_agenda_p;
	
	if (ie_medico_executor_w = 'E') and (coalesce(cd_medico_exec_p::text, '') = '') then
		ds_medico_exec_w	:= substr(obter_texto_tasy(37768, wheb_usuario_pck.get_nr_seq_idioma),1,255);
	elsif (ie_medico_executor_w = 'N') and (cd_medico_exec_p IS NOT NULL AND cd_medico_exec_p::text <> '') then
		ds_medico_exec_w	:= substr(obter_texto_tasy(37769, wheb_usuario_pck.get_nr_seq_idioma),1,255);
	end if;
	
	ie_consiste_horario_w := Obter_Param_Usuario(820, 93, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_consiste_horario_w);
	
	if (ie_consiste_horario_w = 'C') then
		CALL Consistir_agendamento_pf_dur(hr_inicio_p, nr_min_duracao_p, cd_pessoa_fisica_p, nm_usuario_p, cd_estabelecimento_p, nr_seq_agenda_p);
	end if;
	
	if (nr_seq_proc_interno_p IS NOT NULL AND nr_seq_proc_interno_p::text <> '') then
		begin
		CALL consistir_proc_inativo(nr_seq_proc_interno_p,nm_usuario_p,cd_estabelecimento_p);
		end;
	end if;
	
	ie_calc_min_dur_w := Obter_Param_Usuario(820, 33, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_calc_min_dur_w);
	
	if (ie_calc_min_dur_w = 'N') then
		begin
		ds_consistencia_w := consistir_tempo_duracao_proced(
			cd_agenda_p, cd_medico_exec_p, cd_procedimento_p, ie_origem_proced_p, nr_seq_proc_interno_p, cd_pessoa_fisica_p, nr_min_duracao_p, null, null, null, nr_seq_agenda_p, ds_consistencia_w);
		end;
	end if;
	
	if (coalesce(ds_consistencia_w::text, '') = '') then
		begin
		if (ie_consistir_obito_paciente_p = 'S') then
			begin
			
			ie_obito_w :=	obter_se_paciente_obito(cd_pessoa_fisica_p);
			
			if (ie_obito_w = 'A') then
				begin
				ds_consistencia_w	:= obter_texto_dic_objeto(72025,wheb_usuario_pck.get_nr_seq_idioma,null);
				end;
			elsif (ie_obito_w = 'C') then
				begin
				ds_consistencia_w	:= obter_texto_dic_objeto(72026,wheb_usuario_pck.get_nr_seq_idioma,null);
				end;
			end if;
			end;
		end if;
		end;
	end if;
	end;
end if;

ie_se_pac_agendamento_p	:= ie_se_pac_agendamento_w;
ie_se_perm_pf_classif_p	:= ie_se_perm_pf_classif_w;
ie_procedimento_p	:= ie_procedimento_w;
ds_medico_exec_p	:= ds_medico_exec_w;
ds_consistencia_p	:= ds_consistencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE agenda_paciente_beforepost ( nr_seq_agenda_p bigint, cd_agenda_p bigint, cd_pessoa_fisica_p text, hr_inicio_p timestamp, dt_agenda_p timestamp, cd_medico_exec_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, nr_min_duracao_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, ie_consistir_obito_paciente_p text, nm_usuario_p text, ie_se_pac_agendamento_p INOUT text, ie_se_perm_pf_classif_p INOUT text, ie_procedimento_p INOUT text, ds_medico_exec_p INOUT text, ds_consistencia_p INOUT text) FROM PUBLIC;
