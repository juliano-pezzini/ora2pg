-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_obter_dados_atend_esus ( nr_atendimento_p bigint, ie_ficha_esus_p text, cd_pri_profis_p INOUT text, cd_sec_profis_p INOUT text, cd_ter_profis_p INOUT text, nr_seq_sus_equipe_p INOUT bigint, cd_pri_cbo_p INOUT text, cd_sec_cbo_p INOUT text, cd_ter_cbo_p INOUT text, cd_cnes_unidade_p INOUT bigint, dt_atendimento_p INOUT timestamp, ds_retorno_p INOUT text, cd_pessoa_fisica_p INOUT text, nr_prontuario_p INOUT bigint, nm_usuario_p usuario.nm_usuario%type, dt_fim_consulta_P INOUT atendimento_paciente.dt_fim_consulta%type, qt_per_cefalico_p INOUT atendimento_sinal_vital.qt_perimetro_cefalico%type, qt_peso_p INOUT atendimento_sinal_vital.qt_peso%type, qt_altura_cm_p INOUT atendimento_sinal_vital.qt_altura_cm%type, dt_ult_menstruacao_p INOUT historico_saude_mulher.dt_ult_menstruacao%type, ie_gravidez_plan_p INOUT historico_saude_mulher.ie_gravidez_plan%type, qt_sem_ig_cronologica_p INOUT historico_saude_mulher.qt_sem_ig_cronologica%type, qt_gestacoes_p INOUT historico_saude_mulher.qt_gestacoes%type, qt_partos_p INOUT bigint ) AS $body$
DECLARE


cd_medico_resp_w		atendimento_paciente.cd_medico_resp%type;
cd_pessoa_fisica_w		atendimento_paciente.cd_pessoa_fisica%type;
dt_entrada_w			atendimento_paciente.dt_entrada%type;
nr_seq_equipe_sus_w		sus_profissional_equipe.nr_seq_equipe_sus%type;
cd_cbo_equipe_w			sus_profissional_equipe.cd_cbo%type;
nr_cnes_equipe_w		sus_profissional_equipe.nr_cnes_equipe%type;
cd_municipio_equipe_w	sus_profissional_equipe.cd_municipio_equipe%type;
nr_seq_equipe_w			sus_equipe.nr_sequencia%type;
dt_competencia_w		sus_equipe.dt_competencia%type;
nr_interno_conta_w		conta_paciente.nr_interno_conta%type;
cd_medico_executor_w	procedimento_paciente.cd_medico_executor%type;
cd_cbo_w				procedimento_paciente.cd_cbo%type;
cd_sec_profis_w			procedimento_paciente.cd_medico_executor%type;
cd_ter_profis_w			procedimento_paciente.cd_medico_executor%type;
cd_sec_cbo_w			procedimento_paciente.cd_cbo%type;
cd_ter_cbo_w			procedimento_paciente.cd_cbo%type;
ds_erro_w				varchar(255);
qt_executor_w			bigint := 1;
nr_prontuario_w			pessoa_fisica.nr_prontuario%type := 0;
dt_fim_consulta_w		atendimento_paciente.dt_fim_consulta%type;
qt_per_cefalico_w   	atendimento_sinal_vital.qt_perimetro_cefalico%type;
qt_peso_w           	atendimento_sinal_vital.qt_peso%type;
qt_altura_cm_w      	atendimento_sinal_vital.qt_altura_cm%type;
dt_ult_menstruacao_w    historico_saude_mulher.dt_ult_menstruacao%type;
ie_gravidez_plan_w      historico_saude_mulher.ie_gravidez_plan%type;
qt_sem_ig_cronologica_w historico_saude_mulher.qt_sem_ig_cronologica%type;
qt_gestacoes_w          historico_saude_mulher.qt_gestacoes%type;
qt_partos_w				smallint;

C01 CURSOR FOR
	SELECT	cd_medico_executor,
		cd_cbo
	from	procedimento_paciente
	where	nr_interno_conta = nr_interno_conta_w
	and	cd_medico_executor <> cd_medico_resp_w
	and	coalesce(cd_motivo_exc_conta::text, '') = '';
	
type 		fetch_array is table of c01%rowtype;
s_array 	fetch_array;
i		integer := 1;
type vetor is table of fetch_array index by integer;
vetor_c01_w			vetor;	

BEGIN

begin
select	cd_pessoa_fisica,
	cd_medico_resp,
	coalesce(dt_atend_medico, dt_entrada),
	dt_fim_consulta
into STRICT	cd_pessoa_fisica_w,
	cd_medico_resp_w,
	dt_entrada_w, 
	dt_fim_consulta_w
