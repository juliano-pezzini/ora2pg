-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_qt_vinc_res_pag ( nr_seq_conta_p pls_conta_medica_resumo.nr_seq_conta%type, nr_seq_item_p pls_conta_medica_resumo.nr_seq_item%type, ie_opcao_p text) RETURNS integer AS $body$
DECLARE


qt_retorno_w	integer;


BEGIN
-- validação para registros de pagamento da Produção Médica. Verifica se existe
-- algum registro na conta médica resumo com um lote de pagamento
/* ie_opcao_P =

C - Conta
CP - Conta proc
CM - Conta mat
PP - Participante proc
*/
if (ie_opcao_p = 'C') then

	select	sum(qt)
	into STRICT	qt_retorno_w
	from (
		SELECT	count(1) qt
		from	pls_conta_medica_resumo a,
			pls_lote_pagamento b
		where	a.nr_seq_conta = nr_seq_item_p
		and	b.nr_sequencia = a.nr_seq_lote_pgto
		
union all

		SELECT	count(1) qt
		from	pls_conta_medica_resumo a,
			pls_pp_lote b
		where	a.nr_seq_conta = nr_seq_item_p
		and	b.nr_sequencia = a.nr_seq_pp_lote
	) alias4;

elsif (ie_opcao_p = 'CP') then

	select	sum(qt)
	into STRICT	qt_retorno_w
	from (
		SELECT	count(1) qt
		from	pls_conta_medica_resumo a,
			pls_lote_pagamento b
		where	a.nr_seq_conta = nr_seq_conta_p
		and	a.nr_seq_conta_proc = nr_seq_item_p
		and	b.nr_sequencia = a.nr_seq_lote_pgto
		
union all

		SELECT	count(1) qt
		from	pls_conta_medica_resumo a,
			pls_pp_lote b
		where	a.nr_seq_conta = nr_seq_conta_p
		and	a.nr_seq_conta_proc = nr_seq_item_p
		and	b.nr_sequencia = a.nr_seq_pp_lote
	) alias4;

elsif (ie_opcao_p = 'CM') then

	select	sum(qt)
	into STRICT	qt_retorno_w
	from (
		SELECT	count(1) qt
		from	pls_conta_medica_resumo a,
			pls_lote_pagamento b
		where	a.nr_seq_conta = nr_seq_conta_p
		and	a.nr_seq_conta_mat = nr_seq_item_p
		and	b.nr_sequencia = a.nr_seq_lote_pgto
		
union all

		SELECT	count(1) qt
		from	pls_conta_medica_resumo a,
			pls_pp_lote b
		where	a.nr_seq_conta = nr_seq_conta_p
		and	a.nr_seq_conta_mat = nr_seq_item_p
		and	b.nr_sequencia = a.nr_seq_pp_lote
	) alias4;

elsif (ie_opcao_p = 'PP') then

	select	sum(qt)
	into STRICT	qt_retorno_w
	from (
		SELECT	count(1) qt
		from	pls_conta_medica_resumo a,
			pls_lote_pagamento b
		where	a.nr_seq_conta = nr_seq_conta_p
		and	a.nr_seq_participante = nr_seq_item_p
		and	b.nr_sequencia = a.nr_seq_lote_pgto
		
union all

		SELECT	count(1) qt
		from	pls_conta_medica_resumo a,
			pls_pp_lote b
		where	a.nr_seq_conta = nr_seq_conta_p
		and	a.nr_seq_participante = nr_seq_item_p
		and	b.nr_sequencia = a.nr_seq_pp_lote
	) alias4;

else

	select	sum(qt)
	into STRICT	qt_retorno_w
	from (
		SELECT	count(1) qt
		from	pls_conta_medica_resumo a,
			pls_lote_pagamento b
		where	a.nr_seq_conta = nr_seq_conta_p
		and	a.nr_seq_item = nr_seq_item_p
		and	b.nr_sequencia = a.nr_seq_lote_pgto
		
union all

		SELECT	count(1) qt
		from	pls_conta_medica_resumo a,
			pls_pp_lote b
		where	a.nr_seq_conta = nr_seq_conta_p
		and	a.nr_seq_item = nr_seq_item_p
		and	b.nr_sequencia = a.nr_seq_pp_lote
	) alias3;
end if;

return qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_qt_vinc_res_pag ( nr_seq_conta_p pls_conta_medica_resumo.nr_seq_conta%type, nr_seq_item_p pls_conta_medica_resumo.nr_seq_item%type, ie_opcao_p text) FROM PUBLIC;
