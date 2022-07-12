-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

                      --Treatment Interface InternalProcedure
    

	/** 
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Append data with values
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	**/
CREATE OR REPLACE PROCEDURE nais_mla_internalpro.append_text ( ds_text_p text, qt_size_p bigint, ie_left_rigth_p text default 'L', ds_default_p text default ' ') AS $body$
BEGIN
        if ( ie_left_rigth_p = 'R' ) then
            PERFORM set_config('nais_mla_internalpro.ds_line_w', current_setting('nais_mla_internalpro.ds_line_w')::varchar(32767)
                         || rpad(ds_text_p, qt_size_p, ds_default_p), false);
        else
            PERFORM set_config('nais_mla_internalpro.ds_line_w', current_setting('nais_mla_internalpro.ds_line_w')::varchar(32767)
                         || lpad(ds_text_p, qt_size_p, ds_default_p), false);
        end if;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nais_mla_internalpro.append_text ( ds_text_p text, qt_size_p bigint, ie_left_rigth_p text default 'L', ds_default_p text default ' ') FROM PUBLIC;
