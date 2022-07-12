-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_desc_modify_disease_epc ( nr_seq_disease_number_p diagnostico_doenca.nr_seq_disease_number%type, ie_side_modifier_p diagnostico_doenca.ie_side_modifier%type, nr_seq_jap_pref_1_p diagnostico_doenca.nr_seq_jap_pref_1%type, nr_seq_jap_pref_2_p diagnostico_doenca.nr_seq_jap_pref_2%type, nr_seq_jap_pref_3_p diagnostico_doenca.nr_seq_jap_pref_3%type, nr_seq_jap_sufi_1_p diagnostico_doenca.nr_seq_jap_sufi_1%type, nr_seq_jap_sufi_2_p diagnostico_doenca.nr_seq_jap_sufi_2%type, nr_seq_jap_sufi_3_p diagnostico_doenca.nr_seq_jap_sufi_3%type, nr_seq_interno_p diagnostico_doenca.nr_seq_interno%type default null) RETURNS varchar AS $body$
DECLARE

	description_modify_disease_w varchar(255);
	description_side_modifier_w  varchar(255);
	description_pref_1_w         varchar(255);
	description_pref_2_w         varchar(255);
	description_pref_3_w         varchar(255);
	description_disease_w        varchar(255);
	description_sufi_1_w         varchar(255);
	description_sufi_2_w         varchar(255);
	description_sufi_3_w         varchar(255);
	ds_preliminary_w             diagnostico_doenca.ds_diagnostico%type;

BEGIN
    if (nr_seq_disease_number_p IS NOT NULL AND nr_seq_disease_number_p::text <> '') then
    IF (ie_side_modifier_p IS NOT NULL AND ie_side_modifier_p::text <> '') THEN
      description_side_modifier_w := Obter_valor_dominio_idioma(10074,
                                     ie_side_modifier_p,
                                     wheb_usuario_pck.get_nr_seq_idioma);

      description_modify_disease_w := coalesce(description_modify_disease_w, '')
                                      || coalesce(description_side_modifier_w, '');
    END IF;

    IF (nr_seq_jap_pref_1_p IS NOT NULL AND nr_seq_jap_pref_1_p::text <> '') THEN
      SELECT trim(both ds_modifier_notation)
      INTO STRICT   description_pref_1_w
      FROM   icd_code_modifier_jpn
      WHERE  nr_modifier_mgmt_num = nr_seq_jap_pref_1_p;

      description_modify_disease_w := coalesce(description_modify_disease_w, '')
                                      || coalesce(description_pref_1_w, '');
    END IF;

    IF (nr_seq_jap_pref_2_p IS NOT NULL AND nr_seq_jap_pref_2_p::text <> '') THEN
      SELECT trim(both ds_modifier_notation)
      INTO STRICT   description_pref_2_w
      FROM   icd_code_modifier_jpn
      WHERE  nr_modifier_mgmt_num = nr_seq_jap_pref_2_p;

      description_modify_disease_w := coalesce(description_modify_disease_w, '')
                                      || coalesce(description_pref_2_w, '');
    END IF;

    IF (nr_seq_jap_pref_3_p IS NOT NULL AND nr_seq_jap_pref_3_p::text <> '') THEN
      SELECT trim(both ds_modifier_notation)
      INTO STRICT   description_pref_3_w
      FROM   icd_code_modifier_jpn
      WHERE  nr_modifier_mgmt_num = nr_seq_jap_pref_3_p;

      description_modify_disease_w := coalesce(description_modify_disease_w, '')
                                      || coalesce(description_pref_3_w, '');
    END IF;

    IF (nr_seq_disease_number_p IS NOT NULL AND nr_seq_disease_number_p::text <> '') THEN
      SELECT trim(both ds_disease_name)
      INTO STRICT   description_disease_w
      FROM   icd_codes_main_jpn
      WHERE  nr_disease_number = nr_seq_disease_number_p;

      description_modify_disease_w := coalesce(description_modify_disease_w, '')
                                      || coalesce(description_disease_w, '');
    END IF;

    IF (nr_seq_jap_sufi_1_p IS NOT NULL AND nr_seq_jap_sufi_1_p::text <> '') THEN
      SELECT trim(both ds_modifier_notation)
      INTO STRICT   description_sufi_1_w
      FROM   icd_code_modifier_jpn
      WHERE  nr_modifier_mgmt_num = nr_seq_jap_sufi_1_p;

      description_modify_disease_w := coalesce(description_modify_disease_w, '')
                                      || coalesce(description_sufi_1_w, '');
    END IF;

    IF (nr_seq_jap_sufi_2_p IS NOT NULL AND nr_seq_jap_sufi_2_p::text <> '') THEN
      SELECT trim(both ds_modifier_notation)
      INTO STRICT   description_sufi_2_w
      FROM   icd_code_modifier_jpn
      WHERE  nr_modifier_mgmt_num = nr_seq_jap_sufi_2_p;

      description_modify_disease_w := coalesce(description_modify_disease_w, '')
                                      || coalesce(description_sufi_2_w, '');
    END IF;

    IF (nr_seq_jap_sufi_3_p IS NOT NULL AND nr_seq_jap_sufi_3_p::text <> '') THEN
      SELECT trim(both ds_modifier_notation)
      INTO STRICT   description_sufi_3_w
      FROM   icd_code_modifier_jpn
      WHERE  nr_modifier_mgmt_num = nr_seq_jap_sufi_3_p;

      description_modify_disease_w := coalesce(description_modify_disease_w, '')
                                      || coalesce(description_sufi_3_w, '');
    END IF;
	IF (nr_seq_interno_p IS NOT NULL AND nr_seq_interno_p::text <> '') THEN
      SELECT CASE WHEN IE_TIPO_DIAGNOSTICO=1 THEN  ' - ' || Obter_valor_dominio(13,IE_TIPO_DIAGNOSTICO)   ELSE null END
      INTO STRICT   ds_preliminary_w
      FROM   diagnostico_doenca
      WHERE  nr_seq_interno = nr_seq_interno_p;

      description_modify_disease_w := coalesce(description_modify_disease_w, '')
                                      || coalesce(ds_preliminary_w, '');
    END IF;
    end if;
    RETURN coalesce(description_modify_disease_w, '');
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_desc_modify_disease_epc ( nr_seq_disease_number_p diagnostico_doenca.nr_seq_disease_number%type, ie_side_modifier_p diagnostico_doenca.ie_side_modifier%type, nr_seq_jap_pref_1_p diagnostico_doenca.nr_seq_jap_pref_1%type, nr_seq_jap_pref_2_p diagnostico_doenca.nr_seq_jap_pref_2%type, nr_seq_jap_pref_3_p diagnostico_doenca.nr_seq_jap_pref_3%type, nr_seq_jap_sufi_1_p diagnostico_doenca.nr_seq_jap_sufi_1%type, nr_seq_jap_sufi_2_p diagnostico_doenca.nr_seq_jap_sufi_2%type, nr_seq_jap_sufi_3_p diagnostico_doenca.nr_seq_jap_sufi_3%type, nr_seq_interno_p diagnostico_doenca.nr_seq_interno%type default null) FROM PUBLIC;
