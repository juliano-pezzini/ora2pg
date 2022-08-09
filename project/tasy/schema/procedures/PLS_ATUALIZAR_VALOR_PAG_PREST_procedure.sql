-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_valor_pag_prest ( nr_seq_pagamento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Atualizar o valor do pagamento prestador
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
-------------------------------------------------------------------------------------------------------------------
Referências:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_saldo_negativo_w		varchar(255);
vl_pagamento_w			double precision	:= 0;
vl_item_w			double precision;
nr_seq_pag_item_w		bigint;

C01 CURSOR FOR
	SELECT	a.vl_item
	from	pls_pagamento_item	a
	where	a.vl_item > 0
	and	a.nr_seq_pagamento	= nr_seq_pagamento_p;

C02 CURSOR FOR
	SELECT	abs(a.vl_item),
		b.ie_saldo_negativo,
		a.nr_sequencia
	from	pls_evento		b,
		pls_pagamento_item 	a
	where	b.nr_sequencia 		= a.nr_seq_evento
	and	a.nr_seq_pagamento 	= nr_seq_pagamento_p
	and	b.ie_natureza		= 'D'
	and	a.vl_item		< 0
	order by
		coalesce(a.nr_prior_desc, 0) desc;


BEGIN
open C01;
loop
fetch C01 into
	vl_item_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	vl_pagamento_w	:= vl_pagamento_w + vl_item_w;
	end;
end loop;
close C01;

open C02;
loop
fetch C02 into
	vl_item_w,
	ie_saldo_negativo_w,
	nr_seq_pag_item_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	if	((vl_pagamento_w - vl_item_w) < 0) and (ie_saldo_negativo_w = 'AT') then
		update	pls_pagamento_item
		set	ie_apropriar_total	= 'S'
		where	nr_sequencia		= nr_seq_pag_item_w;
	else
		vl_pagamento_w	:= vl_pagamento_w - vl_item_w;
	end if;
	end;
end loop;
close C02;

update	pls_pagamento_prestador
set	vl_pagamento	= vl_pagamento_w
where	nr_sequencia	= nr_seq_pagamento_p;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_valor_pag_prest ( nr_seq_pagamento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
