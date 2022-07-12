-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_registro_ptu_a300 ( nr_sequencia_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


qt_total_w	bigint := 0;


BEGIN

if (ie_opcao_p	= '302') then
	select	count(1)
	into STRICT	qt_total_w
	from	ptu_mov_produto_empresa		a,
		ptu_movimentacao_produto	b
	where	a.nr_seq_mov_produto	= b.nr_sequencia
	and	b.nr_sequencia		= nr_sequencia_p;
elsif (ie_opcao_p	= '304') then
	select	count(1)
	into STRICT	qt_total_w
	from	ptu_mov_produto_benef		a,
		ptu_mov_produto_empresa		b,
		ptu_movimentacao_produto	c
	where	b.nr_seq_mov_produto	= c.nr_sequencia
	and	a.nr_seq_empresa	= b.nr_sequencia
	and	c.nr_sequencia		= nr_sequencia_p;
elsif (ie_opcao_p	= '306') then
	select	count(1)
	into STRICT	qt_total_w
	from	ptu_mov_produto_benef		a,
		ptu_mov_produto_empresa		b,
		ptu_movimentacao_produto	c,
		ptu_movimento_benef_compl	d
	where	b.nr_seq_mov_produto	= c.nr_sequencia
	and	a.nr_seq_empresa	= b.nr_sequencia
	and	d.nr_seq_beneficiario	= a.nr_sequencia
	and	c.nr_sequencia		= nr_sequencia_p
	and	d.ie_tipo_endereco 	= '1';
elsif (ie_opcao_p	= 'QT_ALTERADOS') then
	select	count(1)
	into STRICT	qt_total_w
	from	ptu_mov_produto_benef		a,
		ptu_mov_produto_empresa		b,
		ptu_movimentacao_produto	c
	where	b.nr_seq_mov_produto	= c.nr_sequencia
	and	a.nr_seq_empresa	= b.nr_sequencia
	and	c.nr_sequencia		= nr_sequencia_p;
elsif (ie_opcao_p	= 'QT_PLANO') then
	select	count(1)
	into STRICT	qt_total_w
	from	ptu_mov_produto_benef		a,
		ptu_mov_produto_empresa		b,
		ptu_movimentacao_produto	c
	where	b.nr_seq_mov_produto	= c.nr_sequencia
	and	a.nr_seq_empresa	= b.nr_sequencia
	and	c.nr_sequencia		= nr_sequencia_p;
elsif (ie_opcao_p	= 'QT_INCLUSAO') then
	select	count(1)
	into STRICT	qt_total_w
	from	ptu_mov_produto_benef		a,
		ptu_mov_produto_empresa		b,
		ptu_movimentacao_produto	c
	where	b.nr_seq_mov_produto	= c.nr_sequencia
	and	a.nr_seq_empresa	= b.nr_sequencia
	and	(a.dt_inclusao IS NOT NULL AND a.dt_inclusao::text <> '')
	and	b.nr_sequencia		= nr_sequencia_p;
elsif (ie_opcao_p	= 'QT_EXCLUSAO') then
	select	count(1)
	into STRICT	qt_total_w
	from	ptu_mov_produto_benef		a,
		ptu_mov_produto_empresa		b,
		ptu_movimentacao_produto	c
	where	b.nr_seq_mov_produto	= c.nr_sequencia
	and	a.nr_seq_empresa	= b.nr_sequencia
	and	(a.dt_exclusao IS NOT NULL AND a.dt_exclusao::text <> '')
	and	b.nr_sequencia		= nr_sequencia_p;
end if;

return	qt_total_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_registro_ptu_a300 ( nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;
