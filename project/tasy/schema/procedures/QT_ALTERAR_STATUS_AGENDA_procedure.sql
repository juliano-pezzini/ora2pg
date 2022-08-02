-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qt_alterar_status_agenda ( nr_Seq_agenda_p bigint, ie_status_agenda_p text, nm_usuario_p text, ie_cancelar_consulta_p text, nr_seq_motivo_p bigint, ds_motivo_p text, cd_estabelecimento_p bigint, ds_observacao_p text) AS $body$
DECLARE


ie_tipo_pend_agenda_w	varchar(15);
qt_tempo_div_w		bigint;
qt_min_duracao_w	bigint;
dt_agenda_w		timestamp;
dt_agenda_ww		timestamp;
nr_seq_paciente_w	bigint;
nr_seq_atendimento_w	bigint;
nr_seq_pendencia_w	bigint;
ie_status_agenda_w	varchar(15);

nr_seq_agenda_cons_w	agenda_quimio.nr_seq_agenda_cons%type;
cd_agenda_w		bigint;
nr_seq_ageint_item_w	bigint;
nr_seq_local_w		bigint;
nr_min_apres_local_w	smallint;

nr_minuto_duracao_w		bigint;
nr_seq_pend_agenda_w	bigint;
cd_pessoa_fisica_w		varchar(10);
nr_seq_prof_w			bigint;
qt_hor_cancelada_w		bigint;
nr_seq_agenda_w			bigint;
nr_seq_atend_w			bigint;
ie_executar_consulta_w		varchar(1);
nr_seq_ag_integrada_w	agenda_integrada.nr_sequencia%type;
nr_seq_ag_int_item_w	agenda_integrada_item.nr_sequencia%type;
qt_hor_cancel_w			bigint;
ie_gerar_agenda_cons_w	varchar(1);
cd_pessoa_fisica_ww		agenda_quimio.cd_pessoa_fisica%type;

			
C01 CURSOR FOR
	SELECT	nr_sequencia,
			dt_agenda
	from	agenda_quimio
	where	((coalesce(nr_seq_paciente_w,0) = 0 and cd_pessoa_fisica_ww = cd_pessoa_fisica) or (coalesce(nr_seq_paciente_w,0) > 0 and coalesce(Qt_Obter_Seq_Pac_Seq_Atend(nr_seq_atendimento, nm_usuario_p),0)  = coalesce(nr_seq_paciente_w,0)))
	and	nr_sequencia	>= nr_seq_agenda_p
	and coalesce(dt_executada::text, '') = ''
	and ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_agenda) >= ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_Agenda_w)
	order by nr_sequencia;
			

BEGIN

ie_executar_consulta_w := obter_param_usuario(865, 244, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_executar_consulta_w);

select	max(Qt_Obter_Seq_Pac_Seq_Atend(nr_seq_atendimento, nm_usuario_p)),
	max(nr_seq_atendimento),
	max(Dt_Agenda),
	max(nr_seq_local),
	max(cd_pessoa_fisica)
into STRICT	nr_seq_paciente_w,
	nr_Seq_atendimento_w,
	dt_Agenda_w,
	nr_seq_local_w,
	cd_pessoa_fisica_ww
from	agenda_quimio
where	nr_sequencia	= nr_seq_agenda_p;

select	max(nr_min_apres)
into STRICT	nr_min_apres_local_w
from	qt_local
where	nr_sequencia = nr_seq_local_w;


if (ie_Status_agenda_p	= 'A') then
	update	agenda_quimio
	set	ie_status_agenda	= ie_status_agenda_p,
		dt_aguardando	= clock_timestamp(),
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_seq_agenda_p;
	
elsif (ie_status_agenda_p 	= 'P') then
	update	agenda_quimio
	set	ie_status_agenda	= ie_status_agenda_p,
		dt_em_preparo	= clock_timestamp(),
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_seq_agenda_p;
	
elsif (ie_status_agenda_p 	= 'M') then
	update	agenda_quimio
	set	ie_status_agenda	= ie_status_agenda_p,
		dt_medic_liberado	= clock_timestamp(),
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_seq_agenda_p;	
	
