-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rxt_alterar_status_agenda (nr_seq_agenda_p bigint, ie_status_p text, nm_usuario_p text) AS $body$
DECLARE


ie_status_w	varchar(3);
dt_confirmacao_w	timestamp;
nr_seq_equip_w	bigint;
dt_agenda_w	timestamp;
qt_hor_cancel_w	bigint;
nr_atendimento_w	bigint;
integracao_tasy_w varchar(1) := 'N';
retorno_integracao_w	text;

procedure enviar_adt_a10 is
  n RECORD;

BEGIN
    integracao_tasy_w := obter_param_usuario(9041, 10, wheb_usuario_pck.get_cd_perfil, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, integracao_tasy_w);

    if (integracao_tasy_w = 'S') then
        for n in (SELECT c.nr_sequencia nr_seq_tumor_w
                    from rxt_agenda a, rxt_tratamento b, rxt_tumor c
                   where a.nr_seq_tratamento = b.nr_sequencia
                     and b.nr_seq_tumor = c.nr_sequencia
                     and a.nr_sequencia = nr_seq_agenda_p  LIMIT 1) loop
            retorno_integracao_w := BIFROST.SEND_INTEGRATION_CONTENT('VARIAN_registerPatientArrival',
              obter_adt_a10_varian(n.nr_seq_tumor_w),
              OBTER_USUARIO_ATIVO);
        end loop;
    end if;
end;

begin

