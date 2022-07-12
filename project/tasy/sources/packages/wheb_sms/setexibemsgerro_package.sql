-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE wheb_sms.setexibemsgerro ( exibeMsg_p text default 'S') AS $body$
BEGIN
     PERFORM set_config('wheb_sms.exibemsg_w', exibeMsg_p, false);
    end;


$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON PROCEDURE wheb_sms.setexibemsgerro ( exibeMsg_p text default 'S') FROM PUBLIC;
