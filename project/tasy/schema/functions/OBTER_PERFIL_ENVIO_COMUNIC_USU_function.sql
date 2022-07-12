-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_perfil_envio_comunic_usu (nr_seq_evento_p bigint) RETURNS varchar AS $body$
DECLARE



cd_perfil_destino_w		varchar(4000);
cd_perfil_regra_w		integer;


C01 CURSOR FOR
SELECT	distinct cd_perfil
from	regra_envio_comunic_usu
where	nr_seq_evento = nr_seq_evento_p
and	(cd_perfil IS NOT NULL AND cd_perfil::text <> '');


BEGIN
open C01;
loop
fetch C01 into
	cd_perfil_regra_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	cd_perfil_destino_w := substr(cd_perfil_destino_w || cd_perfil_regra_w || ',',1,4000);
	end;
end loop;
close C01;

return	cd_perfil_destino_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_perfil_envio_comunic_usu (nr_seq_evento_p bigint) FROM PUBLIC;

