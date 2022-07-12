-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_motivo_susp_lib ( nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE



ie_retorno_w	varchar(10)	:= 'S';
qt_reg_w		bigint;

BEGIN

select	count(*)
into STRICT	qt_reg_w
from	MOTIVO_SUSP_PRESCR_LIB
where	NR_SEQ_MOTIVO_SUSP = nr_sequencia_p;

if (qt_reg_w	> 0) then

	select	count(*)
	into STRICT	qt_reg_w
	from	MOTIVO_SUSP_PRESCR_LIB
	where	NR_SEQ_MOTIVO_SUSP = nr_sequencia_p
	and		cd_perfil	= obter_perfil_ativo;

	if (qt_reg_w	= 0) then
		ie_retorno_w	:= 'N';
	end if;

end if;


return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_motivo_susp_lib ( nr_sequencia_p bigint) FROM PUBLIC;

