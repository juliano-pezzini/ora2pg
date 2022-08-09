-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE get_ihc_dmg ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE

			
ds_erro_w              	 	varchar(2000) := '';
nr_account_w                    ihc_claim.nr_account%type;
ie_claim_type_w			ihc_claim.ie_claim_type%type;				
ie_acc_status_w			ihc_claim.ie_acc_status%type;
ie_contiguous_w			ihc_claim.ie_contiguous%type;
cd_procedimento_w		procedimento.cd_procedimento_loc%type;
ie_classificacao_doenca_w       diagnostico_doenca.ie_classificacao_doenca%type;
cd_doenca_w       		diagnostico_doenca.cd_doenca%type;
nr_atendimento_w                atendimento_paciente.nr_atendimento%type;
cd_drg_w                        drg_procedimento.cd_drg%type;
cd_version_w                    ihc_claim.cd_version%type;
psg_count_w						integer;
c01_w							integer;
c02_w							integer;
c03_w							integer;

c01 CURSOR FOR
SELECT  c.ie_classificacao_doenca,
	c.cd_doenca
from 	atendimento_paciente a,
	conta_paciente b,
	diagnostico_doenca c
where   a.nr_atendimento = b.nr_atendimento
and     a.nr_atendimento = c.nr_atendimento
and 	b.nr_interno_conta = nr_account_w
and     coalesce(c.ie_classificacao_doenca,'S') = 'S'  LIMIT 49;

c02 CURSOR FOR
SELECT  c.ie_classificacao_doenca,
	c.cd_doenca
from 	atendimento_paciente a,
	conta_paciente b,
	diagnostico_doenca c
where   a.nr_atendimento = b.nr_atendimento
and     a.nr_atendimento = c.nr_atendimento
and 	b.nr_interno_conta = nr_account_w
and     c.ie_classificacao_doenca = 'P'  LIMIT 19;

c03 CURSOR FOR
SELECT  b.cd_procedimento_loc cd_procedimento
from    procedimento_paciente a,
		procedimento b
where   b.cd_procedimento = a.cd_procedimento
and 	b.ie_origem_proced = a.ie_origem_proced
and 	a.nr_interno_conta = nr_account_w
and 	length(b.cd_procedimento_loc) <= 7 LIMIT 50;


BEGIN

select  max(ie_claim_type),
	max(nr_account),
	max(ie_acc_status),
	max(ie_contiguous)
into STRICT	ie_claim_type_w,
	nr_account_w,
	ie_acc_status_w,
	ie_contiguous_w
from	ihc_claim
where   nr_sequencia = nr_sequencia_p;


if ((ie_claim_type_w = 'PR') and (ie_acc_status_w = 'A') and (ie_contiguous_w in ('N','L'))) then

	select  max(a.nr_atendimento)
	into STRICT    nr_atendimento_w
	from    atendimento_paciente a,
			conta_paciente b
	where   a.nr_atendimento = b.nr_atendimento
	and     b.nr_interno_conta = nr_account_w;

	select  max(b.cd_drg)
	into STRICT    cd_drg_w
	from	episodio_paciente_drg a,
			drg_procedimento b
	where   b.nr_sequencia = a.nr_seq_drg_proc
	and     a.nr_atendimento = nr_atendimento_w;
	
	cd_version_w := substr(obtain_source_rule_drg(nr_atendimento_w, null, 'E'),1,4);
	
	update  ihc_claim
	set  	cd_drg = cd_drg_w,
			cd_version = cd_version_w,
			qt_ventilation  = NULL,
			nm_usuario = nm_usuario_p,
			dt_atualizacao = clock_timestamp()
	where   nr_sequencia = nr_sequencia_p;

end if;

select 	count(*)
into STRICT 	psg_count_w
from 	ihc_psg
where 	nr_seq_claim = nr_sequencia_p;

if ((ie_claim_type_w = 'PR') or (ie_claim_type_w = 'PU' and psg_count_w > 0)) then
	select  count(*)
	into STRICT 	c01_w
	from 	atendimento_paciente a,
		conta_paciente b,
		diagnostico_doenca c
	where   a.nr_atendimento = b.nr_atendimento
	and     a.nr_atendimento = c.nr_atendimento
	and 	b.nr_interno_conta = nr_account_w
	and     coalesce(c.ie_classificacao_doenca,'S') = 'S';

	select  count(*)
	into STRICT 	c02_w
	from 	atendimento_paciente a,
		conta_paciente b,
		diagnostico_doenca c
	where   a.nr_atendimento = b.nr_atendimento
	and     a.nr_atendimento = c.nr_atendimento
	and 	b.nr_interno_conta = nr_account_w
	and     c.ie_classificacao_doenca = 'P';

	select  count(*)
	into STRICT 	c03_w
	from    procedimento_paciente
	where   nr_interno_conta = nr_account_w;

	if (c01_w = 0 and c02_w = 0) then
		CALL GENERATE_INCO_ECLIPSE(nr_account_w, 1, obter_desc_expressao(619773), nm_usuario_p);
	elsif (c03_w = 0) then
		CALL GENERATE_INCO_ECLIPSE(nr_account_w, 1, obter_desc_expressao(621262), nm_usuario_p);
	end if;

	if (BILLING_I18N_PCK.get_validate_eclipse() = 'N') then
		begin
		open c01;
		loop
		fetch c01 into
		ie_classificacao_doenca_w,
		cd_doenca_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */

		
			insert into ihc_dmg_diagnosis(	cd_diagnosis,
							ie_diagnosis,
							nr_seq_claim,
							nr_sequencia,
							dt_atualizacao,
							dt_atualizacao_nrec,
							nm_usuario,
							nm_usuario_nrec)
						values (	cd_doenca_w,
							ie_classificacao_doenca_w,
							nr_sequencia_p,
							nextval('ihc_dmg_diagnosis_seq'),
							clock_timestamp(),
							clock_timestamp(),
							nm_usuario_p,
							nm_usuario_p);
		end loop;
		close c01;
		end;

		begin
		open c02;
		loop
		fetch c02 into
		ie_classificacao_doenca_w,
		cd_doenca_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */

			insert into ihc_dmg_diagnosis(	cd_diagnosis,
							ie_diagnosis,
							nr_seq_claim,
							nr_sequencia,
							dt_atualizacao,
							dt_atualizacao_nrec,
							nm_usuario,
							nm_usuario_nrec)
						values (	cd_doenca_w,
							ie_classificacao_doenca_w,
							nr_sequencia_p,
							nextval('ihc_dmg_diagnosis_seq'),
							clock_timestamp(),
							clock_timestamp(),
							nm_usuario_p,
							nm_usuario_p);
		end loop;
		close c02;
		end;

			
		begin
		open  c03;
		loop
		fetch c03 into	
		cd_procedimento_w;
		EXIT WHEN NOT FOUND; /* apply on c03 */	

			insert into ihc_dmg_procedure( cd_procedure,
							nr_seq_claim,
							nr_sequencia,
							dt_atualizacao,
							dt_atualizacao_nrec,
							nm_usuario,
							nm_usuario_nrec)
						values ( cd_procedimento_w,
							nr_sequencia_p,
							nextval('ihc_dmg_procedure_seq'),
							clock_timestamp(),
							clock_timestamp(),
							nm_usuario_p,
							nm_usuario_p);
		end loop;
		close c03;
		end;

		commit;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE get_ihc_dmg ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
