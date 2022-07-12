-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_ausen_exige_lib ( nr_seq_motivo_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(1)	:= 'N';
nr_seq_classif_ausencia_w	bigint;


BEGIN

select	coalesce(nr_seq_classif_ausencia,0)
into STRICT	nr_seq_classif_ausencia_w
from	pls_atend_motivo_ausencia
where	nr_sequencia	= nr_seq_motivo_p;

if (nr_seq_classif_ausencia_w > 0) then
	select	ie_exige_liberacao
	into STRICT	ds_retorno_w
	from	pls_classif_ausencia_atend
	where	nr_sequencia	= nr_seq_classif_ausencia_w
	and	ie_situacao	= 'A';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_ausen_exige_lib ( nr_seq_motivo_p bigint) FROM PUBLIC;

