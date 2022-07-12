-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_usuario_desenvolvimento (nm_usuario_p usuario.nm_usuario%type) RETURNS varchar AS $body$
DECLARE

		
    ds_retorno_w varchar(1) := 'N';
		

BEGIN

    select coalesce(max('S'),'N')
      into STRICT ds_retorno_w
      from usuario
     where nm_usuario = nm_usuario_p
       and cd_setor_atendimento = 2;

    return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_usuario_desenvolvimento (nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

