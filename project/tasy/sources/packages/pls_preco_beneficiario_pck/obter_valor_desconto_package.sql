-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_preco_beneficiario_pck.obter_valor_desconto ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_seq_contrato_p pls_segurado.nr_seq_contrato%type, dt_preco_p pls_segurado_preco.dt_reajuste%type, vl_preco_atual_p pls_segurado_preco.vl_preco_atual%type, nr_seq_titular_p pls_segurado.nr_seq_titular%type, ie_tipo_parentesco_p grau_parentesco.ie_tipo_parentesco%type, vl_desconto_p INOUT pls_segurado_preco.vl_desconto%type, nr_seq_regra_desc_p INOUT pls_regra_desconto.nr_sequencia%type) AS $body$
DECLARE


nr_seq_regra_desc_w		pls_regra_desconto.nr_sequencia%type	:= null;
tx_desconto_w			pls_preco_regra.tx_desconto%type	:= null;
vl_desconto_regra_w		pls_preco_regra.vl_desconto%type	:= null;
qt_vidas_w			bigint;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		b.ie_tipo_segurado,
		b.qt_min_vidas,
		b.qt_max_vidas,
		b.tx_desconto,
		b.vl_desconto
	from	pls_regra_desconto	a,
		pls_preco_regra		b
	where	a.nr_sequencia		= b.nr_seq_regra
	and	a.nr_seq_contrato	= nr_seq_contrato_p
	and	dt_preco_p between coalesce(a.dt_inicio_vigencia,dt_preco_p) and coalesce(a.dt_fim_vigencia,dt_preco_p)
	and	a.ie_situacao	= 'A'
	and	((a.ie_tipo_regra = 'T') or
		((a.ie_tipo_regra = 'I') and (coalesce(nr_seq_titular_p::text, '') = '')) or
		(a.ie_tipo_regra = 'L' AND ie_tipo_parentesco_p = '1') or
		((a.ie_tipo_regra = 'E') and ((ie_tipo_parentesco_p = '1') or (coalesce(nr_seq_titular_p::text, '') = ''))));

BEGIN

for r_c01_w in c01 loop
	begin
	qt_vidas_w	:= coalesce(pls_obter_quantidade_vidas(nr_seq_segurado_p, r_c01_w.ie_tipo_segurado, 'C'), 0);
	
	if (qt_vidas_w between r_c01_w.qt_min_vidas and r_c01_w.qt_max_vidas) then
		nr_seq_regra_desc_w	:= r_c01_w.nr_sequencia;
		tx_desconto_w		:= r_c01_w.tx_desconto;
		vl_desconto_regra_w	:= r_c01_w.vl_desconto;
	end if;
	end;
end loop;

nr_seq_regra_desc_p	:= nr_seq_regra_desc_w;
vl_desconto_p		:= (vl_preco_atual_p * (coalesce(tx_desconto_w, 0) / 100)) + coalesce(vl_desconto_regra_w, 0);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_preco_beneficiario_pck.obter_valor_desconto ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_seq_contrato_p pls_segurado.nr_seq_contrato%type, dt_preco_p pls_segurado_preco.dt_reajuste%type, vl_preco_atual_p pls_segurado_preco.vl_preco_atual%type, nr_seq_titular_p pls_segurado.nr_seq_titular%type, ie_tipo_parentesco_p grau_parentesco.ie_tipo_parentesco%type, vl_desconto_p INOUT pls_segurado_preco.vl_desconto%type, nr_seq_regra_desc_p INOUT pls_regra_desconto.nr_sequencia%type) FROM PUBLIC;
