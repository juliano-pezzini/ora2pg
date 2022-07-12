-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_grupo_quest_visivel (nr_seq_grupo_p bigint) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_visivel_w	varchar(1);


BEGIN

select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_visivel_w
from	modelo_grupo_regra_visual a,
	modelo_grupo_conteudo b
where	a.nr_seq_grupo	= b.nr_sequencia
and	b.nr_sequencia	= nr_seq_grupo_p;

return	ie_visivel_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_grupo_quest_visivel (nr_seq_grupo_p bigint) FROM PUBLIC;
