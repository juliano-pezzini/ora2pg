-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nome_tablespace ( nm_objeto_p text, ie_tipo_p text) RETURNS varchar AS $body$
DECLARE

/* 
	Esta rotina não deve ser documentada nos objetos do Dicionário de Dados 
*/
 
 
nm_tablespace_w	varchar(50) := null;


BEGIN 
 
return	nm_tablespace_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_tablespace ( nm_objeto_p text, ie_tipo_p text) FROM PUBLIC;

