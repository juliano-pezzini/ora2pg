-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qt_confirmar_marcacao ( nr_seq_pend_agenda_p bigint, nm_usuario_p text, ds_observacao_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_atendimento_w		bigint;
nr_seq_atendimento_ww		bigint;
nr_seq_paciente_w		bigint;
cd_pessoa_fisica_w		varchar(10);
dt_agenda_w			timestamp;
nr_seq_local_w			bigint;
nr_duracao_w			bigint;
nr_seq_marcacao_w		bigint;
nr_seq_prof_w			bigint;
ie_tipo_agendamento_w		varchar(15);
nr_ciclo_w			smallint;
ie_gera_autorizacao_w		varchar(1);
cd_estabelecimento_w		smallint;
ds_observacao_w			varchar(255);
nr_seq_ageint_item_w		bigint;
nr_seq_agenda_w			bigint;
cd_medico_resp_w		varchar(10);
cd_estab_local_w		smallint;
dt_prevista_agenda_w		timestamp;
ie_anestesia_w			varchar(1) := 'N';
ie_encaixe_w			varchar(1);
dt_agenda_ant_w			timestamp;
nr_seq_agenda_reserva_w		bigint;
nm_usuario_confirm_forc_w	varchar(15);
nr_seq_estagio_w		bigint;
ie_confirmar_ciclo_autor_w	varchar(1);
ie_gerar_solic_pront_w		varchar(1);
cd_setor_local_w		bigint;
ie_atualiza_estab_w		varchar(1);
qt_marcacao_w			bigint;
qt_tempo_medic_w		bigint;
qt_tempo_prep_medic_w		bigint;
qt_tempo_prep_pac_w		bigint;
ie_consist_outro_agen_w		varchar(1);
ie_limpar_campo_quimio		varchar(1);
dt_agenda_ww			varchar(20);
nr_duracao_ww			bigint;
ds_bloq_trat_quimio_w		paciente_atendimento.ds_bloq_trat_quimio%type;
nr_seq_motivo_bloq_w		paciente_atendimento.nr_seq_motivo_bloq%type;
nr_seq_ageint_w			agenda_integrada.nr_sequencia%type;
nr_seq_proc_interno_w		paciente_atend_proc.nr_seq_proc_interno%type;
ie_origem_proced_w		paciente_atend_proc.ie_origem_proced%type;
cd_procedimento_w		paciente_atend_proc.cd_procedimento%type;
nr_agrupamento_w		paciente_atend_proc.nr_agrupamento%type;
cd_convenio_w			paciente_setor_convenio.cd_convenio%type;
cd_categoria_w			paciente_setor_convenio.cd_categoria%type;
cd_plano_w			paciente_setor_convenio.cd_plano%type;
dt_prevista_item_w		timestamp;
ie_gerar_agenda_cons_w		varchar(1);
ie_classif_agenda_w		agenda_integrada_item.ie_classif_agenda%type;
cd_protocolo_w			paciente_setor.cd_protocolo%type;
cd_especialidade_proc_w		protocolo_medic_proc.cd_especialidade%type;
nr_seq_mot_reagendamento_w	agenda_quimio.nr_seq_mot_reagendamento%type;
nr_seq_medicacao_w		paciente_setor.nr_seq_medicacao%type;


ds_observacao_prot_w		protocolo_medic_proc.ds_observacao%type;
ds_cor_w			protocolo_medic_proc.ds_cor%type;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		dt_agenda,
		nr_seq_local,
		nr_duracao,
		nr_seq_prof,
		ie_tipo_agendamento,
		coalesce(ds_observacao_p,ds_observacao),
		nr_seq_ageint_item,
		coalesce(ie_encaixe,'N'),
		nm_usuario_confirm_forc,
		nr_seq_atendimento
	from	agenda_quimio_marcacao
	where	nr_seq_pend_agenda	= nr_seq_pend_agenda_p
	and	nm_usuario 		= nm_usuario_p
	and	ie_gerado		= 'N'
	order by dt_agenda;
	
C02 CURSOR FOR
	SELECT	distinct nr_seq_paciente,
		nr_ciclo
	from	paciente_atendimento
	where	nr_seq_pend_agenda	= nr_seq_pend_agenda_p;
	
C03 CURSOR FOR	
	SELECT	a.nr_seq_proc_interno,
			a.ie_origem_proced,
			a.cd_procedimento,
			trunc(b.dt_prevista),
			a.nr_agrupamento
	from	paciente_atend_proc a,	
			paciente_atendimento b
	where	a.nr_seq_atendimento = b.nr_seq_atendimento
	and		b.nr_seq_atendimento = nr_seq_atendimento_ww
	and		((a.nr_seq_proc_interno IS NOT NULL AND a.nr_seq_proc_interno::text <> '') or (a.cd_procedimento IS NOT NULL AND a.cd_procedimento::text <> ''))
	order by 1;
	

BEGIN

/* Retirado pois e necessario obter a duracao de acordo com cada NR_SEQ_ATENDIMENTO da pendencia de quimio, adicionado o mesmo select apos abertura do C01
select	max(a.cd_pessoa_Fisica), 
		max(a.cd_estabelecimento),
		max(b.dt_prevista_agenda),
		max(qt_obter_dur_aplicacao(b.ds_dia_ciclo,a.nr_seq_medicacao,a.cd_protocolo,b.nr_seq_atendimento,nvl(b.dt_real, b.dt_prevista),nr_seq_pend_agenda_p,nm_usuario_p,cd_estabelecimento_p))
into	cd_pessoa_fisica_w,
		cd_estabelecimento_w,
		dt_prevista_agenda_w,
		qt_tempo_medic_w
from	paciente_setor a,
		paciente_atendimento b
where	b.nr_seq_pend_agenda	= nr_seq_pend_agenda_p
and		a.nr_seq_paciente	= b.nr_seq_paciente;*/
ie_gera_autorizacao_w := obter_param_usuario(865, 6, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_gera_autorizacao_w);
ie_confirmar_ciclo_autor_w := obter_param_usuario(865, 115, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_confirmar_ciclo_autor_w);
ie_atualiza_estab_w := obter_param_usuario(865, 132, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_atualiza_estab_w);

qt_tempo_prep_medic_w := obter_param_usuario(865, 1, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, qt_tempo_prep_medic_w);	
qt_tempo_prep_pac_w := obter_param_usuario(865, 2, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, qt_tempo_prep_pac_w);
ie_consist_outro_agen_w := obter_param_usuario(865, 237, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_consist_outro_agen_w);

ie_limpar_campo_quimio := obter_param_usuario(865, 245, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_limpar_campo_quimio);


qt_tempo_medic_w	:= (coalesce(qt_tempo_medic_w,0) + coalesce(qt_tempo_prep_medic_w,0) + coalesce(qt_tempo_prep_pac_w,0));

--Parametros da agenda de quimioterapia(Shift + F11)
select	max(coalesce(ie_gerar_agenda_cons,'N'))		
into STRICT	ie_gerar_agenda_cons_w		
from	parametro_agenda_quimio
where	cd_estabelecimento = cd_estabelecimento_p;

if (ie_consist_outro_agen_w = 'S') then
	open C01;
	loop
	fetch C01 into	
		nr_seq_marcacao_w,
		dt_agenda_w,
		nr_seq_local_w,
		nr_duracao_w,
		nr_seq_prof_w,
		ie_tipo_agendamento_w,
		ds_observacao_w,
		nr_seq_ageint_item_w,
		ie_encaixe_w,
		nm_usuario_confirm_forc_w,
		nr_seq_atendimento_ww;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		
		select	max(a.cd_pessoa_Fisica),
				max(a.cd_estabelecimento),
				max(b.dt_prevista_agenda),
				max(qt_obter_dur_aplicacao(b.ds_dia_ciclo,a.nr_seq_medicacao,a.cd_protocolo,b.nr_seq_atendimento,coalesce(b.dt_real, b.dt_prevista),nr_seq_pend_agenda_p,nm_usuario_p,cd_estabelecimento_p))
		into STRICT	cd_pessoa_fisica_w,
				cd_estabelecimento_w,
				dt_prevista_agenda_w,
				qt_tempo_medic_w
		from	paciente_setor a,
				paciente_atendimento b
		where	b.nr_seq_pend_agenda	= nr_seq_pend_agenda_p
		and		a.nr_seq_paciente		= b.nr_seq_paciente
		and (b.nr_seq_atendimento	= nr_seq_atendimento_ww or coalesce(nr_seq_atendimento_ww::text, '') = '');
		
		select	count(*)
		into STRICT	qt_marcacao_w
		from	agenda_quimio_marcacao a
		where	((dt_agenda_w between dt_agenda and dt_agenda + (nr_duracao - 1) / 1440)
		or	(dt_agenda_w + (nr_duracao_w - 1) / 1440 between dt_agenda and dt_agenda + (nr_duracao - 1) / 1440)
		or	(dt_agenda between dt_agenda_w and dt_agenda_w + (nr_duracao_w - 1) / 1440)
		or	(dt_agenda + (nr_duracao - 1) / 1440 between dt_agenda_w and dt_agenda_w + (nr_duracao_w - 1) / 1440))
		and	nr_seq_local	= nr_seq_local_w
		and	nr_seq_pend_agenda <> nr_seq_pend_agenda_p
		and (coalesce(ie_gerado, 'X')	= 'N'
		or (coalesce(ie_gerado, 'X')	= 'S'
		and	(a.nr_seq_pend_agenda IS NOT NULL AND a.nr_seq_pend_agenda::text <> '')
		and	not exists (	SELECT	1
					from 	agenda_quimio x
					where 	a.nr_seq_atendimento = x.nr_seq_atendimento 
					and	a.nr_seq_pend_agenda = x.nr_seq_pend_agenda
					and	trunc(x.dt_agenda)   = trunc(a.dt_Agenda)
					and	x.ie_status_agenda in ('F','S','C')) ));	
		
		if (coalesce(qt_marcacao_w,0) > 0) then
		
			select	max(to_char(dt_agenda, 'dd/mm/yyyy hh24:mi:ss')),
					max(nr_duracao)
			into STRICT	dt_agenda_ww,
					nr_duracao_ww
			from	agenda_quimio_marcacao a
			where	((dt_agenda_w between dt_agenda and dt_agenda + (nr_duracao - 1) / 1440)
			or	(dt_agenda_w + (nr_duracao_w - 1) / 1440 between dt_agenda and dt_agenda + (nr_duracao - 1) / 1440)
			or	(dt_agenda between dt_agenda_w and dt_agenda_w + (nr_duracao_w - 1) / 1440)
			or	(dt_agenda + (nr_duracao - 1) / 1440 between dt_agenda_w and dt_agenda_w + (nr_duracao_w - 1) / 1440))
			and	nr_seq_local	= nr_seq_local_w
			and	nr_seq_pend_agenda <> nr_seq_pend_agenda_p
			and (coalesce(ie_gerado, 'X')	= 'N'
			or (coalesce(ie_gerado, 'X')	= 'S'
			and	(a.nr_seq_pend_agenda IS NOT NULL AND a.nr_seq_pend_agenda::text <> '')
			and	not exists (	SELECT	1
						from 	agenda_quimio x
						where 	a.nr_seq_atendimento = x.nr_seq_atendimento 
						and	a.nr_seq_pend_agenda = x.nr_seq_pend_agenda
						and	trunc(x.dt_agenda)   = trunc(a.dt_Agenda)
						and	x.ie_status_agenda in ('F','S','C')) ));
		end if;
		
	
		if (coalesce(qt_marcacao_w,0) = 0) then
		
			select	count(*)
			into STRICT	qt_marcacao_w                                                         
			from	agenda_quimio                                                         
			where	((dt_agenda_w between dt_agenda and dt_agenda + (nr_minuto_duracao - 1) / 1440)                                                                                                                                                      
			or	(dt_agenda_w + (nr_duracao_w - 1) / 1440 between dt_agenda and dt_agenda + (nr_minuto_duracao - 1) / 1440)                                                                                                                          
			or	(dt_agenda between dt_agenda_w and dt_agenda_w + (nr_duracao_w - 1) / 1440)                                                                         
			or	(dt_agenda + (nr_minuto_duracao - 1) / 1440 between dt_agenda_w and dt_agenda_w + (nr_duracao_w - 1) / 1440))                                                                                                                       
			and	nr_seq_local	= nr_seq_local_w                                          
			and	coalesce(nr_seq_pend_agenda,0) <> nr_seq_pend_agenda_p
			and	ie_status_agenda	not in ('F','S','C');
			
			if (coalesce(qt_marcacao_w,0) > 0) then
			
				select	max(to_char(dt_agenda, 'dd/mm/yyyy hh24:mi:ss')),
						max(nr_minuto_duracao)
				into STRICT	dt_agenda_ww,
						nr_duracao_ww
				from	agenda_quimio
				where	((dt_agenda_w between dt_agenda and dt_agenda + (nr_minuto_duracao - 1) / 1440)                                                                                                                                                      
				or	(dt_agenda_w + (nr_duracao_w - 1) / 1440 between dt_agenda and dt_agenda + (nr_minuto_duracao - 1) / 1440)                                                                                                                          
				or	(dt_agenda between dt_agenda_w and dt_agenda_w + (nr_duracao_w - 1) / 1440)                                                                         
				or	(dt_agenda + (nr_minuto_duracao - 1) / 1440 between dt_agenda_w and dt_agenda_w + (nr_duracao_w - 1) / 1440))                                                                                                                       
				and	nr_seq_local	= nr_seq_local_w                                          
				and	coalesce(nr_seq_pend_agenda,0) <> nr_seq_pend_agenda_p
				and	ie_status_agenda	not in ('F','S','C');
			end if;
			
		end if;
		
		if (coalesce(qt_marcacao_w,0) > 0) then
		
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(243336,'DT_DIAS='||dt_agenda_ww|| ';QT_TEMPO=' || to_char(nr_duracao_ww));	

			if (ie_limpar_campo_quimio = 'S')	then --OS 620565
				select	max(ds_bloq_trat_quimio),
						max(nr_seq_motivo_bloq)
				into STRICT	ds_bloq_trat_quimio_w,
						nr_seq_motivo_bloq_w
				from	paciente_atendimento
				where	nr_seq_atendimento = nr_seq_atendimento_ww;
			
				if (ds_bloq_trat_quimio_w IS NOT NULL AND ds_bloq_trat_quimio_w::text <> '') and (nr_seq_motivo_bloq_w IS NOT NULL AND nr_seq_motivo_bloq_w::text <> '')then
				
				update	paciente_atendimento
				set		ds_bloq_trat_quimio 	= '',
						nr_seq_motivo_bloq 	 = NULL
				where	nr_seq_atendimento 		= nr_seq_atendimento_ww;
			end if;	
		
		end if;	
			
		end if;
		end;
	end loop;
	close C01;
end if;

open C01;
loop
fetch C01 into	
	nr_seq_marcacao_w,
	dt_agenda_w,
	nr_seq_local_w,
	nr_duracao_w,
	nr_seq_prof_w,
	ie_tipo_agendamento_w,
	ds_observacao_w,
	nr_seq_ageint_item_w,
	ie_encaixe_w,
	nm_usuario_confirm_forc_w,
	nr_seq_atendimento_ww;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
		
	select	max(a.cd_pessoa_Fisica),
			max(a.cd_estabelecimento),
			max(b.dt_prevista_agenda),
			max(qt_obter_dur_aplicacao(b.ds_dia_ciclo,a.nr_seq_medicacao,a.cd_protocolo,b.nr_seq_atendimento,coalesce(b.dt_real, b.dt_prevista),nr_seq_pend_agenda_p,nm_usuario_p,cd_estabelecimento_p))
	into STRICT	cd_pessoa_fisica_w,
			cd_estabelecimento_w,
			dt_prevista_agenda_w,
			qt_tempo_medic_w
	from	paciente_setor a,
			paciente_atendimento b
	where	b.nr_seq_pend_agenda	= nr_seq_pend_agenda_p
	and		a.nr_seq_paciente		= b.nr_seq_paciente
	and (b.nr_seq_atendimento	= nr_seq_atendimento_ww or coalesce(nr_seq_atendimento_ww::text, '') = '');
		
	if (nr_seq_ageint_item_w > 0) then
		select	coalesce(max(ie_anestesia),'N')
		into STRICT	ie_anestesia_w
		from	agenda_integrada_item
		where	nr_sequencia = nr_seq_ageint_item_w;
	end if;
	
	select	max(cd_estabelecimento)
	into STRICT	cd_estab_local_w
	from	qt_local
	where	nr_sequencia = nr_seq_local_w;
	
	select	max(a.nr_seq_atendimento),
		max(b.cd_medico_resp)
	into STRICT	nr_seq_atendimento_w,
		cd_medico_resp_w
	from	paciente_atendimento a,
		paciente_setor b
	where	a.nr_seq_paciente	= b.nr_seq_paciente
	and	a.nr_seq_pend_agenda	= nr_seq_pend_agenda_p
	and	nr_seq_atendimento      = nr_seq_atendimento_ww
	and	coalesce(a.dt_suspensao::text, '') = ''
	and coalesce(a.dt_cancelamento::text, '') = ''
	and	trunc(coalesce(dt_prevista_agenda,coalesce(a.dt_real, a.dt_prevista)))		= trunc(dt_agenda_w);
	
	if (nr_seq_atendimento_w IS NOT NULL AND nr_seq_atendimento_w::text <> '') then
		select	max(a.nr_seq_mot_reagendamento)
		into STRICT	nr_seq_mot_reagendamento_w
		from	agenda_quimio a
		where	a.nr_seq_atendimento = nr_seq_atendimento_w;
	end if;
	
	
	if (ie_confirmar_ciclo_autor_w = 'N') then
		nr_seq_estagio_w := qt_obter_cor_estagio_autor(nr_seq_atendimento_w,'W');
		
		if (coalesce(nr_seq_estagio_w::text, '') = '') or (nr_seq_estagio_w <> 10) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(202390);			
		end if;
	end if;
	
	select	nextval('agenda_quimio_seq')
	into STRICT	nr_seq_Agenda_w
	;
	
	
	insert into agenda_quimio(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_pessoa_fisica,
		nr_seq_prof,
		nr_seq_local,
		nr_seq_atendimento,
		nr_minuto_duracao,
		dt_agenda,
		ie_tipo_pend_agenda,
		ie_status_agenda,
		ie_tipo_agendamento,
		ds_observacao,
		cd_estabelecimento,
		cd_medico_resp,
		nr_seq_pend_agenda,
		ie_anestesia,
		ie_encaixe,
		nm_usuario_confirm_forc,
		nr_seq_mot_reagendamento)
	values (nr_seq_Agenda_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		cd_pessoa_fisica_w,
		nr_seq_prof_w,
		nr_seq_local_w,
		nr_seq_atendimento_w,
		nr_duracao_w,
		dt_agenda_w,
		'Q',
		'N',
		ie_tipo_agendamento_w,
		ds_observacao_w,
		cd_estab_local_w,
		cd_medico_resp_w,
		nr_seq_pend_agenda_p,
		ie_anestesia_w,
		ie_encaixe_w,
		nm_usuario_confirm_forc_w,
		nr_seq_mot_reagendamento_w);	
		
	commit;
	
	if (coalesce(dt_prevista_agenda_w::text, '') = '') and
		((dt_agenda_ant_w	<> trunc(dt_agenda_w)) or (coalesce(dt_agenda_ant_w::text, '') = ''))		then
		update	paciente_atendimento
		set	dt_real		= dt_agenda_w,
			nm_usuario	= nm_usuario_p,
			dt_atualizacao	= clock_timestamp(),
			cd_estabelecimento = cd_estab_local_w
		--	nr_seq_local	= nr_seq_local_w
		where	nr_seq_pend_agenda	= nr_seq_pend_agenda_p
		and	nr_seq_atendimento = nr_seq_atendimento_w
		and	trunc(coalesce(dt_prevista_agenda, coalesce(dt_real,dt_prevista)))	= trunc(dt_agenda_w);
	end if;
	
	select	coalesce(max(ie_gerar_solic_pront),'N')
	into STRICT	ie_gerar_solic_pront_w
	from 	parametro_agenda_quimio
	where	cd_estabelecimento = obter_estabelecimento_ativo;
	
	if (ie_gerar_solic_pront_w IS NOT NULL AND ie_gerar_solic_pront_w::text <> '') and (ie_gerar_solic_pront_w = 'S') then

		select	max(cd_setor_atendimento)
		into STRICT	cd_setor_local_w
		from	qt_local
		where	nr_sequencia = nr_seq_local_w;

		if (coalesce(cd_setor_local_w,0) > 0) then	
			CALL Solic_Pront_Agenda_Quimio_GP(	cd_pessoa_fisica_w,
							nr_seq_Agenda_w,
							nr_seq_local_w,
							dt_agenda_w,
							nm_usuario_p,
							cd_setor_local_w);
		end if;
	end if;
	
	update	agenda_quimio_marcacao
	set	ie_gerado	= 'S'
	where	nr_sequencia	= nr_seq_marcacao_w;
	dt_agenda_ant_w	:= trunc(dt_agenda_w);
	
	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_agenda_reserva_w
	from	agenda_quimio
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w
	and		coalesce(ie_reserva, 'N')= 'S'
	and		(dt_agenda			between dt_agenda_w and dt_agenda_w + (nr_duracao_w / 1440)
	or		dt_agenda + (nr_minuto_duracao / 1440) between dt_agenda_w and dt_agenda_w + (nr_duracao_w / 1440));
	if (nr_seq_agenda_reserva_w	> 0) then
		CALL Qt_Alterar_Status_Agenda(nr_seq_agenda_reserva_w, 'C', nm_usuario_p, 'N', null, wheb_mensagem_pck.get_texto(795018), cd_estabelecimento_p,'');
	end if;
	
	if (ie_atualiza_estab_w = 'S') then
	select	max(cd_estabelecimento)
	into STRICT	cd_estab_local_w
	from	qt_local
	where	nr_sequencia = nr_seq_local_w;
	
	update	paciente_atendimento
	set	cd_estabelecimento = cd_estab_local_w
	where	nr_seq_atendimento = nr_seq_atendimento_w;
	end if;
	
	if (nr_seq_ageint_item_w IS NOT NULL AND nr_seq_ageint_item_w::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '')then
		select	max(a.nr_sequencia)
		into STRICT	nr_seq_ageint_w
		from	agenda_integrada a,
				agenda_integrada_item b
	   where	a.nr_sequencia		= b.nr_seq_agenda_int	
	   and	   	b.nr_sequencia		= nr_seq_ageint_item_w;
	
		CALL ageint_ins_anexo_email(nr_seq_ageint_w, nm_usuario_p, cd_estab_local_w);
	end if;
	
	--Gerar agendamento de consulta na Ag. Integrada	
	if (ie_gerar_agenda_cons_w = 'S')then	
		open C03;
		loop
		fetch C03 into	
			nr_seq_proc_interno_w,
			ie_origem_proced_w,
			cd_procedimento_w,
			dt_prevista_item_w,
			nr_agrupamento_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin
			
			select	max(c.cd_convenio),
				max(c.cd_categoria),
				max(c.cd_plano)
			into STRICT	cd_convenio_w,
				cd_categoria_w,
				cd_plano_w
			from	paciente_atendimento a,
				paciente_setor b,
				paciente_setor_convenio c
			where	a.nr_seq_paciente	= b.nr_seq_paciente
			and	b.nr_seq_paciente	= c.nr_seq_paciente
			and	a.nr_seq_pend_agenda	= nr_seq_pend_agenda_p
			and	nr_seq_atendimento      = nr_seq_atendimento_ww
			and	coalesce(a.dt_suspensao::text, '') = ''
			and 	coalesce(a.dt_cancelamento::text, '') = ''
			and	trunc(coalesce(dt_prevista_agenda,coalesce(a.dt_real, a.dt_prevista))) = trunc(dt_agenda_w);			
			
			if	((cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') or (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '')) then
				
				select	max(a.cd_protocolo),
						max(a.nr_seq_medicacao)
				into STRICT	cd_protocolo_w,
						nr_seq_medicacao_w
				from	paciente_setor a,
					paciente_atendimento b		
				where	a.nr_seq_paciente	= b.nr_seq_paciente
				and	b.nr_seq_pend_agenda	= nr_seq_pend_agenda_p
				and	b.nr_seq_atendimento	= nr_seq_atendimento_ww;
				
				
				if (cd_protocolo_w IS NOT NULL AND cd_protocolo_w::text <> '') or (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '')then
				
					select	max(a.ie_classif_agenda),
						max(a.cd_especialidade),


						max(a.ds_observacao),
						max(a.ds_cor)
					into STRICT	ie_classif_agenda_w,
						cd_especialidade_proc_w,


						ds_observacao_prot_w,
						ds_cor_w
					from	protocolo_medic_proc a
					where	a.cd_protocolo 	= cd_protocolo_w
					and	a.nr_sequencia = nr_seq_medicacao_w
					and     a.nr_seq_proc = nr_agrupamento_w
					and	((nr_seq_proc_interno = nr_seq_proc_interno_w) or (cd_procedimento = cd_procedimento_w))
					and	(a.ie_classif_agenda IS NOT NULL AND a.ie_classif_agenda::text <> '');
				
					CALL qt_gerar_agend_cons_integrada(	nr_seq_atendimento_ww,
									nr_seq_pend_agenda_p,
									cd_pessoa_fisica_w,
									cd_procedimento_w,
									nr_seq_proc_interno_w,
									ie_origem_proced_w,
									cd_convenio_w,
									cd_categoria_w,
									cd_plano_w,
									cd_estabelecimento_p,
									'A',
									dt_prevista_item_w,
									ie_classif_agenda_w,
									cd_especialidade_proc_w,



									nm_usuario_p,
									ds_observacao_prot_w,
									ds_cor_w);
				end if;
			end if;	
			end;
		end loop;
		close C03;
	end if;

commit;

	end;
end loop;
close C01;

if (ie_gera_autorizacao_w	= 'S') then
	open C02;
	loop
	fetch C02 into	
		nr_seq_paciente_w,
		nr_ciclo_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		CALL gerar_autor_conv_quimioterapia(nr_seq_paciente_w, nr_ciclo_w, nm_usuario_p, 'S');
		end;
	end loop;
	close C02;
end if;

update	qt_pendencia_agenda
set	dt_liberacao	= clock_timestamp(),
	dt_atualizacao	= clock_timestamp(),
	nm_usuario	= nm_usuario_p,
	ie_alt_enfermagem	 = NULL
where	nr_sequencia	= nr_seq_pend_agenda_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qt_confirmar_marcacao ( nr_seq_pend_agenda_p bigint, nm_usuario_p text, ds_observacao_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
