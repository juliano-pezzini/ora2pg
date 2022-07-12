-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION nais_mla_pck.get_affairs_code ( ie_type_message_p nais_conversion_master.ie_type_message%type, nm_tabela_p nais_conversion_master.nm_tasy_table%type, nm_attribute_p nais_conversion_master.nm_tasy_column%type, int_tasy_code_p nais_conversion_master.vl_tasy_code%type ) RETURNS varchar AS $body$
DECLARE


    r_acct_w nais_conversion_master%rowtype;


BEGIN
        r_acct_w := get_medicalaffair_code(ie_type_message_p, nm_tabela_p, nm_attribute_p, int_tasy_code_p, null, null);

        if (coalesce(r_acct_w.cd_medical_affair::text, '') = '')then
            r_acct_w.cd_medical_affair  := 0;
        end if;

    return r_acct_w.cd_medical_affair;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION nais_mla_pck.get_affairs_code ( ie_type_message_p nais_conversion_master.ie_type_message%type, nm_tabela_p nais_conversion_master.nm_tasy_table%type, nm_attribute_p nais_conversion_master.nm_tasy_column%type, int_tasy_code_p nais_conversion_master.vl_tasy_code%type ) FROM PUBLIC;