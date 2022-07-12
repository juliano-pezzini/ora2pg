-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_integra_patient_data_hl7 ( nr_prescricao_p prescr_procedimento.nr_prescricao%TYPE) RETURNS varchar AS $body$
DECLARE


    medical_record_w       varchar(10);
    id_patient_w           pessoa_fisica.cd_pessoa_fisica%TYPE;
    document_w             pessoa_fisica.cd_rfc%TYPE;
    nr_order_w             varchar(14);
    patient_name_w         pessoa_fisica.nm_pessoa_fisica%TYPE;
    surname_father_w       pessoa_fisica.nm_sobrenome_pai%TYPE;
    surname_mother_w       pessoa_fisica.nm_sobrenome_mae%TYPE;
    first_name_w           pessoa_fisica.nm_primeiro_nome%TYPE;
    sex_w                  pessoa_fisica.ie_sexo%TYPE;
    date_birth_w           pessoa_fisica.dt_nascimento%TYPE;
    age_w                  varchar(3);
    identifiertypecode_w   varchar(2);
    assigningfacility_w    varchar(4);
    nametypecode_w         varchar(1);
    street_w               compl_pessoa_fisica.ds_endereco%TYPE;
    house_number_w         varchar(5);
    neighborhood_w         compl_pessoa_fisica.ds_bairro%TYPE;
    city_w                 compl_pessoa_fisica.ds_municipio%TYPE;
    state_w                compl_pessoa_fisica.sg_estado%TYPE;
    postal_code_w          compl_pessoa_fisica.cd_cep%TYPE;
    country_w              pais.sg_pais%TYPE;
    phone_number_w         compl_pessoa_fisica.nr_telefone%TYPE;
    email_w                compl_pessoa_fisica.ds_email%TYPE;
    json_aux_w             philips_json;
    ds_message_w           text;

BEGIN
    json_aux_w := philips_json();
    BEGIN
        SELECT substr(obter_prontuario_pf(b.cd_estabelecimento, a.cd_pessoa_fisica), 1, 30) medical_record,
            a.cd_pessoa_fisica id_patient,
            a.cd_rfc document,
            b.nr_prescricao nr_order,
            substr(a.nm_pessoa_fisica, 0, 100) patient_name,
            substr(a.nm_sobrenome_pai, 0, 100) surname_father,
            substr(a.nm_sobrenome_mae, 0, 100) surname_mother,
            substr(a.nm_primeiro_nome, 0, 100) first_name,
            CASE WHEN a.ie_sexo='I' THEN  'U'  ELSE a.ie_sexo END  sex,
            a.dt_nascimento date_birth,
            substr(obter_idade(a.dt_nascimento, clock_timestamp(), 'A'), 1, 3) age,
            'PI' identifiertypecode,
            'TASY' assigningfacility,
            'L' nametypecode,
            c.ds_endereco street,
            c.nr_endereco house_number,
            c.ds_bairro neighborhood,
            c.ds_municipio city,
            c.sg_estado state,
            c.cd_cep postal_code,
            (SELECT sg_pais FROM pais WHERE nr_sequencia = c.nr_seq_pais) country,
            c.nr_telefone phone_number,
            c.ds_email email
        INTO STRICT medical_record_w,
             id_patient_w,
             document_w,
             nr_order_w,
             patient_name_w,
             surname_father_w,
             surname_mother_w,
             first_name_w,
             sex_w,
             date_birth_w,
             age_w,
             identifiertypecode_w,
             assigningfacility_w,
             nametypecode_w,
             street_w,
             house_number_w,
             neighborhood_w,
             city_w,
             state_w,
             postal_code_w,
             country_w,
             phone_number_w,
             email_w
        FROM pessoa_fisica         a,
             prescr_medica         b,
             compl_pessoa_fisica   c
        WHERE a.cd_pessoa_fisica = b.cd_pessoa_fisica
        AND a.cd_pessoa_fisica = c.cd_pessoa_fisica
        AND c.ie_tipo_complemento = 1
        AND (b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
        AND b.nr_prescricao = nr_prescricao_p;

        json_aux_w.put('medical_record', medical_record_w);
        json_aux_w.put('id_patient', id_patient_w);
        json_aux_w.put('document', document_w);
        json_aux_w.put('nr_order', nr_order_w);
        json_aux_w.put('patient_name', patient_name_w);
        json_aux_w.put('surname_father', surname_father_w);
        json_aux_w.put('surname_mother', surname_mother_w);
        json_aux_w.put('first_name', first_name_w);
        json_aux_w.put('sex', sex_w);
        json_aux_w.put('date_birth', to_char(date_birth_w, 'mm/dd/yyyy'));
        json_aux_w.put('age', age_w);
        json_aux_w.put('identifiertypecode', identifiertypecode_w);
        json_aux_w.put('assigningfacility', assigningfacility_w);
        json_aux_w.put('nametypecode', nametypecode_w);
        json_aux_w.put('street', street_w);
        json_aux_w.put('house_number', house_number_w);
        json_aux_w.put('neighborhood', neighborhood_w);
        json_aux_w.put('city', city_w);
        json_aux_w.put('state', state_w);
        json_aux_w.put('postal_code', postal_code_w);
        json_aux_w.put('country', country_w);
        json_aux_w.put('phone_number', phone_number_w);
        json_aux_w.put('email', email_w);
        dbms_lob.createtemporary(ds_message_w, true);
        json_aux_w.(ds_message_w);
    EXCEPTION
        WHEN no_data_found OR too_many_rows THEN
            ds_message_w := '';
    END;

    RETURN ds_message_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_integra_patient_data_hl7 ( nr_prescricao_p prescr_procedimento.nr_prescricao%TYPE) FROM PUBLIC;
