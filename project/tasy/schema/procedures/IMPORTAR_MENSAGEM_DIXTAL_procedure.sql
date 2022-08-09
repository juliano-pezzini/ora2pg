-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE importar_mensagem_dixtal ( nr_seq_agenda_p bigint, dt_execucao_p text) AS $body$
DECLARE

 
nr_prescricao_w		prescr_medica.nr_prescricao%type;
nr_seq_prescricao_w	prescr_procedimento.nr_sequencia%type;
nr_sequencia_w		laudo_paciente.nr_sequencia%type;
nr_laudo_w		laudo_paciente.nr_laudo%type;
laudo_paciente_seq_w	laudo_paciente.nr_sequencia%type;
nr_atendimento_w		atendimento_paciente.nr_atendimento%type;
cd_medico_resp_w		pessoa_fisica.cd_pessoa_fisica%type;
nr_seq_propaci_w		procedimento_paciente.nr_sequencia%type;
nr_seq_proc_interno_w	agenda_paciente.nr_seq_proc_interno%type;
cd_procedimento_w	agenda_paciente.cd_procedimento%type;
ie_origem_proced_w	agenda_paciente.ie_origem_proced%type;
qt_procedimento_w		prescr_procedimento.qt_procedimento%type;
cd_setor_atendimento_w	prescr_procedimento.cd_setor_atendimento%type;
cd_medico_exec_w		pessoa_fisica.cd_pessoa_fisica%type;
ie_lado_w		prescr_procedimento.ie_lado%type;
ie_status_execucao_w	prescr_procedimento.ie_status_execucao%type;
ds_titulo_laudo_w		varchar(255);
dt_entrada_unidade_w	timestamp;
dt_procedimento_w		timestamp;


BEGIN 
 
commit;
 
