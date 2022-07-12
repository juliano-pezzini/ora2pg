-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_motivo_agenda (nr_seq_agenda_p bigint) RETURNS varchar AS $body$
DECLARE


ds_motivo_w			varchar(4000);
ie_status_agenda_w		varchar(3);
nr_seq_mot_inativ_w		bigint;
nr_seq_motivo_bloq_w		bigint;
cd_motivo_cancel_w		agenda_paciente.cd_motivo_cancelamento%type;
nr_seq_motivo_transf_w	bigint;
nr_seq_cpoe_procedimento_w  agenda_paciente_auxiliar.nr_seq_cpoe_procedimento%type;
ie_cpoe_suspenso_w        char(1);


BEGIN
if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') then
	/* obter dados agenda */

	select	a.ie_status_agenda,
		a.nr_seq_mot_inativ,
		a.nr_seq_motivo_bloq,
		a.cd_motivo_cancelamento,
		a.nr_seq_motivo_transf,
        b.nr_seq_cpoe_procedimento
	into STRICT	ie_status_agenda_w,
		nr_seq_mot_inativ_w,
		nr_seq_motivo_bloq_w,
		cd_motivo_cancel_w,
		nr_seq_motivo_transf_w,
        nr_seq_cpoe_procedimento_w
	FROM agenda_paciente a
LEFT OUTER JOIN agenda_paciente_auxiliar b ON (a.nr_sequencia = b.nr_seq_agenda)
WHERE a.nr_sequencia = nr_seq_agenda_p;

  select (CASE WHEN (max(b.dt_suspensao) IS NOT NULL AND (max(b.dt_suspensao))::text <> '') THEN 'S' ELSE 'N' END)
  into STRICT  ie_cpoe_suspenso_w
  from  agenda_paciente_auxiliar a,
        cpoe_procedimento b
  where a.nr_seq_cpoe_procedimento = b.nr_sequencia
  and   a.nr_seq_agenda = nr_seq_agenda_p;

	/* obter motivo */

  if ((nr_seq_cpoe_procedimento_w IS NOT NULL AND nr_seq_cpoe_procedimento_w::text <> '')
      and ie_status_agenda_w = 'C'
      and ie_cpoe_suspenso_w = 'S') then
    /* obter motivo cancelamento cpoe */

    select substr(concat(obter_motivo_suspensao_prescr(cd_motivo_cancel_w),
                  obter_motivo_cancel_agenda(nr_seq_agenda_p, null)), 1, 4000)
    into STRICT ds_motivo_w
;
	elsif (ie_status_agenda_w = 'II') then
		/* obter motivo inativacao */

		select	obter_motivo_inativ_agenda(nr_seq_agenda_p, nr_seq_mot_inativ_w)
		into STRICT	ds_motivo_w
		;
	elsif (ie_status_agenda_w = 'B') then
		/* obter motivo bloqueio */

		select	obter_motivo_bloq_agenda(nr_seq_agenda_p, nr_seq_motivo_bloq_w)
		into STRICT	ds_motivo_w
		;
	elsif (ie_status_agenda_w = 'C') then
		/* obter motivo cancelamento */

		select	substr(obter_motivo_cancel_agenda(nr_seq_agenda_p, cd_motivo_cancel_w),1,4000)
		into STRICT	ds_motivo_w
		;
	elsif (ie_status_agenda_w in ('F','I')) then
		/* obter motivo falta */

		select	obter_motivo_falta_agenda(nr_seq_agenda_p)
		into STRICT	ds_motivo_w
		;
	elsif (nr_seq_motivo_transf_w IS NOT NULL AND nr_seq_motivo_transf_w::text <> '') then
		/* obter motivo transferencia */

		select	obter_motivo_transf_agenda(nr_seq_agenda_p, nr_seq_motivo_transf_w)
		into STRICT	ds_motivo_w
		;
	end if;
end if;

return ds_motivo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_motivo_agenda (nr_seq_agenda_p bigint) FROM PUBLIC;

