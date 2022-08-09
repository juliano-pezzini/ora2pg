-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE create_medical_report_bft ( nr_seq_interno_p bigint, cd_physician_p text, nm_usuario_p text, nr_seq_laudo_p INOUT bigint, nr_atendimento_p bigint default null, ds_titulo_laudo_p text default null, nr_seq_proc_hor_p bigint default null) AS $body$
DECLARE

nr_prescricao_w		bigint;
nr_seq_prescricao_w	bigint;
nr_seq_propaci_w	bigint;
nr_seq_proc_interno_w	bigint;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
qt_procedimento_w	bigint;
cd_setor_atendimento_w	bigint;
cd_medico_exec_w	varchar(10);
nr_seq_exame_w		bigint;
ie_lado_w		varchar(15);
dt_prev_execucao_w	timestamp;
nr_atendimento_w	bigint;
dt_entrada_unidade_w	timestamp;
nr_laudo_w        	bigint;
cd_medico_resp_w	varchar(10);
qt_existe_medico_w	bigint;
ds_laudo_w		text;
ds_laudo_copia_w	text;
nr_seq_laudo_w		bigint;
nr_seq_laudo_ant_w	bigint;
nr_seq_laudo_atual_w	bigint;
nr_seq_copia_w		bigint;

cd_laudo_externo_w	bigint;
cd_medico_laudante_w	varchar(10);
ds_titulo_laudo_w	varchar(255);
dt_liberacao_laudo_w	timestamp := clock_timestamp();
ie_existe_laudo_w	varchar(1);
ie_tipo_ordem_w		varchar(5);

nm_usuario_w		usuario.nm_usuario%type;

nr_acesso_dicom_w	varchar(30);
nr_seq_prescr_w		bigint;
nm_medico_solicitante_w varchar(200);
ie_insere_medico_solic_w varchar(1);

dt_procedimento_w	timestamp;
ie_status_execucao_w	varchar(3);

cd_estabelecimento_w	smallint;
ie_alterar_medico_conta_w 	varchar(2);
ie_alterar_medico_exec_conta_w	varchar(2);
ie_cancelar_laudo_w   varchar(2);
nr_sequencia_ww varchar(10);
nr_sequencia_www	bigint;
nr_seq_interno_w	bigint	:= coalesce(nr_seq_interno_p,0);
dt_suspensao_w		timestamp;


BEGIN

nm_usuario_w := coalesce(nm_usuario_p,'Integration');
nr_seq_laudo_p := 0;

select 	MAX(vl_parametro)
into STRICT	ie_insere_medico_solic_w
from 	funcao_parametro
where  	cd_funcao = 28
and 	nr_sequencia = 78;


if (nr_seq_proc_hor_p IS NOT NULL AND nr_seq_proc_hor_p::text <> '') and (nr_seq_proc_hor_p	> 0) and (nr_seq_interno_w	= 0) then
	
	select	max(nr_prescricao),
		max(nr_seq_procedimento)
	into STRICT	nr_prescricao_w,
		nr_seq_prescricao_w
	from	prescr_proc_hor
	where	nr_sequencia = nr_seq_proc_hor_p;
	
	
	select	max(nr_seq_interno),
		max(dt_suspensao)
	into STRICT	nr_seq_interno_w,
		dt_suspensao_w
	from	prescr_procedimento
	where	nr_prescricao 	= nr_prescricao_w
	and	nr_sequencia	= nr_seq_prescricao_w;
	
end if;


if (nr_seq_interno_w IS NOT NULL AND nr_seq_interno_w::text <> '') and (nr_seq_interno_w > 0) then
	select	nr_prescricao,
		nr_sequencia,
		nr_seq_proc_interno,
		cd_procedimento,
		ie_origem_proced,
		qt_procedimento,
		cd_setor_atendimento,
		cd_medico_exec,
		nr_seq_exame,
		coalesce(ie_lado,'A'),
		dt_prev_execucao,
		dt_suspensao
	into STRICT	nr_prescricao_w,
		nr_seq_prescricao_w,
		nr_seq_proc_interno_w,
		cd_procedimento_w,
		ie_origem_proced_w,
		qt_procedimento_w,
		cd_setor_atendimento_w,
		cd_medico_exec_w,
		nr_seq_exame_w,
		ie_lado_w,
		dt_prev_execucao_w,
		dt_suspensao_w
	from	prescr_procedimento
	where	nr_seq_interno	= nr_seq_interno_w;
