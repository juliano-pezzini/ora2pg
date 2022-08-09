-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_mens_item_agravo ( nr_seq_mensalidade_seg_p pls_mensalidade_segurado.nr_sequencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, dt_referencia_p pls_mensalidade_segurado.dt_mesano_referencia%type, vl_mensalidade_p pls_mensalidade_seg_item.vl_item%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


ds_observacao_w			varchar(4000);
vl_agravo_mensalidade_w		pls_mensalidade_seg_item.vl_item%type;
nr_seq_item_mensalidade_w	pls_mensalidade_seg_item.nr_sequencia%type;
ie_inseriu_item_w		varchar(1);

C01 CURSOR FOR
	SELECT	b.nr_sequencia,
		a.nr_seq_agravo,
		coalesce(b.vl_agravo,0) vl_agravo,
		c.ds_agravo,
		b.nr_parcela,
		coalesce(b.tx_agravo,0) tx_agravo,
		a.qt_parcelas
	from	pls_segurado_agravo	a,
		pls_segurado_agravo_parc b,
		pls_agravo		c
	where	b.nr_seq_segurado_agravo	= a.nr_sequencia
	and	a.nr_seq_agravo			= c.nr_sequencia
	and	a.nr_seq_segurado		= nr_seq_segurado_p
	and	trunc(b.dt_mes_competencia,'month')	= dt_referencia_p
	and	coalesce(b.nr_seq_mensalidade_item::text, '') = '';

BEGIN

for r_c01_w in C01 loop
	begin
	ds_observacao_w	:= wheb_mensagem_pck.get_texto(392632,'NR_PARCELA='||r_c01_w.nr_parcela||';QT_PARCELA='||r_c01_w.qt_parcelas||';DS_AGRAVO='||r_c01_w.ds_agravo);
	vl_agravo_mensalidade_w	:= 0;

	if (r_c01_w.vl_agravo <> 0) then
		vl_agravo_mensalidade_w	:= r_c01_w.vl_agravo;
	elsif (r_c01_w.tx_agravo <> 0) then
		vl_agravo_mensalidade_w	:= vl_agravo_mensalidade_w + ((coalesce(r_c01_w.tx_agravo,0)/100) * coalesce(vl_mensalidade_p,0));
	end if;

	if (vl_agravo_mensalidade_w > 0) then
		ie_inseriu_item_w := pls_mens_itens_pck.add_item_agravo(nr_seq_mensalidade_seg_p, '21', vl_agravo_mensalidade_w, r_c01_w.nr_sequencia, ds_observacao_w, ie_inseriu_item_w);
	end if;
	end;
end loop;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mens_item_agravo ( nr_seq_mensalidade_seg_p pls_mensalidade_segurado.nr_sequencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, dt_referencia_p pls_mensalidade_segurado.dt_mesano_referencia%type, vl_mensalidade_p pls_mensalidade_seg_item.vl_item%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
