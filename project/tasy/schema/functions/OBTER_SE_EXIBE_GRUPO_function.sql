-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exibe_grupo ( nr_seq_grupo_p bigint, cd_perfil_p bigint, cd_setor_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w			char(1) := 'S';
nr_seq_agrupamento_w	bigint;

c01 CURSOR FOR
SELECT	coalesce(a.ie_incluir,'S')
from	grupo_exame_rotina_lib a
where	a.nr_seq_grupo = nr_seq_grupo_p
and		coalesce(a.cd_perfil,cd_perfil_p) = cd_perfil_p
and		((coalesce(cd_setor_atendimento::text, '') = '') or (cd_setor_atendimento = cd_setor_atendimento_p))
and		coalesce(a.nr_seq_agrupamento,nr_seq_agrupamento_w) = nr_seq_agrupamento_w
order by
	coalesce(a.cd_perfil,0),
	coalesce(a.cd_setor_atendimento,0),
	coalesce(a.nr_seq_agrupamento,0);


BEGIN

Select	coalesce(max('N'),'S')
into STRICT	ie_retorno_w
from	grupo_exame_rotina_lib where		nr_seq_grupo = nr_seq_grupo_p LIMIT 1;

if (ie_retorno_w = 'N') then
	nr_seq_agrupamento_w	:= obter_agrupamento_setor(cd_setor_atendimento_p);
open c01;
loop
fetch c01 into ie_retorno_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	ie_retorno_w := ie_retorno_w;
end loop;
close c01;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exibe_grupo ( nr_seq_grupo_p bigint, cd_perfil_p bigint, cd_setor_atendimento_p bigint) FROM PUBLIC;
