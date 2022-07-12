-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION verifica_se_setorvv (nm_usuario_p text) RETURNS varchar AS $body$
DECLARE




cd_cargo_w bigint;
ie_setorvv_w varchar(1) := 'N';




BEGIN

 

 select b.cd_cargo
 into STRICT cd_cargo_w
 from usuario a,
  pessoa_fisica b
 where a.cd_pessoa_fisica = b.cd_pessoa_fisica
 and upper(a.nm_usuario) = upper(nm_usuario_p);



 if (cd_cargo_w IS NOT NULL AND cd_cargo_w::text <> '') then
  begin
  if (cd_cargo_w in (1202)) then
   begin
    ie_setorvv_w := 'S';
   end;
  end if;
  end;
 end if;



if (nm_usuario_p = 'tmcardoso') then
 ie_setorvv_w := 'S';
end if;



return ie_setorvv_w;



end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION verifica_se_setorvv (nm_usuario_p text) FROM PUBLIC;

