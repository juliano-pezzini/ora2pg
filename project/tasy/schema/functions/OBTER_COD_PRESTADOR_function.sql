-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cod_prestador ( cd_interno_p text, cd_setor_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


cd_classif_setor_w   	bigint;
cd_prestador_w		varchar(11);


BEGIN

select 	cd_classif_setor
into STRICT 	cd_classif_setor_w
from 	setor_atendimento
where 	cd_setor_atendimento = cd_setor_atendimento_p;

if (cd_classif_setor_w = 5) then

	 select max(distinct(cd_externo))
	 into STRICT 	cd_prestador_w
	 from 	conversao_meio_externo
	 where 	cd_interno = to_char(cd_setor_atendimento_p)
	 and 	nm_atributo = 'CD_PREST_EXEC';
	 RETURN cd_prestador_w;

else
	RETURN cd_interno_p;
end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cod_prestador ( cd_interno_p text, cd_setor_atendimento_p bigint) FROM PUBLIC;
