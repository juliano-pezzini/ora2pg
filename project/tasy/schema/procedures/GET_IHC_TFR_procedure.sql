-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE get_ihc_tfr ( nr_seq_claim_p ihc_claim.nr_sequencia%type, nm_usuario_p ihc_claim.nm_usuario%type) AS $body$
DECLARE

		

cd_discharge_w			ihc_claim.cd_discharge%type;
ie_referral_source_w		ihc_claim.ie_referral_source%type;
nr_account_w			ihc_claim.nr_account%type;
ie_transfer_w			ihc_tfr.ie_transfer%type;
cd_facility_w			ihc_tfr.cd_facility%type;
nr_episode_w			conta_paciente.nr_atendimento%type;
cd_establishment_w		conta_paciente.cd_estabelecimento%type;
nr_records_w			ihc_claim.nr_sequencia%type;
nr_seq_w			ihc_tfr.nr_sequencia%type;
ie_type_w       		ihc_tfr.ie_type%type;
qt_previous_days_w  		integer;
qt_previous_hours_w 		integer;


c_procedimento_paciente CURSOR FOR
	SELECT	a.dt_procedimento,
		a.cd_procedimento,
		b.cd_procedimento_loc
	from	procedimento_paciente a,
		procedimento b
	where	a.cd_procedimento = b.cd_procedimento
	and	a.ie_origem_proced = b.ie_origem_proced
	and	a.nr_interno_conta = nr_account_w
	and	a.nr_atendimento = nr_episode_w
	and	a.dt_procedimento < clock_timestamp()
	and b.cd_procedimento_loc not in ('G67B','00147','00108','00104','00106','00109')
-- order by b.cd_procedimento_loc;
  order by a.dt_procedimento;

BEGIN

--- PROCEDURE = 00106

	-- DISCHARGE DATE


--- PROCEDURE = 00113

	-- ADMISSION DATE
select	max(nr_account)
into STRICT	nr_account_w
from	ihc_claim
where	nr_sequencia = nr_seq_claim_p;

select 	max(nr_atendimento),
		max(cd_estabelecimento)
into STRICT	nr_episode_w,
		cd_establishment_w
from 	conta_paciente
where 	nr_interno_conta = nr_account_w;

if (nr_episode_w IS NOT NULL AND nr_episode_w::text <> '') then

	select	max(cd_discharge),
			max(ie_referral_source)
	into STRICT	cd_discharge_w,
			ie_referral_source_w
	from	ihc_claim
	where	nr_sequencia = nr_seq_claim_p;

	for r_c_procedimento_paciente in c_procedimento_paciente loop

		if (cd_discharge_w in ('01', '03')) then

			select	max(cd_facility)
			into STRICT	cd_facility_w
			from	eclipse_parameters a,
					atendimento_paciente b
			where	a.cd_estabelecimento = b.cd_estabelecimento
			and		b.nr_atendimento = nr_episode_w;

			if (coalesce(cd_facility_w::text, '') = '') then
				CALL generate_inco_eclipse(nr_account_w,1, obter_desc_expressao(958723) || ' (Proc: ' || r_c_procedimento_paciente.cd_procedimento || ')',nm_usuario_p);
			end if;

		end if;

  if (r_c_procedimento_paciente.cd_procedimento_loc = '00114') then
			ie_transfer_w := 'S';
			qt_previous_days_w := null;
			qt_previous_hours_w :=null;
			ie_type_w :=null;
		end if;

		if (r_c_procedimento_paciente.cd_procedimento_loc = '00113') then
			ie_transfer_w := 'A';
			qt_previous_days_w := 2;
			qt_previous_hours_w :=12;
			ie_type_w := 'U';
		end if;



		if (coalesce(ie_transfer_w::text, '') = '') then
			CALL generate_inco_eclipse(nr_account_w,1, obter_desc_expressao(965086) || ' (Proc: ' || r_c_procedimento_paciente.cd_procedimento || ')',nm_usuario_p);
		elsif (ie_transfer_w not in ('A', 'S')) then
			CALL generate_inco_eclipse(nr_account_w,3, obter_desc_expressao(965086) || ' (Proc: ' || r_c_procedimento_paciente.cd_procedimento || ')',nm_usuario_p);
		end if;

		select  count(nr_sequencia)
	    into STRICT    nr_records_w
	    from    eclipse_inco_account
	    where   NR_INTERNO_CONTA = nr_account_w;

	    if (billing_i18n_pck.get_validate_eclipse() = 'N') and (nr_records_w = 0) then

			select	nextval('ihc_tfr_seq')
			into STRICT	nr_seq_w
			;

			insert into ihc_tfr(
					nr_sequencia,
					nr_seq_claim,      
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					cd_facility,
					qt_previous_days,
					qt_previous_hours,
					dt_transfer,    
					ie_transfer,
					ie_type)
				values (
					nr_seq_w,
					nr_seq_claim_p,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					cd_facility_w,
					qt_previous_days_w,
					qt_previous_hours_w,
					r_c_procedimento_paciente.dt_procedimento,
					ie_transfer_w,
					ie_type_w);

		end if;

	end loop;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE get_ihc_tfr ( nr_seq_claim_p ihc_claim.nr_sequencia%type, nm_usuario_p ihc_claim.nm_usuario%type) FROM PUBLIC;

