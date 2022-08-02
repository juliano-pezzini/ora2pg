-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_liberar_exame_prescricao ( nr_prescricao_p bigint, nr_seq_procedimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_horario_w				bigint;
ie_atualiza_hor_hemoterap_w		varchar(1);


BEGIN

ie_atualiza_hor_hemoterap_w := obter_param_usuario(1113, 597, Obter_perfil_Ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_atualiza_hor_hemoterap_w);

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_procedimento_p IS NOT NULL AND nr_seq_procedimento_p::text <> '') then

	update	prescr_procedimento
	set	dt_liberacao_hemoterapia = clock_timestamp(),
		nm_usuario_lib_hemoterapia = nm_usuario_p
	where	nr_prescricao = nr_prescricao_p
	and	nr_sequencia = nr_seq_procedimento_p;

	if (ie_atualiza_hor_hemoterap_w = 'S') then
		select	max(b.nr_sequencia)
		into STRICT	nr_seq_horario_w
		from	prescr_procedimento a,
		 		prescr_proc_hor b
		where	a.nr_prescricao = b.nr_prescricao
		and		a.nr_sequencia = b.nr_seq_procedimento
		and		a.nr_prescricao = nr_prescricao_p
		and		a.nr_sequencia = nr_seq_procedimento_p
		and		a.ie_tipo_proced = 'BSST';

		if (nr_seq_horario_w IS NOT NULL AND nr_seq_horario_w::text <> '') then

			update	prescr_proc_hor
			set		dt_horario = clock_timestamp()
			where	nr_sequencia = nr_seq_horario_w;

			update	prescr_procedimento
			set		dt_prev_execucao = clock_timestamp(),
					dt_status = clock_timestamp()
			where	nr_prescricao = nr_prescricao_p
			and		nr_sequencia = nr_seq_procedimento_p;

		end if;

	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_liberar_exame_prescricao ( nr_prescricao_p bigint, nr_seq_procedimento_p bigint, nm_usuario_p text) FROM PUBLIC;

