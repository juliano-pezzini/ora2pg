-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE get_imc_claim ( nr_seq_account_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_resubmission_p text default 'N', ie_validate_p text DEFAULT NULL, ie_imc_type text default 'N') AS $body$
DECLARE


nr_sequencia_w			imc_claim.nr_sequencia%type;
nr_seq_transaction_w		imc_claim.nr_seq_transaction%type;
nr_seq_tipo_acidente_w		atendimento_paciente.nr_seq_tipo_acidente%type;
ie_accident_w			imc_claim.ie_accident%type;
ie_account_paid_w		varchar(10) := 'false';
vl_saldo_titulo_w		titulo_receber.vl_saldo_titulo%type;
nm_bank_account_w		imc_claim.nm_bank_account%type;
nr_bank_account_w		imc_claim.nr_bank_account%type;
cd_bsb_w			imc_claim.cd_bsb%type;
nr_seq_estagio_w		autorizacao_convenio.nr_seq_estagio%type;
nr_provider_w			imc_claim.cd_billing_agent%type;
nr_billing_agent_w 		imc_claim.cd_billing_agent%type;
ie_benefit_w			imc_claim.ie_benefit%type;
ds_endereco_w			compl_pessoa_fisica.ds_endereco%type;
ds_complemento_w		compl_pessoa_fisica.ds_complemento%type;
ds_municipio_w			compl_pessoa_fisica.ds_municipio%type;
cd_cep_w			compl_pessoa_fisica.cd_cep%type;
dt_nascimento_w			pessoa_fisica.dt_nascimento%type;
nr_seq_person_name_w		pessoa_fisica.nr_seq_person_name%type;
nm_first_w			imc_claim.nm_first%type;
nm_family_w			imc_claim.nm_family%type;
cd_user_insurance_w		atend_categoria_convenio.cd_usuario_convenio%type;
cd_complemento_w		atend_categoria_convenio.cd_complemento%type;
ie_authorised_w			imc_claim.ie_authorised%type;
cd_facility_w			eclipse_parameters.cd_facility%type;
cd_convenio_w			convenio.cd_convenio%type;
cd_externo_w			convenio.cd_externo%type;
cd_fund_payee_id_w		medico_convenio.cd_medico_convenio%type;
nr_telefone_w			compl_pessoa_fisica.nr_telefone%type;
nm_pessoa_fisica_w		pessoa_fisica.nm_pessoa_fisica%type;
nr_atendimento_w		atendimento_paciente.nr_atendimento%type;
cd_medico_resp_w		atendimento_paciente.cd_medico_resp%type;
nr_records_w			integer;
ie_imc_type_w			eclipse_parameters.ie_imc_type%type;
qt_services_w			integer;
cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;

------------------
CLAIMANT_DS_ADDRESS_ONE_w   		pci_claim.CLAIMANT_DS_ADDRESS_ONE%type;
CLAIMANT_DS_ADDRESS_TWO_w  		pci_claim.CLAIMANT_DS_ADDRESS_TWO%type;
CLAIMANT_DS_LOCALITY_w  		pci_claim.CLAIMANT_DS_LOCALITY%type;
CLAIMANT_NR_POSTCODE_w  		pci_claim.CLAIMANT_NR_POSTCODE%type;
claimant_nm_family_w 			varchar(40);
claimant_nm_first_w 			varchar(40);
claimant_dt_birth_w 			timestamp;
claimant_nr_patient_num_w  		varchar(20);
claimant_ie_authorised_w  		pci_claim.claimant_ie_authorised%type := 'N';
cd_med_card_num_w    			varchar(20);

