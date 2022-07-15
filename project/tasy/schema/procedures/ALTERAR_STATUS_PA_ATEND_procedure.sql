-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_status_pa_atend ( nr_seq_pa_status_p bigint default null, nr_atendimento_p bigint DEFAULT NULL, nr_seq_status_p bigint default null) AS $body$
DECLARE


ie_reavaliacao_medica_w		varchar(1);
ie_liberacao_enfermagem_w	varchar(1);
nr_seq_next_val_w numeric(38);


BEGIN
if (nr_seq_pa_status_p IS NOT NULL AND nr_seq_pa_status_p::text <> '') and (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
	update	atendimento_paciente
	set	nr_seq_pa_status = nr_seq_pa_status_p
	where	nr_atendimento   = nr_atendimento_p;
end if;	

SELECT	max(IE_REAVALIACAO_MEDICA),
	max(IE_LIBERACAO_ENFERMAGEM)
into STRICT	ie_reavaliacao_medica_w,
	ie_liberacao_enfermagem_w
FROM 	PA_STATUS_PACIENTE
WHERE 	nr_sequencia = nr_seq_pa_status_p;

if (ie_reavaliacao_medica_w = 'S') then
	Begin
	update	atendimento_paciente
	set	dt_reavaliacao_medica = clock_timestamp()
	where	nr_atendimento   = nr_atendimento_p;
	End;
end if;
	
if (ie_liberacao_enfermagem_w = 'S') then
	Begin
	update	atendimento_paciente
	set	dt_liberacao_enfermagem = clock_timestamp()
	where	nr_atendimento   = nr_atendimento_p;
	End;
end if;

select	nextval('status_pa_atend_log_seq')
		into STRICT	nr_seq_next_val_w
		;

Insert into STATUS_PA_ATEND_LOG(DT_REGISTRO, NR_SEQ_STATUS, NR_SEQ_STATUS_PROC, NM_USUARIO, NR_SEQUENCIA, DT_ATUALIZACAO, NR_ATENDIMENTO)
 Values (clock_timestamp(), nr_seq_pa_status_p, nr_seq_status_p, wheb_usuario_pck.get_nm_usuario, nr_seq_next_val_w, clock_timestamp(), nr_atendimento_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_status_pa_atend ( nr_seq_pa_status_p bigint default null, nr_atendimento_p bigint DEFAULT NULL, nr_seq_status_p bigint default null) FROM PUBLIC;

