-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_mens_itens_preco_pre_pck.obter_vl_pre_ultima_mens ( nr_seq_segurado_p pls_mensalidade_segurado.nr_seq_segurado%type, dt_referencia_p pls_mensalidade_segurado.dt_mesano_referencia%type) RETURNS bigint AS $body$
DECLARE

nr_seq_mens_seg_ant_w	pls_mensalidade_segurado.nr_sequencia%type;
vl_preco_ant_w		pls_mensalidade_seg_item.vl_item%type;

BEGIN
vl_preco_ant_w	:= 0;

select	max(b.nr_sequencia)
into STRICT	nr_seq_mens_seg_ant_w
from	pls_mensalidade_seg_item a,
	pls_mensalidade_segurado b,
	pls_mensalidade c
where	a.nr_seq_mensalidade_seg = b.nr_sequencia
and	b.nr_seq_mensalidade = c.nr_sequencia
and	coalesce(c.ie_cancelamento::text, '') = ''
and	a.ie_tipo_item = 1
and	b.nr_seq_segurado = nr_seq_segurado_p
and	b.dt_mesano_referencia = add_months(dt_referencia_p,-1);

if (nr_seq_mens_seg_ant_w IS NOT NULL AND nr_seq_mens_seg_ant_w::text <> '') then
	begin
	select	sum(vl_item)
	into STRICT	vl_preco_ant_w
	from	pls_mensalidade_seg_item
	where	nr_seq_mensalidade_seg = nr_seq_mens_seg_ant_w
	and	ie_tipo_item in (1,5); --Somar o valor do preco pre e do reajuste de faixa etaria se existir.
	exception
	when others then
		vl_preco_ant_w := 0;
	end;
end if;

return coalesce(vl_preco_ant_w,0);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_mens_itens_preco_pre_pck.obter_vl_pre_ultima_mens ( nr_seq_segurado_p pls_mensalidade_segurado.nr_seq_segurado%type, dt_referencia_p pls_mensalidade_segurado.dt_mesano_referencia%type) FROM PUBLIC;
