-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE generate_cpoe_slip_number ( nr_atendimento_p bigint, ie_tipo_atendimento_p bigint, cd_pessoa_fisica_p text, nr_seq_agenda_consulta_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_guidance_fee_p bigint default null) AS $body$
DECLARE


si_event_type_w cpoe_rule_slip_tipo_ped.si_event_type%type  := null;
cd_pessoa_fisica_w pessoa_fisica.cd_pessoa_fisica%type  := null;
nr_seq_cpoe_rule_slip_w cpoe_rule_slip_number.nr_sequencia%type := null;
cd_slip_number_w cpoe_order_type_identify.cd_slip_number%type := null;
new_day_w varchar(1)  := 'N';
nr_current_seq_w    cpoe_rule_slip_number.nr_current_seq%type := null;
cd_estabelecimento_w  estabelecimento.cd_estabelecimento%type;
nr_seq_pac_reab_w	rp_paciente_reabilitacao.nr_sequencia%type;
nr_seq_agenda_consulta_w	agenda_consulta.nr_sequencia%type;
ie_tipo_atendimento_w	atendimento_paciente.ie_tipo_atendimento%type	:= null;
nr_order_serial_w int_serial_number.nr_serial%type;

C_rule CURSOR FOR
SELECT	a.nr_sequencia
FROM cpoe_rule_slip_number a
LEFT OUTER JOIN cpoe_rule_slip_tipo_ped b ON (a.nr_sequencia = b.nr_seq_cpoe_rule_slip)
WHERE clock_timestamp() Between pkg_date_utils.start_of(a.dt_vigencia_ini,'DAY') and coalesce(pkg_date_utils.end_of(a.Dt_vigencia_fim,'DAY'), clock_timestamp()) AND (b.ie_tipo_atendimento = ie_tipo_atendimento_w or coalesce(ie_tipo_atendimento_w::text, '') = '') and b.si_event_type = si_event_type_w order by
		coalesce(b.ie_tipo_atendimento,0);

C_Update CURSOR( nr_sequencia_pc  bigint) FOR
SELECT	nr_sequencia,
		CD_PREFIXO_SLIP_NUMBER,
		ds_timestamp_format,
		nr_current_seq,
		qt_maximo,
		si_seq_restart_daily,
		dt_last_seq_reset,
		ds_sufixo
from	cpoe_rule_slip_number
where	nr_sequencia = nr_sequencia_pc

for update of dt_last_seq_reset, nr_current_seq;
BEGIN

if (nr_atendimento_p > 0) then
	si_event_type_w := 'AT';

	ie_tipo_atendimento_w := ie_tipo_atendimento_p;
	cd_pessoa_fisica_w := cd_pessoa_fisica_p;
elsif (nr_seq_agenda_consulta_p > 0) then
	si_event_type_w := 'AC';

	select	a.cd_pessoa_fisica,
			a.nr_seq_pac_reab
	INTO STRICT	cd_pessoa_fisica_w,
			nr_seq_pac_reab_w
	from	agenda_consulta a
	where	a.nr_sequencia = nr_seq_agenda_consulta_p;
	
	IF (nr_seq_pac_reab_w IS NOT NULL AND nr_seq_pac_reab_w::text <> '') THEN
		nr_seq_agenda_consulta_w	:= null;
	ELSE
		nr_seq_agenda_consulta_w	:= nr_seq_agenda_consulta_p;
	end if;
elsif (nr_seq_guidance_fee_p IS NOT NULL AND nr_seq_guidance_fee_p::text <> '') then	
	si_event_type_w := 'GF';
	cd_pessoa_fisica_w := cd_pessoa_fisica_p;
end if;

cd_estabelecimento_w  := coalesce(cd_estabelecimento_p,wheb_usuario_pck.get_cd_estabelecimento);

if (si_event_type_w IS NOT NULL AND si_event_type_w::text <> '') and (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then

	for r_c_rule in c_rule loop
		nr_seq_cpoe_rule_slip_w := r_c_rule.nr_sequencia;
	end loop;

	if	(nr_seq_cpoe_rule_slip_w IS NOT NULL AND nr_seq_cpoe_rule_slip_w::text <> '') then
		for rLin in C_Update( nr_seq_cpoe_rule_slip_w ) loop
			new_day_w := 'N';
			
			if (rLin.si_seq_restart_daily = 'S') and
				( (rLin.dt_last_seq_reset < trunc(clock_timestamp(),'dd')) or (coalesce(rLin.dt_last_seq_reset::text, '') = '') ) then
				new_day_w := 'S';
			end if;
			
			if new_day_w = 'S' then
				nr_current_seq_w  := 1;
			else
				nr_current_seq_w  := rLin.nr_current_seq + 1;
			end if;

			cd_slip_number_w := rLin.CD_PREFIXO_SLIP_NUMBER || TO_CHAR(clock_timestamp(), rLin.ds_timestamp_format)
				   || LPAD(nr_current_seq_w,LENGTH(rLin.qt_maximo), '0')
				   || rLin.ds_sufixo;

			if (new_day_w = 'S') then
				update	cpoe_rule_slip_number
				set		nr_current_seq = 0,
						dt_last_seq_reset = clock_timestamp()
				where current of C_Update;
			end if;

			update	cpoe_rule_slip_number
			set		nr_current_seq = nr_current_seq + 1
			where current of C_Update;
		end loop;
	end if;

  nr_order_serial_w := generate_int_serial_number(cd_pessoa_fisica_w, 'ACC_ORDER_SEQ', cd_estabelecimento_w, nm_usuario_p, nr_order_serial_w, 949);
	
  if (cd_slip_number_w IS NOT NULL AND cd_slip_number_w::text <> '') then

		insert into CPOE_ORDER_TYPE_IDENTIFY(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			cd_estabelecimento,
			cd_slip_number,
			nr_atendimento,
			nr_seq_agenda_consulta,
			nr_seq_rp_reabilitacao,
                        nr_seq_med_guid,
			cd_pessoa_fisica,
			ie_situacao,
			nr_order_patient_seq)
			values (
			nextval('cpoe_order_type_identify_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			cd_estabelecimento_w,
			cd_slip_number_w,
			nr_atendimento_p,
			nr_seq_agenda_consulta_w,
			nr_seq_pac_reab_w,
                        nr_seq_guidance_fee_p,
			cd_pessoa_fisica_w,
			'A',
			nr_order_serial_w);
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE generate_cpoe_slip_number ( nr_atendimento_p bigint, ie_tipo_atendimento_p bigint, cd_pessoa_fisica_p text, nr_seq_agenda_consulta_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_guidance_fee_p bigint default null) FROM PUBLIC;

