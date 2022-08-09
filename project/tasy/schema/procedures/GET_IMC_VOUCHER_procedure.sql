-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE get_imc_voucher ( nr_seq_claim_p imc_claim.nr_sequencia%type, nm_usuario_p imc_claim.nm_usuario%type, ie_validate_p text, nr_seq_account_p bigint, ie_imc_type_p text) AS $body$
DECLARE


nr_seq_w			imc_voucher.nr_sequencia%type;
dt_admission_w			atendimento_paciente.dt_entrada%type;
dt_discharge_w			atendimento_paciente.dt_alta%type;
dt_birth_w			pessoa_fisica.dt_nascimento%type;
nm_first_w			imc_voucher.nm_first%type;
nm_family_w			imc_voucher.nm_family%type;
cd_fund_card_w			imc_voucher.cd_fund_card%type;
cd_upi_w			imc_voucher.cd_upi%type;
ie_gender_w			pessoa_fisica.ie_sexo%type;
nm_second_w			imc_voucher.nm_second%type;
nr_atendimento_w		atendimento_paciente.nr_atendimento%type;
dt_atualizacao_nrec_w		parecer_medico_req.dt_atualizacao_nrec%type;
nr_seq_account_w		imc_claim.nr_seq_account%type;
nr_seq_person_name_w		pessoa_fisica.nr_seq_person_name%type;
cd_estabelecimento_w		imc_claim.cd_establishment%type;
ie_financial_interest_w		imc_voucher.ie_financial_interest%type;
cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;
nr_seq_tipo_parecer_w		parecer_medico_req.nr_seq_tipo_parecer%type;
cd_medico_w			parecer_medico_req.cd_medico%type;
cd_pessoa_parecer_w		parecer_medico_req.cd_pessoa_parecer%type;
nr_seq_classificacao_w		atendimento_paciente.nr_seq_classificacao%type;
nr_provider_w			medical_provider_number.nr_provider%type;
ie_ifc_w			imc_voucher.ie_ifc%type := null;
nm_alias_family_w		imc_voucher.nm_alias_family%type;
nm_alias_first_w		imc_voucher.nm_alias_first%type;
dt_service_min_w		procedimento_paciente.dt_procedimento%type;
dt_service_max_w		procedimento_paciente.dt_procedimento%type;
medico_resp_w			atendimento_paciente.cd_medico_resp%type;
nr_records_w			integer;
cd_voucher_id_w			imc_voucher.cd_voucher_id%type;
ie_imc_type_w			eclipse_parameters.ie_imc_type%type;
cd_medicare_card_w		atend_categoria_convenio.cd_usuario_convenio%type;
ie_service_type_w		imc_voucher.ie_service_type%type;
qt_voucher_w			integer;
nr_patient_ref_w		imc_voucher.nr_patient_ref%type;
qt_period_w 			bigint;
ie_fund_cde_w 			varchar(1);
ie_request_type_w 		varchar(1);

---------------------------------
vl_charge_w			imc_service.vl_charge%type;
cd_provider_w			imc_voucher.cd_provider%type;
qt_service_w			imc_service.qt_service%type;
nr_lsp_w			imc_service.nr_lsp%type;
dt_accession_w			imc_service.dt_accession%type;
cd_medico_executor_w		medical_provider_number.cd_medico%type;
dt_service_w			procedimento_paciente.dt_procedimento%type;
dt_collection_w			prescr_proc_peca.dt_atualizacao_nrec%type;
qt_item_w			integer;
has_proc_w			integer;
contador_w			integer := 0;
cd_service_id_w			varchar(5);--pls_integer;
cd_mbs_code_w              	varchar(5);
nr_service_count_w             	bigint :=0;
nr_seq_service_w        	bigint;
cd_current_ser_provi_w    	varchar(10);
new_voucher_ind_w 		bigint;
qt_patients_w 			imc_service.qt_patients%type;
cd_qt_pat_w 			varchar(10);

ie_referral_period_w            varchar(1);
cd_referring_tw 		varchar(15);
ie_hospital_w 			varchar(1) :='Y';
dt_referral_tw  		timestamp;
cd_requesting_tw 		varchar(15);
dt_request_tw   		timestamp;
ie_referral_period_tw 		varchar(5);
ie_rule_w	           	imc_service.ie_rule%type;
ie_restrictive_w    		varchar(2);
ie_aftercare_w   	        varchar(1);
ie_selfdeemed_w		        imc_service.ie_selfdeemed%type;
ie_s4b3_w			imc_service.ie_s4b3%type;
cd_medic_w			parecer_medico_req.cd_medico%type;
ie_specialist_w			varchar(10) := 'N';
nr_seq_ext_doc_w	        bigint;
dt_referral_w                   timestamp;
cd_referring_w                  varchar(8);
cd_requesting_w                 varchar(8);
dt_validate_w		        timestamp;
dt_request_w                    timestamp;
ie_multiple_procedure_w   	varchar(1);
ie_duplicate_w		        imc_service.ie_duplicate%type;
qt_procedure_count_w		bigint;
cd_equipamento_w  		varchar(10);
dt_ref_req_w 			timestamp;
req_ref_provider_num_w 		medical_provider_number.nr_provider%type;
ie_referral_override_w          varchar(1);
nr_voucher_seq_w	        imc_voucher.nr_sequencia%type;
general_procedures_w   		varchar(400);
specialist_procedures_w  	varchar(400);
pathology_procedures_w 		varchar(400);
nr_Service_count_W1 		bigint;
cd_claimant_w     		varchar(10);
------------------------------------------------------
c01 CURSOR FOR

