-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_ev_lembrete_rec ( nr_prescricao_p bigint, nm_usuario_p text) AS $body$
DECLARE

										
										
										
										
nr_seq_proc_w			bigint;
nr_seq_recomendacao_w	bigint;
nr_seq_evento_w			bigint;	
ie_forma_ev_w			varchar(15);
cd_pessoa_fisica_w		varchar(15);
nr_atendimento_w		bigint;
ds_titulo_w				varchar(255);
ds_mensagem_w			varchar(4000);
nr_seq_ev_pac_w			bigint;
nr_seq_ev_pac_dest_w	bigint;
dt_horario_w			timestamp;
ds_tipo_recomendacao_w	varchar(255);
dt_horario_princ_w		timestamp;		
										
C01 CURSOR FOR
	SELECT	distinct
			a.nr_sequencia,
			b.nr_seq_evento,
			b.ie_forma_ev,
			trim(both b.ds_tipo_recomendacao),
			ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(c.DT_HORARIO) dt_horario
	from	prescr_recomendacao a,
			TIPO_RECOMENDACAO b,
			prescr_rec_hor c
	where	a.nr_prescricao	= nr_prescricao_p
	and		a.CD_RECOMENDACAO	= b.CD_TIPO_RECOMENDACAO
	and		c.nr_prescricao		= a.nr_prescricao
	and		c.NR_SEQ_RECOMENDACAO = a.nr_sequencia
	and		(b.nr_seq_evento IS NOT NULL AND b.nr_seq_evento::text <> '')
	and		(b.ie_forma_ev IS NOT NULL AND b.ie_forma_ev::text <> '')
	and		exists (	SELECT	1
						from	prescr_rec_hor x
						where	x.nr_prescricao	= a.nr_prescricao
						and		x.NR_SEQ_RECOMENDACAO = a.nr_sequencia
						and		(x.dt_horario IS NOT NULL AND x.dt_horario::text <> ''));
						
						
C02 CURSOR FOR
	SELECT	a.DT_HORARIO
	from	prescr_rec_hor a
	where	a.nr_prescricao		= nr_prescricao_p
	and		a.NR_SEQ_RECOMENDACAO	= nr_seq_recomendacao_w
	and		ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(a.dt_horario) = dt_horario_princ_w
	and		(a.dt_horario IS NOT NULL AND a.dt_horario::text <> '');


BEGIN


select	nr_atendimento,
		cd_pessoa_fisica
into STRICT	nr_atendimento_w,
		cd_pessoa_fisica_w
from	prescr_medica
where	nr_prescricao	= nr_prescricao_p;



open C01;
loop
fetch C01 into	
	nr_seq_recomendacao_w,
	nr_seq_evento_w,
	ie_forma_ev_w,
	ds_tipo_recomendacao_w,
	dt_horario_princ_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	
	ds_titulo_w		:= substr(obter_dados_evento_paciente(nr_seq_evento_w,'TI',nr_atendimento_w,cd_pessoa_fisica_w),1,255);
	ds_mensagem_w	:= substr(obter_dados_evento_paciente(nr_seq_evento_w,'ME',nr_atendimento_w,cd_pessoa_fisica_w),1,4000);	
	ds_mensagem_w	:= substr(ds_mensagem_w|| ' ' || obter_desc_expressao(729002) || ' ' || ds_tipo_recomendacao_w,1,4000);
	
	select	nextval('ev_evento_paciente_seq')
	into STRICT	nr_seq_ev_pac_w
	;
	
	insert into ev_evento_paciente(
			 nr_sequencia,
			 nr_seq_evento,
			 dt_atualizacao,
			 nm_usuario,
			 dt_atualizacao_nrec,
			 nm_usuario_nrec,
			 cd_pessoa_fisica,
			 nr_atendimento,
			 ds_titulo,
			 ds_mensagem,
			 ie_status,
			 ds_maquina,
			 dt_evento,
			 dt_liberacao,
			 ie_situacao,
			 nr_repasse_terceiro,
			 cd_perfil_ativo,
			 ie_comunic_pendente)
		values (
			 nr_seq_ev_pac_w,
			 nr_seq_evento_w,
			 clock_timestamp(),
			 nm_usuario_p,
			 clock_timestamp(),
			 nm_usuario_p,
			 cd_pessoa_fisica_w,
			 nr_atendimento_w,
			 ds_titulo_w,
			 ds_mensagem_w,
			 'G',
			 null,
			 clock_timestamp(),
			 null,
			 'A',
			 null,
			 null,
			 null);	
			
			 
	select	nextval('ev_evento_pac_destino_seq')
	into STRICT	nr_seq_ev_pac_dest_w
	;
			
	insert into EV_EVENTO_PAC_DESTINO(
				 NR_SEQUENCIA,
				 NR_SEQ_EV_PAC,
				 DT_ATUALIZACAO,
				 NM_USUARIO,
				 DT_ATUALIZACAO_NREC,
				 NM_USUARIO_NREC,
				 CD_PESSOA_FISICA,
				 IE_FORMA_EV,
				 IE_STATUS,
				 DT_CIENCIA,
				 ID_SMS,
				 IE_STATUS_SMS,
				 NM_USUARIO_DEST,
				 IE_PESSOA_DESTINO,
				 DT_EVENTO,
				 IE_FREQUENCIA,
				 NR_DIAS_INTERVALO)
			values (
				 nr_seq_ev_pac_dest_w,
				 nr_seq_ev_pac_w,
				 clock_timestamp(),
				 nm_usuario_p,
				 clock_timestamp(),
				 nm_usuario_p,
				 null,
				 IE_FORMA_EV_w,
				 'G',
				 null,
				 null,
				 null,
				 null,
				 null,
				 null,
				 'D',
				 null);
			

			 
			 
			 
	open C02;
	loop
	fetch C02 into	
		dt_horario_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		insert into ev_evento_pac_dest_hor(
					 nr_sequencia,
					 nr_seq_ev_pac_dest,
					 dt_atualizacao,
					 nm_usuario,
					 dt_atualizacao_nrec,
					 nm_usuario_nrec,
					 dt_horario,
					 ie_dia_semana)
				values (
					 nextval('ev_evento_pac_dest_hor_seq'),
					 nr_seq_ev_pac_dest_w,
					 clock_timestamp(),
					 nm_usuario_p,
					 clock_timestamp(),
					 nm_usuario_p,
					 dt_horario_w,
					 null);

		end;
	end loop;
	close C02;
			
			 
	CALL liberar_evento_pac(nr_seq_ev_pac_w,null,nm_usuario_p);
	
	
	end;
end loop;
close C01;


if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_ev_lembrete_rec ( nr_prescricao_p bigint, nm_usuario_p text) FROM PUBLIC;

