-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_pagto_escrit ( nr_seq_escrit_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
/*	ie_opcao_p 
 
'QTRI'		Quantidade de registros tipo 0, 1, 3, 5 e 9 - Itaú 
'QTRC'		Quantidade de registros tipo 1, 3 e 5 - Caixa 
'QTDOCC'	Quantidade de registros tipo 1, 3 e 5 (segmentos A e B) - Caixa 
'QTBLQC'	Quantidade de registros tipo 1, 3 e 5 (bloqueto) - Caixa 
'QTLS'		Quantidade de lotes - Santander 
'QTRHSBC'	Quantidade de registros tipo 0, 1, 3, 5 e 9 - HSBC 
'QTLHSBC'	Quantidade de lotes - HSBC 
 
*/
 
 
qt_registro_doc_w	bigint	:= 0;
qt_registro_blq_w	bigint	:= 0;
qt_blq_nao_itau_w	bigint	:= 0;
qt_registro_ted_w	bigint	:= 0;
qt_registro_cc_w	bigint	:= 0;
qt_lote_w		bigint	:= 0;
ds_retorno_w		varchar(255);


BEGIN 
 
if (ie_opcao_p = 'QTRI') or (ie_opcao_p = 'QTRI2') then 
 
	/* registro documento */
 
	select	count(*) 
	into STRICT	qt_registro_doc_w 
	from	titulo_pagar_v2 d, 
		titulo_pagar_escrit c, 
		banco_estabelecimento b, 
		banco_escritural a 
	where	a.nr_sequencia		= nr_seq_escrit_p 
	and	a.nr_seq_conta_banco	= b.nr_sequencia 
	and	b.ie_tipo_relacao	in ('EP','ECC') 
	and	a.nr_sequencia		= c.nr_seq_escrit 
	and 	c.ie_tipo_pagamento	= 'DOC' 
	and	c.nr_titulo		= d.nr_titulo;
 
	if (qt_registro_doc_w > 0) then	/* somar o header e o trailer de lote */
 
		qt_registro_doc_w	:= qt_registro_doc_w + 2;
	end if;
 
	/* registro bloqueto itaú */
 
	select	count(*) 
	into STRICT	qt_registro_blq_w 
	from	titulo_pagar d, 
		titulo_pagar_escrit c, 
		banco_estabelecimento b, 
		banco_escritural a 
	where	a.nr_sequencia		= nr_seq_escrit_p 
	and	a.nr_seq_conta_banco	= b.nr_sequencia 
	and	b.ie_tipo_relacao	in ('EP','ECC') 
	and	a.nr_sequencia		= c.nr_seq_escrit 
	and 	c.ie_tipo_pagamento	= 'BLQ' 
	and	c.nr_titulo		= d.nr_titulo 
	and	'341'			= substr(d.nr_bloqueto, 1,3);
 
	if (qt_registro_blq_w > 0) then	/* somar o header e o trailer de lote */
 
		qt_registro_blq_w	:= qt_registro_blq_w + 2;
	end if;
 
	/* registro bloqueto não itaú */
 
	select	count(*) 
	into STRICT	qt_blq_nao_itau_w 
	from	titulo_pagar d, 
		titulo_pagar_escrit c, 
		banco_estabelecimento b, 
		banco_escritural a 
	where	a.nr_sequencia		= nr_seq_escrit_p 
	and	a.nr_seq_conta_banco	= b.nr_sequencia 
	and	b.ie_tipo_relacao	in ('EP','ECC') 
	and	a.nr_sequencia		= c.nr_seq_escrit 
	and 	c.ie_tipo_pagamento	= 'BLQ' 
	and	c.nr_titulo		= d.nr_titulo 
	and	'341'			<> substr(d.nr_bloqueto, 1,3);
 
	if (qt_blq_nao_itau_w > 0) then	/* somar o header e o trailer de lote */
 
		qt_blq_nao_itau_w	:= qt_blq_nao_itau_w + 2;
	end if;
 
	/* registro ted */
 
	select	count(*) 
	into STRICT	qt_registro_ted_w 
	from	titulo_pagar_v2 d, 
		titulo_pagar_escrit c, 
		banco_estabelecimento b, 
		banco_escritural a 
	where	a.nr_sequencia		= nr_seq_escrit_p 
	and	a.nr_seq_conta_banco	= b.nr_sequencia 
	and	b.ie_tipo_relacao	in ('EP','ECC') 
	and	a.nr_sequencia		= c.nr_seq_escrit 
	and 	c.ie_tipo_pagamento	= 'TED' 
	and	c.nr_titulo		= d.nr_titulo;
 
	if (qt_registro_ted_w > 0) then	/* somar o header e o trailer de lote */
 
		qt_registro_ted_w	:= qt_registro_ted_w + 2;
	end if;
 
	/* registro conta corrente */
 
	select	count(*) 
	into STRICT	qt_registro_cc_w 
	from	titulo_pagar_v2 d, 
		titulo_pagar_escrit c, 
		banco_estabelecimento b, 
		banco_escritural a 
	where	a.nr_sequencia		= nr_seq_escrit_p 
	and	a.nr_seq_conta_banco	= b.nr_sequencia 
	and	b.ie_tipo_relacao	in ('EP','ECC') 
	and	a.nr_sequencia		= c.nr_seq_escrit 
	and 	c.ie_tipo_pagamento	= 'CC' 
	and	c.nr_titulo		= d.nr_titulo;
 
	if (qt_registro_cc_w > 0) then	/* somar o header e o trailer de lote */
 
		qt_registro_cc_w	:= qt_registro_cc_w + 2;
	end if;
 
	/* somar o header e o trailer de arquivo*/
 
	ds_retorno_w	:= to_char(coalesce(qt_registro_doc_w,0) + coalesce(qt_registro_blq_w,0) + coalesce(qt_blq_nao_itau_w,0) + coalesce(qt_registro_ted_w,0) + coalesce(qt_registro_cc_w,0) + 2);
 
elsif (ie_opcao_p = 'QTRC') then 
 
	/* registro documento - segmento A */
 
	select	count(*) 
	into STRICT	qt_registro_doc_w 
	from	banco_estabelecimento_v b, 
		banco_escritural a, 
		titulo_pagar_escrit c 
	where	a.nr_sequencia		= c.nr_seq_escrit 
	and 	b.ie_tipo_relacao	in ('EP','ECC') 
	and	b.nr_sequencia		= a.nr_seq_conta_banco 
	and 	c.ie_tipo_pagamento	in ('DOC','TED','CC','CCP','OP','PC') 
	and	a.nr_sequencia		= nr_seq_escrit_p;
 
	if (qt_registro_doc_w > 0) then	/* somar os registros do segmento B, e o header e o trailer de lote */
 
		qt_registro_doc_w	:= (qt_registro_doc_w * 2) + 2;
	end if;
 
	select	count(*) 
	into STRICT	qt_registro_blq_w 
	from	banco_estabelecimento_v b, 
		banco_escritural a, 
		titulo_pagar_escrit c 
	where	a.nr_sequencia     	= c.nr_seq_escrit 
	and	b.ie_tipo_relacao    	in ('EP','ECC') 
	and	a.nr_seq_conta_banco		= b.nr_sequencia 
	and 	c.ie_tipo_pagamento		= 'BLQ' 
	and	a.nr_sequencia			= nr_seq_escrit_p;
 
	if (qt_registro_blq_w > 0) then	/* somar o header e o trailer de lote */
 
		qt_registro_blq_w	:= qt_registro_blq_w + 2;
	end if;
 
	ds_retorno_w	:= to_char(coalesce(qt_registro_doc_w,0) + coalesce(qt_registro_blq_w,0));
 
elsif (ie_opcao_p = 'QTDOCC') then 
 
	/* registro documento - segmento A */
 
	select	count(*) 
	into STRICT	qt_registro_doc_w 
	from	banco_estabelecimento_v b, 
		banco_escritural a, 
		titulo_pagar_escrit c 
	where	a.nr_sequencia		= c.nr_seq_escrit 
	and 	b.ie_tipo_relacao	in ('EP','ECC') 
	and	b.nr_sequencia		= a.nr_seq_conta_banco 
	and 	c.ie_tipo_pagamento	in ('DOC','TED','CC','CCP','OP','PC') 
	and	a.nr_sequencia		= nr_seq_escrit_p;
 
	if (qt_registro_doc_w > 0) then	/* somar os registros do segmento B, e o header e o trailer de lote */
 
		qt_registro_doc_w	:= (qt_registro_doc_w * 2) + 2;
	end if;
 
	ds_retorno_w	:= to_char(qt_registro_doc_w);
 
elsif (ie_opcao_p = 'QTBLQC') then 
 
	select	count(*) 
	into STRICT	qt_registro_blq_w 
	from	banco_estabelecimento_v b, 
		banco_escritural a, 
		titulo_pagar_escrit c 
	where	a.nr_sequencia     	= c.nr_seq_escrit 
	and	b.ie_tipo_relacao    	in ('EP','ECC') 
	and	a.nr_seq_conta_banco		= b.nr_sequencia 
	and 	c.ie_tipo_pagamento		= 'BLQ' 
	and	a.nr_sequencia			= nr_seq_escrit_p;
 
	if (qt_registro_blq_w > 0) then	/* somar o header e o trailer de lote */
 
		qt_registro_blq_w	:= qt_registro_blq_w + 2;
	end if;
 
	ds_retorno_w	:= to_char(qt_registro_blq_w);
 
elsif (ie_opcao_p = 'QTLS') then 
 
	select	coalesce(max(1),0) 
	into STRICT	qt_registro_doc_w 
	from	banco_estabelecimento_v b, 
		banco_escritural a, 
		titulo_pagar_escrit c 
	where	a.nr_sequencia		= c.nr_seq_escrit 
	and 	b.ie_tipo_relacao	in ('EP','ECC') 
	and	b.nr_sequencia		= a.nr_seq_conta_banco 
	and 	c.ie_tipo_pagamento	in ('DOC','TED','CC','CCP','OP','PC') 
	and	a.nr_sequencia		= nr_seq_escrit_p;
 
	select	coalesce(max(1),0) 
	into STRICT	qt_registro_blq_w 
	from	banco_estabelecimento_v b, 
		banco_escritural a, 
		titulo_pagar_escrit c 
	where	a.nr_sequencia     	= c.nr_seq_escrit 
	and	b.ie_tipo_relacao    	in ('EP','ECC') 
	and	a.nr_seq_conta_banco		= b.nr_sequencia 
	and 	c.ie_tipo_pagamento		= 'BLQ' 
	and	a.nr_sequencia			= nr_seq_escrit_p;
 
	ds_retorno_w	:= to_char(coalesce(qt_registro_doc_w,0) + coalesce(qt_registro_blq_w,0));
 
elsif (ie_opcao_p = 'QTRHSBC') or (ie_opcao_p = 'QTLHSBC') then 
 
	/* registro documento */
 
	select	count(*) 
	into STRICT	qt_registro_doc_w 
	from	titulo_pagar_v2 d, 
		titulo_pagar_escrit c, 
		banco_estabelecimento b, 
		banco_escritural a 
	where	a.nr_sequencia		= nr_seq_escrit_p 
	and	a.nr_seq_conta_banco	= b.nr_sequencia 
	and	b.ie_tipo_relacao	in ('EP','ECC') 
	and	a.nr_sequencia		= c.nr_seq_escrit 
	and 	c.ie_tipo_pagamento	= 'DOC' 
	and	c.nr_titulo		= d.nr_titulo;
 
	if (qt_registro_doc_w > 0) then	/* somar o header e o trailer de lote */
 
		qt_registro_doc_w	:= qt_registro_doc_w + 2;
		qt_lote_w		:= qt_lote_w + 1;
	end if;
 
	/* registro bloqueto itaú */
 
	select	count(*) 
	into STRICT	qt_registro_blq_w 
	from	titulo_pagar d, 
		titulo_pagar_escrit c, 
		banco_estabelecimento b, 
		banco_escritural a 
	where	a.nr_sequencia		= nr_seq_escrit_p 
	and	a.nr_seq_conta_banco	= b.nr_sequencia 
	and	b.ie_tipo_relacao	in ('EP','ECC') 
	and	a.nr_sequencia		= c.nr_seq_escrit 
	and 	c.ie_tipo_pagamento	= 'BLQ' 
	and	c.nr_titulo		= d.nr_titulo;
 
	if (qt_registro_blq_w > 0) then	/* somar o header e o trailer de lote */
 
		qt_registro_blq_w	:= qt_registro_blq_w + 2;
		qt_lote_w		:= qt_lote_w + 1;
	end if;
 
	if (ie_opcao_p = 'QTRHSBC') then 
		/* somar o header e o trailer de arquivo*/
 
		ds_retorno_w	:= to_char(coalesce(qt_registro_doc_w,0) + coalesce(qt_registro_blq_w,0) + 2);
	else 
		ds_retorno_w	:= to_char(qt_lote_w);
	end if;
 
end if;
 
return	ds_retorno_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_pagto_escrit ( nr_seq_escrit_p bigint, ie_opcao_p text) FROM PUBLIC;

