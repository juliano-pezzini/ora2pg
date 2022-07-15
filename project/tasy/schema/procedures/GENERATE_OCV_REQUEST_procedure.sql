-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE generate_ocv_request ( nm_usuario_p text, cd_estabelecimento_p bigint, nr_atendimento_p bigint default null, cd_pessoa_fisica_p text default null, ie_calling_point_p text DEFAULT NULL, cd_seq_transaction_p INOUT text DEFAULT NULL) AS $body$
DECLARE


dt_service_w			timestamp;
cd_entitlement_w		varchar(11);
cd_opv_type_w			varchar(3);
dt_birth_w			timestamp;
nm_family_w			varchar(40);
nm_first_w			varchar(40);
cd_medicare_card_w		bigint;
ie_reference_num_w		smallint;
cd_provider_w			varchar(8);
nr_seq_request			bigint;
cd_seq_transaction_w		varchar(25);
cd_attribute_w             	varchar(100);
cd_field_name_w            	varchar(100);
error_flag_w			varchar(1);
entity_name_w			varchar(20);
entity_cond_val_w		numeric(20);

c03 CURSOR FOR
	SELECT	nm_eclipse_field,
		nm_atributo
	from	eclipse_attribute
	where	ie_condition = 'M'
	and	ie_ocv = 'S';

BEGIN

	select	nextval('ocv_request_seq')
	into STRICT	nr_seq_request
	;

	cd_opv_type_w:= 'CEV';

if (ie_calling_point_p = 'M') then

	delete	from eclipse_inco_account
	where	cd_pessoa_fisica = cd_pessoa_fisica_p;

	cd_provider_w := null;
	entity_cond_val_W:= (cd_pessoa_fisica_p)::numeric;
	entity_name_w:='PERSON';

	select 	max(pkg_name_utils.get_person_name(b.nr_seq_person_name,cd_estabelecimento_p,'givenName')) nm_first,
		max(pkg_name_utils.get_person_name(b.nr_seq_person_name,cd_estabelecimento_p,'familyName')) nm_family,
		max(b.dt_nascimento) dt_birth,
		max(substr(c.nr_con_card, 1, 11))  cd_entitlement, --check agian for which concession card for that
		generaterandomnumber cd_seq_transaction
	into STRICT    nm_first_w,
		nm_family_w,
		dt_birth_w,
		cd_entitlement_w,
		cd_seq_transaction_w
	from	pessoa_fisica b,
		person_concession c
	where	b.cd_pessoa_fisica = cd_pessoa_fisica_p
	and 	c.cd_pessoa_fisica = b.cd_pessoa_fisica  LIMIT 1;

	select 	max(substr(a.cd_usuario_convenio, 1, 10)) cd_medicare_card,
		max(substr(a.cd_usuario_convenio_tit, 0,1))  ie_reference_num 
	into STRICT 	cd_medicare_card_w,
		ie_reference_num_w		
	from    pessoa_titular_convenio a,
		convenio b          
	where   a.cd_pessoa_fisica = cd_pessoa_fisica_p
	and     a.cd_convenio = b.cd_convenio
	and     b.ie_tipo_convenio  = 12  LIMIT 1;

  select	max(Lpad(substr(c.nr_provider, 1,8),8,'0')) cd_provider
	into STRICT	cd_provider_w
	from 	atendimento_paciente b ,
		medical_provider_number c
	where	b.cd_pessoa_fisica = cd_pessoa_fisica_p
	and	c.cd_medico =  b.cd_medico_resp  LIMIT 1;

elsif (ie_calling_point_p = 'P') then

	delete	from eclipse_inco_account
	where	nr_atendiment = nr_atendimento_p;

	entity_cond_val_W:=nr_atendimento_p;
	entity_name_w:='ENCOUNTER';

	select 	max(Lpad(b.cd_usuario_convenio,10,' '))  cd_medicare_card,
		max(pkg_name_utils.get_person_name(e.nr_seq_person_name,cd_estabelecimento_p,'givenName')) nm_first,
		max(pkg_name_utils.get_person_name(e.nr_seq_person_name,cd_estabelecimento_p,'familyName')) nm_family,
		max(e.dt_nascimento) dt_birth,
		max(substr(b.cd_complemento, 0,1)) ie_reference_num,
		generaterandomnumber cd_seq_transaction
	into STRICT	cd_medicare_card_w,
		nm_first_w,
		nm_family_w,
		dt_birth_w,
		ie_reference_num_w,
		cd_seq_transaction_w
	from  	atend_categoria_convenio b,
		atendimento_paciente d,
		pessoa_fisica e,
		convenio f
	where 	 b.nr_atendimento = nr_atendimento_p
	and   	d.nr_atendimento = b.nr_atendimento
	and     e.CD_PESSOA_FISICA = d.CD_PESSOA_FISICA
	and     b.CD_CONVENIO  = f.CD_CONVENIO
	and     f.IE_TIPO_CONVENIO  = 12  LIMIT 1;

	select	max(Lpad(substr(c.nr_provider, 1,8),8,'0')) cd_provider
	into STRICT	cd_provider_w
	from 	atendimento_paciente b ,
		medical_provider_number c
	where	b.nr_atendimento = nr_atendimento_p
	and	c.cd_medico =  b.cd_medico_resp  LIMIT 1;
	
	select	max(substr(b.nr_con_card, 1, 11)) cd_entitlement
	into STRICT	cd_entitlement_w
	from	atendimento_paciente a,
		person_concession b
	where	a.nr_atendimento = nr_atendimento_p
	and	b.cd_pessoa_fisica = a.cd_pessoa_fisica  LIMIT 1;

