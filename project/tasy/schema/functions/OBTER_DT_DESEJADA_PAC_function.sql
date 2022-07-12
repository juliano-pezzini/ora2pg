-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dt_desejada_pac ( cd_agenda_p bigint, cd_pessoa_fisica_p text) RETURNS timestamp AS $body$
DECLARE

 
dt_desejada_w  timestamp;


BEGIN 
 
select max(dt_desejada) 
into STRICT  dt_desejada_w 
from  agenda_lista_espera 
where  cd_pessoa_fisica    = cd_pessoa_fisica_p 
and   cd_agenda    = cd_agenda_p 
and   ie_status_espera    = 'A';
 
return dt_desejada_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dt_desejada_pac ( cd_agenda_p bigint, cd_pessoa_fisica_p text) FROM PUBLIC;