if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') and (ie_status_p IS NOT NULL AND ie_status_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin

	select	coalesce(max(ie_status_agenda),ie_status_p),
		max(dt_confirmacao),
		max(nr_seq_equipamento),
		max(dt_agenda)
	into STRICT	ie_status_w,
		dt_confirmacao_w,
		nr_seq_equip_w,
		dt_agenda_w
	from	rxt_agenda
	where	nr_sequencia = nr_seq_agenda_p;

	if (ie_status_p = 'C') then
		/*
		update	rxt_agenda
		set	ie_status_agenda	= decode(ie_status_w, 'C', 'M', ie_status_p),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_seq_agenda_p;	
		*/
		
		
		if (ie_status_w in ('M','P','V')) then /* Jerusa OS 120512 - Inclui o status = 'P', pois quando a procedure: RXT_GERAR_PLANEJAMENTO e executado ao gerar agenda do tratamento, o status e 'P' de planejamento, assim nunca entrava nesta rotina quando cancelavamos os dias agendados*/
			select	coalesce(max(PKG_DATE_UTILS.extract_field('SECOND', dt_agenda)),0)+1
			into STRICT	qt_hor_cancel_w
			from	rxt_agenda
			where	nr_seq_equipamento = nr_seq_equip_w
			and	to_date(to_char(dt_agenda,'dd/mm/yyyy hh24:mi') || ':00', 'dd/mm/yyyy hh24:mi:ss') = to_date(to_char(dt_agenda_w,'dd/mm/yyyy hh24:mi') || ':00', 'dd/mm/yyyy hh24:mi:ss')
			and	ie_status_agenda = 'C';		
		
			update	rxt_agenda
			set	ie_status_agenda	= 'C',
				dt_agenda		= dt_agenda + qt_hor_cancel_w / 86400,
				nm_usuario		= nm_usuario_p,
				dt_cancelamento		= clock_timestamp(),
				nm_usuario_cancel	= nm_usuario_p
			where	nr_sequencia		= nr_seq_agenda_p;			
		elsif (ie_status_w = 'C') then
			update	rxt_agenda
			set	ie_status_agenda	= 'M',
				dt_agenda		= PKG_DATE_UTILS.start_of(dt_agenda, 'mi', 0),
				nm_usuario		= nm_usuario_p,
				dt_cancelamento		 = NULL,
				nm_usuario_cancel	 = NULL
			where	nr_sequencia		= nr_seq_agenda_p;					
		end if;
	elsif (ie_status_p = 'F') then
		update	rxt_agenda
		set	ie_status_agenda	= CASE WHEN ie_status_w='F' THEN  'M'  ELSE ie_status_p END ,
			nm_usuario	= nm_usuario_p,
			nr_seq_motivo_falta	= CASE WHEN ie_status_w='M' THEN  nr_seq_motivo_falta  ELSE null END
		where	nr_sequencia	= nr_seq_agenda_p;
	elsif (ie_status_p = 'M') then
		update	rxt_agenda
		set	ie_status_agenda	= ie_status_p,
			nm_usuario		= nm_usuario_p
		where	nr_sequencia		= nr_seq_agenda_p;		
	elsif (ie_status_p = 'H') then
		update	rxt_agenda
		set	ie_status_agenda	= ie_status_p,
			nm_usuario		= nm_usuario_p
		where	nr_sequencia		= nr_seq_agenda_p;		
	elsif (ie_status_p = 'V') then
		begin
		if (ie_status_w = 'V') then
			update	rxt_agenda
			set	ie_status_agenda	= 'M',
				nm_usuario		= nm_usuario_p,
				dt_confirmacao		 = NULL,
				nm_usuario_confirmacao	 = NULL
			where	nr_sequencia		= nr_seq_agenda_p;
		else
			update	rxt_agenda
			set	ie_status_agenda		= ie_status_p,
				nm_usuario		= nm_usuario_p,
				dt_confirmacao		= clock_timestamp(),
				nm_usuario_confirmacao	= nm_usuario_p
			where	nr_sequencia		= nr_seq_agenda_p;
		end if;
		end;
	elsif (ie_status_p = 'A') then
		begin
		if (ie_status_w = 'A') then
			update	rxt_agenda
			set	ie_status_agenda		= CASE WHEN dt_confirmacao_w = NULL THEN  'M'  ELSE 'V' END ,
				nm_usuario		= nm_usuario_p,
				dt_chegada		 = NULL,
				nm_usuario_chegada	 = NULL
			where	nr_sequencia		= nr_seq_agenda_p;
		else
			update	rxt_agenda
			set	ie_status_agenda		= ie_status_p,
				nm_usuario		= nm_usuario_p,
				dt_chegada		= clock_timestamp(),
				nm_usuario_chegada	= nm_usuario_p
			where	nr_sequencia		= nr_seq_agenda_p;
			
			select 	max(nr_atendimento)
			into STRICT	nr_atendimento_w
			from 	rxt_agenda
			where 	nr_sequencia = nr_seq_agenda_p;
		
			if (coalesce(nr_atendimento_w,0) > 0) then
				CALL gerar_lancamento_automatico(nr_atendimento_w, null, 353, nm_usuario_p, null, null, null, null, null, null);
			end if;	
		end if;
		end;
	elsif (ie_status_p = 'T') then
		begin
		if (ie_status_w = 'T') then
			update	rxt_agenda
			set	ie_status_agenda		= 'A',
				nm_usuario		= nm_usuario_p,
				dt_tratamento		 = NULL,
				nm_usuario_tratamento	 = NULL
			where	nr_sequencia		= nr_seq_agenda_p;
		else
			update	rxt_agenda
			set	ie_status_agenda		= ie_status_p,
				nm_usuario		= nm_usuario_p,
				dt_tratamento		= clock_timestamp(),
				nm_usuario_tratamento	= nm_usuario_p
			where	nr_sequencia		= nr_seq_agenda_p;
		end if;
		end;
	elsif (ie_status_p = 'E') then
		begin

		if (ie_status_w = 'E') then
			update	rxt_agenda
			set	ie_status_agenda		= 'T',
				nm_usuario		= nm_usuario_p,
				dt_execucao		 = NULL,
				nm_usuario_execucao	 = NULL
			where	nr_sequencia		= nr_seq_agenda_p;
		else
			update	rxt_agenda
			set	ie_status_agenda		= ie_status_p,
				nm_usuario		= nm_usuario_p,
				dt_execucao		= clock_timestamp(),
				nm_usuario_execucao	= nm_usuario_p
			where	nr_sequencia		= nr_seq_agenda_p;
		end if;

		end;
	elsif (ie_status_p = 'AP') then
		update	rxt_agenda
		set	ie_status_agenda	= ie_status_p,
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_seq_agenda_p;
	elsif (ie_status_p = 'S') then
		begin
		if (ie_status_w = 'S') then
			update	rxt_agenda
			set	ie_status_agenda	= 'A',
				nm_usuario		= nm_usuario_p,
				dt_simulacao		 = NULL,
				nm_usuario_simulacao	 = NULL
			where	nr_sequencia		= nr_seq_agenda_p;
		else
			update	rxt_agenda
			set	ie_status_agenda	= ie_status_p,
				nm_usuario		= nm_usuario_p,
				dt_simulacao		= clock_timestamp(),
				nm_usuario_simulacao	= nm_usuario_p
			where	nr_sequencia		= nr_seq_agenda_p;
		end if;
		end;
	elsif (ie_status_p = 'SE') then
		begin
		if (ie_status_w = 'SE') then
			update	rxt_agenda
			set	ie_status_agenda		= 'S',
				nm_usuario			= nm_usuario_p,
				dt_exec_simulacao		 = NULL,
				nm_usuario_exec_simulacao	 = NULL
			where	nr_sequencia			= nr_seq_agenda_p;
		else
			update	rxt_agenda
			set	ie_status_agenda		= ie_status_p,
				nm_usuario			= nm_usuario_p,
				dt_exec_simulacao		= clock_timestamp(),
				nm_usuario_exec_simulacao	= nm_usuario_p
			where	nr_sequencia			= nr_seq_agenda_p;
			
			CALL Rxt_Gerar_Proced_Fat(nr_seq_Agenda_p, null, 'S', nm_usuario_p);
		end if;
		end;
	end if;
	end;

  if (ie_status_w = 'M' and ie_status_p = 'A') then
    enviar_adt_a10;
  end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rxt_alterar_status_agenda (nr_seq_agenda_p bigint, ie_status_p text, nm_usuario_p text) FROM PUBLIC;

