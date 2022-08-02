-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE replicar_agendamento_grupo (nr_seq_agenda_p bigint, nr_seq_grupo_p bigint, ie_classificacao_p text, ie_profissional_p text, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE


cd_agenda_w	bigint;
nr_sequencia_w	            agenda_consulta.nr_sequencia%type;
cd_agenda_marcacao_w	bigint;

nr_minuto_duracao_w	bigint;
ie_status_agenda_w	varchar(05);
ie_classif_agenda_w	varchar(05) := 'E';
cd_convenio_w		integer;
cd_pessoa_fisica_w	varchar(10);
nm_pessoa_contato_w	varchar(255);
ds_observacao_w		varchar(2000);
ie_status_paciente_w	varchar(03);
nm_paciente_w		varchar(80);
nr_atendimento_w	bigint;
dt_confirmacao_w	timestamp;
ds_confirmacao_w	varchar(80);
nr_telefone_w		varchar(80);
qt_idade_pac_w		smallint;
nr_seq_plano_w		bigint;
nr_seq_agenda_w		        agenda_consulta.nr_sequencia%type;
dt_agenda_w		timestamp;
cd_pessoa_dest_w	varchar(10);
ie_necessita_contato_w	varchar(01);
nr_seq_sala_w		bigint;
cd_categoria_w		varchar(10);
cd_tipo_acomodacao_w	smallint;
cd_usuario_convenio_w	varchar(30);
cd_complemento_w	varchar(30);
dt_validade_carteira_w	timestamp;
nr_doc_convenio_w	varchar(20);
cd_senha_w		varchar(20);
ds_senha_w		varchar(10);
dt_nascimento_pac_w	timestamp;
nr_controle_secao_w	bigint;
nr_seq_proc_interno_w	bigint;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
qt_total_secao_w	smallint;
nr_secao_w		smallint;
cd_medico_solic_w	varchar(10);
nr_seq_agepaci_w	bigint;
nr_seq_indicacao_w	bigint;
cd_setor_atendimento_w	bigint;
nr_seq_agenda_sessao_w      agenda_consulta.nr_sequencia%type;
cd_medico_w		varchar(10);	
qt_proced_princ_w	integer;
nr_seq_hora_w		bigint    := 0;	

ie_dia_semana_w		integer;
nr_seq_turno_w		bigint;

cd_estabelecimento_w	smallint;
ie_situacao_w         	varchar(1);
				
				     
C01 CURSOR FOR
	SELECT	cd_agenda
	from	regra_grupo_agenda_item a,
		regra_grupo_agenda b
	where	b.nr_sequencia	= a.nr_seq_grupo
	and	b.nr_sequencia 	= nr_seq_grupo_p;
				

BEGIN

select	max(cd_agenda)
into STRICT	cd_agenda_marcacao_w
from	agenda_consulta
where	nr_sequencia = nr_seq_agenda_p;


select	nr_minuto_duracao,
	ie_status_agenda,
	ie_classif_agenda,
	cd_convenio,
	cd_pessoa_fisica,
	nm_pessoa_contato,
	ds_observacao,
	ie_status_paciente,
	nm_paciente,
	nr_atendimento,
	dt_confirmacao,
	ds_confirmacao,
	nr_telefone,
	qt_idade_pac,
	nr_seq_plano,
	dt_agenda,
	ie_necessita_contato,
	nr_seq_sala,
	cd_categoria,
	cd_tipo_acomodacao,
	cd_usuario_convenio,    
	cd_complemento,         
	dt_validade_carteira,
	nr_doc_convenio,        
	cd_senha,
	ds_senha,
	dt_nascimento_pac,
	nr_seq_proc_interno,
	cd_procedimento,
	ie_origem_proced,
	qt_total_secao,
	cd_medico_solic,
	nr_seq_agepaci,
	nr_seq_indicacao,
	cd_setor_atendimento,
	CASE WHEN coalesce(nr_seq_agenda_sessao::text, '') = '' THEN  nr_sequencia  ELSE nr_seq_agenda_sessao END ,
	cd_medico,
	qt_procedimento,
	nr_controle_secao
into STRICT	nr_minuto_duracao_w,
	ie_status_agenda_w,
	ie_classif_agenda_w,
	cd_convenio_w,
	cd_pessoa_fisica_w,
	nm_pessoa_contato_w,
	ds_observacao_w,
	ie_status_paciente_w,
	nm_paciente_w,
	nr_atendimento_w,
	dt_confirmacao_w,
	ds_confirmacao_w,
	nr_telefone_w,
	qt_idade_pac_w,
	nr_seq_plano_w,
	dt_agenda_w,
	ie_necessita_contato_w,
	nr_seq_sala_w,
	cd_categoria_w,           
	cd_tipo_acomodacao_w,
	cd_usuario_convenio_w,    
	cd_complemento_w,         
	dt_validade_carteira_w,
	nr_doc_convenio_w,        
	cd_senha_w,
	ds_senha_w,
	dt_nascimento_pac_w,
	nr_seq_proc_interno_w,
	cd_procedimento_w,
	ie_origem_proced_w,
	qt_total_secao_w,
	cd_medico_solic_w,
	nr_seq_agepaci_w,
	nr_seq_indicacao_w,
	cd_setor_atendimento_w,
	nr_seq_agenda_sessao_w,
	cd_medico_w,
	qt_proced_princ_w,
	nr_controle_secao_w
from	agenda_consulta
where	nr_sequencia		= nr_seq_agenda_p;

if (ie_profissional_p = 'N') then
	cd_medico_w	:= null;
end if;

open C01;
loop
fetch C01 into	
	cd_agenda_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	if (cd_agenda_w <> cd_agenda_marcacao_w) then
	
		select	max(cd_estabelecimento), max(ie_situacao)
		into STRICT	cd_estabelecimento_w, ie_situacao_w
		from	agenda
		where	cd_agenda = cd_agenda_w;
		
		if (ie_situacao_w <> 'I') then
	
			select	nextval('agenda_consulta_seq')
			into STRICT	nr_sequencia_w
			;
		
			select	coalesce(max(nr_seq_hora),0) + 1
			into STRICT	nr_seq_hora_w
			from	agenda_consulta
			where	cd_agenda	= cd_agenda_w
			and	dt_agenda	= dt_agenda_w;
		
			if (ie_classificacao_p = 'N') then
			
				ie_dia_semana_w	:= obter_cod_dia_semana(dt_agenda_w);
				
				select	coalesce(max(nr_sequencia),0)
				into STRICT	nr_seq_turno_w
				from	agenda_turno
				where	cd_agenda	= cd_agenda_w
				and	((ie_dia_semana	= ie_dia_semana_w)  or ((ie_dia_semana = 9) and (ie_dia_Semana_w not in (7,1))))
				and	to_date('01/01/1900 ' || to_char(dt_agenda_w, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss') between
					to_date('01/01/1900 ' || to_char(hr_inicial, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss') and
					to_date('01/01/1900 ' || to_char(hr_final, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss');
	
				select 	coalesce(max(cd_classificacao), 'E')
				into STRICT	ie_classif_agenda_w
				from 	agenda_turno_classif
				where	nr_seq_turno	= nr_seq_turno_w;
			
			end if;		
		
			CALL gerar_horario_agenda_servico(cd_estabelecimento_w,
				             cd_agenda_w,
					     dt_agenda_w,
					     nm_usuario_p);
		
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_agenda_w
			from	agenda_consulta
			where	dt_agenda = dt_agenda_w
			and	cd_agenda = cd_agenda_w
			and	ie_status_agenda = 'L';
		
			if (nr_seq_agenda_w > 0) then
						
				update	agenda_consulta
				set	nr_minuto_duracao	= nr_minuto_duracao_w,
					ie_status_agenda	= ie_status_agenda_w,
					ie_classif_agenda	= ie_classif_agenda_w,
					cd_convenio		= cd_convenio_w,
					cd_pessoa_fisica	= cd_pessoa_fisica_w,
					nm_pessoa_contato	= nm_pessoa_contato_w,
					ds_observacao		= ds_observacao_w,
					ie_status_paciente	= ie_status_paciente_w,
					nm_paciente		= nm_paciente_w,
					nr_atendimento		= nr_atendimento_w,
					dt_confirmacao		= dt_confirmacao_w,
					ds_confirmacao		= ds_confirmacao_w,
					nr_telefone		= nr_telefone_w,
					qt_idade_pac		= qt_idade_pac_w,
					nr_seq_plano		= nr_seq_plano_w,
					ie_necessita_contato	= ie_necessita_contato_w,
					nr_seq_sala		= nr_seq_sala_w,
					cd_categoria		= cd_categoria_w,
					cd_tipo_acomodacao	= cd_tipo_acomodacao_w,
					cd_usuario_convenio	= cd_usuario_convenio_w,
					cd_complemento     	= cd_complemento_w,
					dt_validade_carteira	= dt_validade_carteira_w,
					nr_doc_convenio		= nr_doc_convenio_w, 
					cd_senha		= cd_senha_w,
					ds_senha		= ds_senha_w,
					dt_nascimento_pac	= dt_nascimento_pac_w,
					nm_usuario_origem	= nm_usuario_p,
					dt_agendamento		= clock_timestamp(),
					nr_seq_proc_interno	= nr_seq_proc_interno_w,
					cd_procedimento		= cd_procedimento_w,
					ie_origem_proced	= ie_origem_proced_w,	
					qt_total_secao		= qt_total_secao_w,
					cd_medico_solic		= cd_medico_solic_w,
					nr_seq_agepaci		= nr_seq_agepaci_w,
					nr_seq_indicacao	= nr_seq_indicacao_w,
					cd_setor_atendimento	= cd_setor_atendimento_w,
					nr_seq_agenda_sessao	= nr_seq_agenda_sessao_w,
					cd_medico		= coalesce(cd_medico_w,cd_medico),
					qt_procedimento		= qt_proced_princ_w,
					nr_controle_secao	= nr_controle_secao_w,	
					dt_atualizacao		= clock_timestamp(),
					nm_usuario		= nm_usuario_p,
					nr_seq_hora		= nr_seq_hora_w
				where	nr_sequencia		= nr_seq_agenda_w;
			elsif (nr_seq_agenda_w = 0) and (coalesce(ds_erro_p::text, '') = '') then
				ds_erro_p := WHEB_MENSAGEM_PCK.get_texto(278850,null);
			end if;
		
		end if;
	
	end if;
		
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE replicar_agendamento_grupo (nr_seq_agenda_p bigint, nr_seq_grupo_p bigint, ie_classificacao_p text, ie_profissional_p text, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;

