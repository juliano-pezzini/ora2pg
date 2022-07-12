-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ie_delegation_profile (nm_proxy_p text, cd_departamento_p bigint, cd_cargo_p bigint) RETURNS varchar AS $body$
DECLARE


nm_usuario_w        usuario.nm_usuario%type;
ie_response_w       varchar(1) := 'N';
ie_department_w     varchar(1) := 'N';
ie_cargo_w          varchar(1) := 'N';

BEGIN

nm_usuario_w    := obter_usuario_ativo;

if (nm_proxy_p = nm_usuario_w) then
    ie_response_w   := 'S';
    goto finalize;
end if;

select  coalesce(max('S'), 'N')
into STRICT    ie_department_w
from    USER_MEDICAL_DEPARTMENT u
where   NM_USUARIO = nm_usuario_w
and     CD_DEPARTAMENTO = cd_departamento_p;

select  coalesce(max('S'), 'N')
into STRICT    ie_cargo_w
from    pessoa_fisica
where   cd_pessoa_fisica = obter_pf_usuario(nm_usuario_w, 'C')
and     cd_cargo = cd_cargo_p;

if ((ie_department_w = 'S' and ie_cargo_w = 'S') or ie_department_w = 'S' or ie_cargo_w = 'S') then
    ie_response_w   := 'S';
end if;

<<finalize>>
return	ie_response_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ie_delegation_profile (nm_proxy_p text, cd_departamento_p bigint, cd_cargo_p bigint) FROM PUBLIC;
