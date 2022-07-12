-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE nicu_patient_demographics_pck.get_staff_info ( nr_seq_encounter_p nicu_encounter.nr_sequencia%type, ie_field_order_p bigint, cd_exp_valor_dominio_p INOUT bigint, ds_value_p INOUT text) AS $body$
DECLARE


cd_professional_role_w	nicu_settings.cd_professional_role1%type := '';
cd_exp_valor_dominio_w  valor_dominio.cd_exp_valor_dominio%type;


BEGIN

    select	case ie_field_order_p
                when 1 then max(cd_professional_role1)
                when 2 then max(cd_professional_role2)
                when 3 then max(cd_professional_role3)
                when 4 then max(cd_professional_role4)
                else 'XPTO' end
    into STRICT	cd_professional_role_w
    from 	nicu_settings;

    if (cd_professional_role_w <> 'XPTO') then

        select	max(cd_exp_valor_dominio)
        into STRICT	cd_exp_valor_dominio_p
        from	valor_dominio
        where	cd_dominio = 10497
        and		upper(vl_dominio) = upper(cd_professional_role_w);

        select	max(nm_employee)
        into STRICT	ds_value_p
        from	nicu_encounter_staff
        where	nr_seq_encounter = nr_seq_encounter_p
        and	ie_type = cd_professional_role_w;

    end if;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nicu_patient_demographics_pck.get_staff_info ( nr_seq_encounter_p nicu_encounter.nr_sequencia%type, ie_field_order_p bigint, cd_exp_valor_dominio_p INOUT bigint, ds_value_p INOUT text) FROM PUBLIC;