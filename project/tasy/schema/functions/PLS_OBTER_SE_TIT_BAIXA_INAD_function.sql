-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_tit_baixa_inad (nr_titulo_p bigint) RETURNS varchar AS $body$
DECLARE


ie_inadimplente_w		varchar(1)	:= 'N';
nr_seq_pagador_w		bigint;


BEGIN
select	max(a.nr_seq_pagador)
into STRICT	nr_seq_pagador_w
from	titulo_receber	b,
	pls_mensalidade	a
where	a.nr_sequencia	= b.nr_seq_mensalidade
and	b.nr_titulo	= nr_titulo_p;

select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_inadimplente_w
from	pls_contrato_pagador	b,
	pls_notificacao_pagador a
where	a.nr_seq_pagador	= b.nr_sequencia
and	b.nr_sequencia		= nr_seq_pagador_w
and	(a.dt_rescisao IS NOT NULL AND a.dt_rescisao::text <> '');

return	ie_inadimplente_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_tit_baixa_inad (nr_titulo_p bigint) FROM PUBLIC;

