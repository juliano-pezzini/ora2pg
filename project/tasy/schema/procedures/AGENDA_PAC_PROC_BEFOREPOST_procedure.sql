-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE agenda_pac_proc_beforepost ( cd_agenda_p bigint, nr_seq_agenda_p bigint, cd_convenio_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, nr_sequencia_p bigint, cd_setor_atendimento_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, dt_agenda_p timestamp, ie_novo_registro_p text, cd_pessoa_fisica_p text, cd_medico_exec_p text, cd_medico_p text, ie_proximo_mes_p text, ie_inserir_p text, ie_lado_p text, nm_usuario_p text, hr_inicio_p timestamp, ie_agenda_pac_cota_munic_p INOUT text, ds_se_medico_p INOUT text, ds_consiste_sobreposicao_p INOUT text, ds_proc_lib_setor_p INOUT text, ds_exige_lado_p INOUT text, ds_consiste_sexo_p INOUT text, ds_erro_p INOUT text, qt_procedimento_p bigint default 0) AS $body$
DECLARE



ie_proc_lib_setor_w		varchar(1);
ie_consistir_sexo_proc_w	varchar(1);
ie_verif_cota_munic_w		varchar(1);
ie_agenda_pac_cota_munic_w	varchar(1);
ie_sobreposicao_param_w		varchar(1);
ie_sobreposicao_w		varchar(1);
ie_exige_lado_w			varchar(1);
ie_se_medico_w			varchar(1);
nm_usuario_hist_w		varchar(15);
vl_consiste_setor_w		varchar(255);
vl_consiste_lado_w		varchar(255);
vl_consiste_sexo_w		varchar(255);
vl_ie_calc_min_dur_w		varchar(255);
ds_proc_lib_setor_w		varchar(255);
ds_exige_lado_w			varchar(255);
ds_consiste_sexo_w		varchar(255);
ds_se_medico_w			varchar(255);
ds_consiste_sobreposicao_w	varchar(1000);
qt_tempo_duracao_proced_w	bigint;
ie_se_cons_dur_final_turno_w	varchar(1);
ds_erro_w			varchar(255);
qt_procedimento_w		agenda_paciente_proc.qt_procedimento%TYPE;


BEGIN

if (ie_novo_registro_p = 'S') then
	begin
	nm_usuario_hist_w	:= substr(WHEB_MENSAGEM_PCK.get_texto(277812,'CD_PROCEDIMENTO='||cd_procedimento_p),1,15);

	CALL gerar_agenda_paciente_hist(cd_agenda_p, nr_seq_agenda_p, 'P', nm_usuario_hist_w, null, null, null, clock_timestamp(), obter_perfil_ativo);
	end;
end if;

ie_verif_cota_munic_w		:= substr(verificar_cota_munic_agepac(cd_agenda_p, dt_agenda_p, cd_pessoa_fisica_p, cd_convenio_p, cd_procedimento_p, ie_origem_proced_p, nr_seq_proc_interno_p, null, cd_estabelecimento_p, ie_proximo_mes_p),1,1);

if (ie_verif_cota_munic_w = 'S') or (ie_inserir_p = 'S') then
	CALL inserir_cota_munic_agepac(	nr_sequencia_p, cd_agenda_p, dt_agenda_p, cd_pessoa_fisica_p, cd_convenio_p,
					cd_procedimento_p, ie_origem_proced_p, nr_seq_proc_interno_p, cd_medico_exec_p, ie_novo_registro_p, 
					nm_usuario_p, cd_estabelecimento_p, ie_proximo_mes_p, nr_seq_agenda_p);
elsif (ie_verif_cota_munic_w = 'N') then
	ie_agenda_pac_cota_munic_w := 'S';
end if;

vl_ie_calc_min_dur_w := Obter_Param_Usuario(820, 33, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, vl_ie_calc_min_dur_w);
vl_consiste_setor_w := Obter_Param_Usuario(820, 98, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, vl_consiste_setor_w);
vl_consiste_lado_w := Obter_Param_Usuario(820, 77, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, vl_consiste_lado_w);
vl_consiste_sexo_w := Obter_Param_Usuario(820, 107, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, vl_consiste_sexo_w);
ie_se_cons_dur_final_turno_w := Obter_Param_Usuario(820, 387, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_se_cons_dur_final_turno_w);

if (vl_consiste_setor_w = 'S') then
	begin
	ie_proc_lib_setor_w	:= substr(obter_se_setor_exec(cd_setor_atendimento_p, cd_estabelecimento_p, cd_procedimento_p, ie_origem_proced_p, nr_seq_proc_interno_p),1,1);

	if (ie_proc_lib_setor_w <> 'S') then
		ds_proc_lib_setor_w	:= substr(obter_texto_tasy(32710, wheb_usuario_pck.get_nr_seq_idioma),1,255);
	end if;
	end;
end if;

