-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pagina_linha ( nr_rownum_p bigint, qt_total_registro_p bigint, qt_max_linha_pagina_p bigint) RETURNS bigint AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Obter o número da página de uma linha , quando deseja se estipular um número máximo de linhas para
uma página
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [ X]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
qt_total_pagina_w	bigint;
nr_pagina_w		bigint	:= null;


BEGIN

qt_total_pagina_w	:= trunc(coalesce(qt_total_registro_p,1) / coalesce(qt_max_linha_pagina_p,1));

if (qt_total_pagina_w >= 1) and (nr_rownum_p <= qt_total_registro_p) then
	nr_pagina_w	:= 1;
	while(nr_pagina_w <= qt_total_pagina_w) loop
		if (nr_rownum_p <= nr_pagina_w * coalesce(qt_max_linha_pagina_p,1)) then
			exit;
		else
			nr_pagina_w	:= nr_pagina_w + 1;
		end if;
	end loop;
end if;

return	nr_pagina_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pagina_linha ( nr_rownum_p bigint, qt_total_registro_p bigint, qt_max_linha_pagina_p bigint) FROM PUBLIC;

