-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_agrup_guia_xml ( nr_seq_pagador_p pls_contrato_pagador.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255) := 'N';
nr_seq_regra_w		pls_regra_agrup_guia_xml.nr_sequencia%type;

C01 CURSOR(	nr_seq_pagador_pc	pls_contrato_pagador.nr_sequencia%type,
			cd_estabelecimento_pc	estabelecimento.cd_estabelecimento%type) FOR
	SELECT	ie_agrupamento_guia
	from	pls_regra_agrup_guia_xml
	where (nr_seq_pagador		= nr_seq_pagador_pc or coalesce(nr_seq_pagador::text, '') = '')
	and	cd_estabelecimento	= cd_estabelecimento_pc
	order by nr_seq_pagador;

BEGIN

for r_c01_w in c01( nr_seq_pagador_p, cd_estabelecimento_p) loop
	ds_retorno_w := coalesce(r_c01_w.ie_agrupamento_guia,'N');
end loop;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_agrup_guia_xml ( nr_seq_pagador_p pls_contrato_pagador.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;