elsif (ie_Status_agenda_p	= 'E') then
	qt_tempo_div_w	:= Obter_Valor_Param_Usuario(865, 3, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p);
	select	max(ie_tipo_pend_agenda),
		max(dt_agenda)
	into STRICT	ie_tipo_pend_agenda_w,
		dt_agenda_w
	from	agenda_quimio
	where	nr_sequencia		= nr_seq_agenda_p;
	
	if (ie_tipo_pend_agenda_w	= 'A') then
		qt_min_duracao_w	:= Obter_Min_Entre_Datas(dt_agenda_w, clock_timestamp(), coalesce(nr_min_apres_local_w,qt_tempo_div_w));
	end if;
	
	update	agenda_quimio
	set	ie_status_agenda	= ie_status_agenda_p,
		dt_executada		= clock_timestamp(),
		nr_minuto_duracao	= CASE WHEN ie_tipo_pend_agenda_w='A' THEN  qt_min_duracao_w  ELSE nr_minuto_duracao END ,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	nr_sequencia		= nr_seq_agenda_p;
	
	
	if (ie_executar_consulta_w = 'S') then
		select	max(a.nr_seq_agenda_cons),
			max(b.cd_agenda)
		into STRICT	nr_seq_agenda_cons_w,
			cd_agenda_w
		from	agenda_quimio a,
			agenda_consulta b
		where	a.nr_seq_agenda_cons 	= b.nr_sequencia
		and	a.nr_sequencia		= nr_seq_agenda_p;
		
		CALL alterar_status_agenda_cons(
			cd_estabelecimento_p,
			cd_agenda_w,
			nr_seq_agenda_cons_w,
			'E',
			null,
			null,
			'N',
			nm_usuario_p,
			null);
	end if;

	
