-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE wheb_sms.logmodo_debug ( log_debug_p text ) AS $body$
BEGIN
     if current_setting('wheb_sms.modo_debug_w')::varchar(1) = 'S' then
      RAISE NOTICE '%',  log_debug_p;
     end if;
    end;


$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON PROCEDURE wheb_sms.logmodo_debug ( log_debug_p text ) FROM PUBLIC;