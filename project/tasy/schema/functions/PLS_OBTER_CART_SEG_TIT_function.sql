-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_cart_seg_tit (nr_titulo_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(4000) := '';
cd_pessoa_fisica_w	varchar(4000);
nr_seq_segurado_w	bigint;
nr_seq_pagador_w	bigint;


BEGIN
if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') then
	select	nr_seq_pagador,
		cd_pessoa_fisica
	into STRICT	nr_seq_pagador_w,
		cd_pessoa_fisica_w
	from	titulo_receber
	where	nr_titulo = nr_titulo_p;

	if (coalesce(nr_seq_pagador_w::text, '') = '') then
		select	max(a.nr_sequencia)
		into STRICT	nr_seq_pagador_w
		from	pls_contrato_pagador a
		where	a.cd_pessoa_fisica = cd_pessoa_fisica_w;
	end if;

	select	pls_obter_segurado_pagador(nr_seq_pagador_w)
	into STRICT	nr_seq_segurado_w
	;

	if (coalesce(nr_seq_segurado_w::text, '') = '') then
		select	max(a.nr_sequencia)
		into STRICT	nr_seq_segurado_w
		from	pls_segurado a
		where	a.nr_seq_pagador = nr_seq_pagador_w;

		if (coalesce(nr_seq_segurado_w::text, '') = '') then
			select	max(x.nr_sequencia)
			into STRICT	nr_seq_segurado_w
			from	pls_segurado x
			where	x.cd_pessoa_fisica = cd_pessoa_fisica_w;
		end if;
	end if;

	if (nr_seq_segurado_w IS NOT NULL AND nr_seq_segurado_w::text <> '') then
		ds_retorno_w := substr(pls_obter_dados_cart_segurado(nr_seq_segurado_w, 'C'),1,14);
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_cart_seg_tit (nr_titulo_p bigint) FROM PUBLIC;
