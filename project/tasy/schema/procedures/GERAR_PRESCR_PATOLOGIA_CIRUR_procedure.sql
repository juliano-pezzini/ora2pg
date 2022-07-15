-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_prescr_patologia_cirur ( nr_seq_agenda_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
nr_prescricao_w			bigint;
ie_origem_inf_w			varchar(1);
ie_adep_w		  	varchar(10);
nr_cirurgia_w			bigint;
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
nr_sequencia_w			bigint;
cd_cgc_w			varchar(14);
cd_setor_atendimento_w		integer;
nr_seq_proc_interno_w		bigint;
cd_pessoa_fisica_w		varchar(10);
nr_atendimento_w		bigint;
cd_medico_w			varchar(10);
dt_prescricao_w			timestamp;
hr_inicio_w			timestamp;

c01 CURSOR FOR 
	SELECT	b.cd_procedimento, 
		b.ie_origem_proced, 
		b.nr_sequencia, 
		a.cd_cgc 
	from	agenda_pac_servico a, 
		proc_interno b 
	where	a.nr_seq_agenda  	= nr_seq_agenda_p 
	and	a.nr_seq_proc_servico 	= b.nr_sequencia 
	and	a.ie_status 		<> 'C' 
	and	b.ie_tipo 		= 'AP' 
	and	not exists (SELECT	1 
				from 	prescr_procedimento x 
				where	x.nr_seq_proc_interno 	= b.nr_sequencia 
				and	x.nr_prescricao 	= nr_prescricao_w);


BEGIN 
 
begin 
select	coalesce(a.nr_cirurgia,0), 
	coalesce(b.cd_setor_exclusivo,0), 
	a.cd_pessoa_fisica, 
	a.nr_atendimento, 
	a.cd_medico, 
	to_date(to_char(a.dt_agenda,'dd/mm/yyyy') || ' ' || to_char(a.hr_inicio,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'), 
	a.hr_inicio 
into STRICT	nr_cirurgia_w, 
	cd_setor_atendimento_w, 
	cd_pessoa_fisica_w, 
	nr_atendimento_w, 
	cd_medico_w, 
	dt_prescricao_w, 
	hr_inicio_w 
from	agenda_paciente a, 
	Agenda b 
where 	a.cd_agenda	= b.cd_agenda 
and	a.nr_sequencia	= nr_seq_agenda_p;
exception 
when others then 
	nr_cirurgia_w := 0;
end;
 
if (nr_cirurgia_w > 0) then 
	if (cd_setor_atendimento_w = 0) then 
		select	max(cd_setor_atendimento) 
		into STRICT	cd_setor_atendimento_w 
		from 	usuario 
		where 	nm_usuario = nm_usuario_p;
	end if;
 
	select	coalesce(max(a.nr_prescricao),0) 
	into STRICT	nr_prescricao_w 
	from	prescr_medica a 
	where	a.nr_cirurgia_patologia = nr_cirurgia_w 
	and	a.ie_tipo_prescr_cirur	= 3;
	 
	select 	coalesce(max('1'),'3') 
	into STRICT	ie_origem_inf_w 
	from	Medico b, 
		Usuario a 
	where 	a.nm_usuario		= nm_usuario_p 
	and	a.cd_pessoa_fisica	= b.cd_pessoa_fisica;
 
	if (nr_prescricao_w = 0) then 
		begin 
		-- Obter ie_origem_inf se é médico ou não 
		Select 	nextval('prescr_medica_seq')  
		into STRICT 	nr_prescricao_w 
		;
 
		select	coalesce(max(ie_adep),'N') 
		into STRICT	ie_adep_w 
		from	setor_atendimento 
		where	cd_setor_atendimento = cd_setor_atendimento_w;
			 
		insert into prescr_medica( 
			nr_prescricao,    
			cd_pessoa_fisica,    
			nr_atendimento,    
			cd_medico,    
			dt_prescricao,    
			dt_atualizacao,    
			nm_usuario, 
			nm_usuario_original,    
			nr_horas_validade,    
			dt_primeiro_horario,    
			dt_liberacao,    
			cd_setor_atendimento, 
			cd_setor_entrega, 
			dt_entrega, 
			ie_origem_inf, 
			nr_seq_agenda, 
			ie_recem_nato, 
			cd_estabelecimento, 
			cd_prescritor, 
			ie_adep, 
			nr_cirurgia_patologia, 
			ie_tipo_prescr_cirur) 
		values (nr_prescricao_w, 
			cd_pessoa_fisica_w, 
			nr_atendimento_w, 
			cd_medico_w, 
			dt_prescricao_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			nm_usuario_p,		 
			24, 
			hr_inicio_w, 
			null, 
			cd_setor_atendimento_w, 
			cd_setor_atendimento_w, 
			null, 
			ie_origem_inf_w, 
			nr_seq_agenda_p, 
			'N', 
			cd_estabelecimento_p, 
			obter_dados_usuario_opcao(nm_usuario_p, 'C'), 
			ie_adep_w, 
			nr_cirurgia_w, 
			3);
		end;
	end if;
	 
	open c01;
	loop 
	fetch c01 into 
		cd_procedimento_w, 
		ie_origem_proced_w, 
		nr_seq_proc_interno_w, 
		cd_cgc_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		select	coalesce(max(nr_sequencia),0)+1 
		into STRICT	nr_sequencia_w 
		from	prescr_procedimento 
		where	nr_prescricao = nr_prescricao_w;
		 
		insert	into	prescr_procedimento(nr_prescricao, 
				nr_sequencia, 
				nr_seq_interno, 
				cd_procedimento, 
				ie_origem_proced, 
				nr_seq_proc_interno, 
				cd_cgc_laboratorio, 
				ie_amostra, 
				ie_suspenso, 
				qt_procedimento, 
				ie_origem_inf, 
				nm_usuario, 
				dt_atualizacao 
				) 
		values (nr_prescricao_w, 
				nr_sequencia_w, 
				nextval('prescr_procedimento_seq'), 
				cd_procedimento_w, 
				ie_origem_proced_w, 
				nr_seq_proc_interno_w, 
				cd_cgc_w, 
				'N', 
				'N', 
				1, 
				ie_origem_inf_w, 
				nm_usuario_p, 
				clock_timestamp());
	end loop;
	close c01;	
	commit;
end if;	
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_prescr_patologia_cirur ( nr_seq_agenda_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