end if;


for r03 in c03 loop

begin

cd_attribute_w	:= r03.nm_atributo;
cd_field_name_w := r03.nm_eclipse_field;

	if (upper(cd_field_name_w) = upper('PatientDateOfBirth') and (coalesce(dt_birth_w::text, '') = '' ) ) then
	
		CALL generate_inco_eclipse(entity_cond_val_W , 1, Wheb_mensagem_pck.get_texto(1112321), nm_usuario_p, entity_name_w);
		error_flag_w := 'T';
    
	elsif (upper(cd_field_name_w) = upper('PatientFirstName') and (coalesce(nm_first_w::text, '') = '' ) ) then 
	
		CALL generate_inco_eclipse(entity_cond_val_W , 1, Wheb_mensagem_pck.get_texto(1112323), nm_usuario_p, entity_name_w);
		error_flag_w := 'T';

	elsif (upper(cd_field_name_w) = upper('PatientFamilyName') and (coalesce(nm_family_w::text, '') = '' ) ) then 
	
		CALL generate_inco_eclipse(entity_cond_val_W , 1, Wheb_mensagem_pck.get_texto(1112322), nm_usuario_p , entity_name_w);
		error_flag_w := 'T';

	elsif (upper(cd_field_name_w) = upper('PatientMedicareCardNum') and (coalesce(cd_medicare_card_w::text, '') = '' ) ) then 
	
		CALL generate_inco_eclipse(entity_cond_val_W , 1, Wheb_mensagem_pck.get_texto(1112324), nm_usuario_p , entity_name_w);
		error_flag_w := 'T';
    
	elsif (upper(cd_field_name_w) = upper('PatientReferenceNum') and (coalesce(ie_reference_num_w::text, '') = '' ) ) then 
	
		CALL generate_inco_eclipse(entity_cond_val_W , 1, Wheb_mensagem_pck.get_texto(1112325), nm_usuario_p , entity_name_w);
		error_flag_w := 'T';
   		
	elsif (upper(cd_field_name_w) = upper('EntitlementId') and (coalesce(cd_entitlement_w::text, '') = '' ) ) then
	
		CALL generate_inco_eclipse(entity_cond_val_W , 1, Wheb_mensagem_pck.get_texto(1113599), nm_usuario_p , entity_name_w);
		error_flag_w := 'T';
		
	end if;
end;

end loop;
if (coalesce(error_flag_w::text, '') = '') then

	insert into ocv_request(nr_sequencia  ,
			dt_atualizacao ,           
			nm_usuario     ,    
			dt_atualizacao_nrec  ,           
			nm_usuario_nrec   ,            
			dt_service        ,                   
			cd_entitlement    ,           
			cd_opv_type     ,               
			dt_birth       ,                  
			nm_family      ,               
			nm_first        ,             
			cd_medicare_card   ,             
			ie_reference_num   ,              
			cd_provider       ,            
			nr_seq_transaction)
		values (nr_seq_request,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			cd_entitlement_W ,           
			cd_opv_type_w, 
			dt_birth_w      ,                  
			nm_family_w      ,
			nm_first_w,             
			cd_medicare_card_w,             
			ie_reference_num_w,              
			cd_provider_w,
			cd_seq_transaction_w);

commit;
cd_seq_transaction_p := cd_seq_transaction_w;

end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE generate_ocv_request ( nm_usuario_p text, cd_estabelecimento_p bigint, nr_atendimento_p bigint default null, cd_pessoa_fisica_p text default null, ie_calling_point_p text DEFAULT NULL, cd_seq_transaction_p INOUT text DEFAULT NULL) FROM PUBLIC;

