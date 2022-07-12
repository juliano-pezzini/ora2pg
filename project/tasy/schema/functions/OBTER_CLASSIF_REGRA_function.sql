-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_classif_regra (nr_seq_regra_p bigint, nr_seq_classif_p bigint) RETURNS varchar AS $body$
DECLARE


ie_classif_regra_w		varchar(1);
qt_regra_w				bigint;

BEGIN
ie_classif_regra_w := 'S';

select	count(*)
into STRICT	qt_regra_w
from	regra_envio_sms_paciente
where	nr_seq_regra_p = nr_seq_regra;

if (qt_regra_w > 0) then
	select	coalesce(max('S'),'N')
	into STRICT	ie_classif_regra_w
	from	regra_envio_sms_paciente
	where	nr_seq_classif = nr_seq_classif_p
	and		nr_seq_regra_p = nr_seq_regra;
end if;

return	ie_classif_regra_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_classif_regra (nr_seq_regra_p bigint, nr_seq_classif_p bigint) FROM PUBLIC;

