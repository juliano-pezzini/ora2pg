-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nr_registro_pagto (nr_seq_envio_p bigint, nr_titulo_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


/* ie_opcao_p

'DS'	DOC e TED Santander
'BS'	BLQ Santander

*/
nr_reg_lote_w	numeric(20);


BEGIN

If (ie_opcao_p	= 'DS') then

	Select	max(nr_linha)
	into STRICT	nr_reg_lote_w
	from (SELECT	nr_titulo,
			row_number() OVER () AS nr_linha
		from (Select	c.nr_titulo
			from	titulo_pagar_escrit c,
				banco_estabelecimento_v b,
				banco_escritural a
			where (c.ie_tipo_pagamento 	= 'DOC' or c.ie_tipo_pagamento = 'TED')
			and	a.nr_sequencia		= c.nr_seq_escrit
			and 	b.ie_tipo_relacao	in ('EP','ECC')
			and	a.nr_seq_conta_banco	= b.nr_sequencia
			and	a.nr_sequencia		= nr_seq_envio_p
			order by	c.nr_titulo
			) alias4
		) alias5
	where	nr_titulo	= nr_titulo_p;

elsif (ie_opcao_p = 'BS') then

	Select	max(nr_linha)
	into STRICT	nr_reg_lote_w
	from (SELECT	nr_titulo,
			row_number() OVER () AS nr_linha
		from (Select	c.nr_titulo
			from	titulo_pagar_escrit c,
				banco_estabelecimento_v b,
				banco_escritural a
			where (c.ie_tipo_pagamento 	= 'BLQ')
			and	a.nr_sequencia		= c.nr_seq_escrit
			and 	b.ie_tipo_relacao	in ('EP','ECC')
			and	a.nr_seq_conta_banco	= b.nr_sequencia
			and	a.nr_sequencia		= nr_seq_envio_p
			order by	c.nr_titulo
			) alias4
		) alias5
	where	nr_titulo	= nr_titulo_p;

end if;

return nr_reg_lote_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nr_registro_pagto (nr_seq_envio_p bigint, nr_titulo_p bigint, ie_opcao_p text) FROM PUBLIC;

