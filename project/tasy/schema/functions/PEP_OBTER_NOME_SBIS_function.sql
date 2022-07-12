-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pep_obter_nome_sbis ( nr_atendimento_p bigint, nm_pf_p text default null) RETURNS varchar AS $body$
DECLARE

 
nm_pf_w		varchar(255);
ie_sbis_w	varchar(1);


BEGIN 
ie_sbis_w := obter_param_usuario(0, 220, obter_perfil_ativo, obter_usuario_ativo, obter_estabelecimento_ativo, ie_sbis_w);
 
if (ie_sbis_w = 'S') then 
 
	select	max(substr(obter_dados_pf_sbis(nr_atendimento_p,'NOME'),1,255)) 
	into STRICT	nm_pf_w 
	;
	 
end if;
 
return	coalesce(nm_pf_w,nm_pf_p);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pep_obter_nome_sbis ( nr_atendimento_p bigint, nm_pf_p text default null) FROM PUBLIC;

