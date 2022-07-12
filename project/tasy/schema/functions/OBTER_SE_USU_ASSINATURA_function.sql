-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_usu_assinatura (cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


ie_tipo_w varchar(1) := 'N';


BEGIN
    if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
        select	max('S')
        into STRICT	ie_tipo_w
        from	usuario_assinatura a,
                usuario b
        where	a.nm_usuario_atual = b.nm_usuario
        and	    b.cd_pessoa_fisica = cd_pessoa_fisica_p
        and     a.ie_tipo = 'A';
    end if;

    return	ie_tipo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_usu_assinatura (cd_pessoa_fisica_p text) FROM PUBLIC;
