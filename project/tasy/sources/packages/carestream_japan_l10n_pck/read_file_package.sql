-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

    
    
    /** 
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Read file for inbound message to process and save in Tasy
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   **/
 


CREATE OR REPLACE PROCEDURE carestream_japan_l10n_pck.read_file (ds_file_p text, ds_file_search_p text,cd_data_event_p text ,ds_messsage INOUT text) AS $body$
DECLARE

    ie_reading_w    boolean := true;
    ds_file_line_w  varchar(32000);
    ds_file_line_wW  varchar(32000);
    ds_file_w varchar(255);

    
BEGIN
        ds_file_line_w := null;
        CALL jpn_utl_file_pck.open_file(cd_data_event_p, ds_file_p); --read the file
         while(ie_reading_w and ds_file_p like ds_file_search_p||'%')
            loop --for each row of the file
              SELECT * FROM jpn_utl_file_pck.read_file(ds_file_line_ww, ie_reading_w) INTO STRICT ds_file_line_ww, ie_reading_w;
              if (ie_reading_w) then
              ds_file_line_w := ds_file_line_w || ds_file_line_ww ||  chr(13) || chr(10);
              end if;
        end loop;

        select encode(ds_file_line_w::bytea, 'hex')::bytea
        into STRICT ds_file_line_w
;
        ds_messsage := ds_file_line_w;

   END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE carestream_japan_l10n_pck.read_file (ds_file_p text, ds_file_search_p text,cd_data_event_p text ,ds_messsage INOUT text) FROM PUBLIC;