SELECT	a.nr_sequencia,
    coalesce(cd_medico_executor, medico_resp_w) as cd_medico_executor,
		(coalesce(a.vl_procedimento,0) * 100) vl_procedimento,
		a.dt_procedimento,
		a.cd_equipamento,
		coalesce(a.cd_procedimento, 0) cd_procedimento,
		a.ie_origem_proced,
		a.ds_observacao,
		trunc((a.dt_final_procedimento - a.dt_inicio_procedimento)* (24 * 60)) qt_duracao,
		substr(b.cd_setor_externo,0,5) cd_setor_externo,
		COUNT(a.nr_sequencia) OVER () qt_item_w

from	procedimento_paciente a,
		setor_atendimento b
where	a.nr_interno_conta		= nr_seq_account_p
and		a.cd_setor_atendimento	= b.cd_setor_atendimento
order by  vl_procedimento desc,   cd_medico_executor, a.dt_procedimento  ,  a.cd_procedimento;
c01_w	c01%rowtype;


BEGIN

	CALL billing_i18n_pck.set_validate_eclipse(ie_validate_p);

	select max(cd_establishment)
	into STRICT cd_estabelecimento_w
	from	imc_claim
	where	nr_sequencia = nr_seq_claim_p;

	nr_seq_account_w := nr_seq_account_p;

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
	--ie_service_type_w := 'S';
	select 	coalesce(max(ie_imc_type), 0)
	into STRICT	ie_imc_type_w
	from 	eclipse_parameters
	where	cd_estabelecimento = obter_estabelecimento_ativo;
	ie_imc_type_w := ie_imc_type_p;

	select	max(a.dt_entrada),
		max(a.dt_alta),
		max(c.nr_seq_person_name),
		max(c.dt_nascimento),
		max(c.ie_sexo),
		max(a.nr_atendimento),
		max(c.cd_pessoa_fisica),
		max(a.nr_seq_classificacao),
		max(a.cd_medico_resp),
		max(a.NR_SEQ_TIPO_LESAO)
	into STRICT	dt_admission_w,
		dt_discharge_w,
		nr_seq_person_name_w,
		dt_birth_w,
		ie_gender_w,
		nr_atendimento_w,
		cd_pessoa_fisica_w,
		nr_seq_classificacao_w,
		medico_resp_w,
		ie_fund_cde_w
	from	atendimento_paciente a,
		conta_paciente b,
		pessoa_fisica c
	where	a.nr_atendimento = b.nr_atendimento
	and	a.cd_pessoa_fisica = c.cd_pessoa_fisica
	and	b.nr_interno_conta = nr_seq_account_p;

	select	min(dt_procedimento),
		max(dt_procedimento)
	into STRICT	dt_service_min_w,
		dt_service_max_w
	from	procedimento_paciente
	where	nr_interno_conta = nr_seq_account_p;

	SELECT	max(a.cd_usuario_convenio),
		max(a.cd_complemento)
	into STRICT	cd_fund_card_w,
		cd_upi_w
	FROM   	atend_categoria_convenio a,
		convenio b ,
		conta_paciente c,
		atendimento_paciente x
	WHERE  	a.cd_convenio = b.cd_convenio
		and    c.nr_atendimento = x.nr_atendimento
		and    a.nr_atendimento = x.nr_atendimento
		and  c.nr_interno_conta  = nr_seq_account_p
		and b.ie_tipo_convenio <> 12;

    -- MEDICARE DETAILS
	SELECT 	max(a.cd_usuario_convenio),
		max(a.cd_complemento)
	into STRICT	cd_medicare_card_w,
		nr_patient_ref_w
	FROM	atend_categoria_convenio a,
		convenio b ,
		conta_paciente c,
		atendimento_paciente x
	WHERE   a.cd_convenio = b.cd_convenio
        and    	c.nr_atendimento = x.nr_atendimento
        and   	a.nr_atendimento = x.nr_atendimento
        and  	c.nr_interno_conta  = nr_seq_account_p
        AND 	b.ie_tipo_convenio = 12;

	select	max(a.dt_atualizacao_nrec),
		max(a.nr_seq_tipo_parecer),
		max(a.cd_pessoa_parecer)
	into STRICT	dt_atualizacao_nrec_w,
		nr_seq_tipo_parecer_w,
		cd_pessoa_parecer_w
	from 	parecer_medico_req a
	where	a.nr_atendimento = nr_atendimento_w;
	--ie_service_type_w := 'P';
    -------------------Voucher------------
	select	max(a.dt_referencia),
		max((select max(Lpad(substr(k.nr_provider, 1,8),8,'0'))
    		from 	medical_provider_number k
		where 	k.cd_medico = a.cd_medico )) as ref_provider_num,
		max(a.dt_validade),
		max(a.ie_type_code)
            --decode(ie_service_type_w , 'S' , null)
	into STRICT 	dt_ref_req_w,  		---- ReferralIssueDate
		req_ref_provider_num_w,   	---- RequestingProviderNum
		dt_validate_w,		---- Validate date
		ie_referral_override_w  -- referral override indicator
	from	atendimento_paciente_inf a,
		conta_paciente b
	where 	b.nr_interno_conta = nr_seq_account_p
        and	a.nr_atendimento = b.nr_atendimento;

            ------------------------
        if (ie_service_type_w = 'S') then
		cd_referring_w := req_ref_provider_num_w;
		dt_referral_w := dt_ref_req_w;
		cd_requesting_w := null;
		dt_request_w := null;
	end if;

	if (ie_service_type_w = 'P') then

		cd_requesting_w := req_ref_provider_num_w;
		dt_request_w := dt_ref_req_w;
		cd_referring_w := null;
		dt_referral_w := null;
	end if;


    --AfterCareOverrideInd
	select	CASE WHEN max(b.ie_contato_alta)='S' THEN 'Y'   ELSE 'N' END
        into STRICT	ie_aftercare_w
	from	atendimento_paciente a, motivo_alta b, conta_paciente c
	where	a.cd_motivo_alta = b.cd_motivo_alta
        and	c.nr_atendimento = a.nr_atendimento
        and	c.nr_interno_conta = nr_seq_account_p;

	cd_referring_tw := cd_referring_w;
	dt_referral_tw := dt_referral_w;
	cd_requesting_tw := cd_requesting_w;
	dt_request_tw := dt_request_w;
	ie_referral_period_tw :=ie_referral_period_w;

	if ((nr_seq_tipo_parecer_w IS NOT NULL AND nr_seq_tipo_parecer_w::text <> '') or ie_selfdeemed_w ='SD' ) then
		cd_referring_w := null;
		dt_referral_w := null;
		cd_requesting_w :=null;
		ie_referral_period_w := null;
		dt_request_w :=null;
	else
		cd_referring_w := cd_referring_tw;
		dt_referral_w := dt_referral_tw;
		cd_requesting_w := cd_requesting_tw;
		dt_request_w := dt_request_tw;
		ie_referral_period_w :=ie_referral_period_tw;
	end if;

	select	max(c.nr_seq_tipo_medico)
        into STRICT	nr_seq_ext_doc_w
	from 	conta_paciente a,
		atendimento_paciente b,
		pf_medico_externo c
	where 	a.nr_interno_conta = nr_seq_account_p
        and 	a.nr_atendimento = b.nr_atendimento
        and 	b.cd_medico_resp = c.cd_medico;

	if (coalesce(nr_seq_ext_doc_w::text, '') = '') then
        --	ie_specialist_w := 'SP'; -- if type is not set then consider as general physician
		select 	max(cd_especialidade)
                into STRICT 	ie_specialist_w
		from 	conta_paciente a,
			atendimento_paciente b,
			medico_especialidade c
		where 	a.nr_interno_conta = nr_seq_account_p
		and 	a.nr_atendimento = b.nr_atendimento
		and 	c.cd_pessoa_fisica = b.cd_medico_resp;
	else
		select 	coalesce(max(m.ie_medico_familia) ,'SP')
		into STRICT	ie_specialist_w
		from 	tipo_medico_externo m
		where 	m.nr_sequencia = nr_seq_ext_doc_w;
	end if;

	select	CASE WHEN coalesce(ie_specialist_w::text, '') = '' THEN  'GP'  WHEN ie_specialist_w='S' THEN 'GP'  WHEN ie_specialist_w='N' THEN 'SP'  ELSE 'SP' END
        into STRICT 	ie_specialist_w