---------------
BEGIN

	CALL billing_i18n_pck.set_validate_eclipse(ie_validate_p);

	select  coalesce(max(nr_sequencia),0)
	into STRICT    nr_sequencia_w
	from    imc_claim
	where   nr_seq_account	=  nr_seq_account_p;

	delete	FROM eclipse_inco_account a
	where	a.nr_interno_conta = nr_seq_account_p;

	CALL clear_imc_claim(nr_sequencia_w);

	select 	coalesce(max(ie_imc_type), 0)
	into STRICT	ie_imc_type_w
	from 	eclipse_parameters
	where	cd_estabelecimento = obter_estabelecimento_ativo;
	ie_imc_type_w := ie_imc_type;

 --------------------------------------
 --claiment details
	select
		max(pkg_name_utils.get_person_name(d2.nr_seq_person_name,cd_estabelecimento_p,'familyName')) nm_family,
		max(pkg_name_utils.get_person_name(d2.nr_seq_person_name,cd_estabelecimento_p,'givenName')) nm_first,
		max(d2.dt_nascimento) dt_birth,
		max(e2.CD_USUARIO_CONVENIO) cd_med_card_num_w,
		max(substr(e2.CD_USUARIO_CONVENIO_TIT, 1, 1)) claimant_nr_patient_num_w ,
		max(substr(f.ds_endereco, 1, 40)) ds_address,
		max(substr(f.DS_COMPLEMENTO, 1, 40)) CLAIMANT_DS_ADDRESS_TWO_w,
		max(substr(f.DS_MUNICIPIO, 1, 40)) CLAIMANT_DS_LOCALITY_w,
		max(substr(f.cd_cep, 1, 4)),
		max('N')
	into STRICT
		claimant_nm_family_w,
		claimant_nm_first_w,
		claimant_dt_birth_w,
		cd_med_card_num_w,
		claimant_nr_patient_num_w,
		claimant_ds_address_one_w,
		claimant_ds_address_two_w,
		claimant_ds_locality_w,
		claimant_nr_postcode_w,
		claimant_ie_authorised_w
	from  	conta_paciente a,
		atendimento_paciente c,
		pessoa_fisica d,
		PESSOA_TITULAR_CONVENIO e,
		pessoa_fisica d2,
		PESSOA_TITULAR_CONVENIO e2,
		compl_pessoa_fisica f
	where 	a.nr_interno_conta = nr_seq_account_p
	and   	c.nr_atendimento   = a.nr_atendimento
	and   	c.cd_pessoa_fisica = d.cd_pessoa_fisica
	and   	d.cd_pessoa_fisica = e.cd_pessoa_fisica
	and     e.CD_PESSOA_TITULAR = d2.cd_pessoa_fisica
	and     d2.cd_pessoa_fisica = e2.cd_pessoa_fisica
	and     d2.cd_pessoa_fisica = f.cd_pessoa_fisica
	and    	e2.CD_CONVENIO = '4'  LIMIT 1;


 ---------------------------------------
	select	max(a.nr_seq_tipo_acidente),
		max(a.nr_atendimento),
		max(d.ds_endereco),
		max(d.ds_complemento),
		max(d.ds_municipio),
		max(d.cd_cep),
		max(e.dt_nascimento),
		max(e.nr_seq_person_name),
		max(d.nr_telefone),
		max(e.nm_pessoa_fisica),
		max(a.cd_medico_resp),
		max(e.cd_pessoa_fisica)
	into STRICT	nr_seq_tipo_acidente_w,
		nr_atendimento_w,
		ds_endereco_w,
		ds_complemento_w,
		ds_municipio_w,
		cd_cep_w,
		dt_nascimento_w,
		nr_seq_person_name_w,
		nr_telefone_w,
		nm_pessoa_fisica_w,
		cd_medico_resp_w,
		cd_pessoa_fisica_w
	from	atendimento_paciente a,
		conta_paciente b,
		compl_pessoa_fisica d,
		pessoa_fisica e
	where	a.nr_atendimento = b.nr_atendimento
	and	a.cd_pessoa_fisica = d.cd_pessoa_fisica
	and 	d.cd_pessoa_fisica = e.cd_pessoa_fisica
	and	b.nr_interno_conta = nr_seq_account_p;

	select	max(nr_provider)
	into STRICT	nr_provider_w
	from	medical_provider_number
	where	cd_medico = cd_medico_resp_w;

	select 	max(nr_provider)
	into STRICT 	nr_billing_agent_w
	from 	medical_provider_number a,
		conta_paciente b
	where 	b.NR_INTERNO_CONTA = nr_seq_account_p
	and 	b.CD_RESPONSAVEL = a.cd_medico;
	ie_accident_w := get_eclipse_conversion('NR_SEQ_TIPO_ACIDENTE', nr_seq_tipo_acidente_w, 'IMC', null, nr_seq_account_p, ie_accident_w);
	nm_first_w := pkg_name_utils.get_person_name(nr_seq_person_name_w,cd_estabelecimento_p,'givenName');
	nm_family_w := pkg_name_utils.get_person_name(nr_seq_person_name_w,cd_estabelecimento_p,'familyName');

	select  obter_convenio_atendimento(nr_atendimento_w)
	into STRICT    cd_convenio_w
	;

  	SELECT 	Max(a.cd_usuario_convenio),
		Max(a.cd_complemento)
	INTO STRICT   	cd_user_insurance_w, cd_complemento_w
	FROM   	atend_categoria_convenio a,
		convenio b ,
		conta_paciente c,
		atendimento_paciente x
	WHERE   a.cd_convenio = b.cd_convenio
        and    	c.nr_atendimento = x.nr_atendimento
        and    	a.nr_atendimento = x.nr_atendimento
        and  	c.nr_interno_conta  = nr_seq_account_p
        AND 	b.ie_tipo_convenio = 12;

	select  max(cd_medico_convenio)
	into STRICT 	cd_fund_payee_id_w
	from    medico_convenio a
	where   a.cd_convenio = cd_convenio_w;


	if (ie_imc_type_w <> 'MO') then

		if (coalesce(ie_accident_w::text, '') = '') then

			CALL generate_inco_eclipse(nr_seq_account_p, 1, obter_desc_expressao(565389), nm_usuario_p);

		end if;

		if (cd_convenio_w > 0) then

			select  max(cd_externo)
			into STRICT    cd_externo_w
			from    convenio
			where   cd_convenio = cd_convenio_w;

			if (coalesce(cd_externo_w::text, '') = '') then
				CALL generate_inco_eclipse(nr_seq_account_p, 1, obter_desc_expressao(960562), nm_usuario_p);
			end if;

		end if;


	end if;

	select  max(cd_facility)
	into STRICT    cd_facility_w
	from    eclipse_parameters
	where   cd_estabelecimento = cd_estabelecimento_p;

	select	max(a.nr_conta),
		max(a.cd_agencia_bancaria),
		max(b.ds_banco)
	into STRICT	nr_bank_account_w,
		cd_bsb_w,
		nm_bank_account_w
	from 	pessoa_fisica_conta a,
		banco b
	where	a.cd_pessoa_fisica = cd_pessoa_fisica_w
	and	b.cd_banco = a.cd_banco;

	select	max(c.nr_seq_estagio)
	into STRICT	nr_seq_estagio_w
	from	autorizacao_convenio c
	where	nr_atendimento = nr_atendimento_w;

	if (coalesce(ie_imc_type_w::text, '') = '') then

		CALL generate_inco_eclipse(nr_seq_account_p, 1, obter_desc_expressao(960556), nm_usuario_p);

	end if;

	if (coalesce(cd_facility_w::text, '') = '' ) then

		CALL generate_inco_eclipse(nr_seq_account_p, 1, obter_desc_expressao(958723), nm_usuario_p);

	end if;

	if (ie_imc_type_w <> 'PC') then

		ie_account_paid_w := 'false';
		nm_bank_account_w := null;
		nr_bank_account_w := null;
		cd_bsb_w := null;

	end if;

	if (ie_imc_type_w = 'MO' or ie_imc_type_w = 'MB' )then

		ie_benefit_w := 'true';

		if (coalesce(nr_billing_agent_w::text, '') = '') then

			CALL generate_inco_eclipse(nr_seq_account_p, 1, obter_desc_expressao(964733), nm_usuario_p);

		end if;

	else

		ie_benefit_w := get_eclipse_conversion('NR_SEQ_ESTAGIO', nr_seq_estagio_w, 'IMC', null, nr_seq_account_p, ie_benefit_w);

	end if;

	if (ie_imc_type_w = 'PC') then

		select	coalesce(max(b.vl_saldo_titulo),1)
		into STRICT	vl_saldo_titulo_w
		from	conta_paciente a,
				titulo_receber b
		where	a.nr_interno_conta = nr_seq_account_p
		and		b.nr_interno_conta = a.nr_interno_conta  LIMIT 1;

		select	count(cd_procedimento)
		into STRICT	qt_services_w
		from	procedimento_paciente
		where	nr_interno_conta = nr_seq_account_p;

		if (qt_services_w > 16) then

			CALL generate_inco_eclipse(nr_seq_account_p, 3, obter_desc_expressao(964733), nm_usuario_p);--a quantidade de procedimentos por claim deve ser inferior a 16 - criar expressao
		end if;

		nr_billing_agent_w := null;

		if (vl_saldo_titulo_w > 0) then

			ie_account_paid_w := 'false';
			nm_bank_account_w := null;
			nr_bank_account_w := null;
			cd_bsb_w := null;

		end if;

		if (vl_saldo_titulo_w = 0 ) then

			ie_account_paid_w := 'true';

			if (coalesce(nm_bank_account_w::text, '') = '') then

				CALL generate_inco_eclipse(nr_seq_account_p, 3, obter_desc_expressao(965326), nm_usuario_p);

			end if;

			if (coalesce(nr_bank_account_w::text, '') = '') then

				CALL generate_inco_eclipse(nr_seq_account_p, 3, obter_desc_expressao(617809), nm_usuario_p);

			end if;

			if (coalesce(cd_bsb_w::text, '') = '') then

				CALL generate_inco_eclipse(nr_seq_account_p, 3, obter_desc_expressao(510051), nm_usuario_p);

			end if;

		end if;

		if (nm_first_w IS NOT NULL AND nm_first_w::text <> '') then

			if (coalesce(nm_family_w::text, '') = '') then

				CALL generate_inco_eclipse(nr_seq_account_p, 1, obter_desc_expressao(591289), nm_usuario_p);

			end if;


			if (coalesce(dt_nascimento_w::text, '') = '') then

				CALL generate_inco_eclipse(nr_seq_account_p, 1, obter_desc_expressao(959332), nm_usuario_p);

			end if;



			if (cd_user_insurance_w = 0) then

				CALL generate_inco_eclipse(nr_seq_account_p, 3, obter_desc_expressao(632283), nm_usuario_p); --- inconsistencia nesse campo
			end if;

			if (cd_complemento_w = 0) then

				CALL generate_inco_eclipse(nr_seq_account_p, 3, obter_desc_expressao(632283), nm_usuario_p); -- ou nesse
			end if;
		else

			CALL generate_inco_eclipse(nr_seq_account_p, 1, obter_desc_expressao(591289), nm_usuario_p);

		end if;

		ie_authorised_w := 'true';

	else


	ie_authorised_w := null;

	end if;

	if (coalesce(nr_provider_w::text, '') = '') then

		CALL generate_inco_eclipse(nr_seq_account_p, 1, obter_desc_expressao(964733), nm_usuario_p);

	end if;
	select  count(nr_sequencia)
	into STRICT    nr_records_w
	from    eclipse_inco_account
	where   nr_interno_conta = nr_seq_account_p;

	if (ie_resubmission_p = 'N') then

		nr_seq_transaction_w := generateRandomNumber();

	end if;
	if (nr_records_w = 0) then
		if (nr_sequencia_w = 0) then
			select 	nextval('imc_claim_seq')
			into STRICT 	nr_sequencia_w
			;

			insert into imc_claim(
						nr_sequencia,
						cd_establishment,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_account,
						nr_seq_transaction,
						ie_accident,
						ie_account_paid,
						nm_bank_account,
						nr_bank_account,
						cd_bsb,
						ie_benefit,
						cd_billing_agent,
						ds_address_one,
						ds_address_two,
						ds_locality,
						nr_postcode,
						dt_birth,
						nm_family,
						nm_first,
						cd_medicare_card,
						nr_patient_num,
						ie_authorised,
						ie_claim_type,
						IE_IMC_TYPE,
						cd_facility,
						cd_fund_brand,
						cd_fund_payee,
						cd_principal_provider,
						nr_phone,
						nm_contact
						)
				values (		nr_sequencia_w,
						cd_estabelecimento_p,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						NR_SEQ_ACCOUNT_P,
						nr_seq_transaction_w,
						ie_accident_w,
						ie_account_paid_w,
						nm_bank_account_w,
						nr_bank_account_w,
						cd_bsb_w,
						ie_benefit_w,
						nr_billing_agent_w,
						coalesce(CLAIMANT_DS_ADDRESS_ONE_w ,ds_endereco_w),
						coalesce(CLAIMANT_DS_ADDRESS_two_w,ds_complemento_w),
						ds_municipio_w,
						cd_cep_w,
						coalesce(claimant_dt_birth_w,dt_nascimento_w),
						coalesce(claimant_nm_family_w,nm_family_w),
						coalesce(claimant_nm_first_w ,nm_first_w),
						coalesce(cd_med_card_num_w,cd_user_insurance_w),
						coalesce(cd_complemento_w,claimant_nr_patient_num_w),
						ie_authorised_w,
						ie_imc_type_w,
						ie_imc_type_w,
						cd_facility_w,
						cd_externo_w, --lpad 3
						cd_fund_payee_id_w,
						nr_provider_w,
						nr_telefone_w,
						nm_pessoa_fisica_w
						);
		else
			delete	FROM imc_service	a
			where	a.nr_seq_voucher in (SELECT b.nr_sequencia from imc_voucher b where b.nr_seq_claim = nr_sequencia_w);

			delete	FROM imc_voucher
			where	nr_seq_claim	= nr_sequencia_w;

			update	imc_claim
			set		cd_establishment 		= cd_estabelecimento_p,
					dt_atualizacao			= clock_timestamp(),
					nm_usuario			= nm_usuario_p,
					dt_atualizacao_nrec		= clock_timestamp(),
					nm_usuario_nrec			= nm_usuario_p,
					nr_seq_account			= nr_seq_account_p,
					ie_accident			= ie_accident_w,
					ie_account_paid			= ie_account_paid_w,
					nm_bank_account			= nm_bank_account_w,
					nr_bank_account			= nr_bank_account_w,
					cd_bsb				= cd_bsb_w,
					ie_benefit			= ie_benefit_w,
					cd_billing_agent		= nr_billing_agent_w,
					ds_address_one			= coalesce(CLAIMANT_DS_ADDRESS_ONE_w, ds_endereco_w),
					ds_address_two			= coalesce(CLAIMANT_DS_ADDRESS_two_w,ds_complemento_w),
					ds_locality			= ds_municipio_w,
					nr_postcode			= cd_cep_w,
					dt_birth			= coalesce(claimant_dt_birth_w,dt_nascimento_w),
					nm_family			= coalesce(claimant_nm_family_w,nm_family_w),
					nm_first			= coalesce(claimant_nm_family_w,nm_first_w),
					cd_medicare_card		= coalesce(cd_med_card_num_w,cd_user_insurance_w),
					nr_patient_num			= coalesce(cd_complemento_w,claimant_nr_patient_num_w),
					ie_authorised			= ie_authorised_w,
					ie_claim_type			= ie_imc_type_w,
					cd_facility			= cd_facility_w,
					cd_fund_brand			= cd_externo_w,
					cd_fund_payee			= cd_fund_payee_id_w,
					cd_principal_provider		= nr_provider_w,
					nr_phone			= nr_telefone_w,
					nm_contact			= nm_pessoa_fisica_w,
					nr_seq_transaction 		= nr_seq_transaction_w
			where		nr_sequencia			= nr_sequencia_w;

		end if;
	end if;

	CALL get_imc_voucher(nr_sequencia_w, nm_usuario_p, ie_validate_p, nr_seq_account_p,ie_imc_type_w);

	commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE get_imc_claim ( nr_seq_account_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_resubmission_p text default 'N', ie_validate_p text DEFAULT NULL, ie_imc_type text default 'N') FROM PUBLIC;
