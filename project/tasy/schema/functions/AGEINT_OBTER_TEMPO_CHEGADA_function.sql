-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_obter_tempo_chegada ( nr_seq_proc_interno_p bigint, ie_anestesia_p text) RETURNS bigint AS $body$
DECLARE


vl_retorno_w		bigint;
qt_min_cheg_anest_w	bigint;


BEGIN
select	max(qt_min_preparo)
into STRICT	vl_Retorno_w
from	proc_interno
where	nr_sequencia	= nr_seq_proc_interno_p;

if (coalesce(ie_anestesia_p,'N')	= 'S') then
	select	coalesce(max(qt_min_chegada),0)
	into STRICT	qt_min_cheg_anest_w
	from	ageint_tempo_exame_anest
	where	nr_seq_proc_interno	= nr_seq_proc_interno_p
	and 	coalesce(cd_estabelecimento, wheb_usuario_pck.get_cd_estabelecimento) = wheb_usuario_pck.get_cd_estabelecimento;

	if (qt_min_cheg_anest_w	> 0) then
		vl_Retorno_w	:= qt_min_cheg_anest_w;
	end if;
end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_obter_tempo_chegada ( nr_seq_proc_interno_p bigint, ie_anestesia_p text) FROM PUBLIC;