;

	if ( ie_service_type_w = 'S' and (dt_referral_w IS NOT NULL AND dt_referral_w::text <> '') ) then
    	/*
        	if we set the value of ReferralOverrideTypeCde , value of ReferralPeriodTypeCde should be null;
    	*/
		if (coalesce(dt_validate_w::text, '') = '') then
			ie_referral_period_w := 'I';  -- Indifinate
		elsif (pkg_date_utils.get_diffdate(dt_referral_w, dt_validate_w, 'MONTH') <= 3 and ie_specialist_w = 'SP') then
		ie_referral_period_w := 'S';
		elsif (pkg_date_utils.get_diffdate(dt_referral_w, dt_validate_w, 'MONTH') <= 12 and ie_specialist_w = 'GP') then
			ie_referral_period_w := 'S';
		elsif (pkg_date_utils.get_diffdate(dt_referral_w, dt_validate_w, 'MONTH') >= 3 and ie_specialist_w = 'SP') then
			ie_referral_period_w := 'N';
		select pkg_date_utils.get_diffdate(dt_referral_w, dt_validate_w, 'MONTH') into STRICT QT_PERIOD_W;
		elsif (pkg_date_utils.get_diffdate(dt_referral_w, dt_validate_w, 'MONTH') >= 12 and ie_specialist_w = 'GP') then
		select pkg_date_utils.get_diffdate(dt_referral_w, dt_validate_w, 'MONTH') into STRICT QT_PERIOD_W;
			ie_referral_period_w := 'N';
		end if;
	end if;


	if (nr_seq_tipo_parecer_w IS NOT NULL AND nr_seq_tipo_parecer_w::text <> '') then
		cd_referring_w := null;
		dt_referral_w := null;
		cd_requesting_w :=null;
		dt_request_w :=null;
		ie_referral_period_w :=null;
	end if;

	nm_first_w := pkg_name_utils.get_person_name(nr_seq_person_name_w,cd_estabelecimento_w,'givenName');
	nm_family_w := pkg_name_utils.get_person_name(nr_seq_person_name_w,cd_estabelecimento_w,'familyName');
	nm_second_w	:= substr(pkg_name_utils.get_person_name(nr_seq_person_name_w,cd_estabelecimento_w,'middleName'),1,1);
	nm_alias_family_w := pkg_name_utils.Get_person_name(nr_seq_person_name_w,cd_estabelecimento_w,'familyName', 'social');
	nm_alias_first_w := pkg_name_utils.Get_person_name(nr_seq_person_name_w, cd_estabelecimento_w, 'givenName', 'social');

	if ( ie_imc_type_p<> 'MO' and (cd_medicare_card_w = 0 or coalesce(cd_medicare_card_w::text, '') = '')) then

		CALL generate_inco_eclipse(nr_seq_account_p, 1, obter_desc_expressao(632283), nm_usuario_p);

	end if;

	if ( ie_imc_type_p<> 'MO' and (nr_patient_ref_w = 0 or coalesce(nr_patient_ref_w::text, '') = '')) then

		CALL generate_inco_eclipse(nr_seq_account_p, 1, obter_desc_expressao(534894), nm_usuario_p);

	end if;

	if (coalesce(ie_service_type_w::text, '') = '') then

		CALL generate_inco_eclipse(nr_seq_account_p, 1, obter_desc_expressao(798395), nm_usuario_p);

	end if;

	if (ie_imc_type_w = 'PC') then

		select	count(distinct coalesce(cd_medico_executor, medico_resp_w))
		into STRICT	qt_voucher_w
		from	procedimento_paciente
		where	nr_interno_conta = nr_seq_account_p;

		if (qt_voucher_w > 1) then

			CALL generate_inco_eclipse(nr_seq_account_p, 1, obter_desc_expressao(775617) || ' '
			|| obter_desc_expressao(862254) || ' ' || obter_desc_expressao(722393), nm_usuario_p); --- cadastrar uma mensagem mais adequada Requires information. Only once Executing physician
		end if;

	end if;

	if (ie_imc_type_w = 'SC') then

		ie_financial_interest_w := 'true';
		ie_ifc_w := 'X';
	else
		ie_financial_interest_w :=  null;

	end if;

	if (ie_imc_type_w = 'AG') then

		ie_ifc_w := 'W';

	end if;

	if (coalesce(nm_first_w::text, '') = '' or coalesce(nm_family_w::text, '') = '') then

		CALL generate_inco_eclipse(nr_seq_account_p, 1, obter_desc_expressao(591289), nm_usuario_p);

	end if;

	if (dt_discharge_w > clock_timestamp()) then

		CALL generate_inco_eclipse(nr_seq_account_p, 3, obter_desc_expressao(512522), nm_usuario_p);

	elsif (dt_discharge_w < dt_admission_w) then

		CALL generate_inco_eclipse(nr_seq_account_p, 3, obter_desc_expressao(651270), nm_usuario_p);

	elsif (dt_discharge_w < dt_service_max_w) then

		CALL generate_inco_eclipse(nr_seq_account_p, 3, obter_desc_expressao(651270), nm_usuario_p); --a data de alta nao deve ser menor que a data de realizacao do servico ou procedimento - achar expressao
	elsif (dt_discharge_w < dt_birth_w) then

		CALL generate_inco_eclipse(nr_seq_account_p, 3, obter_desc_expressao(651270), nm_usuario_p);--a data de alta nao pode ser menor que a data de nascimento - achar expressao
	end if;

	if (dt_admission_w > clock_timestamp()) then

		CALL generate_inco_eclipse(nr_seq_account_p, 3, obter_desc_expressao(10652198), nm_usuario_p);

	elsif (dt_admission_w < dt_birth_w)then

		CALL generate_inco_eclipse(nr_seq_account_p, 3, obter_desc_expressao(517269), nm_usuario_p);

	elsif (coalesce(dt_admission_w::text, '') = '' and (dt_discharge_w IS NOT NULL AND dt_discharge_w::text <> '')) then

		CALL generate_inco_eclipse(nr_seq_account_p, 1, obter_desc_expressao(632280), nm_usuario_p);

	elsif (dt_admission_w > dt_service_min_w) then

		CALL generate_inco_eclipse(nr_seq_account_p, 3, obter_desc_expressao(960562), nm_usuario_p); -- a data de entrada nao deve ser maior que a data de realizacao do servico ou procedimento - achar expressao
	end if;

	if (coalesce(dt_birth_w::text, '') = '') then

		CALL generate_inco_eclipse(nr_seq_account_p, 1, obter_desc_expressao(959332), nm_usuario_p);

	end if;

	if (ie_imc_type_w <> 'MO') then

		if (coalesce(cd_fund_card_w::text, '') = '') then

			CALL generate_inco_eclipse(nr_seq_account_p, 1, obter_desc_expressao(632283), nm_usuario_p);

		end if;

		if (cd_upi_w = 0 or coalesce(cd_upi_w::text, '') = '') then

			CALL generate_inco_eclipse(nr_seq_account_p, 1, obter_desc_expressao(632283), nm_usuario_p);

		end if;

	else

		cd_fund_card_w := null;
		cd_upi_w := null;

	end if;

	begin
	open c01;
	loop
	fetch c01 into c01_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

		select	max(nr_provider)
		into STRICT	nr_provider_w
		from	medical_provider_number
		where	cd_medico = c01_w.cd_medico_executor;

		if (nr_provider_w <>  cd_current_ser_provi_w) then
		new_voucher_ind_w := 1;
		end if;

    -----------------------
		select	count(nr_sequencia)
		into STRICT	has_proc_w
		from	imc_service a
		where	a.nr_seq_proc = c01_w.nr_sequencia;
    -----------------------
		if (coalesce(nr_provider_w::text, '') = '') then

			CALL generate_inco_eclipse(nr_seq_account_p, 1, obter_desc_expressao(559017), nm_usuario_p);

		end if;

		select  count(nr_sequencia)
		into STRICT    nr_records_w
		from    eclipse_inco_account
		where   nr_interno_conta = nr_seq_account_p;

		if (nr_records_w = 0) then

			if (mod(nr_service_count_w, 14) = 0 or new_voucher_ind_w = 1 ) then
				nr_service_count_w := 0;
				new_voucher_ind_w := 0;

				select	nextval('imc_voucher_seq')
				into STRICT	nr_seq_w
				;

				select	lpad(coalesce(max(a.cd_voucher_id),0) + 1, 2, 0)
				into STRICT	cd_voucher_id_w
				from	imc_voucher a,
					imc_claim b
				where	b.nr_sequencia = a.nr_seq_claim
				and	a.nr_seq_claim = nr_seq_claim_p;

				select	max(a.dt_referencia),
				max((select max(Lpad(substr(k.nr_provider, 1,8),8,'0'))
				from 	medical_provider_number k
				where 	k.cd_medico = a.cd_medico )) as ref_provider_num,
					max(a.dt_validade),
					max(a.ie_type_code)
				into STRICT 	dt_request_w,  		---- ReferralIssueDate
					cd_requesting_w,   	---- RequestingProviderNum
					dt_validate_w,	 	---- Validate date
					ie_referral_override_w  -- referral override indicator
				from	atendimento_paciente_inf a,
					conta_paciente b
				where 	b.nr_interno_conta = nr_seq_account_p
				and	a.nr_atendimento = b.nr_atendimento;



				insert into imc_voucher(
								dt_atualizacao,
								nr_seq_claim,
								nr_sequencia,
								nm_usuario,
								dt_discharge,
								ie_financial_interest,
								ie_ifc,
								nm_alias_family,
								nm_alias_first,
								dt_birth,
								nm_family,
								cd_provider,
								cd_fund_card,
								cd_upi, -- cd_complemento
								ie_gender,
								cd_medicare_card,
								nr_patient_ref,
								nm_second,
								ie_referral_period,
								dt_referral,
								ie_referral_override,
								qt_period,
								cd_referring,
								dt_request,
								cd_requesting,
								ie_request_type,
								ie_service_type,
								ie_compensation,
								dt_admission,
								nm_usuario_nrec,
								dt_atualizacao_nrec,
								nm_first,
								cd_voucher_id)

							values (
								clock_timestamp(),
								nr_seq_claim_p,
								nr_seq_w,
								nm_usuario_p,
								dt_discharge_w,
								ie_financial_interest_w,
								ie_ifc_w,
								nm_alias_family_w,
								nm_alias_first_w,
								dt_birth_w,
								nm_family_w,
								nr_provider_w,
								cd_fund_card_w,
								cd_upi_w,
								ie_gender_w,
								cd_medicare_card_w,
								nr_patient_ref_w,
								nm_second_w,
								ie_referral_period_w,
								dt_referral_w,
								ie_referral_override_w,
								QT_PERIOD_w,
								cd_referring_w,
								dt_request_w,
								cd_requesting_w,
								CASE WHEN ie_Service_type_w ='S' THEN 'D' WHEN ie_Service_type_w ='P' THEN  'P' END ,
								ie_service_type_w,
								cd_claimant_w,
								dt_admission_w,
								nm_usuario_p,
								clock_timestamp(),
								nm_first_w,
								cd_voucher_id_w);

		end if;
        	nr_service_count_w := nr_service_count_w +1;
		cd_current_ser_provi_w   :=  nr_provider_w;

		select		count(nr_sequencia)
		into STRICT		has_proc_w
		from		imc_service a
		where		a.nr_seq_proc = c01_w.nr_sequencia;

		dt_service_w := c01_w.dt_procedimento;

		select 	max(a.dt_prev_execucao)
		into STRICT	   dt_accession_w
		from	prescr_procedimento a ,
			prescr_medica b ,
			atendimento_paciente c ,
			conta_paciente d

		where	d.nr_interno_conta = nr_seq_account_p   -- :conta_pat
                and  	a.cd_procedimento  = c01_w.cd_procedimento
                and   	d.nr_atendimento   = c.nr_atendimento
                and   	b.nr_atendimento   = c.nr_atendimento
                and   	b.nr_prescricao    = a.nr_prescricao;

		select	max(a.dt_coleta)
		into STRICT	dt_collection_w
		from	prescr_procedimento a,
			prescr_medica b ,
			atendimento_paciente c ,
			conta_paciente d
		where	d.nr_interno_conta = nr_seq_account_p   -- :conta_pat
                and  	a.cd_procedimento  = c01_w.cd_procedimento
                and   	d.nr_atendimento   = c.nr_atendimento
                and   	b.nr_atendimento   = c.nr_atendimento
                and   	b.nr_prescricao    = a.nr_prescricao;

		select	max(qt_autorizada)
		into STRICT	qt_service_w
		from	procedimento_autorizado
		where	cd_procedimento = c01_w.cd_procedimento;

		select	max(cd_imobilizado_ext)
		into STRICT	nr_lsp_w
		from	equipamento
		where	cd_equipamento = c01_w.cd_equipamento;



		select	lpad(coalesce(max(cd_service_id),0) + 1, 4, 0)
		into STRICT	cd_service_id_w
		from	imc_service a,
			imc_voucher b
		where	b.nr_sequencia = a.nr_seq_voucher
		and		a.nr_seq_voucher = nr_seq_w;

		select 	cd_procedimento_loc
		into STRICT   	cd_mbs_code_w
		from   procedimento
		where  cd_procedimento = c01_w.cd_procedimento
		and 	 ie_origem_proced = c01_w.ie_origem_proced;

		select  max(CASE WHEN a.cd_setor_entrega=50 THEN 'SD'  WHEN a.cd_setor_entrega=37 THEN 'SS'  WHEN a.cd_setor_entrega=44 THEN 'SN'  END )  ,     	--selfdeemed
			max(CASE WHEN a.ie_aprovacao_execucao='S' THEN 'Y' END ) , 	-- Rule 3 excemption
			max(CASE WHEN a.ie_urgencia='S' THEN  'Y' END ), 			-- rule s4b3,
			max(CASE WHEN coalesce(a.nr_seq_topografia::text, '') = '' THEN 'N'  ELSE 'Y' END ),
			max(CASE WHEN a.IE_EXECUTAR_LEITO='S' THEN 'Y'  END ),
			CASE WHEN max(a.qt_procedimento)=0 THEN null  ELSE max(a.qt_procedimento) END ,

			max(CASE WHEN coalesce(a.NR_CONTROLE_EXT::text, '') = '' THEN  'Y' WHEN a.NR_CONTROLE_EXT=1 THEN  'N'  ELSE 'Y' END )
		into STRICT	ie_selfdeemed_w,
        		ie_rule_w,
			ie_s4b3_w,
			ie_multiple_procedure_w,
			ie_duplicate_w,
			qt_procedure_count_w,
			ie_hospital_w

		from	prescr_procedimento a ,
			prescr_medica b ,
			atendimento_paciente c ,
			conta_paciente d

		where	d.nr_interno_conta = nr_seq_account_p   -- :conta_pat
                and  	a.cd_procedimento  = c01_w.cd_procedimento
                and   	d.nr_atendimento   = c.nr_atendimento
                and   	b.nr_atendimento   = c.nr_atendimento
                and   	b.nr_prescricao    = a.nr_prescricao;


		cd_equipamento_w := c01_w.cd_equipamento;
		if (c01_w.cd_procedimento = 0) then
			CALL generate_inco_eclipse(nr_seq_account_p, 3, obter_desc_expressao(568639), nm_usuario_p);
		end if;

		if (c01_w.qt_duracao = 0) then
			CALL generate_inco_eclipse(nr_seq_account_p, 3, obter_desc_expressao(742492), nm_usuario_p); -- a duracao do procedimento nao pode ser 0 -criar uma expressao
		end if;

		if (dt_collection_w > clock_timestamp()) then

			CALL generate_inco_eclipse(nr_seq_account_p, 3, obter_desc_expressao(899094), nm_usuario_p); -- a data da coleta nao pode ser futura -criar uma expressao
		elsif (dt_collection_w < dt_birth_w) then

			CALL generate_inco_eclipse(nr_seq_account_p, 3, obter_desc_expressao(899094), nm_usuario_p); --data da coleta nao pode ser anterior que a data de nascimento que -criar uma expressao
		elsif (dt_collection_w > dt_service_w) then

			CALL generate_inco_eclipse(nr_seq_account_p, 3, obter_desc_expressao(899094), nm_usuario_p); --a data da coleta nao pode ser superior que a data do procedimento -criar uma expressao
		end if;

		if (dt_service_w > clock_timestamp()) then

			CALL generate_inco_eclipse(nr_seq_account_p, 3, obter_desc_expressao(583872), nm_usuario_p); -- a data do servico nao pode ser futura -criar uma expressao
		elsif (dt_service_w < dt_birth_w) then

			CALL generate_inco_eclipse(nr_seq_account_p, 3, obter_desc_expressao(583872), nm_usuario_p); --data de servico nao pode ser anterior que a data de nascimento que -criar uma expressao
		end if;


		if (c01_w.vl_procedimento < 100) then

			CALL generate_inco_eclipse(nr_seq_account_p, 3, obter_desc_expressao(587168), nm_usuario_p); --o valor do procedimento nao poder ser inferior a 100-criar uma expressao
		end if;

		if (c01_w.qt_duracao IS NOT NULL AND c01_w.qt_duracao::text <> '') then

			c01_w.cd_equipamento := null;
			qt_service_w := null;
			nr_lsp_w := null;

		end if;

		if (c01_w.cd_setor_externo IS NOT NULL AND c01_w.cd_setor_externo::text <> '') then

			c01_w.cd_equipamento := null;

		end if;

		if (ie_service_type_w <> 'S') then

			qt_service_w := null;
			nr_lsp_w := null;

		elsif (ie_service_type_w = 'S' and  2 = 0) then

			CALL generate_inco_eclipse(nr_seq_account_p, 3, obter_desc_expressao(587168), nm_usuario_p); --o campo qt_autorizada deve ter valor quando o tipo de service for S -criar uma expressao
		end if;

		if ((c01_w.cd_equipamento IS NOT NULL AND c01_w.cd_equipamento::text <> '') and coalesce(nr_lsp_w::text, '') = '') then

			CALL generate_inco_eclipse(nr_seq_account_p, 3, obter_desc_expressao(587168), nm_usuario_p); --o campo cd_imobilizado_ext deve ser setado junto como o campo equipamento-criar uma expressao
		end if;

		ie_restrictive_w := check_seprate_site(nr_voucher_seq_w,nr_seq_account_p,c01_w.cd_procedimento,c01_w.ie_origem_proced);

		if ((ie_selfdeemed_w IS NOT NULL AND ie_selfdeemed_w::text <> '') and (ie_selfdeemed_w not in ('SD' , 'SS','NN'))) then
			CALL generate_inco_eclipse(nr_seq_account_p, 1, 'invalid selfdeemed code', nm_usuario_p);
		end if;

		if (ie_selfdeemed_w  = 'SD' and ((cd_referring_w IS NOT NULL AND cd_referring_w::text <> '') or  (cd_requesting_w IS NOT NULL AND cd_requesting_w::text <> ''))) then
			CALL generate_inco_eclipse(nr_seq_account_p, 1, 'invalid selfDeemed value', nm_usuario_p);
		end if;

		if (ie_selfdeemed_w  = 'SS' and ( (ie_referral_period_w IS NOT NULL AND ie_referral_period_w::text <> '') or (ie_referral_period_w IS NOT NULL AND ie_referral_period_w::text <> '') or (cd_medic_w IS NOT NULL AND cd_medic_w::text <> '') or (dt_referral_w IS NOT NULL AND dt_referral_w::text <> '') )) then
			CALL generate_inco_eclipse(nr_seq_account_p, 1, 'invalid selfDeemed value', nm_usuario_p);
		end if;

		if ((ie_rule_w IS NOT NULL AND ie_rule_w::text <> '') and (ie_rule_w not in ('Y' ,'N'))) then
			CALL generate_inco_eclipse(nr_seq_account_p, 1, 'invalid rule indication', nm_usuario_p);
		end if;

			if (ie_rule_w IS NOT NULL AND ie_rule_w::text <> '' AND ie_service_type_w <> 'P' ) then
				CALL generate_inco_eclipse(nr_seq_account_p, 1, 'invalid rule indication', nm_usuario_p);
		end if;

		if (ie_rule_w = 'Y' and ie_s4b3_w = 'Y') then
			CALL generate_inco_eclipse(nr_seq_account_p, 1, 'invalid rule indication', nm_usuario_p);
		end if;

		if ((ie_s4b3_w IS NOT NULL AND ie_s4b3_w::text <> '') and (ie_s4b3_w not in ('Y' ,'N'))) then
			CALL generate_inco_eclipse(nr_seq_account_p, 1, 'invalid S4b3ExemptInd', nm_usuario_p);
		end if;

		if (ie_s4b3_w IS NOT NULL AND ie_s4b3_w::text <> '' AND ie_service_type_w <> 'P' ) then
			CALL generate_inco_eclipse(nr_seq_account_p, 1, 'invalid S4b3ExemptInd', nm_usuario_p);
		end if;

		if (ie_s4b3_w IS NOT NULL AND ie_s4b3_w::text <> '' AND ie_service_type_w <> 'P' ) then
			CALL generate_inco_eclipse(nr_seq_account_p, 1, 'invalid S4b3ExemptInd', nm_usuario_p);
		end if;

		if (length(c01_w.ds_observacao) > 50) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort('Service description should be lesser than  50 characters.');
		end if;

		select  count(nr_sequencia)
		into STRICT    nr_records_w
		from    eclipse_inco_account
		where   nr_interno_conta = nr_seq_account_p;

		if (nr_records_w = 0) then

			select	nextval('imc_service_seq')
			into STRICT	nr_seq_service_w
			;

        	select	max(coalesce((SUBSTR(c01_w.DS_OBSERVACAO, 24, 2))::numeric , 1))
		into STRICT 	cd_qt_pat_w
		
		where 	upper(SUBSTR(c01_w.DS_OBSERVACAO , 1,23)) = upper('Number of patient seen ');

		qt_patients_w := (cd_qt_pat_w)::numeric;

		select	count(*)
		into STRICT 	nr_Service_count_W1
		from 	imc_Service
		where 	nr_seq_voucher = nr_seq_w
		and 	cd_item = lpad(cd_mbs_code_w, 5 , 0);

		if (nr_Service_count_W1 = 0) then
		ie_duplicate_w := null;
		end if;

		insert into imc_service(
						dt_atualizacao,
						nr_sequencia,
						nm_usuario,
						nr_seq_voucher,
						vl_charge,
						dt_collection,
						dt_service,
						ie_duplicate,
						nr_time_service,
						qt_service,
						cd_item,
						nr_lsp,
						ie_multiple,
						qt_patients,
						ie_restrictive,
						ie_rule,
						ie_s4b3,
						cd_scp,
						ie_selfdeemed,
						ds_service,
						qt_duration,
						ie_aftercare,
						dt_accession,
						nm_usuario_nrec,
						dt_atualizacao_nrec,
						cd_equipament,
						nr_seq_proc,
						cd_service_id)
			values (
						clock_timestamp(),
						nr_seq_service_w,
						nm_usuario_p,
						nr_seq_w,
						c01_w.vl_procedimento,
						dt_collection_w,
						dt_service_w,
						CASE WHEN ie_duplicate_w='Y' THEN 'true'  ELSE null END ,
						to_char(dt_service_w, 'hh:mm:ss') || tz_offset(sessiontimezone),
						qt_procedure_count_w,
						lpad(cd_mbs_code_w, 5 , 0),
						nr_lsp_w,
						CASE WHEN ie_multiple_procedure_w='Y' THEN 'true'  ELSE null END ,
						qt_patients_w, --- number of paitents
						ie_restrictive_w,
						CASE WHEN ie_rule_w='Y' THEN 'true'  ELSE null END ,
						CASE WHEN ie_s4b3_w='Y' THEN 'true'  ELSE null END ,
						CASE WHEN ie_service_type_w ='P' THEN c01_w.cd_setor_externo  ELSE null END ,
						ie_selfdeemed_w,
						c01_w.ds_observacao,
						c01_w.qt_duracao,
						CASE WHEN ie_aftercare_w='Y' THEN 'true'  ELSE null END ,
						dt_accession_w,
						nm_usuario_p,
						clock_timestamp(),
						cd_equipamento_w,
						c01_w.nr_sequencia,
						cd_service_id_w
				);
			end if;


		end if;
	end loop;
	close c01;
	end;

 end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE get_imc_voucher ( nr_seq_claim_p imc_claim.nr_sequencia%type, nm_usuario_p imc_claim.nm_usuario%type, ie_validate_p text, nr_seq_account_p bigint, ie_imc_type_p text) FROM PUBLIC;
