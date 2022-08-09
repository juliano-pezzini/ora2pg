-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dva_claim_request (nm_usuario_p text, cd_estabelecimento_p bigint, ie_service_type_p text, nr_seq_account_p bigint, nr_interno_conta_p bigint, ie_resubmission_p text default 'N', ie_validation text default 'F', cd_transaction_p INOUT text DEFAULT NULL) AS $body$
DECLARE


dt_authorisation_w 		dva_claim.dt_authorisation%type;
cd_motivo_alta_w    		atendimento_paciente.cd_motivo_alta%type;
dt_certified_w 			dva_claim.dt_certified%type;
dt_collection_w   		timestamp;
ie_certified_w 			dva_claim.ie_certified%type;
cd_provider_w			dva_claim.cd_provider%type;
dt_validate_w			timestamp;
cd_claim_w   			dva_claim.cd_claim%type;
ds_disability_w   		dva_voucher.ds_disability%type;
service_count_number 		varchar(4);
cd_payee_provider_w		dva_claim.cd_payee_provider%type;
nr_lsp_w  			dva_service.nr_lsp%type;
nr_dva_claim_seq_w  		dva_claim.nr_sequencia%type;
nr_dva_voucher_seq_w		dva_voucher.nr_sequencia%type;
cd_attribute_w             	varchar(20);
error_flag_w			varchar(1);
cd_field_name_w            	varchar(40);
cd_tasy_claim_w    		nota_fiscal.nr_nota_fiscal%type;
cd_transaction_id		varchar(25);
dt_referal_w			timestamp;
ref_provider_num_w		medical_provider_number.nr_provider%type;
req_provider_num_w		medical_provider_number.nr_provider%type;
req_ref_provider_num_w		medical_provider_number.nr_provider%type;
cd_service_code_w 		bigint :=0;
ds_address_w			varchar(40);
nr_postcode_w			varchar(4);
nm_alias_family_w		varchar(40);
nm_alias_first_w		varchar(40);
dt_birth_w			timestamp;
nm_family_w			varchar(40);
nm_first_w			varchar(40);
ie_gender_w			varchar(1);
cd_veteran_w			varchar(9);
cd_cep_w			bigint;
ie_disability_ind_w		varchar(1);
dt_service_w 			timestamp;
ie_adm_type_w 			varchar(1) :='Y';
request_date_w 			timestamp;
cd_mbs_code_w              	varchar(5);
cd_eclipse_w    	        varchar(100);
request_sts              	varchar(500);
is_found_rec 			boolean := false;
nr_seq_history_claim_w		eclipse_claim_history.nr_sequencia%type;
ie_service_type_w		varchar(1);
nr_seq_tipe_parecer_w		parecer_medico_req.nr_seq_tipo_parecer%type;
ie_referral_override_w		varchar(10);
ie_rule_w			dva_service.ie_rule%type;
cd_scp_w			dva_service.cd_scp%type;
ie_duplicate_w			dva_service.ie_duplicate%type  := 'N';
nr_atendimento_w  		conta_paciente.nr_interno_conta%type;
dt_accession_w    		prescr_procedimento.dt_coleta%type;
qt_periodo_parecer_w 		dva_voucher.qt_period%type  := null;
ie_tipo_periodo_w 		dva_voucher.ie_referral_period%type := null;
nr_voucher_w               	varchar(2);
nr_voucher_count_w         	smallint;
curr_cd_medico_resp_w      	varchar(10);
new_voucher_ind_w          	smallint;
qt_distance_w			bigint;
nr_justification_seq_w   	paciente_justificativa.nr_sequencia%type;
ie_s4b3_w                	dva_service.ie_s4b3%type;
cd_opinion_text_w       	tipo_parecer.ds_tipo_parecer%type;
ie_referral_period_w    	dva_voucher.ie_referral_period%type;
ie_selfdeemed_w         	dva_service.ie_selfdeemed%type;
cd_medic_w			parecer_medico_req.cd_medico%type;
ie_specialist_w			varchar(10) := 'N';
cd_person_opinion_w		parecer_medico_req.cd_pessoa_parecer%type;
qt_patients_w 			dva_service.qt_patients%type;
qt_procedure_count_w		bigint;
nr_procedure_w			bigint;
ie_multiple_procedure_w		varchar(1) := 'N';
nr_ext_doc_w  			bigint;
nr_seq_ext_doc_w		bigint;
dt_ref_req_w    		timestamp;
general_procedures_w   		varchar(400);
specialist_procedures_w  	varchar(400);
pathology_procedures_w 		varchar(400);
ie_aftercare_w 			dva_service.ie_aftercare%type;
voucher_date_w 			timestamp;
NR_REFERRAL_MONTHS_W 		DVA_VOUCHER.NR_REFERRAL_MONTHS%type;
cd_location_w 			varchar(1);



c03 CURSOR FOR
	SELECT 	nm_eclipse_field,
		nm_atributo
	from   	eclipse_attribute
	where  	ie_condition = 'M'
	and	ie_dva = 'S';

c01 CURSOR FOR
	SELECT	c.vl_procedimento,
		c.dt_atualizacao,
		c.cd_procedimento,
		c.cd_equipamento,
		c.ie_origem_proced,
		c.DS_OBSERVACAO,
		trunc(c.dt_final_procedimento - dt_inicio_procedimento) qt_duracao,
		c.DT_INICIO_PROCEDIMENTO ,
		c.QT_PROCEDIMENTO,
		(SELECT max(Lpad(substr(k.NR_PROVIDER, 1,8),8,'0')) from MEDICAL_PROVIDER_NUMBER k where k.CD_MEDICO = c.CD_MEDICO) as cd_medico_resp,
		c.DT_PROCEDIMENTO 
		from 	procedimento_paciente c, procedimento d
		where 	c.nr_interno_conta = nr_seq_account_p
		and d.cd_procedimento = c.cd_procedimento
	--	and	c.ie_origem_proced = 20 -- Only MBS codes
		ORDER  BY c.DT_PROCEDIMENTO,c.CD_MEDICO, d.CD_GRUPO_PROC desc, c.cd_procedimento;

