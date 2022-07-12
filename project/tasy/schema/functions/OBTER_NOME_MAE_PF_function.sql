-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nome_mae_pf (cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE

 
ds_contato_mae_w    varchar(255) := '';				
 

BEGIN 
 
select max(coalesce(obter_compl_pf( cd_pessoa_fisica_p ,5,'NPR'),obter_nome_contato( cd_pessoa_fisica_p , 5 ))) 
into STRICT ds_contato_mae_w
;
 
return	ds_contato_mae_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_mae_pf (cd_pessoa_fisica_p text) FROM PUBLIC;