elsif (ie_Status_agenda_p	= 'C') then
	select	max(ie_status_agenda),
			max(dt_agenda),
			max(nr_Seq_local),
			max(nr_minuto_duracao),
			max(nr_seq_pend_agenda),
			max(cd_pessoa_fisica),
			max(nr_seq_atendimento)
	into STRICT	ie_status_agenda_w,
			dt_agenda_w,
			nr_seq_local_w,
			nr_minuto_duracao_w,
			nr_seq_pend_agenda_w,
			cd_pessoa_fisica_w,
			nr_seq_atendimento_w
	from	agenda_quimio
	where	nr_sequencia	= nr_seq_agenda_p
	and 	coalesce(dt_executada::text, '') = '';
	
	select	max(nr_seq_prof)
	into STRICT	nr_seq_prof_w
	from	qt_paciente_prof
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w;
		
	if (ie_status_agenda_w	= 'C') then
	
		if (coalesce(ds_observacao_p,'XPTO') <> 'CANCELARDIAQUIMIO') then  --  Cancelar_Dia_Quimio
		
			select	count(*)
			into STRICT	qt_hor_cancelada_w
			from	agenda_quimio
			where	((dt_agenda between dt_agenda_w and dt_Agenda_w + nr_minuto_duracao_w / 1440)
			or		((dt_agenda + (nr_minuto_duracao - 1) / 1440) between dt_agenda_w and dt_Agenda_w + nr_minuto_duracao_w / 1440)
			or		(dt_agenda_w between dt_agenda and dt_agenda + (nr_minuto_duracao - 1) / 1440)
			or		((dt_agenda_w + nr_minuto_duracao_w / 1440) between dt_agenda and dt_agenda + (nr_minuto_duracao - 1) / 1440))
			and		ie_status_agenda <> 'C'
			and		nr_seq_local	= nr_seq_local_w
			and		nr_sequencia	<> nr_seq_agenda_p;
			
			--Parametros da agenda de quimioterapia(Shift + F11)
			select	max(coalesce(ie_gerar_agenda_cons,'N'))		
			into STRICT	ie_gerar_agenda_cons_w
			from	parametro_agenda_quimio
			where	cd_estabelecimento = cd_estabelecimento_p;
			
			if (qt_hor_cancelada_w > 0 and ie_gerar_agenda_cons_w = 'S') then
				--Nao foi possivel reverter o cancelamento pois ja existe agendamento nesse horario!
				CALL Wheb_mensagem_pck.exibir_mensagem_abort(207997);
			end if;
		
			insert into agenda_quimio_marcacao(nr_sequencia,
						dt_agenda,
						nm_usuario,
						nr_seq_local,
						nr_duracao,
						nr_seq_pend_agenda,
						dt_atualizacao,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						ie_gerado,
						ie_transferencia,
						nr_seq_prof,
						ie_tipo_agendamento,
						nr_seq_Ageint_item,
						nr_seq_atendimento)
					values (nextval('agenda_quimio_marcacao_seq'),
						dt_agenda_w,
						nm_usuario_p,
						nr_seq_local_w,
						nr_minuto_duracao_w, 
						nr_seq_pend_agenda_w,
						clock_timestamp(),
						clock_timestamp(),
						nm_usuario_p,
						'S',
						'N', 
						nr_seq_prof_w,
						'',
						null,
						nr_seq_atendimento_w);
						
			update	agenda_quimio
			set	ie_status_agenda	= 'N',
				dt_cancelada		 = NULL,
				nr_seq_mot_cancelamento  = NULL,
				nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp(),
				nm_usuario_cancel	= '',
				ds_motivo_status        = ''
			where	nr_sequencia		= nr_seq_agenda_p;
		
		end if;
	else
		update	agenda_quimio
		set	ie_status_agenda	= ie_status_agenda_p,
			dt_cancelada		= clock_timestamp(),
			nr_seq_mot_cancelamento = CASE WHEN nr_seq_motivo_p=0 THEN null  ELSE nr_seq_motivo_p END ,
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp(),
			nm_usuario_cancel	= nm_usuario_p,
			ds_motivo_status        = ds_motivo_p
		where	nr_sequencia		= nr_seq_agenda_p;
			
		select	max(b.nr_sequencia),
				max(b.cd_agenda),
				max(a.nr_seq_agenda_cons)
		into STRICT	nr_seq_ag_int_item_w,
				cd_agenda_w,
				nr_seq_agenda_cons_w		
		from	agenda_integrada_item a,
				agenda_consulta b,
				agenda_integrada c
		where	a.nr_seq_agenda_cons = b.nr_sequencia
		and		a.nr_seq_agenda_int = c.nr_sequencia
		and		a.nr_seq_atendimento = nr_seq_atendimento_w
		and		c.nr_seq_pendencia = nr_seq_pend_agenda_w;
		
		--Cancelar item vinculado na Agenda Integrada		
		select	max(dt_agenda)			
		into STRICT	dt_agenda_ww			
		from	agenda_consulta
		where	nr_sequencia = nr_seq_agenda_cons_w;
		
		select	coalesce(max(pkg_date_utils.extract_field('SECOND', dt_Agenda, 0)),0) + 1
		into STRICT	qt_hor_cancel_w
		from	agenda_consulta
		where	cd_agenda = cd_agenda_w
		and	to_date(to_char(dt_agenda,'dd/mm/yyyy hh24:mi') || ':00', 'dd/mm/yyyy hh24:mi:ss') = to_date(to_char(dt_agenda_ww,'dd/mm/yyyy hh24:mi') || ':00', 'dd/mm/yyyy hh24:mi:ss')
		and	ie_status_agenda = 'C';
		
		
		update	agenda_consulta
		set		ie_status_agenda	= 'C',
				dt_Agenda			= dt_agenda + qt_hor_cancel_w / 86400,
				nm_usuario_status	= nm_usuario_p,
				dt_status			= clock_timestamp(),
				ds_motivo_status	= OBTER_DESC_EXPRESSAO(729626),			-- 729626: 'Cancelamento do item agendado na Agenda de Quimioterapia'
				cd_motivo_cancelamento	 = NULL,
				nm_usuario				= nm_usuario_p,
				nm_usuario_cancelamento	= nm_usuario_p,
				dt_cancelamento			= clock_timestamp()
		where	nr_sequencia			= nr_seq_agenda_cons_w;		
		--alterar_status_agecons(cd_agenda_w, nr_seq_agenda_cons_w, 'C', null, 'Cancelamento do item agendado na Agenda de Quimioterapia', 'N', nm_usuario_p, null);
		
		if (ie_cancelar_consulta_p = 'S') then
			select	max(a.nr_seq_agenda_cons),
				max(b.cd_agenda)
			into STRICT	nr_seq_agenda_cons_w,
				cd_agenda_w
			from	agenda_quimio a,
				agenda_consulta b
			where	a.nr_seq_agenda_cons 	= b.nr_sequencia
			and	a.nr_sequencia		= nr_seq_agenda_p;
			
			CALL alterar_status_agenda_cons(
				cd_estabelecimento_p,
				cd_agenda_w,
				nr_seq_agenda_cons_w,
				'C',
				null,
				null,
				'N',
				nm_usuario_p,
				null);
		end if;
		
		select	coalesce(max(nr_seq_pend_Agenda),0)
		into STRICT	nr_seq_pendencia_w
		from	paciente_atendimento
		where	nr_seq_atendimento	= nr_Seq_atendimento_w;
		
		select	coalesce(max(nr_seq_Ageint_item),0)
		into STRICT	nr_seq_ageint_item_w
		from	agenda_quimio
		where	nr_sequencia	= nr_seq_agenda_p;
		
		/*SO-2225714*/

		if (nr_seq_ageint_item_w	> 0) then
			delete	FROM agenda_quimio_marcacao
			where	nr_seq_ageint_item	= nr_seq_ageint_item_w;
				
			delete	FROM w_agenda_quimio
			where	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_horario) between ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_Agenda_w) and ESTABLISHMENT_TIMEZONE_UTILS.endOfDay(dt_Agenda_w)
			and	nr_seq_Agequi		= nr_Seq_agenda_p;
		elsif (nr_seq_pendencia_w	> 0) then
			update	qt_pendencia_Agenda
			set	dt_liberacao	 = NULL,
				nm_usuario	= nm_usuario_p,
				dt_Atualizacao	= clock_timestamp()
			where	nr_sequencia	= nr_seq_pendencia_w;
			
			delete	FROM agenda_quimio_marcacao
			where	nr_seq_pend_agenda	= nr_seq_pendencia_w
			and	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_Agenda) = ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_Agenda_w);
			
			delete FROM w_agenda_quimio
			where ie_status = 'AG' 
			and nr_seq_atendimento = nr_Seq_atendimento_w;
		else
			delete	FROM agenda_quimio_marcacao
			where	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_Agenda) between ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_Agenda_w) and ESTABLISHMENT_TIMEZONE_UTILS.endOfDay(coalesce(dt_Agenda_w, clock_timestamp()))
			and	nr_seq_agenda		= nr_Seq_agenda_p;
			
			delete	FROM w_agenda_quimio
			where	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_horario) between ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_Agenda_w) and ESTABLISHMENT_TIMEZONE_UTILS.endOfDay(coalesce(dt_Agenda_w, clock_timestamp()))
			and	nr_seq_Agequi		= nr_Seq_agenda_p;
		end if;
	end if;
