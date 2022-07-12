-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_leitos_livres_setor ( cd_setor_atendimento_p bigint ) RETURNS bigint AS $body$
DECLARE


qt_unidades_setor_w	smallint;


BEGIN

select	count(*)
into STRICT	qt_unidades_setor_w
from	setor_atendimento c,
     	unidade_atendimento b
where 	b.cd_setor_atendimento     	= c.cd_setor_atendimento
and	b.ie_situacao              	= 'A'
and	b.ie_status_unidade 		= 'L'
and	c.cd_setor_atendimento 	= cd_setor_atendimento_p;
return	qt_unidades_setor_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_leitos_livres_setor ( cd_setor_atendimento_p bigint ) FROM PUBLIC;

