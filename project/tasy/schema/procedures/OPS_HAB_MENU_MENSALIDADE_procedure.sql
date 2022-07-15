-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ops_hab_menu_mensalidade ( nr_seq_mensalidade_p bigint, nr_seq_lote_mensalidade_p bigint, nr_seq_contrato_pagador_p bigint, nr_seq_cobranca_escritual_p INOUT bigint, qt_cobranca_escritual_p INOUT bigint, ie_contrato_pagador_p INOUT text, qt_log_erro_p INOUT bigint) AS $body$
BEGIN

if (nr_seq_mensalidade_p IS NOT NULL AND nr_seq_mensalidade_p::text <> '') then
	select	substr(obter_lote_desconto_folha(nr_seq_mensalidade_p),1,255)
	into STRICT	nr_seq_cobranca_escritual_p
	;
end if;

if (nr_seq_lote_mensalidade_p IS NOT NULL AND nr_seq_lote_mensalidade_p::text <> '') then
	select	count(*)
	into STRICT	qt_cobranca_escritual_p
	from	cobranca_escritural
	where	nr_seq_lote_mensalidade = nr_seq_lote_mensalidade_p;

	select  count(*)
	into STRICT	qt_log_erro_p
	from	pls_mensalidade_log
	where	nr_seq_lote = nr_seq_lote_mensalidade_p;
end if;

if (nr_seq_contrato_pagador_p IS NOT NULL AND nr_seq_contrato_pagador_p::text <> '') then
	select	CASE WHEN coalesce(nr_seq_contrato::text, '') = '' THEN  'S'  ELSE 'N' END
	into STRICT	ie_contrato_pagador_p
	from	pls_contrato_pagador
	where	nr_sequencia = nr_seq_contrato_pagador_p;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ops_hab_menu_mensalidade ( nr_seq_mensalidade_p bigint, nr_seq_lote_mensalidade_p bigint, nr_seq_contrato_pagador_p bigint, nr_seq_cobranca_escritual_p INOUT bigint, qt_cobranca_escritual_p INOUT bigint, ie_contrato_pagador_p INOUT text, qt_log_erro_p INOUT bigint) FROM PUBLIC;

