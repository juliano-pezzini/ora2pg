-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_classif_setor_cross (cd_setor_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


nr_retorno_w 		bigint := 0;
cd_classif_setor_w 	varchar(2);


BEGIN

if (coalesce(cd_setor_atendimento_p,0) > 0) then

	select 	max(cd_classif_setor)
	into STRICT	cd_classif_setor_w
	from	setor_atendimento
	where	cd_setor_atendimento = cd_setor_atendimento_p;

	select	count(*)
	into STRICT	nr_retorno_w
	from	regra_classif_setor_cross
	where	ie_situacao = 'A'
	and		coalesce(cd_classif_setor, cd_classif_setor_w) = cd_classif_setor_w;

	if (nr_retorno_w = 0) then
		select	CASE WHEN count(*)=0 THEN 1  ELSE 0 END
		into STRICT	nr_retorno_w
		from	regra_classif_setor_cross
		where	ie_situacao = 'A';
	end if;

end if;

return nr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_classif_setor_cross (cd_setor_atendimento_p bigint) FROM PUBLIC;
