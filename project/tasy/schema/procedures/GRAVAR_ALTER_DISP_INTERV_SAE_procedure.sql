-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_alter_disp_interv_sae ( nr_atendimento_p bigint, nr_seq_prescr_p bigint, nr_seq_proc_p bigint, nr_seq_dispositivo_p bigint, nr_seq_disp_atend_p bigint, ie_gerar_p text, dt_prevista_p text) AS $body$
DECLARE


ds_justificativa_w			varchar(255);
nm_usuario_w				varchar(15);
qt_reg_w					bigint;
ds_justif_incons_quimio_w	varchar(255);
qt_dose_prescricao_w		double precision;
dt_prevista_w				timestamp;


BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nr_seq_prescr_p IS NOT NULL AND nr_seq_prescr_p::text <> '') and (nr_seq_proc_p IS NOT NULL AND nr_seq_proc_p::text <> '') and (ie_gerar_p IS NOT NULL AND ie_gerar_p::text <> '') and (nr_seq_dispositivo_p IS NOT NULL AND nr_seq_dispositivo_p::text <> '') and (nr_seq_disp_atend_p IS NOT NULL AND nr_seq_disp_atend_p::text <> '')then

	if (dt_prevista_p IS NOT NULL AND dt_prevista_p::text <> '') then

	dt_prevista_w := to_date(dt_prevista_p,'hh24:mi');

	end if;

	nm_usuario_w := wheb_usuario_pck.get_nm_usuario;

	Select  count(*)
	into STRICT	qt_reg_w
	from	dispositivo_interv_sae_alt
	where	nr_atendimento = nr_atendimento_p
	and		nr_seq_prescr = nr_seq_prescr_p
	and		nr_seq_proc = nr_seq_proc_p
	and		nr_seq_dispositivo = nr_seq_dispositivo_p
	and		nr_seq_disp_atend = nr_seq_disp_atend_p;

	if ( qt_reg_w = 0) then

		insert into dispositivo_interv_sae_alt(nr_sequencia,
											 nr_atendimento,
											 nr_seq_prescr,
											 nr_seq_proc,
											 nm_usuario,
											 nm_usuario_nrec,
											 dt_atualizacao,
											 dt_atualizacao_nrec,
											 ie_gerar,
											 hr_prim_horario,
											 nr_seq_dispositivo,
											 nr_seq_disp_atend)
									values ( nextval('dispositivo_interv_sae_alt_seq'),
											nr_atendimento_p,
											nr_seq_prescr_p,
											nr_seq_proc_p,
											nm_usuario_w,
											nm_usuario_w,
											clock_timestamp(),
											clock_timestamp(),
											ie_gerar_p,
											to_char(dt_prevista_w,'hh24:mi'),
											nr_seq_dispositivo_p,
											nr_seq_disp_atend_p);

	else

			Update	dispositivo_interv_sae_alt
			set		ie_gerar = ie_gerar_p,
					hr_prim_horario = to_char(dt_prevista_w,'hh24:mi'),
					dt_atualizacao = clock_timestamp(),
					nm_usuario = nm_usuario_w
			where	nr_atendimento = nr_atendimento_p
			and		nr_seq_prescr = nr_seq_prescr_p
			and		nr_seq_proc = nr_seq_proc_p
			and		nr_seq_dispositivo = nr_seq_dispositivo_p
			and		nr_seq_disp_atend = nr_seq_disp_atend_p;


	end if;

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_alter_disp_interv_sae ( nr_atendimento_p bigint, nr_seq_prescr_p bigint, nr_seq_proc_p bigint, nr_seq_dispositivo_p bigint, nr_seq_disp_atend_p bigint, ie_gerar_p text, dt_prevista_p text) FROM PUBLIC;

