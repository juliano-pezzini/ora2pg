-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_questoes_grupo_laudo (nr_seq_laudo_p bigint) RETURNS varchar AS $body$
DECLARE


ds_texto_final_w	varchar(2000);
ds_texto_w		varchar(4000);

c01 CURSOR FOR
SELECT	a.ds_texto
from	grupo_questao_laudo c,
	laudo_questao_item a,
	laudo_grupo_questao b
where	b.nr_seq_laudo		= nr_seq_laudo_p
and	a.nr_seq_laudo_grupo	= b.nr_sequencia
and	c.nr_sequencia		= b.nr_seq_grupo_questao
and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
order by c.nr_seq_apres;


BEGIN

open C01;
loop
fetch C01 into
	ds_texto_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	if (coalesce(ds_texto_final_w::text, '') = '') then
		ds_texto_final_w	:= ds_texto_w;
	else
		ds_texto_final_w	:= ds_texto_final_w || chr(13) || ds_texto_w;
	end if;
end loop;
close C01;


return	ds_texto_final_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_questoes_grupo_laudo (nr_seq_laudo_p bigint) FROM PUBLIC;
