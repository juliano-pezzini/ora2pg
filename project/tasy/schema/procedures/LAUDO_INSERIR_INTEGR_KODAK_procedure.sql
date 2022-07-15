-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE laudo_inserir_integr_kodak (nr_acesso_dicom_p text, ds_nome_diretorio_p text, tipo_laudo_p text, cd_medico_laudante_p text default null, nr_seq_laudo_p INOUT bigint DEFAULT NULL) AS $body$
DECLARE

					 
nr_prescricao_w		bigint;
nr_seq_prescricao_w	bigint;

nr_sequencia_w		bigint;
nr_sequencia_ww		bigint;
nr_seq_imagem_w		bigint;
nr_laudo_w		bigint;
nr_atendimento_w	bigint;
cd_medico_resp_w	varchar(10);
dt_entrada_unidade_w	timestamp;
ds_titulo_laudo_w	varchar(255);
nr_seq_propaci_w	bigint;
dt_procedimento_w	timestamp;
nr_seq_laudo_w		bigint;
nr_seq_proc_interno_w	bigint;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
qt_procedimento_w	bigint;
cd_setor_atendimento_w	bigint;
dt_prev_execucao_w	timestamp;
cd_medico_exec_w	varchar(10);
ie_lado_w		varchar(15);
ds_laudo_copia_w	text;
nr_seq_laudo_ant_w	bigint;
nr_seq_laudo_atual_w	bigint;

ie_status_execucao_w	varchar(3);
nm_usuario_w 		varchar(50);


BEGIN 
 
if (nr_acesso_dicom_p IS NOT NULL AND nr_acesso_dicom_p::text <> '') and (ds_nome_diretorio_p IS NOT NULL AND ds_nome_diretorio_p::text <> '') then 
  
	select	max(a.nr_prescricao), 
		max(a.nr_sequencia), 
		max(nr_seq_proc_interno), 
		max(cd_procedimento), 
		max(ie_origem_proced), 
		max(qt_procedimento), 
		max(cd_setor_atendimento), 
		max(dt_prev_execucao), 
		max(cd_medico_exec), 
		max(coalesce(ie_lado,'A')) 
	into STRICT	nr_prescricao_w, 
		nr_seq_prescricao_w, 
		nr_seq_proc_interno_w, 
		cd_procedimento_w, 
		ie_origem_proced_w, 
		qt_procedimento_w, 
		cd_setor_atendimento_w, 
		dt_prev_execucao_w, 
		cd_medico_exec_w, 
		ie_lado_w 
	from	prescr_procedimento a 
	where	a.nr_acesso_dicom = nr_acesso_dicom_p;
		 
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
	and	nr_sequencia_prescricao	= nr_seq_prescricao_w;
	 
	if (nr_seq_propaci_w = 0) then 
		begin 
		 
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
						dt_prev_execucao_w, 
						'Synapse', 
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
		and	nr_sequencia_prescricao	= nr_seq_prescricao_w;
		 
		end;
	end if;
 
	select MAX(nr_sequencia) 
	into STRICT	nr_sequencia_ww 
	from 	laudo_paciente 
	where  nr_prescricao = nr_prescricao_w 
	and	nr_seq_prescricao = nr_seq_prescricao_w;
	 
	/* *** Cancela o laudo atual do procedimento (Tratamento para retificação do laudo pela Synapse. Quando já existir um laudo para o item, este é cancelado - OS 404183). *** */
 
	if (coalesce(nr_sequencia_ww,0)<>0) then 
		begin 
			CALL cancelar_laudo_paciente(nr_sequencia_ww,'C','Kodak','');
		end;
	end if;
	 
			 
	select	nextval('laudo_paciente_seq') 
	into STRICT	nr_seq_laudo_w 
	;
 
	 
	select	max(substr(obter_desc_prescr_proc_laudo(cd_procedimento, ie_origem_proced, nr_seq_proc_interno, ie_lado, nr_seq_propaci_w),1,255)) 
	into STRICT	ds_titulo_laudo_w		 
	from	prescr_procedimento a 
	where	a.nr_prescricao = nr_prescricao_w 
	and	a.nr_sequencia	= nr_seq_prescricao_w;
				 
	IF (LENGTH(cd_medico_laudante_p) > 0) THEN 
	 BEGIN 
	  SELECT nm_usuario 
	  INTO STRICT nm_usuario_w 
	  FROM usuario a 
	  WHERE a.CD_PESSOA_FISICA = cd_medico_laudante_p;
	 END;
	END IF;
 
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
			dt_liberacao, 
			qt_imagem, 
			ie_status_laudo, 
			dt_exame, 
			ds_arquivo, 
			ie_formato 
			) 
		values (	nr_seq_laudo_w, 
			nr_atendimento_w, 
			dt_entrada_unidade_w, 
			nr_laudo_w, 
			'Kodak', 
			clock_timestamp(), 
			CASE WHEN coalesce(cd_medico_laudante_p::text, '') = '' THEN cd_medico_resp_w  ELSE cd_medico_laudante_p END , 
			ds_titulo_laudo_w, 
			clock_timestamp(), 
			nr_prescricao_w,			 
			nr_seq_propaci_w, 
			nr_seq_prescricao_w, 
			clock_timestamp(), 
			0, 
			'LL', 
			dt_procedimento_w, 
			ds_nome_diretorio_p, 
			tipo_laudo_p 
			);
    
  
 nr_seq_laudo_p := nr_seq_laudo_w;
 
					 
	update	procedimento_paciente 
	set	nr_laudo	= nr_seq_laudo_w 
	where	nr_sequencia	= nr_seq_propaci_w;
	 
	 
	/* ***** Atualiza status execução na prescrição ***** */
 
	update	prescr_procedimento a 
	set	a.ie_status_execucao 	= '40', 
		a.nm_usuario 	= 'Kodak' 
	where	a.nr_prescricao = nr_prescricao_w 
	and	a.nr_sequencia in (	SELECT	b.nr_sequencia_prescricao 
					from	procedimento_paciente b 
					where	b.nr_prescricao 	= a.nr_prescricao 
					and	b.nr_sequencia_prescricao = a.nr_sequencia 
					and	b.nr_laudo 		= nr_seq_prescricao_w);
 
	select 	max(ie_status_execucao) 
	into STRICT	ie_status_execucao_w 
	from	prescr_procedimento a 
	where	a.nr_prescricao = nr_prescricao_w 
	and	a.nr_sequencia = nr_seq_prescricao_w;
 
	if (ie_status_execucao_w <> '40') then 
 
		update	prescr_procedimento a 
		set	a.ie_status_execucao = '40', 
			a.nm_usuario 	= 'Kodak' 
		where	a.nr_prescricao = nr_prescricao_w 
		and	a.nr_sequencia in (	SELECT	b.nr_sequencia_prescricao 
						from	procedimento_paciente b 
						where	b.nr_prescricao = a.nr_prescricao 
						and 	b.nr_prescricao = nr_prescricao_w 
						and	b.nr_sequencia_prescricao = a.nr_sequencia 
						and	b.nr_sequencia_prescricao = nr_seq_prescricao_w);	
	end if;
	 
end if;
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE laudo_inserir_integr_kodak (nr_acesso_dicom_p text, ds_nome_diretorio_p text, tipo_laudo_p text, cd_medico_laudante_p text default null, nr_seq_laudo_p INOUT bigint DEFAULT NULL) FROM PUBLIC;

