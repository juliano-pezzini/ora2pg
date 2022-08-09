-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_forma_pagto_tef ( nr_seq_bandeira_p bigint, ie_tipo_cartao_p text, qt_parcelas_p bigint, nr_seq_forma_pagto_p INOUT bigint) AS $body$
DECLARE


nr_seq_forma_pagto_w	bigint;


BEGIN

select	max(a.nr_seq_forma_pagto)
into STRICT	nr_seq_forma_pagto_w
from	forma_pagto_tef a,
	FORMA_PAGTO_CARTAO_CR b
where	a.nr_seq_forma_pagto	= b.nr_sequencia
and	a.nr_seq_bandeira		= nr_seq_bandeira_p
and	b.ie_situacao		= 'A'
and	((a.ie_tipo_cartao    		= ie_tipo_cartao_p)
	 or (a.ie_tipo_cartao 	= 'A'))
and	CASE WHEN qt_parcelas_p=0 THEN 1  ELSE qt_parcelas_p END  between a.nr_parcela_inicio and a.nr_parcela_fim;

nr_seq_forma_pagto_p	:= nr_seq_forma_pagto_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_forma_pagto_tef ( nr_seq_bandeira_p bigint, ie_tipo_cartao_p text, qt_parcelas_p bigint, nr_seq_forma_pagto_p INOUT bigint) FROM PUBLIC;
