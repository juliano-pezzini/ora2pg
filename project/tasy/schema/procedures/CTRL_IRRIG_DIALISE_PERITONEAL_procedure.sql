-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctrl_irrig_dialise_peritoneal (nr_prescricao_p bigint, nr_seq_solucao_p bigint, ie_controle_p text, dt_controle_p timestamp, qt_volume_p bigint, nm_usuario_p text, cd_perfil_p bigint) AS $body$
DECLARE

nr_seq_evento_w		bigint;
nr_etapa_evento_w	smallint;
ie_etapa_susp_w		hd_prescricao_evento.ie_evento_valido%type := 'N';
nr_seq_horario_w	bigint;
ie_gera_ciclo_w		varchar(1);
dt_horario_w		timestamp;
dt_prox_horario_w	prescr_mat_hor.dt_horario%type;
dt_evento_w		timestamp;
ie_gerar_evolucao_emar_w varchar(1);
nr_atendimento_w bigint;
cd_evolucao_w bigint;
nr_seq_mat_compl_w      prescr_mat_hor_compl.nr_sequencia%type;
nr_seq_item_cpoe_w			cpoe_dialise.nr_sequencia%type;
ie_param716_w       varchar(1);

C01 CURSOR FOR /*Terminar os horarios da solucao que ja foram iniciados*/
SELECT	nr_sequencia
from	prescr_mat_hor
where	coalesce(ie_horario_especial,'N') = 'N'
and		coalesce(dt_suspensao::text, '') = ''
and		(dt_inicio_horario IS NOT NULL AND dt_inicio_horario::text <> '')
and		coalesce(dt_fim_horario::text, '') = ''
and		nr_seq_solucao	= nr_seq_solucao_p
and		nr_prescricao 	= nr_prescricao_p;


BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_solucao_p IS NOT NULL AND nr_seq_solucao_p::text <> '') and (ie_controle_p IS NOT NULL AND ie_controle_p::text <> '') and (dt_controle_p IS NOT NULL AND dt_controle_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

	ie_gera_ciclo_w := obter_param_usuario(1113, 465, Obter_perfil_Ativo, nm_usuario_p, obter_estabelecimento_ativo, ie_gera_ciclo_w);
    ie_param716_w := obter_param_usuario(1113, 716, Obter_perfil_Ativo, nm_usuario_p, obter_estabelecimento_ativo, ie_param716_w);

	update	prescr_solucao
	set		ie_status		= ie_controle_p,
			dt_status 		= dt_controle_p
	where	nr_seq_solucao 	= nr_seq_solucao_p
	and		nr_prescricao 	= nr_prescricao_p;

  select	coalesce(max('S'),'N')
  into STRICT	ie_etapa_susp_w
  from	hd_prescricao_evento
  where	nr_prescricao	= nr_prescricao_p
  and	nr_seq_solucao	= nr_seq_solucao_p
  and	ie_evento	= 'SE';

	if (ie_gera_ciclo_w <> 'I' or (ie_etapa_susp_w = 'S' and ie_controle_p = 'II')) then
		nr_etapa_evento_w := substr(obter_etapa_atual_HM(nr_prescricao_p, nr_seq_solucao_p), 1, 10);
    if (ie_etapa_susp_w = 'S' and ie_controle_p = 'II')  then
      nr_etapa_evento_w := nr_etapa_evento_w + 1;
    end if;
	else
		select	coalesce(max(a.nr_etapa_evento) + 1, 1) nr_seq_etapa
		into STRICT	nr_etapa_evento_w
		from	hd_prescricao_evento a
		where	a.ie_evento in (ie_controle_p, 'SE')
		and		a.nr_prescricao = nr_prescricao_p
		and		a.nr_seq_solucao = nr_seq_solucao_p
		and	    coalesce(a.ie_evento_valido, 'S') = 'S';
	end if;

	if (ie_controle_p = 'II') then

		select	min(dt_horario)
		into STRICT	dt_horario_w
		from	prescr_mat_hor
		where	coalesce(ie_horario_especial,'N') = 'N'
		and		coalesce(dt_suspensao::text, '') = ''
		and		((coalesce(dt_fim_horario::text, '') = '') or (coalesce(dt_inicio_horario::text, '') = ''))
		and		nr_seq_solucao	= nr_seq_solucao_p
		and		nr_prescricao 	= nr_prescricao_p;

		update	prescr_mat_hor
		set		dt_inicio_horario 		= clock_timestamp(),
				dt_primeira_checagem	 = NULL,
				nm_usuario				= nm_usuario_p
		where	coalesce(ie_horario_especial,'N') = 'N'
		--and		dt_inicio_horario is null
		and		coalesce(dt_suspensao::text, '') = ''
		and		coalesce(dt_fim_horario::text, '') = ''
		and		dt_horario		= dt_horario_w
		and		nr_seq_solucao	= nr_seq_solucao_p
		and		nr_prescricao 	= nr_prescricao_p;

	elsif (ie_controle_p = 'IT')	then
        begin
            select max(dt_evento)
            into STRICT dt_evento_w
                from hd_prescricao_evento
                where nr_prescricao = nr_prescricao_p 
                    and coalesce(IE_EVENTO_VALIDO,'S') = 'S' 
                    and coalesce(IE_EVENTO,'R') = 'II'
                    and NR_ETAPA_EVENTO = nr_etapa_evento_w;

             if (dt_controle_p < dt_evento_w) then
                CALL Wheb_mensagem_pck.exibir_mensagem_abort(1119818);
                return;
             end if;
         end;

		open C01;
		loop
		fetch C01 into	
			nr_seq_horario_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */

		if (obter_se_fim_ctrl_irrig_dp(nr_prescricao_p,nr_seq_solucao_p, nm_usuario_p, cd_perfil_p) = 'N') then
			update	prescr_mat_hor
			set		dt_fim_horario 	= clock_timestamp(),
					dt_interrupcao	= clock_timestamp(),
					nm_usuario	= nm_usuario_p
			where	nr_sequencia	= nr_seq_horario_w;
		end if;

			select	max(dt_horario)
			into STRICT	dt_horario_w
			from	prescr_mat_hor
			where	nr_sequencia = nr_seq_horario_w;

		end loop;
		close C01;	
	end if;

	if (ie_controle_p = 'II') and (ie_gera_ciclo_w <> 'I') then
		nr_etapa_evento_w := nr_etapa_evento_w + 1;
	end if;

	begin
	select	nextval('hd_prescricao_evento_seq')
	into STRICT	nr_seq_evento_w
	;	

	insert into hd_prescricao_evento(
		nr_sequencia,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		dt_atualizacao,
		nm_usuario,
		nr_prescricao,
		nr_seq_solucao,
		nr_etapa_evento,
		ie_evento,
		dt_evento,
		cd_pessoa_evento,
		qt_volume,
		qt_vol_drenagem)
	values (
		nr_seq_evento_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_prescricao_p,
		nr_seq_solucao_p,
		nr_etapa_evento_w,
		ie_controle_p,
		dt_controle_p,
		substr(obter_dados_usuario_opcao(nm_usuario_p,'C'),1,10),
		CASE WHEN ie_controle_p='IT' THEN qt_volume_p  ELSE null END ,
		CASE WHEN ie_controle_p='DT' THEN qt_volume_p  ELSE null END );
	exception when others then
		-- Ocorreu um problema na geracao do evento, verifique se o volume informado esta correto!
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(208332);
	end;

	if (ie_controle_p = 'II') then

	commit;	
	end if;
	if (obter_se_fim_ctrl_irrig_dp(nr_prescricao_p,nr_seq_solucao_p, nm_usuario_p, cd_perfil_p) = 'S') and (ie_controle_p in ('IT', 'DT')) then
		CALL encerrar_ctrl_irrig_dp(nr_prescricao_p, nr_seq_solucao_p, dt_controle_p, nm_usuario_p);
	end if;

	if (ie_controle_p = 'DT') and (ie_gera_ciclo_w = 'I') then

		select	max(a.dt_horario)
		into STRICT	dt_prox_horario_w
		from	prescr_mat_hor a
		where	a.nr_prescricao = nr_prescricao_p
		and		a.nr_seq_solucao = nr_seq_solucao_p
		and		a.nr_etapa_sol = (nr_etapa_evento_w + 1);

		if (dt_prox_horario_w IS NOT NULL AND dt_prox_horario_w::text <> '') then
			update	prescr_solucao
			set		ie_status		= ie_controle_p,
					dt_status 		= dt_prox_horario_w
			where	nr_seq_solucao 	= nr_seq_solucao_p
			and		nr_prescricao 	= nr_prescricao_p;
		end if;
	end if;
end if;

ie_gerar_evolucao_emar_w := obter_param_usuario(1113, 727, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, coalesce(wheb_usuario_pck.get_cd_estabelecimento, 1), ie_gerar_evolucao_emar_w);
if (ie_gerar_evolucao_emar_w = 'S' and ie_controle_p in ('II', 'IT')) then
	select	max(b.nr_atendimento)
	into STRICT nr_atendimento_w
from	atendimento_paciente 	a,
		prescr_medica 			b
where	a.nr_atendimento	= b.nr_atendimento
and		b.nr_prescricao		= nr_prescricao_p;
	cd_evolucao_w := clinical_notes_pck.gerar_soap(nr_atendimento_w, nr_seq_evento_w, 'CPOE_ITEMS', 6, 'P', 2, cd_evolucao_w);
	if (cd_evolucao_w IS NOT NULL AND cd_evolucao_w::text <> '') then
		select	nextval('prescr_mat_hor_compl_seq')
        into STRICT    nr_seq_mat_compl_w
;
		insert into prescr_mat_hor_compl(
            nr_sequencia,
            dt_atualizacao,
            nm_usuario,
            dt_atualizacao_nrec,
            nm_usuario_nrec,
			cd_evolucao
        ) values (
            nr_seq_mat_compl_w,
            clock_timestamp(),
            nm_usuario_p,
            clock_timestamp(),
            nm_usuario_p,
            cd_evolucao_w
        );
		update prescr_mat_hor
		set nr_seq_mat_compl = nr_seq_mat_compl_w
		where nr_seq_solucao	= nr_seq_solucao_p
		and	nr_prescricao	= nr_prescricao_p;
	end if;
end if;

    if (ie_param716_w <> 'N') then
        select nr_seq_dialise_cpoe
        into STRICT nr_seq_item_cpoe_w
        from prescr_solucao 
        where nr_prescricao = nr_prescricao_p
            and nr_seq_solucao = nr_seq_solucao_p;
        CALL generate_nurse_ack('N', 'DI', nr_atendimento_w, nr_seq_item_cpoe_w, null);
    end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctrl_irrig_dialise_peritoneal (nr_prescricao_p bigint, nr_seq_solucao_p bigint, ie_controle_p text, dt_controle_p timestamp, qt_volume_p bigint, nm_usuario_p text, cd_perfil_p bigint) FROM PUBLIC;
