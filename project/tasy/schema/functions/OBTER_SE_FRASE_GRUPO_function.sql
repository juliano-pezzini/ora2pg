-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_frase_grupo ( nr_seq_grupo_p bigint, nr_seq_frase_p bigint) RETURNS varchar AS $body$
DECLARE


ie_liberado_w	varchar(1)	:= 'S';
qt_existe_w	integer;

BEGIN

select	count(*)
into STRICT	qt_existe_w
from	lab_frases_regra
where	nr_seq_lab_frases = nr_seq_frase_p;

if (qt_existe_w > 0) then

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_liberado_w
	from	lab_frases_regra
	where	nr_seq_lab_frases	= nr_seq_frase_p
	and	nr_seq_grupo		= nr_seq_grupo_p;

end if;

return	ie_liberado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_frase_grupo ( nr_seq_grupo_p bigint, nr_seq_frase_p bigint) FROM PUBLIC;