BEGIN
 -- Clear the prior validation checks
delete FROM eclipse_inco_account a
where a.nr_interno_conta = nr_seq_account_p;

	-- checking the type of claim
SELECT * FROM get_eclipse_service_types(nr_seq_account_p, general_procedures_w, specialist_procedures_w, pathology_procedures_w ) INTO STRICT general_procedures_w, specialist_procedures_w, pathology_procedures_w;
if (specialist_procedures_w IS NOT NULL AND specialist_procedures_w::text <> '' AND pathology_procedures_w IS NOT NULL AND pathology_procedures_w::text <> '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1118140, ' Specialist items = ' || specialist_procedures_w || ' Pathology items = ' || pathology_procedures_w);
end if;
if (specialist_procedures_w IS NOT NULL AND specialist_procedures_w::text <> '') then
	ie_service_type_w := 'S';
elsif (pathology_procedures_w IS NOT NULL AND pathology_procedures_w::text <> '') then
	ie_service_type_w := 'P';
else
	ie_service_type_w := 'O';
end if;

cd_transaction_id := generateRandomNumber();
if (ie_resubmission_p <> 'N') then
	select max(nr_seq_transaction)
	into STRICT cd_transaction_id
	from dva_claim
	where nr_interno_conta = nr_seq_account_p;
end if;

 
select nr_atendimento
into STRICT nr_atendimento_w
from conta_paciente
where nr_interno_conta = nr_seq_account_p;

select 	max(b.dt_retorno) dt_authorisation,
	max(b.dt_envio) dt_certified ,
	max(CASE WHEN get_auth_stage(b.nr_sequencia)=10 THEN  'Y'  ELSE 'N' END ) ie_certified
into STRICT 	dt_authorisation_w,
	dt_certified_w,
	ie_certified_w
from 	conta_paciente a,
	autorizacao_convenio b
where 	a.nr_interno_conta = nr_seq_account_p
and 	a.nr_atendimento   = b.nr_atendimento  LIMIT 1;

select nr_seq_account_p cd_tasy_claim,
	generateclaimnumeclipse cd_claim
into STRICT 	cd_tasy_claim_w,
	cd_claim_w
;

if (ie_service_type_w = 'P') then
	  select '#'|| substr(cd_claim_w,2,6 )
	  into STRICT cd_claim_w
	;
end if;

select	max(a.dt_referencia),
        max((select max(Lpad(substr(k.nr_provider, 1,8),8,'0'))
		from 	medical_provider_number k
		where 	k.cd_medico = a.cd_medico )) as ref_provider_num,
        max(a.dt_validade),
	max(a.ie_type_code)

into STRICT 	dt_ref_req_w,  		---- ReferralIssueDate
	req_ref_provider_num_w,   	---- RequestingProviderNum
	dt_validate_w,		---- Validate date
	--ie_specialist_w	---- specialist type
	ie_referral_override_w  -- referral override indicator
from	atendimento_paciente_inf a,
        conta_paciente b
where 	b.nr_interno_conta = nr_seq_account_p
and	a.nr_atendimento = b.nr_atendimento;
--ie_referral_override_w :='R';
begin
select	max(c.nr_seq_tipo_medico)
into STRICT	nr_seq_ext_doc_w
from 	conta_paciente a,
	atendimento_paciente b,
	pf_medico_externo c
where 	a.nr_interno_conta = nr_seq_account_p
and 	a.nr_atendimento = b.nr_atendimento
and 	b.cd_medico_resp = c.cd_medico;
if (coalesce(nr_seq_ext_doc_w::text, '') = '') then
	ie_specialist_w := 'S'; -- if type is not set then consider as general physician
else
	select 	coalesce(max(m.ie_medico_familia) ,'S')
	into STRICT	ie_specialist_w
	from 	tipo_medico_externo m
	where m.nr_sequencia = nr_seq_ext_doc_w;

end if;

exception
when	no_data_found	then
	nr_ext_doc_w := 0;
end;
if (nr_ext_doc_w = 0) then
	select max(cd_especialidade) into STRICT ie_specialist_w  from conta_paciente a,
	atendimento_paciente b,
	medico_especialidade c
	where a.nr_interno_conta = nr_seq_account_p
	and a.nr_atendimento = b.nr_atendimento
	and c.cd_pessoa_fisica = b.cd_medico_resp;
end if;


select	CASE WHEN coalesce(ie_specialist_w::text, '') = '' THEN  'GP'   ELSE 'SP' END
into STRICT 	ie_specialist_w
;


select	max(Lpad(substr(k.NR_PROVIDER, 1,8),8,'0'))
into STRICT	cd_payee_provider_w
from   	conta_paciente b,
        atendimento_paciente a ,
        medical_provider_number k
where  	b.nr_interno_conta = nr_seq_account_p
and 	b.nr_atendimento = a.nr_atendimento
and     a.cd_medico_resp = k.cd_medico  LIMIT 1;

select	max(Lpad(substr(k.NR_PROVIDER, 1,8),8,'0'))
into STRICT	cd_provider_w
from   	conta_paciente b,
        medical_provider_number k
where  	b.nr_interno_conta = nr_seq_account_p
and     b.CD_RESPONSAVEL = k.cd_medico  LIMIT 1;


 if (coalesce(cd_provider_w::text, '') = '' ) then 
  cd_provider_w :=cd_payee_provider_w;
 end if;

select	max(ds_tipo_parecer)
into STRICT 	cd_opinion_text_w
from   	tipo_parecer
where	nr_sequencia = nr_seq_tipe_parecer_w;

if ( ie_service_type_w = 'S' ) then

        select	CASE WHEN ie_specialist_w ='SP' THEN 'SP'  ELSE 'GP' END
	into STRICT 	ie_specialist_w
	;


	if (coalesce(dt_validate_w::text, '') = '') then
  		ie_referral_period_w := 'I';  -- Indifinate
	elsif (pkg_date_utils.get_diffdate(clock_timestamp(), dt_validate_w, 'MONTH') <= 3 and ie_specialist_w = 'SP') then
		ie_referral_period_w := 'S';
	elsif (pkg_date_utils.get_diffdate(clock_timestamp(), dt_validate_w, 'MONTH') <= 12 and ie_specialist_w = 'GP') then
		ie_referral_period_w := 'S';
	elsif (pkg_date_utils.get_diffdate(clock_timestamp(), dt_validate_w, 'MONTH') >= 3 and ie_specialist_w = 'SP') then
		ie_referral_period_w := 'N';
	elsif (pkg_date_utils.get_diffdate(clock_timestamp(), dt_validate_w, 'MONTH') >= 12 and ie_specialist_w = 'GP') then
		ie_referral_period_w := 'N';
	end if;
end if;

if (ie_referral_period_w = 'I') then
  NR_REFERRAL_MONTHS_W := TO_CHAR(pkg_date_utils.get_diffdate(clock_timestamp(), dt_validate_w, 'MONTH'));
end if;
--VOUCHER --- PATIENT ACCOUNT IN TASY
select 	CASE WHEN max(h.ie_white_card)='S' THEN 'Y'  ELSE 'N' END ,
        max(substr(b.cd_usuario_convenio, 1, 9))  cd_veteran,
        max(a.dt_periodo_inicial),
        max(pkg_name_utils.get_person_name(d.nr_seq_person_name,cd_estabelecimento_p,'givenName')) nm_first,
        max(pkg_name_utils.get_person_name(d.nr_seq_person_name,cd_estabelecimento_p,'familyName')) nm_family,
        max(pkg_name_utils.get_person_name(d.nr_seq_person_name,cd_estabelecimento_p,'givenName'))  nm_alias_first,
        max(pkg_name_utils.get_person_name(d.nr_seq_person_name,cd_estabelecimento_p,'familyName')) nm_alias_family,
      	max(d.dt_nascimento) dt_birth,
      	max(d.ie_sexo) ie_gender,
        max(substr(e.ds_endereco, 1, 40)) ds_address,
        max(e.cd_cep)

into STRICT 	ie_disability_ind_w,
	cd_veteran_w,					--- VeteranFileNum
	dt_service_w,					--- RequestIssueDate
	nm_first_w,
	nm_family_w,
	nm_alias_first_w,
	nm_alias_family_w,
	dt_birth_w,
	ie_gender_w,
	ds_address_w,
	nr_postcode_w

from  	conta_paciente a,
	atend_categoria_convenio b,
	atendimento_paciente c,
	pessoa_fisica d,
	compl_pessoa_fisica e,
	convenio f,
	categoria_convenio h
where 	a.nr_interno_conta = nr_seq_account_p
and     a.nr_atendimento =	b.nr_atendimento
and   	b.cd_convenio 	 = f.cd_convenio
and   	f.ie_tipo_convenio  = 13 			-- DVA
and     b.CD_CATEGORIA  = h.CD_CATEGORIA
and     b.cd_convenio   = h.cd_convenio
and   	c.nr_atendimento   = b.nr_atendimento
and   	c.cd_pessoa_fisica = d.cd_pessoa_fisica
and   	d.cd_pessoa_fisica = e.cd_pessoa_fisica
and     F.cd_convenio     = h.cd_convenio;

-- WE NEED TO CHECK WITH CAMILA BECAUSE HOW WILL BE IN THE CASE WHERE THERE IS MORE THEN ONE
select	nextval('dva_claim_seq')
into STRICT  	nr_dva_claim_seq_w
;

if (ie_service_type_w = 'O') then
	dt_referal_w := null;
	ie_referral_override_w := null;
	ref_provider_num_w := null;
end if;

if (ie_service_type_w = 'S') then
	ref_provider_num_w := req_ref_provider_num_w;
	dt_referal_w := dt_ref_req_w;
end if;

 if (ie_service_type_w = 'P') then
	ie_duplicate_w := null;   	-- Hard coded to N;
	req_provider_num_w := req_ref_provider_num_w;
	request_date_w := dt_ref_req_w;
 end if;

 select	max(cd_setor_externo)
 into STRICT	cd_scp_w
 from	setor_atendimento
 where	cd_setor_atendimento =(
				SELECT max(cd_setor_atendimento)
				from procedimento_paciente
				where nr_atendimento =	nr_atendimento_w
				);

/*
	Validation Rule for HospitalInd
	-------------------------------

		Must be a valid value:
			N = Not a patient admitted to hospital(Out-Patient)
			Y = Is a patient admitted to hospital (In-Patient)

		Must be set when TreatmentLocationCde is set to H
		Cannot be set when ServiceTypeCde is set to P

*/




/*
	Validation Rule for ReferralIssueDate
		Must be a valid format:
		yyyy-mm-dd+hh:mm 
		? Must be a valid date
		? Cannot be a date in the future
		? Cannot be after to DateOfService
		? Cannot be prior to patient?s DateOfBirth
		? Cannot be set where ServiceTypeCde is
		set to P or O
		? Must be set if referral details are set
		? Cannot be set with:
		ReferralOverrideTypeCde
		NoOfPatientsSeen
		SelfDeemedCde

*/
if((dt_referal_w IS NOT NULL AND dt_referal_w::text <> '') and ((dt_referal_w > clock_timestamp()) or ((dt_referal_w) < (dt_birth_w)) ))	then
	CALL generate_inco_eclipse(nr_seq_account_p , 1, Wheb_mensagem_pck.get_texto(1107436), nm_usuario_p);
	error_flag_w := 'T';
end if;

/*
		Validdation Rule for ReferralOverrideTypeCde
		? Must be a valid value:
			L = Lost
			E = Emergency
			H = In Hospital
			N = Not required (Non-Referred)
			R = Remote Exemption
			? Must be set if ServiceTypeCde is set to
			S, unless referral details or
			SelfDeemedCde are set
			? Cannot be set where ServiceTypeCde is
			set to P,O,R or D
			? Can only be set to H if
			TreatmentLocationCde is set to H and
			HospitalInd is set to Y
			? Cannot be set with:
			ReferralPeriod
			ReferralPeriodTypeCde
			ReferringProviderNum
			ReferralIssueDate
			SelfDeemedCde
			NoOfPatientsSeen
*/
if (ie_referral_override_w IS NOT NULL AND ie_referral_override_w::text <> '' AND (ie_service_type_w <> 'S'  or ie_adm_type_w <>  'Y'))  	then
	CALL generate_inco_eclipse(nr_seq_account_p , 1, Wheb_mensagem_pck.get_texto(1107437), nm_usuario_p);
	error_flag_w := 'T';
end if;


/* 
		? Must be a valid format
		? Cannot be set to 00 or 99
		? Must be set when
		ReferralPeriodTypeCde is set to N
		? Cannot be set if ReferralPeriodTypeCde
		is set to S or I
		? Cannot be set where ServiceTypeCde is
		set to P or O
		? Must be set if referral details are set
		? Cannot be set with:
		ReferralOverrideTypeCde
		NoOfPatientsSeen

*/
if ((qt_periodo_parecer_w IS NOT NULL AND qt_periodo_parecer_w::text <> '') and (qt_periodo_parecer_w not in ('00' , '99') or (ie_referral_override_w <> 'N' or coalesce(ie_referral_override_w::text, '') = '' )  or ie_service_type_w <> 'S'  )) then
	CALL generate_inco_eclipse(nr_seq_account_p , 1, Wheb_mensagem_pck.get_texto(1107438), nm_usuario_p);
	error_flag_w := 'T';
end if;

		/*
		Must be a valid value:
		S - Standard
		(12 months from a GP or Optometrist
		and 3 months from a Specialist)
		N - Non standard
		I ? Indefinite
		? Cannot be set where ServiceTypeCde is
		set to P or O
		? Must be set if referral details are set
		? Cannot be set with:
		ReferralOverrideTypeCde
		NoOfPatientsSeen
		SelfDeemedCde
		*/
if ((ie_tipo_periodo_w IS NOT NULL AND ie_tipo_periodo_w::text <> '') and (ie_tipo_periodo_w not in ('S' , 'N' , 'I') or ie_service_type_w <> 'S' or  (ie_referral_override_w IS NOT NULL AND ie_referral_override_w::text <> ''))) then

	CALL generate_inco_eclipse(nr_seq_account_p , 1, Wheb_mensagem_pck.get_texto(1107439), nm_usuario_p);
	error_flag_w := 'T';
end if;

/*
		Must be a valid format:
		The Provider Number is comprised of:
		- Provider Stem - a 6-digit number.
		- 1 Practice Location Character (PLV)
		- 1 Check Digit
		(See Appendices for further information)
		? Cannot be set where ServiceTypeCde is
		set to P, or O.
		? Must be set if referral details are set
		Cannot be the same stem as the
		ServicingProviderNum
		? Must be set if ServiceTypeCde is set to
		S, unless ReferralOverrideTypeCde or
		SelfDeemedCde is set
		? Cannot be set with:
		ReferralOverrideTypeCde
		NoOfPatientsSeen
		SelfDeemedCde

*/
if (ref_provider_num_w IS NOT NULL AND ref_provider_num_w::text <> '' AND  ie_service_type_w <> 'S' ) then
	CALL generate_inco_eclipse(nr_seq_account_p , 1, Wheb_mensagem_pck.get_texto(1107440), nm_usuario_p);
	error_flag_w := 'T';
end if;

/*
		RequestingProviderNum

		Must be a valid format:
		The Provider Number is comprised of:
		- Provider Stem - a 6-digit number.
		- 1 Practice Location Character (PLV)
		- 1 Check Digit
		(See Appendices for further information)
		? Must be set if ServiceTypeCde is set to P
		unless SelfDeemedCde is set
		? Must be set if RequestTypeCde or
		RequestIssueDate are set
		? Must not be the same stem (first 6
		numbers) as the ServicingProviderNum
		within the same voucher.
		? Cannot be set when ServiceTypeCde is
		set to S or O
		? Cannot be set with:
		SelfDeemedCde (set to SD)
*/



/*
	? Must be set unless ServiceTypeCde is
	set to P
	? Must be a valid format:
	The DVA File Number contains the
	following fields:
	- State Identifier
	- War Code
	- Numeric Field
	- Dependency indicator
	(See Appendices for further information).
	? Cannot be set to zero(s)

*/
if (ie_service_type_w = 'P' and coalesce(cd_scp_w::text, '') = '' ) then
	CALL generate_inco_eclipse(nr_seq_account_p , 1, Wheb_mensagem_pck.get_texto(1107445), nm_usuario_p);
	error_flag_w := 'T';
end if;

for r01 in c01 loop
	begin

	select	cd_procedimento_loc
	into STRICT   	cd_mbs_code_w
	from   	procedimento
	where  	cd_procedimento = r01.cd_procedimento
	and 	ie_origem_proced = r01.ie_origem_proced;

	dt_accession_w := r01.DT_INICIO_PROCEDIMENTO;

	if (coalesce(cd_mbs_code_w::text, '') = '' ) then
		CALL generate_inco_eclipse(nr_seq_account_p , 1, Wheb_mensagem_pck.get_texto(1104649), nm_usuario_p);
		error_flag_w := 'T';

	end if;
	if (ie_service_type_w <> 'P'  and  (dt_accession_w IS NOT NULL AND dt_accession_w::text <> '')) then

		CALL generate_inco_eclipse(nr_seq_account_p , 1, Wheb_mensagem_pck.get_texto(1107442), nm_usuario_p);
		error_flag_w := 'T';
   	end if;
	if ((r01.dt_atualizacao IS NOT NULL AND r01.dt_atualizacao::text <> '') and coalesce(dt_accession_w::text, '') = '' and ie_service_type_w = 'P' ) then
		CALL generate_inco_eclipse(nr_seq_account_p , 1, Wheb_mensagem_pck.get_texto(1107442), nm_usuario_p);
		error_flag_w := 'T';
   	end if;

	if ((dt_accession_w IS NOT NULL AND dt_accession_w::text <> '') and (dt_accession_w > clock_timestamp() + interval '1 days'))	then
		CALL generate_inco_eclipse(nr_seq_account_p , 1, Wheb_mensagem_pck.get_texto(1107442), nm_usuario_p);
		error_flag_w := 'T';
   	end if;

	if(dt_accession_w IS NOT NULL AND dt_accession_w::text <> '' AND  dt_accession_w < dt_birth_w )	then
		CALL generate_inco_eclipse(nr_seq_account_p , 1, Wheb_mensagem_pck.get_texto(1107442), nm_usuario_p);
		error_flag_w := 'T';
   	end if;

	end;
	end loop;



-- logic to validate fields
for r03 in c03 loop
	begin

        cd_attribute_w := r03.nm_atributo;
        cd_field_name_w := r03.nm_eclipse_field;

        if (UPPER(cd_field_name_w) = UPPER('AuthorisationDate')) then
		if (coalesce(dt_authorisation_w::text, '') = '' ) then
			CALL generate_inco_eclipse(nr_seq_account_p , 1, Wheb_mensagem_pck.get_texto(1104641), nm_usuario_p);
			error_flag_w := 'T';
		end if;

        elsif (UPPER(cd_field_name_w) = UPPER('claimcertifieddate') ) then
		if (coalesce(dt_certified_w::text, '') = '' ) then
			CALL generate_inco_eclipse(nr_seq_account_p , 1, Wheb_mensagem_pck.get_texto(1104642), nm_usuario_p);
			error_flag_w := 'T';
		end if;

        elsif ( UPPER(cd_field_name_w) = UPPER('claimcertifiedind') ) then
		if (coalesce(ie_certified_w::text, '') = '' ) then
			CALL generate_inco_eclipse(nr_seq_account_p , 1, Wheb_mensagem_pck.get_texto(1104643), nm_usuario_p);
			error_flag_w := 'T';

		end if;

        elsif ( UPPER(cd_field_name_w) = UPPER('payeeprovidernum') ) then
		if (coalesce(cd_payee_provider_w::text, '') = '' ) then
			CALL generate_inco_eclipse(nr_seq_account_p , 1, Wheb_mensagem_pck.get_texto(1104644), nm_usuario_p);
			error_flag_w := 'T';

		end if;

        elsif ( UPPER(cd_field_name_w) = UPPER('servicingprovidernum') ) then
		if ( coalesce(cd_provider_w::text, '') = '' ) then
			CALL generate_inco_eclipse(nr_seq_account_p , 1, Wheb_mensagem_pck.get_texto(1100198), nm_usuario_p);
			error_flag_w := 'T';
		end if;

        elsif ( UPPER(cd_field_name_w) = UPPER('accepteddisabilityind') ) then
		if ( coalesce(ie_disability_ind_w::text, '') = '' ) then
			CALL generate_inco_eclipse(nr_seq_account_p , 1, Wheb_mensagem_pck.get_texto(1104645), nm_usuario_p);
			error_flag_w := 'T';
		end if;

	elsif ( UPPER(cd_field_name_w) = UPPER('dateofservice') ) then
		if ( coalesce(dt_service_w::text, '') = '' ) then
			CALL generate_inco_eclipse(nr_seq_account_p , 1, Wheb_mensagem_pck.get_texto(1104647), nm_usuario_p);
			error_flag_w := 'T';
		end if;

	elsif ( UPPER(cd_field_name_w) = UPPER('veteranfilenum') ) then
		if ( coalesce(cd_veteran_w::text, '') = '' and ie_service_type_w <> 'P' ) then
			CALL generate_inco_eclipse(nr_seq_account_p , 1, Wheb_mensagem_pck.get_texto(1104648), nm_usuario_p);
			error_flag_w := 'T';
		end if;

        elsif ( UPPER(cd_field_name_w) = UPPER('patientdateofbirth') ) then
		if ( coalesce(dt_birth_w::text, '') = '' ) then
			CALL generate_inco_eclipse(nr_seq_account_p , 1, Wheb_mensagem_pck.get_texto(1101291), nm_usuario_p);
			error_flag_w := 'T';
		end if;

        elsif ( UPPER(cd_field_name_w) = UPPER('patientfamilyname') ) then
		if ( coalesce(nm_family_w::text, '') = '' ) then
			CALL generate_inco_eclipse(nr_seq_account_p , 1, Wheb_mensagem_pck.get_texto(1101292), nm_usuario_p);
			error_flag_w := 'T';
		end if;

        elsif ( UPPER(cd_field_name_w) = UPPER('patientfirstname') ) then
		if ( coalesce(nm_first_w::text, '') = '' ) then
			CALL generate_inco_eclipse(nr_seq_account_p , 1, Wheb_mensagem_pck.get_texto(1101293), nm_usuario_p);
			error_flag_w := 'T';
		end if;

        end if;

	end;
end loop;
if (coalesce(error_flag_w::text, '') = '' and ie_validation = 'F') then

	insert into dva_claim(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		cd_estabelecimento,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		dt_authorisation,
		dt_certified,
		ie_certified,
		cd_payee_provider,
		cd_claim,
		ie_service_type,
		cd_provider,
		nr_seq_transaction,
		cd_tasy_claim,
		ie_status,
		nr_interno_conta)
	values (nr_dva_claim_seq_w,
		clock_timestamp(),
		nm_usuario_p,
		cd_estabelecimento_p,
		null,
		null,
		dt_authorisation_w,
		dt_certified_w,
		ie_certified_w,
		cd_payee_provider_w,
		cd_claim_w,
		ie_service_type_w,
		cd_provider_w,
		cd_transaction_id,
		cd_tasy_claim_w,
		null,
		nr_seq_account_p);

	--	cd_service_code_w := 0;
		nr_voucher_count_w := 0;

		curr_cd_medico_resp_w := cd_provider_w;


--AfterCareOverrideInd
select	max(a.cd_motivo_alta)
into STRICT	cd_motivo_alta_w
from	atendimento_paciente a, motivo_alta b, conta_paciente c
where	a.cd_motivo_alta = b.cd_motivo_alta
and	c.nr_atendimento = a.nr_atendimento
and    	c.nr_interno_conta = nr_seq_account_p;

select	coalesce(max(CASE WHEN ie_contato_alta='S' THEN 'Y'  ELSE 'N' END ),'N')
into STRICT	ie_aftercare_w
from 	motivo_alta
where  	cd_motivo_alta =  cd_motivo_alta_w;

for r01 in c01 loop
begin

	if (coalesce(voucher_date_w::text, '') = '' or (TO_CHAR( voucher_date_w, 'YYYY-MM-DD' ) <> TO_CHAR( r01.DT_PROCEDIMENTO, 'YYYY-MM-DD' ))) then
  		new_voucher_ind_w := 1;
		voucher_date_w := r01.DT_PROCEDIMENTO;
		if (coalesce(r01.DT_PROCEDIMENTO::text, '') = '') then
			voucher_date_w := dt_service_w;
		end if;
	end if;
	 
	if (new_voucher_ind_w <> 1) then
			If (r01.cd_medico_resp IS NOT NULL AND r01.cd_medico_resp::text <> '' AND  r01.cd_medico_resp <> cd_provider_w ) THEN
				curr_cd_medico_resp_w :=r01.cd_medico_resp;
				new_voucher_ind_w := 1;

			ELSIF ( coalesce(r01.cd_medico_resp::text, '') = '' ) THEN
				if (curr_cd_medico_resp_w <> cd_provider_w) then
			--		new_voucher_ind_w := 1;
					curr_cd_medico_resp_w := cd_provider_w;
				end if;

			END IF;

	end if;
      
	select max(coalesce((SUBSTR(r01.DS_OBSERVACAO, 24, 2))::numeric , 1))
	into STRICT qt_patients_w
	
	where upper(SUBSTR(r01.DS_OBSERVACAO , 1,23)) = upper('Number of patient seen ');

	if (ie_disability_ind_w = 'Y') then
		ds_disability_w := r01.DS_OBSERVACAO;
	end if;

	select  max(CASE WHEN a.cd_setor_entrega=50 THEN 'SD'  WHEN a.cd_setor_entrega=37 THEN 'SS'  WHEN a.cd_setor_entrega=44 THEN 'SN'  ELSE null END  ) ,     	--selfdeemed
		max(CASE WHEN a.ie_aprovacao_execucao='S' THEN 'Y'  ELSE 'N' END  ), 	-- Rule 3 excemption
		max(CASE WHEN a.ie_urgencia='S' THEN 'Y'  ELSE 'N' END ), 			-- rule s4b3
		max(a.qt_procedimento),
		max(CASE WHEN a.IE_EXECUTAR_LEITO='S' THEN 'Y'  END ),
		max(CASE WHEN coalesce(a.nr_seq_topografia::text, '') = '' THEN 'N'  ELSE 'Y' END ),
    max((NR_CONTROLE_EXT)::numeric )
	into STRICT	ie_selfdeemed_w,
		ie_rule_w,
		ie_s4b3_w,
		qt_procedure_count_w,
		ie_duplicate_w,
		ie_multiple_procedure_w,
    qt_distance_w

	from	prescr_procedimento a ,
		prescr_medica b ,
		atendimento_paciente c ,
		conta_paciente d

	where	d.nr_interno_conta = nr_seq_account_p   -- :conta_pat
	and  	a.cd_procedimento  = r01.cd_procedimento
	and   	d.nr_atendimento   = c.nr_atendimento
	and   	b.nr_atendimento   = c.nr_atendimento
	and   	b.nr_prescricao    = a.nr_prescricao;

	IF( ( MOD(cd_service_code_w, 14) = 0 and cd_service_code_w <> 0 ) OR new_voucher_ind_w = 1  or ie_selfdeemed_w = 'SD') THEN
		--		cd_service_code_w := 0;
		new_voucher_ind_w := 0;

		nr_voucher_count_w := nr_voucher_count_w + 1;
		if (nr_voucher_count_w > 80) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort('Too many services are added in one claim - more than 80 vouchers are not allowed in one claim please split the claims');
		end if;
		select 	nextval('dva_voucher_seq'),
			Lpad(nr_voucher_count_w, 2, '0')
		into STRICT  	nr_dva_voucher_seq_w, nr_voucher_w
		;


--  if(ie_multiple_procedure_w = 'N' or ie_duplicate_w ='N' ) then 

--  

--  end if;
		 if (ie_service_type_w = 'P') then
			ie_duplicate_w := null;   	
		 end if;

		select	count(*)
		into STRICT 	nr_procedure_w
		from 	DVA_SERVICE a , dva_voucher b
		where 	a.NR_SEQ_VOUCHER = b.nr_sequencia
		and   	a.CD_ITEM = (SELECT	cd_procedimento_loc
					from	procedimento
					where  	cd_procedimento = r01.cd_procedimento
					and 	ie_origem_proced = r01.ie_origem_proced);

--	if(qt_procedure_count_w > 1 and nr_procedure_w > 1 ) then

--		ie_multiple_procedure_w := 'Y';

--	else

--		ie_multiple_procedure_w := 'N';

--	end if;
               if ((ie_selfdeemed_w IS NOT NULL AND ie_selfdeemed_w::text <> '') and (ie_selfdeemed_w not in ('SD' , 'SS','NN'))) then
                              CALL generate_inco_eclipse(nr_seq_account_p, 1, 'invalid selfdeemed code', nm_usuario_p);
               end if;

               if (ie_selfdeemed_w  = 'SD' and ((cd_medic_w IS NOT NULL AND cd_medic_w::text <> '') or  (cd_person_opinion_w IS NOT NULL AND cd_person_opinion_w::text <> ''))) then
                              CALL generate_inco_eclipse(nr_seq_account_p, 1, 'invalid selfDeemed value', nm_usuario_p);
               end if;

               if (ie_selfdeemed_w  = 'SS' and ( (ie_referral_period_w IS NOT NULL AND ie_referral_period_w::text <> '') or (ie_referral_period_w IS NOT NULL AND ie_referral_period_w::text <> '') or (cd_medic_w IS NOT NULL AND cd_medic_w::text <> '') or (dt_referal_w IS NOT NULL AND dt_referal_w::text <> '') )) then
                              CALL generate_inco_eclipse(nr_seq_account_p, 1, 'invalid selfDeemed value', nm_usuario_p);
               end if;

               if ((ie_rule_w IS NOT NULL AND ie_rule_w::text <> '') and (ie_rule_w not in ('Y' ,'N'))) then
                              CALL generate_inco_eclipse(nr_seq_account_p, 1, 'invalid rule 3 exemption indication', nm_usuario_p);
               end if;

               if (ie_rule_w IS NOT NULL AND ie_rule_w::text <> '' AND ie_service_type_w <> 'P' and ie_rule_w ='Y' ) then
                              CALL generate_inco_eclipse(nr_seq_account_p, 1, 'invalid rule 3 exemption indication - cannot be set with Pathology service type', nm_usuario_p);
               end if;

--               if(ie_rule_w = 'Y' and r01.qt_duracao is null) then

--                              generate_inco_eclipse(nr_seq_account_p, 1, 'invalid rule indication', nm_usuario_p);

--               end if;
               if (ie_rule_w = 'Y' and ie_s4b3_w = 'Y') then
                              CALL generate_inco_eclipse(nr_seq_account_p, 1, 'invalid rule indication', nm_usuario_p);
               end if;
               if ((ie_s4b3_w IS NOT NULL AND ie_s4b3_w::text <> '') and (ie_s4b3_w not in ('Y' ,'N'))) then
                              CALL generate_inco_eclipse(nr_seq_account_p, 1, 'invalid S4b3ExemptInd', nm_usuario_p);
               end if;
               if (ie_s4b3_w IS NOT NULL AND ie_s4b3_w::text <> '' AND ie_service_type_w <> 'P' and ie_s4b3_w ='Y' ) then
                              CALL generate_inco_eclipse(nr_seq_account_p, 1, 'invalid S4b3ExemptInd', nm_usuario_p);
               end if;


               

--IE_REFERRAL_PERIOD_w :='S';
		if ((ie_referral_override_w IS NOT NULL AND ie_referral_override_w::text <> '') or ie_selfdeemed_w ='SD' ) then 
		ref_provider_num_w := null;
		dt_referal_w := null;
		req_provider_num_w :=null;
		request_date_w :=null;
		IE_REFERRAL_PERIOD_w := null;
		end if;

if (coalesce(voucher_date_w::text, '') = '') then
  voucher_date_w := dt_service_w;
end if;
--if(cd_location_w = 'H') then

--cd_location_w := 'V';

--else 

--cd_location_w := 'H';

--end if;
cd_location_w := 'H';
--if(nr_voucher_w =2) then

--   ds_address_w :='12 FELICIA GR';

--   nr_postcode_w :='4216';

--   	nm_alias_family_w := null;

--						nm_alias_first_w :=null;

--						dt_birth_w :=TO_DATE('1968/12/19', 'yyyy/mm/dd');

--						nm_family_w := 'ROBERTA';

--						ie_gender_w := 'M';

--						nm_first_w := 'PEDRO';

--            cd_veteran_w := 'QX901583';

--					

--   

--end if;

--

--if(nr_voucher_w =3) then

--   ds_address_w :='27 GRAHAM ST';

--   nr_postcode_w :='6770';

--   	nm_alias_family_w :=null;

--						nm_alias_first_w :=null;

--						dt_birth_w :=TO_DATE('1950/03/31', 'yyyy/mm/dd');

--						nm_family_w := 'MERLIN';

--						ie_gender_w := 'M';

--						nm_first_w := 'ALVIN';

--            cd_veteran_w := 'WX901256';

--					

--   

--end if;
		insert into dva_voucher(nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_claim,
						ie_disability,
						ds_disability,
						dt_service,
						ds_address,
						ie_hospital,
						nr_postcode,
						nm_alias_family,
						nm_alias_first,
						dt_birth,
						nm_family,
						ie_gender,
						nm_first,
						dt_referral,
						ie_referral_override,
						qt_period,
						cd_referring,
						cd_requesting,
						dt_request,
						cd_location,
						cd_veteran,
						nr_voucher,
						nr_time_service,
						IE_REFERRAL_PERIOD)
					values (nr_dva_voucher_seq_w,
						clock_timestamp(),
						nm_usuario_p,
						null,
						null,
						nr_dva_claim_seq_w,
						ie_disability_ind_w, 				--ie_disability
						ds_disability_w, 				-- ds_disability
						voucher_date_w,
						ds_address_w,
						'Y',--ie_adm_type_w, 
						nr_postcode_w,
						nm_alias_family_w, 
						nm_alias_first_w,
						dt_birth_w,
						nm_family_w,
						ie_gender_w, 
						nm_first_w, 
						CASE WHEN ie_service_type_w ='S' THEN dt_referal_w  ELSE null END ,	-- dt_referral
						ie_referral_override_w, 	-- ie_referral_override
						NR_REFERRAL_MONTHS_W,				-- qt_period
						CASE WHEN ie_service_type_w ='S' THEN ref_provider_num_w   ELSE null END , 		-- cd_referring
						CASE WHEN ie_service_type_w ='P' THEN req_provider_num_w   ELSE null END ,       -- cd_requesting
						CASE WHEN ie_service_type_w ='P' THEN request_date_w  ELSE null END , 			-- dt_request
						cd_location_w, 				-- cd_location  
						cd_veteran_w,
						nr_voucher_w, 				-- nr_voucher
						dt_service_w,--	to_number(to_char(dt_service_w, 'HH24MI')),				-- nr_time_service
						IE_REFERRAL_PERIOD_w
						);
	END IF;


	cd_service_code_w := 	cd_service_code_w + 1;
	is_found_rec := true;
	dt_accession_w := r01.DT_INICIO_PROCEDIMENTO;


	select 	cd_procedimento_loc,
		lpad(cd_service_code_w, 4, '0')
	into STRICT   	cd_mbs_code_w,
		service_count_number
	from   procedimento
	where  cd_procedimento = r01.cd_procedimento
	and 	 ie_origem_proced = r01.ie_origem_proced;

	if((r01.vl_procedimento IS NOT NULL AND r01.vl_procedimento::text <> '') and r01.vl_procedimento > 0) then
		qt_distance_w := null;
	ELSIF (r01.vl_procedimento = 0) then
	    r01.vl_procedimento :=null;
	end if;


	select	max(cd_imobilizado_ext)
	into STRICT	nr_lsp_w
	from	equipamento
	where	cd_equipamento = r01.cd_equipamento;

--  if(ie_rule_w = 'Y' or ie_s4b3_w ='Y') then
   dt_collection_w := r01.DT_PROCEDIMENTO;
--  end if; 
	insert into dva_service(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		dt_accession,
		cd_equipament,
		qt_service,
		cd_item,
		nr_lsp,
		ie_multiple,
		qt_patients,
		ie_rule,
		nr_account,
		ie_aftercare,
		vl_charge,
		dt_collection,
		qt_distance,
		ie_duplicate,
		cd_scp, 
		ie_selfdeemed,
		cd_service,
		ds_service,
		ie_s4b3,
		nr_seq_voucher)
	values (nextval('dva_service_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		null,
		dt_accession_w,
		r01.cd_equipamento,
		r01.QT_PROCEDIMENTO,
		cd_mbs_code_w,
		nr_lsp_w,
		ie_multiple_procedure_w,	 		-- ie_multiple
		qt_patients_w,
		ie_rule_w, 			-- ie_rule
		nr_seq_account_p,
		ie_aftercare_w,--'N', 			--aftercare
		r01.vl_procedimento,
		dt_collection_w,	--dt_collection,
		qt_distance_w,		--qt_distance
		ie_duplicate_w,		--ie_duplicate,
		cd_scp_w,		--cd_scp
		ie_selfdeemed_w,			--ie_selfdeemed
		service_count_number,	--cd_service
		r01.DS_OBSERVACAO,			--ds_service
		ie_s4b3_w,			--ie_s4b3
		nr_dva_voucher_seq_w);

		commit;

end;
end loop;
		
if not is_found_rec  then
	CALL generate_inco_eclipse(nr_seq_account_p , 1, Wheb_mensagem_pck.get_texto(1104649), nm_usuario_p);
	error_flag_w := 'T';
end if;
end if;
commit;

select	nextval('eclipse_claim_history_seq')
into STRICT	nr_seq_history_claim_w
;

cd_transaction_p :=cd_transaction_id;
insert	into	eclipse_claim_history(
		nr_sequencia	,
		nm_usuario	,
		dt_atualizacao 	,
		ds_historico	,
		nr_interno_conta
	)
values (
		nr_seq_history_claim_w,
		nm_usuario_p,
		clock_timestamp(),
		wheb_mensagem_pck.get_texto(1105901) ,
		nr_seq_account_p
	);
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dva_claim_request (nm_usuario_p text, cd_estabelecimento_p bigint, ie_service_type_p text, nr_seq_account_p bigint, nr_interno_conta_p bigint, ie_resubmission_p text default 'N', ie_validation text default 'F', cd_transaction_p INOUT text DEFAULT NULL) FROM PUBLIC;
