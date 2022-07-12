-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_unid_regra (nr_seq_regra_p bigint, nr_seq_unidade_p bigint) RETURNS varchar AS $body$
DECLARE


ie_liberado_w			varchar(01)	:= 'S';
qt_regra_w			bigint;


BEGIN

select	count(*)
into STRICT	qt_regra_w
from	sl_regra_servico_unid
where	nr_seq_regra_servico = nr_seq_regra_p;

if (qt_regra_w <> 0) then

	select	coalesce(max('S'), 'N')
	into STRICT	ie_liberado_w
	from	sl_regra_servico_unid
	where	nr_seq_regra_servico	= nr_seq_regra_p
	and	nr_seq_unidade		= nr_seq_unidade_p;

end if;

return	ie_liberado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_unid_regra (nr_seq_regra_p bigint, nr_seq_unidade_p bigint) FROM PUBLIC;

