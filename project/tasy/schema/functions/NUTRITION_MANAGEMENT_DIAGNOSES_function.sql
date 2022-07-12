-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION nutrition_management_diagnoses (nr_atendimento_p bigint DEFAULT NULL) RETURNS varchar AS $body$
DECLARE
    RSQL varchar(32767);

    C1 IS CURSOR
                WITH disease AS (SELECT get_desc_modify_disease(dd.cd_doenca, dd.ie_side_modifier, dd.nr_seq_jap_pref_1, dd.nr_seq_jap_pref_2, dd.nr_seq_jap_pref_3,dd.nr_seq_jap_sufi_1, dd.nr_seq_jap_sufi_2, dd.nr_seq_jap_sufi_3) ds_modified_disease
                                  FROM cpoe_dieta cd,
                                       Diagnostico_Doenca Dd
                                 WHERE cd.cd_diagnostico = cd_doenca 
                                   AND cd.nr_atendimento =  nr_atendimento_p
                                 GROUP BY get_desc_modify_disease(dd.cd_doenca, dd.ie_side_modifier, dd.nr_seq_jap_pref_1, dd.nr_seq_jap_pref_2, dd.nr_seq_jap_pref_3,dd.nr_seq_jap_sufi_1, dd.nr_seq_jap_sufi_2, dd.nr_seq_jap_sufi_3)
                                 ) 
                  SELECT RTRIM(XMLAGG(XMLELEMENT(name e, d.ds_modified_disease, ',')
                               ORDER BY d.ds_modified_disease).EXTRACT['//text()'].getclobval(), ',') AS diagnoses
                   FROM disease d;

BEGIN    OPEN C1;
    FETCH C1 INTO RSQL;
    CLOSE C1;
    RETURN RSQL;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nutrition_management_diagnoses (nr_atendimento_p bigint DEFAULT NULL) FROM PUBLIC;