elsif (ie_Status_agenda_p	= 'Q') then
	update	agenda_quimio
	set	ie_status_agenda	= ie_status_agenda_p,
		dt_em_quimio		= clock_timestamp(),
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	nr_sequencia		= nr_seq_agenda_p;
elsif (ie_status_agenda_p	= 'CC') then
	open C01;
	loop
	fetch C01 into	
		nr_seq_agenda_w,
		dt_Agenda_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		update	agenda_quimio
		set	ie_status_agenda	= 'C',
			dt_cancelada		= clock_timestamp(),
			nr_seq_mot_cancelamento =  CASE WHEN nr_seq_motivo_p=0 THEN null  ELSE nr_seq_motivo_p END ,
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp(),
			nm_usuario_cancel	= nm_usuario_p,
			ds_motivo_status        = ds_motivo_p
		where nr_sequencia = nr_seq_agenda_w;
		
		if (ie_cancelar_consulta_p = 'S') then
			select	max(a.nr_seq_agenda_cons),
				max(b.cd_agenda)
			into STRICT	nr_seq_agenda_cons_w,
				cd_agenda_w
			from	agenda_quimio a,
				agenda_consulta b
			where	a.nr_seq_agenda_cons 	= b.nr_sequencia
			and	a.nr_sequencia		= nr_seq_agenda_w;
			
			CALL alterar_status_agenda_cons(
				cd_estabelecimento_p,
				cd_agenda_w,
				nr_seq_agenda_cons_w,
				'C',
				null,
				null,
				'N',
				nm_usuario_p,
				null);
		end if;
		
		select	coalesce(max(nr_seq_pend_Agenda),0)
		into STRICT	nr_seq_pendencia_w
		from	paciente_atendimento
		where	nr_seq_atendimento	= nr_Seq_atendimento_w;
		
		select	coalesce(max(nr_seq_Ageint_item),0)
		into STRICT	nr_seq_ageint_item_w
		from	agenda_quimio
		where	nr_sequencia	= nr_seq_agenda_w;
		
		/*SO-2225714*/

		if (nr_seq_ageint_item_w	> 0) then
			delete	FROM agenda_quimio_marcacao
			where	nr_seq_ageint_item	= nr_seq_ageint_item_w;
		elsif (nr_seq_pendencia_w	> 0) then
			update	qt_pendencia_Agenda
			set	dt_liberacao	 = NULL,
				nm_usuario	= nm_usuario_p,
				dt_Atualizacao	= clock_timestamp()
			where	nr_sequencia	= nr_seq_pendencia_w;
			
			delete	FROM agenda_quimio_marcacao
			where	nr_seq_pend_agenda	= nr_seq_pendencia_w
			and	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_Agenda) = ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_Agenda_w);
			
			delete FROM w_agenda_quimio
			where ie_status = 'AG' 
			and nr_seq_atendimento = nr_Seq_atendimento_w;
		else
			delete  FROM agenda_quimio_marcacao
			where  ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_Agenda) between ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_Agenda_w) and ESTABLISHMENT_TIMEZONE_UTILS.endOfDay(dt_Agenda_w)
			and  nr_seq_agenda    = nr_seq_agenda_w;

			delete  FROM w_agenda_quimio
			where  ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_horario) between ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_Agenda_w) and ESTABLISHMENT_TIMEZONE_UTILS.endOfDay(dt_Agenda_w)
			and  nr_seq_Agequi    = nr_seq_agenda_w;	
		end if;
		end;
	end loop;
	close C01;
		