if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '' AND dt_execucao_p IS NOT NULL AND dt_execucao_p::text <> '') then 
 
	select	max(a.cd_procedimento), 
			max(a.ie_origem_proced), 
			max(a.nr_seq_proc_interno) 
	into STRICT	cd_procedimento_w, 
			ie_origem_proced_w, 
			nr_seq_proc_interno_w 
	from	agenda_paciente a, 
			proc_interno_integracao b 
	where	b.nr_seq_sistema_integ = 46 
	and		a.ie_status_agenda not in ('C', 'F', 'I', 'S') 
	and		a.nr_sequencia = nr_seq_agenda_p;
 
	select	max(a.nr_prescricao) 
	into STRICT	nr_prescricao_w 
	from	prescr_medica a 
	where	a.nr_seq_agenda = nr_seq_agenda_p;
	 
	if (coalesce(nr_prescricao_w::text, '') = '') then 
		select	max(a.nr_prescricao) 
		into STRICT	nr_prescricao_w 
		from	prescr_procedimento a 
		where	a.nr_seq_agenda = nr_seq_agenda_p;		
	end if;
 
	if (coalesce(cd_procedimento_w::text, '') = '') then 
 
		select	max(a.cd_procedimento), 
				max(a.ie_origem_proced) 
		into STRICT	cd_procedimento_w, 
				ie_origem_proced_w 
		from	proc_interno a 
		where	a.nr_sequencia = nr_seq_proc_interno_w;
 
	end if;
 
	select	max(a.nr_prescricao), 
			max(a.nr_sequencia), 
			max(nr_seq_proc_interno), 
			max(cd_procedimento), 
			max(ie_origem_proced), 
			max(qt_procedimento), 
			max(cd_setor_atendimento), 
			max(cd_medico_exec), 
			max(coalesce(ie_lado,'A')) 
	into STRICT	nr_prescricao_w, 
			nr_seq_prescricao_w, 
			nr_seq_proc_interno_w, 
			cd_procedimento_w, 
			ie_origem_proced_w, 
			qt_procedimento_w, 
			cd_setor_atendimento_w, 
			cd_medico_exec_w, 
			ie_lado_w 
	from	prescr_procedimento a 
	where	a.nr_prescricao = nr_prescricao_w 
	and		a.cd_procedimento = cd_procedimento_w 
	and		a.ie_origem_proced = ie_origem_proced_w;
 
	select	max(a.cd_medico) 
	into STRICT	cd_medico_resp_w 
	from	prescr_medica a 
	where	a.nr_prescricao = nr_prescricao_w;
 
	select	coalesce(max(a.nr_laudo),0)+1 
	into STRICT	nr_laudo_w 
	from	laudo_paciente a 
	where	a.nr_prescricao = nr_prescricao_w;
 
	/*Executando a prescrição*/
 
	select	coalesce(max(nr_sequencia),0), 
			max(nr_atendimento), 
			max(dt_entrada_unidade), 
			max(dt_procedimento) 
	into STRICT	nr_seq_propaci_w, 
			nr_atendimento_w, 
			dt_entrada_unidade_w, 
			dt_procedimento_w 
	from	procedimento_paciente 
	where	nr_prescricao		= nr_prescricao_w 
	and		nr_sequencia_prescricao	= nr_seq_prescricao_w;
 
	if (nr_seq_propaci_w = 0) then 
 
		CALL Gerar_Proc_Pac_item_Prescr(	nr_prescricao_w, 
						nr_seq_prescricao_w, 
						null, 
						null, 
						nr_seq_proc_interno_w, 
						cd_procedimento_w, 
						ie_origem_proced_w, 
						qt_procedimento_w, 
						cd_setor_atendimento_w, 
						9, 
						to_date(dt_execucao_p,'dd/mm/yyyy hh24:mi:ss'), 
						'DIXTALEP12', 
						cd_medico_exec_w, 
						null, 
						ie_lado_w, 
						null);
 
		select	max(nr_sequencia), 
				max(nr_atendimento), 
				max(dt_entrada_unidade), 
				max(dt_procedimento) 
		into STRICT	nr_seq_propaci_w, 
				nr_atendimento_w, 
				dt_entrada_unidade_w, 
				dt_procedimento_w 
		from	procedimento_paciente 
		where	nr_prescricao		= nr_prescricao_w 
		and		nr_sequencia_prescricao	= nr_seq_prescricao_w;
 
	end if;
 
	select MAX(nr_sequencia) 
	into STRICT	nr_sequencia_w 
	from 	laudo_paciente 
	where  nr_prescricao = nr_prescricao_w 
	and		nr_seq_prescricao = nr_seq_prescricao_w;
 
	/* *** Cancela o laudo atual do procedimento (Tratamento para retificação do laudo pela DIXTALEP12. Quando já existir um laudo para o item, este é cancelado - OS 404183). *** */
 
	if (coalesce(nr_sequencia_w,0)<>0) then 
 
		CALL cancelar_laudo_paciente(nr_sequencia_w,'C','DIXTALEP12','');
 
	end if;
 
	select	max(substr(obter_desc_prescr_proc_laudo(cd_procedimento, ie_origem_proced, nr_seq_proc_interno, ie_lado, nr_seq_propaci_w),1,255)) 
	into STRICT	ds_titulo_laudo_w 
	from	prescr_procedimento a 
	where	a.nr_prescricao = nr_prescricao_w 
	and		a.nr_sequencia	= nr_seq_prescricao_w;
 
	select	nextval('laudo_paciente_seq') 
	into STRICT	laudo_paciente_seq_w 
	;
 
	insert into laudo_paciente( 
			nr_sequencia, 
			nr_atendimento, 
			dt_entrada_unidade, 
			nr_laudo, 
			nm_usuario, 
			dt_atualizacao, 
			cd_medico_resp, 
			ds_titulo_laudo, 
			dt_laudo, 
			nr_prescricao, 
			nr_seq_proc, 
			nr_seq_prescricao, 
			dt_exame, 
			qt_imagem 
			) 
		values (	laudo_paciente_seq_w, 
			nr_atendimento_w, 
			dt_entrada_unidade_w, 
			nr_laudo_w, 
			'DIXTALEP12', 
			clock_timestamp(), 
			cd_medico_resp_w, 
			ds_titulo_laudo_w, 
			clock_timestamp(), 
			nr_prescricao_w, 
			nr_seq_propaci_w, 
			nr_seq_prescricao_w, 
			dt_procedimento_w, 
			0 
			);
 
 
		update	procedimento_paciente 
		set		nr_laudo	= laudo_paciente_seq_w 
		where	nr_sequencia	= nr_seq_propaci_w;
 
	/* ***** Atualiza status execução na prescrição ***** */
 
	update	prescr_procedimento a 
	set		a.ie_status_execucao 	= '20', 
			a.nm_usuario 	= 'DIXTALEP12' 
	where	a.nr_prescricao = nr_prescricao_w 
	and		a.nr_sequencia in (	SELECT	b.nr_sequencia_prescricao 
									from	procedimento_paciente b 
									where	b.nr_prescricao 	= a.nr_prescricao 
									and		b.nr_sequencia_prescricao = a.nr_sequencia 
									and		b.nr_laudo 		= nr_seq_prescricao_w);
 
	select 	max(ie_status_execucao) 
	into STRICT	ie_status_execucao_w 
	from	prescr_procedimento a 
	where	a.nr_prescricao = nr_prescricao_w 
	and		a.nr_sequencia = nr_seq_prescricao_w;
 
	if (ie_status_execucao_w <> '20') then 
 
		update	prescr_procedimento a 
		set		a.ie_status_execucao = '20', 
				a.nm_usuario 	= 'DIXTALEP12' 
		where	a.nr_prescricao = nr_prescricao_w 
		and		a.nr_sequencia in (	SELECT	b.nr_sequencia_prescricao 
										from	procedimento_paciente b 
										where	b.nr_prescricao = a.nr_prescricao 
										and 	b.nr_prescricao = nr_prescricao_w 
										and		b.nr_sequencia_prescricao = a.nr_sequencia 
										and		b.nr_sequencia_prescricao = nr_seq_prescricao_w);
 
	end if;
 
end if;
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE importar_mensagem_dixtal ( nr_seq_agenda_p bigint, dt_execucao_p text) FROM PUBLIC;
