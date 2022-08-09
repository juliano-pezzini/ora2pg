-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_modelo_transferencia (nr_seq_modelo_dest_p bigint, nr_seq_modelo_origem_p bigint, nr_seq_pac_reab_p text, nm_usuario_p text) AS $body$
DECLARE


C01 CURSOR FOR
	SELECT	nr_sequencia,
		hr_horario,
		cd_agenda,
		cd_profissional_padrao,
		ie_dia_semana
	from	rp_item_modelo_agenda
	where	nr_seq_modelo = nr_seq_modelo_dest_p;

nr_sequencia_pac_modelo_w  	bigint;
nr_sequencia_w			bigint;
nr_seq_item_modelo_w		bigint;
cd_agenda_w			bigint;
hr_horario_w			timestamp;
qt_vagas_w			bigint;
qt_modelo_w			bigint;
cd_medico_exec_w		varchar(10);
ie_dia_semana_w			smallint;
nr_seq_motivo_fim_tratamento_w	bigint;
dt_fim_tratamento_w		timestamp;



BEGIN

select	coalesce(qt_vagas,0)
into STRICT	qt_vagas_w
from	rp_modelo_agendamento
where	nr_sequencia = nr_seq_modelo_dest_p;


select	count(*)
into STRICT	qt_modelo_w
from	rp_pac_modelo_agendamento
where	nr_seq_modelo_agendamento = nr_seq_modelo_dest_p
and	coalesce(ie_situacao,'A') = 'A'
and	coalesce(dt_fim_tratamento::text, '') = '';

if (qt_modelo_w >= qt_vagas_w) then
	--Rase_application_error(-20011,'Não é possível gerar este modelo. Limite de vagas foi excedido!');
	CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(233146);
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
				       ie_situacao)
				values (nr_sequencia_pac_modelo_w,
					clock_timestamp(),
					nr_seq_pac_reab_p,
					nr_seq_modelo_dest_p,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					'A');

	commit;

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

	select	max(nr_seq_motivo_fim_tratamento),
		max(dt_fim_tratamento)
	into STRICT	nr_seq_motivo_fim_tratamento_w,
		dt_fim_tratamento_w
	from	rp_pac_modelo_agend_item
	where	nr_seq_modelo_pac 	= nr_seq_modelo_origem_p
	and	cd_agenda		= cd_agenda_w
	and	dt_horario		= hr_horario_w
	and	ie_dia_semana		= ie_dia_semana_w
	and	((cd_medico_exec		= cd_medico_exec_w) or (coalesce(cd_medico_exec_w::text, '') = ''))
	and	(dt_fim_tratamento IS NOT NULL AND dt_fim_tratamento::text <> '');

	select	nextval('rp_pac_modelo_agend_item_seq')
	into STRICT	nr_sequencia_w
	;

	if (dt_fim_tratamento_w IS NOT NULL AND dt_fim_tratamento_w::text <> '') then

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
						ie_dia_semana,
						dt_fim_tratamento,
						nr_seq_motivo_fim_tratamento)
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
						ie_dia_semana_w,
						dt_fim_tratamento_w,
						nr_seq_motivo_fim_tratamento_w);

	elsif (coalesce(dt_fim_tratamento_w::text, '') = '') then

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
	end if;
	end;
end loop;
close C01;



commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_modelo_transferencia (nr_seq_modelo_dest_p bigint, nr_seq_modelo_origem_p bigint, nr_seq_pac_reab_p text, nm_usuario_p text) FROM PUBLIC;
