-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_nascidos_cih ( cd_procedimento_p bigint, nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE


qt_filhos_vivos_w	smallint;


BEGIN

select 	coalesce(qt_nasc_vivos,0) + coalesce(qt_nasc_mortos,0)
into STRICT 	qt_filhos_vivos_w
from 	parto
where 	nr_atendimento = nr_atendimento_p;

if (cd_procedimento_p in (35007010,35006013,35001011,35025018,35027010,35080019,35009012,35026014,35082011,35084014,35085010,35028017
			,411010034, 411010026, 411010042, 310010039, 310010047)) then
	return qt_filhos_vivos_w;
else
	return 0;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_nascidos_cih ( cd_procedimento_p bigint, nr_atendimento_p bigint) FROM PUBLIC;
