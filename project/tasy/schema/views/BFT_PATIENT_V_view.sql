-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW bft_patient_v (patient_id, medical_record_id, external_medical_record_id, patient_name, patient_given_name, patient_last_name, patient_middle_name, mother_name, mother_given_name, mother_last_name, mother_middle_name, mother_civil_id, responsible_name, responsible_civil_id, patient_sex, patient_title, sex_id, date_of_birth, char_date_of_birth, skin_color_code, hl7_race_code, marital_status, religion_code, external_religion_code, medical_record, patient_national_id, taxpayer_id, brazil_number_id, death_date, patient_address, country_acronym, country_desc, country_code, state_code, state_description, city_name, nationality_code, neighborhood_name, adress_number, additional_information_address, postal_code, ddi_home_phone_number, ddd_home_phone_number, home_phone_number, ddi_add_home_phone_number, ddd_add_home_phone_number, add_home_phone_number, mobile_phone_number, ddd_mobile_phone_number, ddi_mobile_phone_number, business_phone_number, patient_email, cd_pessoa_fisica, provider_number, abo_system, rh_system, height_cm, weight_kg, medicare_number, medicare_position, dve_number, dve_type, member_ship_number, health_fund_id, health_fund_member, street_code, post_code, street_type, street_number, street_name, suburb_name, dc_client_id, patient_ihi, provider_hpii, ethicity_code, ethicity_desc, corporate_name, corporate_address, corporate_post_code, corporate_city, employee_code, drivers_license_number, external_account_number) AS select a.cd_pessoa_fisica patient_id,
    a.nr_prontuario medical_record_id,
    a.nr_pront_ext external_medical_record_id,
    obter_dados_pf(a.cd_pessoa_fisica,'PNC') patient_name,
    coalesce(c.ds_given_name,CASE WHEN a.nr_seq_person_name IS NULL THEN obter_dados_pf(a.cd_pessoa_fisica,'PNG') END ) patient_given_name,
    coalesce(c.ds_family_name,CASE WHEN a.nr_seq_person_name IS NULL THEN obter_dados_pf(a.cd_pessoa_fisica,'PNL') END ) patient_last_name,
    coalesce(c.ds_component_name_1,CASE WHEN a.nr_seq_person_name IS NULL THEN  obter_dados_pf(a.cd_pessoa_fisica,'PNM') END ) patient_middle_name,
    substr(obter_compl_pf(a.cd_pessoa_fisica,'5','N'),1,60) mother_name,
    substr(obter_parte_nome_pf(obter_compl_pf(a.cd_pessoa_fisica,'5','N'), 'nome'), 1, 60) mother_given_name,
    substr(obter_parte_nome_pf(obter_compl_pf(a.cd_pessoa_fisica,'5','N'), 'sobrenome'), 1, 60) mother_last_name,
	substr(obter_parte_nome_pf(obter_compl_pf(a.cd_pessoa_fisica,'5','N'), 'restonome'), 1, 60) mother_middle_name,
	substr(obter_compl_pf(a.cd_pessoa_fisica,'5','I'),1,255) mother_civil_id,
	substr(obter_compl_pf(a.cd_pessoa_fisica,'3','N'),1,60) responsible_name,
	substr(obter_compl_pf(a.cd_pessoa_fisica,'3','I'),1,60) responsible_civil_id,
	CASE WHEN a.ie_sexo='I' THEN  'U' WHEN a.ie_sexo='D' THEN  'O'  ELSE a.ie_sexo END  patient_sex,
    get_personal_title(a.nr_seq_forma_trat, 'A') patient_title,
    a.ie_sexo sex_id,
    a.dt_nascimento date_of_birth,
    pkg_date_formaters.to_varchar(a.dt_nascimento,'shortDate', a.cd_estabelecimento, a.nm_usuario) char_date_of_birth,
    a.nr_seq_cor_pele skin_color_code,
    (select max(e.cd_raca_hl7) FROM cor_pele e
      where e.nr_sequencia = a.nr_seq_cor_pele) hl7_race_code,
    a.ie_estado_civil marital_status,
    a.cd_religiao religion_code,
    (select max(r.cd_externo) from religiao r
      where r.cd_religiao = a.cd_religiao) external_religion_code,
    obter_prontuario_pf(obter_estabelecimento_ativo,a.cd_pessoa_fisica) medical_record,
    a.cd_rfc patient_national_id,
    a.nr_cpf taxpayer_id,
    a.nr_identidade brazil_number_id,
    a.dt_obito death_date,
    b.ds_endereco patient_address,
    obter_dados_pais(b.nr_seq_pais,'SG') country_acronym,
    obter_dados_pais(b.nr_seq_pais,'N') country_desc,
    b.nr_seq_pais country_code,
    b.sg_estado state_code,
    obter_valor_dominio(50,b.sg_estado) state_description,
    b.ds_municipio city_name,
    a.cd_nacionalidade nationality_code,
    b.ds_bairro neighborhood_name,
    b.nr_endereco adress_number,
    b.ds_complemento additional_information_address,
    b.cd_cep postal_code,
    b.nr_ddi_telefone ddi_home_phone_number,
    b.nr_ddd_telefone ddd_home_phone_number,
    replace(elimina_caractere_esp_asc(b.nr_telefone,'S','S'),' ','') home_phone_number,
    b.nr_ddi_fone_adic ddi_add_home_phone_number,
    b.nr_ddd_fone_adic ddd_add_home_phone_number,
    replace(b.ds_fone_adic,' ','') add_home_phone_number,
    replace(elimina_caractere_esp_asc(a.nr_telefone_celular,'S','S'),' ','') mobile_phone_number,
    a.nr_ddd_celular ddd_mobile_phone_number,
    a.nr_ddi_celular ddi_mobile_phone_number,
    obter_compl_pf(a.cd_pessoa_fisica, 2, 'T') business_phone_number,
    b.ds_email patient_email,
    a.cd_pessoa_fisica,
    a.ds_codigo_prof provider_number,
	a.ie_tipo_sangue abo_system,
    a.ie_fator_rh rh_system,
    a.qt_altura_cm height_cm,
    a.qt_peso weight_kg,
    coalesce(get_insurance_details_aus(a.cd_pessoa_fisica,'MED','MN'),a.cd_rfc) medicare_number,
    get_insurance_details_aus(a.cd_pessoa_fisica,'MED','POC') medicare_position,
    get_insurance_details_aus(a.cd_pessoa_fisica,'DVA','DN') dve_number,
    get_insurance_details_aus(a.cd_pessoa_fisica,'DVA','DT') dve_type,
    get_insurance_details_aus(a.cd_pessoa_fisica,'HFUND','HN') member_ship_number,
    get_insurance_details_aus(a.cd_pessoa_fisica,'HFUND','HFI') health_fund_id,
    get_insurance_details_aus(a.cd_pessoa_fisica,'HFUND','HFM') health_fund_member,
    get_info_end_endereco(b.nr_seq_pessoa_endereco,'ESTADO_PROVINCI','C') street_code,
    get_info_end_endereco(b.nr_seq_pessoa_endereco,'CODIGO_POSTAL','C') post_code,
    get_info_end_endereco(b.nr_seq_pessoa_endereco,'TIPO_LOGRAD','D') street_type,
    get_info_end_endereco(b.nr_seq_pessoa_endereco,'TIPO_LOGRAD','CD') street_number,
    get_info_end_endereco(b.nr_seq_pessoa_endereco,'RUA_VIALIDADE','D') street_name,
    get_info_end_endereco(b.nr_seq_pessoa_endereco,'BAIRRO_VILA','D') suburb_name,
    dc_obter_conversao_externa_int(null,'PESSOA_FISICA','CD_PESSOA_FISICA',a.cd_pessoa_fisica,'DC') dc_client_id,
    get_person_ihi(a.cd_pessoa_fisica,'I') patient_ihi,
    get_person_ihi(a.cd_pessoa_fisica,'P') provider_hpii,
    sus_obter_etnia(a.cd_pessoa_fisica, 'C') ethicity_code,
    sus_obter_etnia(a.cd_pessoa_fisica, 'D') ethicity_desc,
    d.corporate_name,
    d.address corporate_address,
    d.postal_code corporate_post_code,
    d.city corporate_city,
    a.cd_funcionario employee_code,
    a.nr_cnh drivers_license_number,
    (select max(pfe.account_number_ext) from pf_codigo_externo pfe
      where pfe.cd_pessoa_fisica = a.cd_pessoa_fisica
      and coalesce(pfe.cd_estabelecimento, coalesce(a.cd_estabelecimento, -1)) = coalesce(a.cd_estabelecimento, -1)) external_account_number
  from pessoa_fisica a
  left outer join compl_pessoa_fisica b
  on a.cd_pessoa_fisica     = b.cd_pessoa_fisica
  and b.ie_tipo_complemento = 1
  left outer join person_name c
  on c.nr_sequencia = a.nr_seq_person_name
  left outer join bft_service_provider_v d
  on a.cd_estabelecimento = d.establishment_code;
