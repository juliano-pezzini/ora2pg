-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_modelo_agendamento (nr_seq_modelo_p text, nr_seq_pac_reab_p text, nm_usuario_p text, dt_inicio_agenda_p timestamp, cd_convenio_p text, cd_plano_p text, cd_tipo_acomodacao_p bigint, cd_categoria_p text, nr_seq_tratamento_p bigint) AS $body$
DECLARE


C01 CURSOR FOR
	SELECT	nr_sequencia,
		hr_horario,
		cd_agenda,
		cd_profissional_padrao,
		ie_dia_semana
	from	rp_item_modelo_agenda
	where	nr_seq_modelo = nr_seq_modelo_p;
	
c_rp_procedimentos CURSOR FOR
	SELECT procedimentos.*
    from RP_MODELO_AGENDAMENTO modelo
    join RP_ITEM_MODELO_AGENDA item_modelo on item_modelo.NR_SEQ_MODELO = modelo.nr_sequencia
    join RP_PAC_AGEND_PROCEDIMENTOS procedimentos on procedimentos.NR_SEQ_ITEM_MOD_AGENDA = item_modelo.nr_sequencia
    where modelo.nr_sequencia = nr_seq_modelo_p;


nr_sequencia_pac_modelo_w  	bigint;
nr_sequencia_w			bigint;
nr_seq_item_modelo_w		bigint;
cd_agenda_w			bigint;
hr_horario_w			timestamp;
qt_vagas_w			bigint;
qt_modelo_w			bigint;
cd_medico_exec_w		varchar(10);
ie_dia_semana_w			smallint;
nr_seq_agenda_procedimentos_w RP_PAC_AGEND_PROCEDIMENTOS.nr_sequencia%type;

BEGIN

	select	coalesce(qt_vagas,0)
	into STRICT	qt_vagas_w
	from	rp_modelo_agendamento
	where	nr_sequencia = nr_seq_modelo_p;

	select	count(*)
	into STRICT	qt_modelo_w
	from	rp_pac_modelo_agendamento
	where	nr_seq_modelo_agendamento = nr_seq_modelo_p
	and	coalesce(ie_situacao,'A') = 'A'
	and	coalesce(dt_fim_tratamento::text, '') = '';

	if (qt_modelo_w >= qt_vagas_w) then	
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(203911);
	end if;

	select	nextval('rp_pac_modelo_agendamento_seq')
	into STRICT	nr_sequencia_pac_modelo_w
	;

	insert into rp_pac_modelo_agendamento( nr_sequencia,
						   dt_inicio_modelo,
						   nr_seq_pac_reab,
						   nr_seq_modelo_agendamento,
						   dt_atualizacao,
						   nm_usuario,
						   dt_atualizacao_nrec,
						   nm_usuario_nrec,
						   ie_situacao,
						   dt_inicio_agendamento,
						   cd_convenio,
						   cd_categoria,
						   cd_plano,
						   cd_tipo_acomodacao,
						   nr_seq_tratamento)
					values (nr_sequencia_pac_modelo_w,
						clock_timestamp(),
						nr_seq_pac_reab_p,
						nr_seq_modelo_p,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						'A',
						dt_inicio_agenda_p,
						cd_convenio_p,
						cd_categoria_p,
						cd_plano_p,
						cd_tipo_acomodacao_p,
						nr_seq_tratamento_p);
	
	open C01;
		loop
			fetch C01 into
				nr_seq_item_modelo_w,
				hr_horario_w,
				cd_agenda_w,
				cd_medico_exec_w,
				ie_dia_semana_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin
					
					CALL rp_consistir_hr_modelo(hr_horario_w,nr_seq_pac_reab_p,nr_seq_modelo_p,ie_dia_semana_w, 'IM',nm_usuario_p);
					
					select	nextval('rp_pac_modelo_agend_item_seq')
					into STRICT	nr_sequencia_w
					;
					
					insert into rp_pac_modelo_agend_item( nr_sequencia,
										  nr_seq_modelo_pac,
										  nr_seq_item_modelo,
										  dt_horario,
										  cd_agenda,
										  dt_atualizacao,
										  nm_usuario,
										  dt_atualizacao_nrec,
										  nm_usuario_nrec,
										  cd_medico_exec,
										  ie_dia_semana)
									  values (nr_sequencia_w,
										  nr_sequencia_pac_modelo_w,
										  nr_seq_item_modelo_w,
										  hr_horario_w,
										  cd_agenda_w,
										  clock_timestamp(),
										  nm_usuario_p,
										  clock_timestamp(),
										  nm_usuario_p,
										  cd_medico_exec_w,
										  ie_dia_semana_w);
				end;

			for c_rp_procedimentos_w in c_rp_procedimentos loop
				select nextval('rp_pac_agend_procedimentos_seq')
				into STRICT nr_seq_agenda_procedimentos_w
				;
		
				insert into RP_PAC_AGEND_PROCEDIMENTOS(
					NR_SEQUENCIA,
					DT_ATUALIZACAO,
					NM_USUARIO,
					DT_ATUALIZACAO_NREC,
					NM_USUARIO_NREC,
					NR_SEQ_PROC_INTERNO,
					NR_SEQ_PAC_MOD_AGEND_ITEM,
					NR_SEQ_ITEM_MOD_AGENDA,
					NR_SEQ_PAC_AGEND_INDIVIDUAL,
					CD_PROCEDIMENTO,
					IE_ORIGEM_PROCED
				) values (
					nr_seq_agenda_procedimentos_w,
					clock_timestamp(),
					wheb_usuario_pck.get_nm_usuario,
					clock_timestamp(),
					wheb_usuario_pck.get_nm_usuario,
					c_rp_procedimentos_w.NR_SEQ_PROC_INTERNO,
					nr_sequencia_w,
					c_rp_procedimentos_w.NR_SEQ_ITEM_MOD_AGENDA,
					c_rp_procedimentos_w.NR_SEQ_PAC_AGEND_INDIVIDUAL,
					c_rp_procedimentos_w.CD_PROCEDIMENTO,
					c_rp_procedimentos_w.IE_ORIGEM_PROCED
				);
			end loop;
		end loop;
		
	close C01;

		
	commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_modelo_agendamento (nr_seq_modelo_p text, nr_seq_pac_reab_p text, nm_usuario_p text, dt_inicio_agenda_p timestamp, cd_convenio_p text, cd_plano_p text, cd_tipo_acomodacao_p bigint, cd_categoria_p text, nr_seq_tratamento_p bigint) FROM PUBLIC;

