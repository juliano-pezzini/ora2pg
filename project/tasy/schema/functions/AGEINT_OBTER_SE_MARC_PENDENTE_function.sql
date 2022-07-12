-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_obter_se_marc_pendente ( nm_usuario_p text) RETURNS varchar AS $body$
DECLARE



qt_marc_pendente_w	bigint	:= 0;
cd_profissional_w	varchar(10);
nr_Seq_Ageint_w		bigint;
ds_retorno_W		varchar(1)	:= 'N';

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	agenda_integrada
	where	dt_inicio_Agendamento between trunc(clock_timestamp()) and trunc(clock_timestamp()) +  + 86399/86400
	and	cd_profissional	= cd_profissional_w;


BEGIN

select 	max(cd_pessoa_fisica)
into STRICT	cd_profissional_W
from	usuario
where	nm_usuario	= nm_usuario_p;

open C01;
loop
fetch C01 into
	nr_Seq_Ageint_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (qt_marc_pendente_w = 0) then
		select	count(*)
		into STRICT	qt_marc_pendente_w
		from	ageint_marcacao_usuario
		where	nr_seq_ageint			= nr_seq_Ageint_w
		and	coalesce(ie_gerado,'N') 		= 'N'
		and	coalesce(ie_horario_auxiliar,'N')	= 'N'
		and	nm_usuario			= nm_usuario_p;
	end if;

	end;
end loop;
close C01;

if (qt_marc_pendente_w	> 0) then
	ds_retorno_W	:= 'S';
end if;

return	ds_retorno_W;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_obter_se_marc_pendente ( nm_usuario_p text) FROM PUBLIC;