elsif (ie_Status_agenda_p	= 'F') then
	
	select	max(ie_status_agenda)
	into STRICT	ie_status_agenda_w
	from	agenda_quimio
	where	nr_sequencia = nr_seq_agenda_p;
	
	if (ie_status_agenda_w = 'F') then
		update	agenda_quimio
		set	ie_status_agenda	= 'N',
			dt_falta		 = NULL,
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp(),
			ds_observacao		= ds_observacao_p
		where	nr_sequencia		= nr_seq_agenda_p;
	else
		update	agenda_quimio
		set	ie_status_agenda	= ie_status_agenda_p,
			dt_falta		= clock_timestamp(),
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp(),
			nr_seq_mot_falta	= CASE WHEN nr_seq_motivo_p=0 THEN null  ELSE nr_seq_motivo_p END ,
			ds_observacao		= ds_observacao_p
		where	nr_sequencia		= nr_seq_agenda_p;
	end if;
elsif (ie_status_agenda_p	= 'S') then	
	update	agenda_quimio
	set	ie_status_agenda	= ie_status_agenda_p,
		dt_suspenso		= clock_timestamp(),
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp(),
		nr_seq_mot_falta	= CASE WHEN nr_seq_motivo_p=0 THEN null  ELSE nr_seq_motivo_p END 
	where	nr_sequencia		= nr_seq_agenda_p;

	select	coalesce(max(nr_seq_Ageint_item),0),
		coalesce(max(nr_seq_atendimento),0)
	into STRICT	nr_seq_ageint_item_w,
		nr_seq_atend_w
	from	agenda_quimio
	where	nr_sequencia	= nr_seq_agenda_p;
	
	if (nr_seq_ageint_item_w	> 0) then
		delete	FROM agenda_quimio_marcacao
		where	nr_seq_ageint_item	= nr_seq_ageint_item_w;
	elsif (nr_seq_atend_w > 0) then
		delete	FROM agenda_quimio_marcacao
		where	nr_seq_atendimento	= nr_seq_atend_w;
	end if;	
	
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qt_alterar_status_agenda ( nr_Seq_agenda_p bigint, ie_status_agenda_p text, nm_usuario_p text, ie_cancelar_consulta_p text, nr_seq_motivo_p bigint, ds_motivo_p text, cd_estabelecimento_p bigint, ds_observacao_p text) FROM PUBLIC;

