-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_medicalaffair_code ( ie_type_message_p nais_conversion_master.ie_type_message%type, nm_tabela_p nais_conversion_master.nm_tasy_table%type, nm_attribute_p nais_conversion_master.nm_tasy_column%type, int_tasy_code_p nais_conversion_master.vl_tasy_code%type, cd_body_part_p nais_conversion_master.cd_body_part%type default null, cd_direction_p nais_conversion_master.cd_direction%type default null) RETURNS NAIS_CONVERSION_MASTER%ROWTYPE AS $body$
DECLARE

    l_med_rec nais_conversion_master%rowtype;
    record_present_w nais_conversion_master%rowtype;

BEGIN

    <<get_record_all_condition>>
    begin
        select  *
        into STRICT  l_med_rec
        from  nais_conversion_master
        where clock_timestamp() between dt_valid_start and dt_valid_end
        and   ie_send_flaf = 'S'
        and   ie_type_message = ie_type_message_p
        and   nm_tasy_table = nm_tabela_p
        and   nm_tasy_column = nm_attribute_p
        and   vl_tasy_code = int_tasy_code_p
        and   coalesce(cd_body_part,0) = coalesce(cd_body_part_p,0)
        and   coalesce(cd_direction,0) = coalesce(cd_direction_p,0);

    exception
        when too_many_rows  then
            l_med_rec := null;
        when no_data_found then
            l_med_rec := null;

            
                 
            if coalesce(l_med_rec.cd_medical_affair::text, '') = '' then 
           
           <<get_order_type_record>>
            begin
                select 	*
                into STRICT  	record_present_w
                from  	nais_conversion_master
                where   vl_tasy_code = int_tasy_code_p
                and     ie_type_message = ie_type_message_p;
                exception
                  when no_data_found then
                    l_med_rec.cd_medical_affair :='-1';
                 when too_many_rows  then
                    l_med_rec := null;
                    return l_med_rec;
                end;

			
                if (record_present_w.vl_tasy_code IS NOT NULL AND record_present_w.vl_tasy_code::text <> '') then                
                    
                       if  coalesce(record_present_w.nm_tasy_table::text, '') = '' or ( (record_present_w.nm_tasy_table IS NOT NULL AND record_present_w.nm_tasy_table::text <> '') and record_present_w.nm_tasy_table <> nm_tabela_p ) then	
                            l_med_rec.cd_medical_affair := '-2'; --table name incorrect
                        elsif coalesce(record_present_w.nm_tasy_column::text, '') = '' or ( record_present_w.nm_tasy_column is not  null and record_present_w.nm_tasy_column <> nm_attribute_p) then	
                            l_med_rec.cd_medical_affair := '-3';--column name incorrect
                        elsif  record_present_w.ie_send_flaf <> 'S' then	
                            l_med_rec.cd_medical_affair := '-4'; --send flag
                        elsif clock_timestamp() not between record_present_w.dt_valid_start and record_present_w.dt_valid_end then
                            l_med_rec.cd_medical_affair := '-5'; --date range incorrect
                        end if;
                end if;	
			
            end if;
    end;

    
    if coalesce(l_med_rec.cd_medical_affair::text, '') = '' then
		l_med_rec.cd_medical_affair := '-6';
    end if;

    
    return l_med_rec;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_medicalaffair_code ( ie_type_message_p nais_conversion_master.ie_type_message%type, nm_tabela_p nais_conversion_master.nm_tasy_table%type, nm_attribute_p nais_conversion_master.nm_tasy_column%type, int_tasy_code_p nais_conversion_master.vl_tasy_code%type, cd_body_part_p nais_conversion_master.cd_body_part%type default null, cd_direction_p nais_conversion_master.cd_direction%type default null) FROM PUBLIC;

