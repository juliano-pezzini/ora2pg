-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


    /** 
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	append text procedure 
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    **/
 


CREATE OR REPLACE PROCEDURE tosho_pck.append_text ( ds_text_p text, qt_size_p bigint, ie_left_rigth_p text default 'L', ds_default_p text default ' ') AS $body$
BEGIN
        if ( ie_left_rigth_p = 'R' ) then
            PERFORM set_config('tosho_pck.ds_line_w', current_setting('tosho_pck.ds_line_w')::varchar(32767) || substr(rpad(ds_text_p, qt_size_p, ds_default_p), 1, qt_size_p), false);

        else
            PERFORM set_config('tosho_pck.ds_line_w', current_setting('tosho_pck.ds_line_w')::varchar(32767) || substr(lpad(ds_text_p, qt_size_p, ds_default_p), 1, qt_size_p), false);
        end if;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tosho_pck.append_text ( ds_text_p text, qt_size_p bigint, ie_left_rigth_p text default 'L', ds_default_p text default ' ') FROM PUBLIC;
