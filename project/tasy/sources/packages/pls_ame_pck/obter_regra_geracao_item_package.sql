-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_ame_pck.obter_regra_geracao_item ( nr_seq_regra_ger_arq_p pls_ame_regra_ger_arq.nr_sequencia%type, ie_tipo_item_p pls_mensalidade_seg_item.ie_tipo_item%type) RETURNS bigint AS $body$
DECLARE


nr_seq_regra_geracao_item_w	pls_ame_regra_ger_item.nr_sequencia%type;


BEGIN

select	max(x.nr_sequencia)
into STRICT	nr_seq_regra_geracao_item_w
from	pls_ame_regra_ger_item		x
where	x.nr_seq_regra_ger_arq		= nr_seq_regra_ger_arq_p
and	x.ie_regra_excecao		= 'N'
and	x.ie_tipo_item_mens		= ie_tipo_item_p;

if (coalesce(nr_seq_regra_geracao_item_w::text, '') = '') then
	select	max(x.nr_sequencia)
	into STRICT	nr_seq_regra_geracao_item_w
	from	pls_ame_regra_ger_item		x
	where	x.nr_seq_regra_ger_arq		= nr_seq_regra_ger_arq_p
	and	x.ie_regra_excecao		= 'N'
	and	coalesce(x.ie_tipo_item_mens::text, '') = '';
end if;

return	nr_seq_regra_geracao_item_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_ame_pck.obter_regra_geracao_item ( nr_seq_regra_ger_arq_p pls_ame_regra_ger_arq.nr_sequencia%type, ie_tipo_item_p pls_mensalidade_seg_item.ie_tipo_item%type) FROM PUBLIC;