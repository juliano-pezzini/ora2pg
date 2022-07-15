-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_horario_cig (nr_seq_glicemia_p bigint, nr_seq_cig_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_prescricao_w	bigint;
nr_seq_proced_w	integer;

cd_proced_w		bigint;
ie_origem_w		bigint;
nr_seq_int_w		bigint;
dt_horario_w		timestamp;
nr_seq_hor_w		bigint;
ie_liberado_w		varchar(1);


BEGIN
if (nr_seq_glicemia_p IS NOT NULL AND nr_seq_glicemia_p::text <> '') and (nr_seq_cig_p IS NOT NULL AND nr_seq_cig_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

	/* consistir prescricao */

	/* OS 83818, gerava horário vinculado a prescrição antiga e não mostrava no grid, substituído pelo comando abaixo.
	select	nvl(max(nr_prescricao),0) nr_prescricao,
		nvl(max(nr_seq_procedimento),0) nr_seq_proced
	into	nr_prescricao_w,
		nr_seq_proced_w
	from	atend_glicemia
	where	nr_sequencia = nr_seq_glicemia_p;
	*/
	select	coalesce(max(b.nr_prescricao),0) nr_prescricao,
		coalesce(max(b.nr_seq_procedimento),0) nr_seq_proced
	into STRICT	nr_prescricao_w,
		nr_seq_proced_w
	from	prescr_proc_hor b,
		atendimento_cig a
	where	b.nr_sequencia = a.nr_seq_horario
	and	a.nr_sequencia = nr_seq_cig_p
	and	Obter_se_horario_liberado(b.dt_lib_horario, b.dt_horario) = 'S';

	if (nr_prescricao_w > 0) and (nr_seq_proced_w > 0) then

		/* obter dados prescricao */

		select	cd_procedimento,
			ie_origem_proced,
			nr_seq_proc_interno
		into STRICT	cd_proced_w,
			ie_origem_w,
			nr_seq_int_w
		from	prescr_procedimento
		where	nr_prescricao	= nr_prescricao_w
		and	nr_sequencia	= nr_seq_proced_w;

		/* obter dados cig */

		select	dt_proximo_controle
		into STRICT	dt_horario_w
		from	atendimento_cig
		where	nr_sequencia = nr_seq_cig_p;

		/* Verifica se deve setar a data de liberação ao novo horário gerado - Hudson OS361201 */

		select	coalesce(max('S'),'N')
		into STRICT	ie_liberado_w
		from	prescr_proc_hor
		where	nr_prescricao = nr_prescricao_w
		and	(dt_lib_horario IS NOT NULL AND dt_lib_horario::text <> '');

		/* gerar horario */

		select	nextval('prescr_proc_hor_seq')
		into STRICT	nr_seq_hor_w
		;

		insert into prescr_proc_hor(
						nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_prescricao,
						nr_seq_procedimento,
						cd_procedimento,
						ie_origem_proced,
						nr_seq_proc_interno,
						ds_horario,
						dt_horario,
						nr_ocorrencia,
						ie_urgente,
						dt_fim_horario,
						dt_suspensao,
						ie_horario_especial,
						cd_material_exame,
						nm_usuario_reaprazamento,
						qt_hor_reaprazamento,
						ie_aprazado,
						ie_situacao,
						ie_checagem,
						nm_usuario_checagem,
						ie_dose_especial,
						nm_usuario_dose_esp,
						dt_checagem,
						cd_setor_exec,
						dt_lib_horario
						)
		values (
						nr_seq_hor_w,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						nr_prescricao_w,
						nr_seq_proced_w,
						cd_proced_w,
						ie_origem_w,
						nr_seq_int_w,
						to_char(dt_horario_w,'hh24:mi:ss'),
						to_date(to_char(dt_horario_w,'dd/mm/yyyy hh24:mi') || ':00','dd/mm/yyyy hh24:mi:ss'),
						1,
						'N',
						null,
						null,
						'N',
						null,
						null,
						null,
						'N',
						'A',
						null,
						null,
						null,
						null,
						null,
						null,
						CASE WHEN ie_liberado_w='N' THEN null  ELSE clock_timestamp() END );

		/* atualizar horario x medicao */

		update	atendimento_cig
		set	nr_seq_proc_hor	= nr_seq_hor_w
		where	nr_sequencia		= nr_seq_cig_p;

	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_horario_cig (nr_seq_glicemia_p bigint, nr_seq_cig_p bigint, nm_usuario_p text) FROM PUBLIC;