if (vl_consiste_lado_w = 'S') then -- 77
	begin
	ie_exige_lado_w		:= 'N';
	if (nr_seq_proc_interno_p IS NOT NULL AND nr_seq_proc_interno_p::text <> '') then
		ie_exige_lado_w	:= substr(obter_se_proc_exige_lado(nr_seq_proc_interno_p, null, null),1,1);
	elsif (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') then
		ie_exige_lado_w	:= substr(obter_se_proc_exige_lado(null, cd_procedimento_p, ie_origem_proced_p),1,1);
	end if;

	if (coalesce(ie_lado_p::text, '') = '') and (ie_exige_lado_w = 'S' or ie_exige_lado_w = 'L') then
		ds_exige_lado_w	:= substr(obter_texto_tasy(32711, wheb_usuario_pck.get_nr_seq_idioma),1,255);
	end if;
	if (ie_exige_lado_w = 'L') and (ie_lado_p = 'A') then
		ds_exige_lado_w	:= substr(obter_texto_tasy(1022971, wheb_usuario_pck.get_nr_seq_idioma),1,255);
	end if;	
	end;
end if;

if (vl_consiste_sexo_w = 'S') and (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') then
	begin
	ie_consistir_sexo_proc_w	:= substr(consistir_sexo_exclusivo_proc(cd_pessoa_fisica_p, nr_seq_proc_interno_p, cd_procedimento_p, ie_origem_proced_p),1,1);
	if (ie_consistir_sexo_proc_w = 'N') then
		ds_consiste_sexo_w	:= substr(obter_texto_tasy(32712, wheb_usuario_pck.get_nr_seq_idioma),1,255);	
	end if;
	end;
end if;

if (cd_medico_p IS NOT NULL AND cd_medico_p::text <> '') then
	begin
	ie_se_medico_w := obter_se_medico(cd_medico_p, 'M');
	if (ie_se_medico_w = 'N') then
		begin
		ds_se_medico_w := substr(obter_texto_tasy(49229, wheb_usuario_pck.get_nr_seq_idioma),1,255);
		end;
	end if;
	end;
end if;

select	coalesce(max(ie_consiste_duracao), 'I')
into STRICT	ie_sobreposicao_param_w
from	parametro_agenda
where	cd_estabelecimento = cd_estabelecimento_p;

if (ie_sobreposicao_param_w = 'I') and (vl_ie_calc_min_dur_w = 'S') then
	begin
	qt_tempo_duracao_proced_w := obter_tempo_duracao_proced(
						cd_agenda_p,
						cd_medico_exec_p,
						cd_procedimento_p,
						ie_origem_proced_p,
						cd_pessoa_fisica_p,
						nr_seq_proc_interno_p,
						ie_lado_p,
						null,
						null,
						null,
						nr_seq_agenda_p,
						null);
	if (qt_tempo_duracao_proced_w > 0) then
		begin
		ie_sobreposicao_w := obter_se_sobreposicao_horario(
							cd_agenda_p,
							dt_agenda_p,
							qt_tempo_duracao_proced_w);
		if (ie_sobreposicao_w = 'S') then
			begin
			ds_consiste_sobreposicao_w := substr(obter_texto_tasy(61121, wheb_usuario_pck.get_nr_seq_idioma),1,1000);
			end;
		end if;
		end;
	end if;
	end;
end if;

if (ie_se_cons_dur_final_turno_w = 'S')then
	begin
	qt_tempo_duracao_proced_w := obter_tempo_duracao_proced(
						cd_agenda_p,
						cd_medico_exec_p,
						cd_procedimento_p,
						ie_origem_proced_p,
						cd_pessoa_fisica_p,
						nr_seq_proc_interno_p,
						ie_lado_p,
						null,
						null,
						null,
						nr_seq_agenda_p,
						null);
	
	qt_procedimento_w := qt_procedimento_p;
	
	ds_erro_w := Consistir_dur_marcacao_exames(	hr_inicio_p, cd_agenda_p, nm_usuario_p, null, nr_seq_agenda_p, qt_tempo_duracao_proced_w, qt_procedimento_w, ds_erro_w);
	
	end;
end if;

ie_agenda_pac_cota_munic_p	:= ie_agenda_pac_cota_munic_w;
ds_consiste_sobreposicao_p	:= ds_consiste_sobreposicao_w;
ds_se_medico_p			:= ie_se_medico_w;
ds_proc_lib_setor_p		:= ds_proc_lib_setor_w;
ds_exige_lado_p			:= ds_exige_lado_w;
ds_consiste_sexo_p		:= ds_consiste_sexo_w;
ds_erro_p				:= ds_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE agenda_pac_proc_beforepost ( cd_agenda_p bigint, nr_seq_agenda_p bigint, cd_convenio_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, nr_sequencia_p bigint, cd_setor_atendimento_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, dt_agenda_p timestamp, ie_novo_registro_p text, cd_pessoa_fisica_p text, cd_medico_exec_p text, cd_medico_p text, ie_proximo_mes_p text, ie_inserir_p text, ie_lado_p text, nm_usuario_p text, hr_inicio_p timestamp, ie_agenda_pac_cota_munic_p INOUT text, ds_se_medico_p INOUT text, ds_consiste_sobreposicao_p INOUT text, ds_proc_lib_setor_p INOUT text, ds_exige_lado_p INOUT text, ds_consiste_sexo_p INOUT text, ds_erro_p INOUT text, qt_procedimento_p bigint default 0) FROM PUBLIC;
