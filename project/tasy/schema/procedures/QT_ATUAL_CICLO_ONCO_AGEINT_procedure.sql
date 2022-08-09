-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qt_atual_ciclo_onco_ageint ( nr_seq_paciente_p bigint, nr_seq_atend_inicial_p bigint, dt_prevista_p timestamp, ie_todos_ciclos_p text, nr_seq_motivo_p bigint, ie_atualiza_real_p text, ie_dia_selecionado_p text, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE


nr_ciclo_w			integer;
nr_ciclo_ant_w			integer;
nr_ciclo_atual_w		integer;
dt_prevista_inicial_w		timestamp;
dt_prevista_w			timestamp;
dt_prevista_ant_w		timestamp;
dt_prevista_maior_w		timestamp;          --Ivan em 29/08/2007 OS64993
ds_dia_ciclo_w			varchar(05);
ds_erro_w			varchar(254); --Ivan em 29/08/2007 OS64993
qt_anterior_w			bigint;  --Ivan em 29/08/2007 OS64993
nr_prescricao_w			bigint;
dt_real_w			timestamp;
dt_prevista_ww			timestamp;
ie_dia_util_w			varchar(25);
cd_estabelecimento_w		smallint;
nr_seq_ordem_w			bigint;
ie_alterar_data_prod_w		varchar(10);
qt_reg_w			bigint;
dt_atualizacao_w		timestamp;
qt_nao_util_w			bigint:= 1;
dia_w				bigint;
QT_DIAS_INTERVALO_w		bigint;
qt_dias_interv_total_w		bigint:=0;
ie_utliza_dt_atual_prescr_w	varchar(1);
ie_atualizar_horario_w		varchar(1);
ie_atualiza_dia_atendido_w	varchar(3);
ie_status_paciente_w		varchar(60);
dia_primeiro_ciclo_alterar_w	bigint;
nr_seq_atendimento_w		bigint;
ie_dia_selecionado_w		varchar(10);
nr_seq_pend_agenda_w		bigint;
nr_seq_autorizacao_w		bigint:=0;
cd_protocolo_w			bigint;
nr_seq_medicacao_w		bigint;
nr_seq_autorizacao_ww		bigint:=0;

c01 CURSOR FOR
	SELECT	dt_prevista,
		dt_real,
		ds_dia_ciclo,
		nr_prescricao,
		nr_ciclo,
		substr(Obter_status_Paciente_qt(nr_seq_atendimento,dt_inicio_adm,dt_fim_adm,nr_seq_local,ie_exige_liberacao,dt_chegada,'C'),1,60),
		nr_seq_atendimento
	from 	paciente_atendimento
	where	nr_seq_paciente		= nr_seq_paciente_p
	and (ie_todos_ciclos_p	= 'S' or nr_ciclo = nr_ciclo_w)
	and	trunc(dt_prevista)	>= trunc(dt_prevista_inicial_w)
	and	((ie_dia_selecionado_w	= 'N') or (nr_seq_atendimento	= nr_seq_atend_inicial_p))
	order by nr_ciclo, dt_prevista, ds_dia_ciclo;
	

	
	procedure	ajustar_data_producao(	nr_prescicao_p	bigint,
						dt_producao_p	timestamp) is
	
	C02 CURSOR FOR
	SELECT	b.nr_seq_ordem
	from	can_ordem_item_prescr b,
		prescr_material a
	where	a.nr_prescricao		= nr_prescicao_p
	and	a.nr_prescricao		= b.nr_prescricao
	and	a.nr_sequencia		= b.nr_seq_prescricao;	
	
	
BEGIN
	if (ie_alterar_data_prod_w		= 'S') then
		open C02;
		loop
		fetch C02 into	
			nr_seq_ordem_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			
			update	can_ordem_prod
			set	dt_prevista	= dt_producao_p
			where	nr_sequencia	= nr_seq_ordem_w
			and	coalesce(dt_inicio_preparo::text, '') = '';
			
			end;
		end loop;
		close C02;
	
	end if;
	end;
	

begin
dt_prevista_ant_w	:= null;
dt_atualizacao_w	:= clock_timestamp();
ie_dia_selecionado_w	:= coalesce(ie_dia_selecionado_p,'N');

select	coalesce(max(b.cd_estabelecimento),1),
	max(b.QT_DIAS_INTERVALO)
into STRICT	cd_estabelecimento_w,
	QT_DIAS_INTERVALO_w
from	paciente_setor		b,
	paciente_atendimento	a
where	a.nr_seq_paciente	= b.nr_seq_paciente 
and	a.nr_seq_paciente	= nr_seq_paciente_p;

select	max(nr_ciclo),
	max(dt_prevista)
into STRICT	nr_ciclo_w,
	dt_prevista_inicial_w
from	paciente_atendimento
where	nr_seq_atendimento	= nr_seq_atend_inicial_p
and	coalesce(dt_cancelamento::text, '') = '';

if (coalesce(nr_ciclo_w::text, '') = '') and (coalesce(dt_prevista_inicial_w::text, '') = '') then
	--'Nao foi possivel atualizar o dia ciclo. Verificar se o mesmo esta cancelado!'
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(234478);	
end if;

select	max(dt_prevista)
into STRICT	dt_prevista_maior_w
from	paciente_atendimento
where	nr_seq_paciente		= nr_seq_paciente_p
and	nr_ciclo		= nr_ciclo_w
and	trunc(dt_prevista)	< trunc(dt_prevista_inicial_w)
and	coalesce(dt_cancelamento::text, '') = '';

select 	max(cd_protocolo),
	max(nr_seq_medicacao)
into STRICT	cd_protocolo_w,
	nr_seq_medicacao_w
from	paciente_setor
where	nr_seq_paciente = nr_seq_paciente_p;

ie_alterar_data_prod_w := Obter_param_Usuario(281, 517, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_alterar_data_prod_w);
ie_utliza_dt_atual_prescr_w := Obter_param_Usuario(281, 555, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_utliza_dt_atual_prescr_w);
ie_atualiza_dia_atendido_w := Obter_param_Usuario(281, 675, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_atualiza_dia_atendido_w);
ie_atualizar_horario_w := Obter_param_Usuario(3130, 114, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_atualizar_horario_w);


if (trunc(dt_prevista_p) > trunc(dt_prevista_maior_w)) then
	qt_anterior_w	:= 0;
else	
	select	count(*)
	into STRICT	qt_anterior_w
	from	paciente_atendimento
	where	nr_seq_paciente		= nr_seq_paciente_p
	and	nr_ciclo		= nr_ciclo_w
	and	trunc(dt_prevista)	< trunc(dt_prevista_inicial_w)
	and	coalesce(dt_cancelamento::text, '') = '';
end if;

if (qt_anterior_w > 0) and (dt_prevista_p < dt_prevista_inicial_w) then
	ds_erro_p	:= WHEB_MENSAGEM_PCK.get_texto(279591,null);
else	
	begin
	
	open	c01;
		loop
	fetch	c01 into	
		dt_prevista_w,
		dt_real_w,
		ds_dia_ciclo_w,
		nr_prescricao_w,
		nr_ciclo_atual_w,
		ie_status_paciente_w,
		nr_seq_atendimento_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		if (coalesce(dia_primeiro_ciclo_alterar_w::text, '') = '') then
			dia_primeiro_ciclo_alterar_w	:= somente_numero(coalesce(ds_dia_ciclo_w,1));
		end if;
		
		if (ie_atualiza_dia_atendido_w = 'S') or (ie_status_paciente_w <> '83') then
			
			dia_w		:= somente_numero(ds_dia_ciclo_w) - dia_primeiro_ciclo_alterar_w;
			dt_prevista_ww	:= dt_prevista_p + dia_w;
			
			if (coalesce(nr_ciclo_ant_w,nr_ciclo_atual_w)	<> nr_ciclo_atual_w) then
				qt_dias_interv_total_w := qt_dias_interv_total_w + QT_DIAS_INTERVALO_w;
			end if;
			dt_prevista_ww	:= dt_prevista_ww + qt_dias_interv_total_w;

			select	count(*)
			into STRICT	qt_reg_w
			from	paciente_atendimento
			where	nr_seq_paciente = nr_seq_paciente_p
			and (ie_todos_ciclos_p	= 'S' or nr_ciclo = nr_ciclo_w)
			and	dt_atualizacao		= dt_atualizacao_w
			and	dt_prevista		= dt_prevista_ww
			and	coalesce(dt_suspensao::text, '') = '';
			ie_dia_util_w	:= Obter_Se_Dia_Util_Oncologia(dt_prevista_ww, cd_estabelecimento_w, nm_usuario_p,null,cd_protocolo_w,nr_seq_medicacao_w);
			if (qt_reg_w	>0) then
				ie_dia_util_w	:= 'N';
			end if;
				
			
			while(ie_dia_util_w	= 'N') loop
				begin
				qt_nao_util_w	:= qt_nao_util_w +1;
				dt_prevista_ww	:= dt_prevista_ww + 1;
				ie_dia_util_w	:= Obter_Se_Dia_Util_Oncologia(dt_prevista_ww, cd_estabelecimento_w, nm_usuario_p,null,cd_protocolo_w,nr_seq_medicacao_w);
				
				select	count(*)
				into STRICT	qt_reg_w
				from	paciente_atendimento
				where	nr_seq_paciente = nr_seq_paciente_p
				and (ie_todos_ciclos_p	= 'S' or nr_ciclo = nr_ciclo_w)
				and	dt_atualizacao		= dt_atualizacao_w
				and	dt_prevista		= dt_prevista_ww
				and	coalesce(dt_suspensao::text, '') = '';
				
				if (qt_reg_w	>0) then
					ie_dia_util_w	:= 'N';
				end if;
				end;
			end loop;
					
			if (dt_real_w IS NOT NULL AND dt_real_w::text <> '') then
				begin
				dt_real_w	:= dt_prevista_ww;
				end;
			end if;
			
			if (ie_atualizar_horario_w = 'S') then
				update	paciente_atendimento
				set	--dt_prevista	= decode(ie_atualiza_real_p,'S',dt_prevista,dt_prevista_ww),
					--dt_anterior	= dt_prevista,
					nm_usuario	= nm_usuario_p,
					dt_atualizacao	= dt_atualizacao_w,
					dt_prevista_agenda		= dt_real_w
				where	nr_seq_paciente = nr_seq_paciente_p
				and (ie_todos_ciclos_p	= 'S' or nr_ciclo = nr_ciclo_w)
				and	dt_prevista	= dt_prevista_w
				and	ds_dia_ciclo	= ds_dia_ciclo_w;
				
				update	agenda_quimio
				set	--dt_agenda		= dt_real_w,
					nr_seq_mot_reagendamento= nr_seq_motivo_p,
					nm_usuario		= nm_usuario_p,
					dt_atualizacao		= clock_timestamp(),
					nr_seq_atendimento  = NULL
				where	nr_seq_atendimento	= nr_seq_atendimento_w;
				
				select	max(nr_seq_pend_agenda)
				into STRICT	nr_seq_pend_agenda_w
				from	paciente_atendimento
				where	nr_seq_atendimento 	= nr_seq_atendimento_w;
				
				/*update	agenda_quimio_marcacao
				set	dt_agenda		= dt_real_w
				where	to_date(dt_agenda,'dd/mm/yyyy hh24:mi:ss') = to_date(dt_prevista_w,'dd/mm/yyyy hh24:mi:ss')
				and	nr_seq_pend_agenda	= nr_seq_pend_agenda_w;*/
								
			else
				update	paciente_atendimento
				set	--dt_prevista	= decode(ie_atualiza_real_p,'S',dt_prevista,to_date(to_char(dt_prevista_ww,'dd/mm/yyyy') || ' ' || to_char(dt_prevista,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')),
					--dt_anterior	= dt_prevista,
					nm_usuario	= nm_usuario_p,
					dt_atualizacao	= dt_atualizacao_w,
					dt_prevista_agenda		= dt_real_w,
					nr_seq_atendimento  = NULL
				where	nr_seq_paciente = nr_seq_paciente_p
				and (ie_todos_ciclos_p	= 'S' or nr_ciclo = nr_ciclo_w)
				and	dt_prevista	= dt_prevista_w
				and	ds_dia_ciclo	= ds_dia_ciclo_w;			
				
				update	agenda_quimio
				set	--dt_agenda		= dt_real_w,
					nr_seq_mot_reagendamento= nr_seq_motivo_p,
					nm_usuario		= nm_usuario_p,
					dt_atualizacao		= clock_timestamp()
				where	nr_seq_atendimento	= nr_seq_atendimento_w;
				
				select	max(nr_seq_pend_agenda)
				into STRICT	nr_seq_pend_agenda_w
				from	paciente_atendimento
				where	nr_seq_atendimento 	= nr_seq_atendimento_w;
				
				/*update	agenda_quimio_marcacao
				set	dt_agenda		= dt_real_w
				where	to_date(dt_agenda,'dd/mm/yyyy hh24:mi:ss') = to_date(dt_prevista_w,'dd/mm/yyyy hh24:mi:ss')
				and	nr_seq_pend_agenda	= nr_seq_pend_agenda_w;*/
			
			end if;
			
			if (trunc(dt_prevista_w)	<> trunc(dt_prevista_ww)) then
				select	max(nr_seq_atendimento)
				into STRICT	nr_seq_atendimento_w
				from	paciente_atendimento
				where	coalesce(dt_prevista_agenda, dt_prevista)	= dt_prevista_ww
				and	ds_dia_ciclo	= ds_dia_ciclo_w
				and	nr_seq_paciente = nr_seq_paciente_p;
				if (nr_seq_atendimento_w	> 0) then
					CALL Cancelar_Dia_Quimio(nr_seq_atendimento_w, null, nm_usuario_p, cd_estabelecimento_w);			
				end if;
			end if;
			
			if (nr_prescricao_w > 0) and (ie_utliza_dt_atual_prescr_w = 'N') then
				begin
				update	prescr_medica
				set	dt_prescricao	= dt_prevista_ww
				where	nr_prescricao	= nr_prescricao_w
				and	coalesce(dt_liberacao::text, '') = '';
				
				ajustar_data_producao(nr_prescricao_w,dt_prevista_ww);
				end;
			end if;
			
			begin
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_autorizacao_w
			from	autorizacao_convenio
			where	nr_seq_paciente_setor = nr_seq_paciente_p
			and	nr_ciclo = nr_ciclo_w;
			exception
			when others then
				nr_seq_autorizacao_w := 0;
			end;
			
			if (nr_seq_autorizacao_w > 0) and (nr_seq_autorizacao_ww <> nr_seq_autorizacao_w) then
				begin
				/* Ronaldo OS 339546   */

				update	autorizacao_convenio
				set	dt_entrada_prevista = dt_prevista_ww
				where	nr_sequencia = nr_seq_autorizacao_w;

				nr_seq_autorizacao_ww := nr_seq_autorizacao_w;
				
				begin
				insert into autorizacao_convenio_hist(nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						ds_historico,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_sequencia_autor)
					values (nextval('autorizacao_convenio_hist_seq'),
						clock_timestamp(),
						nm_usuario_p,
						WHEB_MENSAGEM_PCK.get_texto(279592,'DT_PREVISTA='|| dt_prevista_w||';DT_PREVISTA_W='|| dt_prevista_ww),
						clock_timestamp(),
						nm_usuario_p,
						nr_seq_autorizacao_w);
				exception
				when others then
					null;
				end;
				end;
			end if;
			
		end if;

		dt_prevista_ant_w	:= dt_prevista_w;
		nr_ciclo_ant_w		:= nr_ciclo_atual_w;
		end;
	end loop;
	close c01;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qt_atual_ciclo_onco_ageint ( nr_seq_paciente_p bigint, nr_seq_atend_inicial_p bigint, dt_prevista_p timestamp, ie_todos_ciclos_p text, nr_seq_motivo_p bigint, ie_atualiza_real_p text, ie_dia_selecionado_p text, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;
