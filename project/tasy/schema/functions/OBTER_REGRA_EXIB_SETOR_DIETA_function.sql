-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_exib_setor_dieta (cd_setor_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1) := 'N';
qt_registros_w		bigint;
cd_classif_setor_w 	varchar(2);


BEGIN

if (cd_setor_atendimento_p > 0) then

	select	count(*)
	into STRICT	qt_registros_w
	from	regra_exib_setor_dieta;

	if (qt_registros_w > 0) then

		select	cd_classif_setor
		into STRICT	cd_classif_setor_w
		from	setor_atendimento
		where	cd_setor_atendimento = cd_setor_atendimento_p;

		select	count(*)
		into STRICT 	qt_registros_w
		from 	regra_exib_setor_dieta
		where (cd_setor_atendimento =  cd_setor_atendimento_p
		or 		cd_classif_setor = cd_classif_setor_w);


		if (qt_registros_w > 0) then
			ds_retorno_w := 'S';
		end if;

	else
		ds_retorno_w := 'S';
	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_exib_setor_dieta (cd_setor_atendimento_p bigint) FROM PUBLIC;