from	atendimento_paciente
where	nr_atendimento = nr_atendimento_p  LIMIT 1;	
exception
when others then
	cd_pessoa_fisica_w	:= '';
	cd_medico_resp_w	:= '';
	dt_entrada_w		:= null;
	dt_fim_consulta_w   := null;
	ds_erro_w := substr(wheb_mensagem_pck.Get_texto(483192),1,255);
end;

begin
select	max(qt_perimetro_cefalico),
		max(qt_peso), 
		max(qt_altura_cm)
into STRICT	qt_per_cefalico_w, 
		qt_peso_w, 
		qt_altura_cm_w
from	atendimento_sinal_vital
where	nr_atendimento = nr_atendimento_p  LIMIT 1;	
exception
when others then
	qt_per_cefalico_w := null;
	qt_peso_w := null;
	qt_altura_cm_w := null;
end;

if (coalesce(cd_pessoa_fisica_w,'X') <> 'X') then
	begin
		begin
		select   max(dt_ult_menstruacao), 
				 max(ie_gravidez_plan), 
				 max(qt_sem_ig_cronologica), 
				 max(qt_gestacoes)
		into STRICT	 dt_ult_menstruacao_w, 
				 ie_gravidez_plan_w, 
				 qt_sem_ig_cronologica_w,
				 qt_gestacoes_w
		from     historico_saude_mulher 
		where    cd_pessoa_fisica = cd_pessoa_fisica_w
		and      ie_situacao = 'A' 
		order by dt_atualizacao desc LIMIT 1;
		exception
		when others then
			dt_ult_menstruacao_w := '';
			ie_gravidez_plan_w := '';
			qt_sem_ig_cronologica_w := '';
			qt_gestacoes_w := '';
		end;
	end;	
end if;

select 	count(*) qt_partos 
into STRICT   	qt_partos_w
from 	parto 
where   nr_atendimento = nr_atendimento_p;

if (coalesce(cd_medico_resp_w,'X') <> 'X') and (ie_ficha_esus_p <> 'FVD') then
	begin
	
	begin
	select	nr_seq_equipe_sus,
		cd_cbo,
		cd_municipio_equipe,
		nr_cnes_equipe
	into STRICT	nr_seq_equipe_sus_w,
		cd_cbo_equipe_w,
		cd_municipio_equipe_w,
		nr_cnes_equipe_w
	from	sus_profissional_equipe
	where	cd_pessoa_fisica = cd_medico_resp_w  LIMIT 1;
	exception
	when others then
		nr_seq_equipe_sus_w	:= '';
		cd_cbo_equipe_w		:= '';
		cd_municipio_equipe_w	:= '';
		nr_cnes_equipe_w	:= '';
		ds_erro_w := substr(wheb_mensagem_pck.Get_texto(483193),1,255);
	end;
	
	begin
	select	max(a.dt_competencia)
	into STRICT	dt_competencia_w
	from	sus_equipe a
	where	a.cd_municipio_ibge = cd_municipio_equipe_w
	and	a.nr_cnes_equipe = nr_cnes_equipe_w
	and	a.nr_seq_equipe = nr_seq_equipe_sus_w;	
	exception
	when others then
		dt_competencia_w := clock_timestamp();
	end;
	
	begin
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_equipe_w
	from	sus_equipe a
	where	a.cd_municipio_ibge = cd_municipio_equipe_w
	and	a.nr_cnes_equipe = nr_cnes_equipe_w
	and	a.nr_seq_equipe = nr_seq_equipe_sus_w
	and	a.dt_competencia = dt_competencia_w;	
	exception
	when others then
		nr_seq_equipe_w := null;
		ds_erro_w := substr(wheb_mensagem_pck.Get_texto(483193),1,255);
	end;

	end;
end if;

if (coalesce(cd_medico_resp_w,'X') <> 'X') and (ie_ficha_esus_p in ('FAD','FAE')) then
	begin
	
	begin
	select	min(nr_interno_conta)
	into STRICT	nr_interno_conta_w
	from	conta_paciente
	where	nr_atendimento = nr_atendimento_p;
	exception
	when others then
		nr_interno_conta_w := 0;
		ds_erro_w := substr(wheb_mensagem_pck.Get_texto(483282),1,255);
		
	end;

	if (nr_interno_conta_w > 0) then
		begin	
		
		begin
		select	cd_medico_executor,
			cd_cbo
		into STRICT	cd_sec_profis_w,
			cd_sec_cbo_w
		from	procedimento_paciente
		where	nr_interno_conta = nr_interno_conta_w
		and	cd_medico_executor <> cd_medico_resp_w
		and	coalesce(cd_motivo_exc_conta::text, '') = ''  LIMIT 1;		
		exception
		when others then
			cd_sec_profis_w	:= '';
			cd_sec_cbo_w	:= '';
		end;
		
		end;
	end if;
	
	end;
