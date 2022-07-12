-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ev_obter_se_evento_perfil (nr_seq_tipo_p bigint) RETURNS varchar AS $body$
DECLARE

ie_retorno_w		varchar(1);
qt_possui_regra_w	integer;

BEGIN
select	count(*)
into STRICT	qt_possui_regra_w
from	ev_tipo_evento_regra
where	nr_seq_tipo = nr_seq_tipo_p;

if (qt_possui_regra_w = 0) then
	ie_retorno_w := 'S';
else
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_retorno_w
	from	ev_tipo_evento_regra
	where	nr_seq_tipo = nr_seq_tipo_p
	and	cd_perfil = obter_perfil_ativo;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ev_obter_se_evento_perfil (nr_seq_tipo_p bigint) FROM PUBLIC;

