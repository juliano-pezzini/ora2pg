-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE get_ihc_anb ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE
 		
			
nr_account_w			ihc_claim.nr_account%type;
nr_atendimento_w		atendimento_paciente.nr_atendimento%type;
dt_nascimento_w			nascimento.dt_nascimento%type;
nr_atendimento_filho_w	atendimento_paciente.nr_atendimento%type;
ie_sexo_w       	 	nascimento.ie_sexo%type;
ds_family_name_w 	 	varchar(255);
ds_given_name_w	 	 	varchar(255);
ds_middle_name_w 	 	varchar(255);
ds_erro_w               varchar(2000) := '';
cd_estabelecimento_w    conta_paciente.cd_estabelecimento%type;
nr_records_w            ihc_claim.nr_sequencia%type;
cd_pessoa_fisica_w		varchar(30);

c01 CURSOR FOR
SELECT  nr_atendimento	
from    atendimento_paciente
where   nr_atendimento_mae = nr_atendimento_w;
		
c02 CURSOR FOR
SELECT  get_formatted_person_name(a.cd_pessoa_fisica,'familyName',cd_estabelecimento_w),
		get_formatted_person_name(a.cd_pessoa_fisica,'givenName',cd_estabelecimento_w),
		substr(get_formatted_person_name(a.cd_pessoa_fisica,'middleName',cd_estabelecimento_w),1, 1),
		b.dt_nascimento,
		b.ie_sexo,
		a.cd_pessoa_fisica
from    atendimento_paciente a,
		nascimento b
where   a.nr_atendimento = b.nr_atend_rn
and     a.nr_atendimento = nr_atendimento_filho_w;
		

BEGIN
			
select  max(nr_account)
into STRICT    nr_account_w
from 	ihc_claim
where	nr_sequencia = nr_sequencia_p;

select  max(a.nr_atendimento),
		max(b.cd_estabelecimento)
into STRICT    nr_atendimento_w,
		cd_estabelecimento_w
from    atendimento_paciente a,
        conta_paciente b
where   a.nr_atendimento = b.nr_atendimento
and     b.nr_interno_conta = nr_account_w;	

begin
open c01;
loop
fetch c01 into
	nr_atendimento_filho_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	begin
	open  c02;
	loop
	fetch c02 into
		ds_family_name_w,
		ds_given_name_w,
		ds_middle_name_w,
		dt_nascimento_w,
		ie_sexo_w,
		cd_pessoa_fisica_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
	
	if (coalesce(ds_given_name_w::text, '') = '') then
    CALL GENERATE_INCO_ECLIPSE(nr_account_w,1, obter_desc_expressao(959336) || ' (' || nr_atendimento_filho_w || ' / ' || cd_pessoa_fisica_w || ')', nm_usuario_p);
	end if;
	
	if (coalesce(ds_family_name_w::text, '') = '') then
    CALL GENERATE_INCO_ECLIPSE(nr_account_w,1,obter_desc_expressao(959334) || ' (' || nr_atendimento_filho_w || ' / ' || cd_pessoa_fisica_w || ')', nm_usuario_p);
	end if;
		
	if (coalesce(dt_nascimento_w::text, '') = '') then
    CALL GENERATE_INCO_ECLIPSE(nr_account_w,1,obter_desc_expressao(959332) || ' (' || nr_atendimento_filho_w || ' / ' || cd_pessoa_fisica_w || ')', nm_usuario_p);
	end if;
	
	if (coalesce(ie_sexo_w::text, '') = '') then
		CALL GENERATE_INCO_ECLIPSE(nr_account_w,1,obter_desc_expressao(302021) || ' (' || nr_atendimento_filho_w || ' / ' || cd_pessoa_fisica_w || ')', nm_usuario_p);
	else
		ie_sexo_w := get_eclipse_conversion('IE_SEXO', ie_sexo_w, 'IHC', null, nr_account_w, ie_sexo_w);
	end if;

  select  count(nr_sequencia)
  into STRICT    nr_records_w
  from    ECLIPSE_INCO_ACCOUNT
  where   NR_INTERNO_CONTA = nr_account_w;

  select  count(nr_sequencia)
  into STRICT    nr_records_w
  from    ECLIPSE_INCO_ACCOUNT
  where   NR_INTERNO_CONTA = nr_account_w;

  if (BILLING_I18N_PCK.GET_VALIDATE_ECLIPSE() = 'N') and (nr_records_w = 0) then
		insert into ihc_anb(    dt_birth,
				        ie_gender,
				        nm_family,
				        nm_first,		     
				        nm_second,
				        nm_usuario,
				        nm_usuario_nrec,
				        dt_atualizacao,
				        dt_atualizacao_nrec,
				        nr_sequencia,
				        nr_seq_claim)
		values ( 	dt_nascimento_w,
				    ie_sexo_w,
					ds_family_name_w,
					ds_given_name_w,
					ds_middle_name_w,
					nm_usuario_p,
					nm_usuario_p,
					clock_timestamp(),
					clock_timestamp(),
					nextval('ihc_anb_seq'),
					nr_sequencia_p);
	end if;
	end loop;
	close c02;
	end;
	
end loop;
close c01;
end;	

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE get_ihc_anb ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
