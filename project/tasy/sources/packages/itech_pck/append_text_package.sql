-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

 -- patient errror cursor 
     -- urine errror cursor
    


CREATE OR REPLACE PROCEDURE itech_pck.append_text ( ds_text_p text, qt_size_p bigint, ie_left_rigth_p text default 'L', ds_default_p text default ' ') AS $body$
DECLARE

    ds_text_w varchar(32767);

BEGIN
    ds_text_w := ds_text_p;
    if coalesce(ds_text_w::text, '') = '' then
        ds_text_w := ' ';
    end if;
    if (ie_left_rigth_p ='R') then
      PERFORM set_config('itech_pck.ds_line_w', current_setting('itech_pck.ds_line_w')::varchar(32767)|| rpad(ds_text_w,qt_size_p,ds_default_p), false);
    else
      PERFORM set_config('itech_pck.ds_line_w', current_setting('itech_pck.ds_line_w')::varchar(32767)|| lpad(ds_text_w,qt_size_p,ds_default_p), false);
    end if;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE itech_pck.append_text ( ds_text_p text, qt_size_p bigint, ie_left_rigth_p text default 'L', ds_default_p text default ' ') FROM PUBLIC;