end if;

if (dt_suspensao_w IS NOT NULL AND dt_suspensao_w::text <> '') then
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(1138956);
end if;

if	((coalesce(nr_prescricao_w,0) > 0) and (coalesce(nr_seq_prescricao_w,0) > 0)) or (coalesce(nr_atendimento_p,0)	> 0)	then
	begin
	
	
	if	((coalesce(nr_prescricao_w,0) > 0) and (coalesce(nr_seq_prescricao_w,0) > 0)) then
	
		select	coalesce(max(nr_sequencia),0),
			max(nr_atendimento),
			max(dt_entrada_unidade),
			max(dt_procedimento)
		into STRICT	nr_seq_propaci_w,
			nr_atendimento_w,
			dt_entrada_unidade_w,
			dt_procedimento_w
		from	procedimento_paciente
		where	nr_prescricao	= nr_prescricao_w
		and	nr_sequencia_prescricao	= nr_seq_prescricao_w
		and     coalesce(nr_seq_proc_princ::text, '') = '';
		
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
							nm_usuario_w, 
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
			and	nr_sequencia_prescricao	= nr_seq_prescricao_w
			and          coalesce(nr_seq_proc_princ::text, '') = '';
			
			end;
		end if;
	elsif (coalesce(nr_atendimento_p,0)	> 0) then
		nr_atendimento_w	:= nr_atendimento_p;
		
		select	max(dt_entrada_unidade)
		into STRICT	dt_entrada_unidade_w
		from	resumo_atendimento_paciente_v
		where	nr_atendimento	= nr_atendimento_w;
	end if;
	

	
	select	coalesce(max(nr_laudo),0) + 1
	into STRICT	nr_laudo_w
	from	laudo_paciente
	where	nr_atendimento	= nr_atendimento_w;

	select	count(*)
	into STRICT	qt_existe_medico_w
	from	medico
	where	cd_pessoa_fisica	= cd_physician_p;
	
	if (coalesce(ie_insere_medico_solic_w,'N') = 'S') then
		select 	MAX(substr(obter_nome_pf(cd_medico),1,60))
		into STRICT 	nm_medico_solicitante_w
		from 	prescr_medica
		where 	nr_prescricao = nr_prescricao_w;
	else
		nm_medico_solicitante_w := '';	
	end if;
	
	if (qt_existe_medico_w = 0) then
	
		select 	MAX(substr(obter_nome_pf(cd_medico),1,60))
		into STRICT 	nm_medico_solicitante_w
		from 	prescr_medica
		where 	nr_prescricao = nr_prescricao_w;
	else
		cd_medico_resp_w	:= cd_physician_p;
	end if;
	

	select  coalesce(MAX(nr_sequencia),0)
	into STRICT	nr_sequencia_www
	from 	laudo_paciente
	where   nr_prescricao = nr_prescricao_w
	and	nr_seq_prescricao = nr_seq_prescricao_w;
	
	if (nr_sequencia_www > 0) then
		CALL cancelar_laudo_paciente(nr_sequencia_www,'C',nm_usuario_w,'');
	end if;	
	
	select	nextval('laudo_paciente_seq')
	into STRICT	nr_seq_laudo_w
	;
	
	if (nr_prescricao_w IS NOT NULL AND nr_prescricao_w::text <> '') then
		
		select	substr(obter_desc_prescr_proc_laudo(p.cd_procedimento,
				p.ie_origem_proced, 
				p.nr_seq_proc_interno, 
				p.ie_lado, 
				nr_seq_propaci_w),1,255)
		into STRICT	ds_titulo_laudo_w
		from	prescr_procedimento p
		where	nr_prescricao	= nr_prescricao_w
		and 	nr_sequencia	= nr_seq_prescricao_w;
	elsif (ds_titulo_laudo_p IS NOT NULL AND ds_titulo_laudo_p::text <> '') then
		ds_titulo_laudo_w	:= ds_titulo_laudo_p;
	end if;

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
		ds_laudo,
		nr_seq_proc,
		nr_seq_prescricao,
		dt_liberacao,
		qt_imagem,
		nm_medico_solicitante,
		ie_status_laudo,
		cd_laudo_externo,
		dt_exame,
		dt_aprovacao)
	values (	nr_seq_laudo_w,
		nr_atendimento_w,
		dt_entrada_unidade_w,
		nr_laudo_w,
		nm_usuario_w,
		clock_timestamp(),
		cd_medico_resp_w,
		ds_titulo_laudo_w,
		dt_liberacao_laudo_w,
		nr_prescricao_w,
		Wheb_Mensagem_Pck.Get_Texto(1071819),
		nr_seq_propaci_w,
		nr_seq_prescricao_w,
		dt_liberacao_laudo_w,
		0,
		nm_medico_solicitante_w,
		'LL',
		null,
		coalesce(dt_procedimento_w,dt_liberacao_laudo_w),
		coalesce(dt_liberacao_laudo_w,clock_timestamp()));
		commit;
	nr_seq_laudo_p := nr_seq_laudo_w;
	
	select	max(cd_estabelecimento)
	into STRICT	cd_estabelecimento_w
	from	prescr_medica
	where	nr_prescricao = nr_prescricao_w;

	ie_alterar_medico_conta_w 	:= Obter_Valor_Param_Usuario(28 ,101 , obter_perfil_ativo ,null,cd_estabelecimento_w);
	ie_alterar_medico_exec_conta_w 	:= Obter_Valor_Param_Usuario(28 ,112 , obter_perfil_ativo ,null,cd_estabelecimento_w);
	
	if (ie_alterar_medico_conta_w = 'S') then
		CALL Atualizar_Propaci_Medico_Laudo(nr_seq_laudo_w,'EX',nm_usuario_w);
	end if;
	
	if (ie_alterar_medico_exec_conta_w = 'S') then
		CALL Atualizar_Propaci_Medico_Laudo(nr_seq_laudo_w,'EXC',nm_usuario_w);
	end if;
	
	if (nr_seq_propaci_w IS NOT NULL AND nr_seq_propaci_w::text <> '') then
	
		update	procedimento_paciente
		set	nr_laudo	= nr_seq_laudo_w
		where	nr_sequencia	= nr_seq_propaci_w;
		commit;		
	end if;
	

	if (nr_seq_interno_w IS NOT NULL AND nr_seq_interno_w::text <> '') then
	
		UPDATE	prescr_procedimento a
		SET 	a.ie_status_execucao = '40',
			a.nm_usuario  = nm_usuario_w
		WHERE 	a.nr_prescricao = nr_prescricao_w
		and 	a.nr_seq_interno  in (nr_seq_interno_w)
		and exists ( 	SELECT	1
				from 	procedimento_paciente b
				where 	b.nr_prescricao = a.nr_prescricao
				and 	b.nr_sequencia_prescricao = a.nr_sequencia);
						
		commit;
	
	end if;
	
	if (nr_prescricao_w IS NOT NULL AND nr_prescricao_w::text <> '') then
	
		select	max(ie_status_execucao)
		into STRICT	ie_status_execucao_w
		from	prescr_procedimento a
		where	a.nr_prescricao = nr_prescricao_w
		and	a.nr_sequencia  = nr_seq_prescricao_w;
		
		if (ie_status_execucao_w <> '40') then
			UPDATE	prescr_procedimento a
			SET 	a.ie_status_execucao = '40',
				a.nm_usuario  = nm_usuario_w
			WHERE 	a.nr_prescricao = nr_prescricao_w
			AND 	a.nr_seq_interno  IN (nr_seq_interno_w)
			AND	EXISTS ( SELECT 1
					FROM 	procedimento_paciente b
					WHERE 	b.nr_prescricao = a.nr_prescricao
					AND 	b.nr_laudo = nr_seq_prescricao_w);
			commit;
		end if;
	
	end if;
	
	end;
else
	CALL gravar_log_cdi(88877,'Prescription number and internal prescription sequence not found in table prescr_procedimento','Tasy');
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(192838);
end if;
commit;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE create_medical_report_bft ( nr_seq_interno_p bigint, cd_physician_p text, nm_usuario_p text, nr_seq_laudo_p INOUT bigint, nr_atendimento_p bigint default null, ds_titulo_laudo_p text default null, nr_seq_proc_hor_p bigint default null) FROM PUBLIC;