end if;

if (coalesce(cd_medico_resp_w,'X') <> 'X') and (ie_ficha_esus_p in ('FAI','FAO')) then
	begin
	
	begin
	select	min(nr_interno_conta)
	into STRICT	nr_interno_conta_w
	from	conta_paciente
	where	nr_atendimento = nr_atendimento_p;
	exception
	when others then
		nr_interno_conta_w := 0;
		ds_erro_w := substr(wheb_mensagem_pck.Get_texto(483282),1,255);
		
	end;

	if (nr_interno_conta_w > 0) then
		begin	
		qt_executor_w := 1;
		
		open c01;
		loop
		fetch c01 bulk collect into s_array limit 1000;
			vetor_c01_w(i) := s_array;
			i := i + 1;
		EXIT WHEN NOT FOUND or (i = 3);  /* apply on c01 */
		end loop;
		close c01;
		
		for i in 1..vetor_c01_w.count loop
			begin
			s_array := vetor_c01_w(i);
			for z in 1..s_array.count loop
				begin
				
				cd_medico_executor_w	:= s_array[z].cd_medico_executor;
				cd_cbo_w		:= s_array[z].cd_cbo;
				
				if (coalesce(esus_verifica_cbo_ficha(cd_cbo_w,ie_ficha_esus_p),'N') = 'S') then
					begin
					if (z = 1) then
						begin
						cd_sec_profis_w	:= cd_medico_executor_w;
						cd_sec_cbo_w	:= cd_cbo_w;
						end;
					elsif (z = 2) then
						begin
						cd_ter_profis_w	:= cd_medico_executor_w;
						cd_ter_cbo_w	:= cd_cbo_w;
						end;
					end if;
					end;
				end if;
				
				end;
			end loop;
			end;
		end loop;			
		
		end;
	end if;
	
	end;
end if;


cd_pri_profis_p			:= cd_medico_resp_w;
cd_sec_profis_p			:= cd_sec_profis_w;
cd_ter_profis_p			:= cd_ter_profis_w;
nr_seq_sus_equipe_p		:= nr_seq_equipe_w;
cd_pri_cbo_p			:= cd_cbo_equipe_w;
cd_sec_cbo_p			:= cd_sec_cbo_w;
cd_ter_cbo_p			:= cd_ter_cbo_w;
cd_cnes_unidade_p		:= nr_cnes_equipe_w;
dt_atendimento_p		:= dt_entrada_w;
cd_pessoa_fisica_p		:= cd_pessoa_fisica_w;
nr_prontuario_p			:= nr_prontuario_w;
ds_retorno_p			:= substr(ds_erro_w,1,255);
dt_fim_consulta_P		:= dt_fim_consulta_w;
qt_per_cefalico_p   	:= qt_per_cefalico_w;
qt_peso_p           	:= qt_peso_w;
qt_altura_cm_p			:= qt_altura_cm_w;
dt_ult_menstruacao_p 	:= dt_ult_menstruacao_w;
ie_gravidez_plan_p 	 	:= ie_gravidez_plan_w;
qt_sem_ig_cronologica_p := qt_sem_ig_cronologica_w;
qt_gestacoes_p 			:= qt_gestacoes_w;
qt_partos_p				:= qt_partos_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_obter_dados_atend_esus ( nr_atendimento_p bigint, ie_ficha_esus_p text, cd_pri_profis_p INOUT text, cd_sec_profis_p INOUT text, cd_ter_profis_p INOUT text, nr_seq_sus_equipe_p INOUT bigint, cd_pri_cbo_p INOUT text, cd_sec_cbo_p INOUT text, cd_ter_cbo_p INOUT text, cd_cnes_unidade_p INOUT bigint, dt_atendimento_p INOUT timestamp, ds_retorno_p INOUT text, cd_pessoa_fisica_p INOUT text, nr_prontuario_p INOUT bigint, nm_usuario_p usuario.nm_usuario%type, dt_fim_consulta_P INOUT atendimento_paciente.dt_fim_consulta%type, qt_per_cefalico_p INOUT atendimento_sinal_vital.qt_perimetro_cefalico%type, qt_peso_p INOUT atendimento_sinal_vital.qt_peso%type, qt_altura_cm_p INOUT atendimento_sinal_vital.qt_altura_cm%type, dt_ult_menstruacao_p INOUT historico_saude_mulher.dt_ult_menstruacao%type, ie_gravidez_plan_p INOUT historico_saude_mulher.ie_gravidez_plan%type, qt_sem_ig_cronologica_p INOUT historico_saude_mulher.qt_sem_ig_cronologica%type, qt_gestacoes_p INOUT historico_saude_mulher.qt_gestacoes%type, qt_partos_p INOUT bigint ) FROM PUBLIC;
