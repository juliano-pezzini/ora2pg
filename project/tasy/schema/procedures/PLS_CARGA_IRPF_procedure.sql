-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_carga_irpf () AS $body$
DECLARE


qt_tit_w	bigint	:= 0;

c01 CURSOR FOR
	SELECT (SELECT	count(1)
		from	titulo_rec_negociado x,
			titulo_receber y
		where	y.nr_titulo = x.nr_titulo
		and   	y.ie_origem_titulo in ('3','4')
		and	x.nr_seq_negociacao = c.nr_sequencia) qt_tit_negociacao,
		b.nr_titulo,
		c.nr_sequencia nr_seq_negociacao,
		c.cd_estabelecimento,
		b.ie_origem_titulo
	from	titulo_rec_negociado a,
		titulo_receber b,
		negociacao_cr c
	where	c.nr_sequencia = a.nr_seq_negociacao
	and	b.nr_titulo = a.nr_titulo
	and	b.ie_origem_titulo in ('3','4')
	and  	(c.dt_fechamento IS NOT NULL AND c.dt_fechamento::text <> '')
	and	coalesce(c.dt_cancelamento::text, '') = ''
	and	c.vl_negociado > 0
	group by
		b.nr_titulo,
		c.nr_sequencia,
		c.cd_estabelecimento,
		b.ie_origem_titulo
	order by
		c.nr_sequencia asc,
		b.ie_origem_titulo asc;

c02 CURSOR(	nt_titulo_pc	titulo_receber.nr_titulo%type) FOR
	SELECT	nr_sequencia nr_seq_baixa
	from	titulo_receber_liq
	where	nr_titulo = nt_titulo_pc
	order by
		nr_sequencia asc;
	
c03 CURSOR FOR
	SELECT	b.nr_sequencia nr_seq_baixa,
		a.nr_titulo,
		a.cd_estabelecimento
	from	titulo_receber a,
		titulo_receber_liq b
	where	a.nr_titulo = b.nr_titulo
	and	a.ie_origem_titulo = '4'
	and	not exists (	SELECT	1
				from	fis_dados_dmed x
				where	x.nr_titulo_rec = a.nr_titulo
				and	x.nr_seq_baixa_rec = b.nr_sequencia)
	order by
		a.nr_titulo asc,
		b.nr_sequencia asc,
		a.cd_estabelecimento;
	
c04 CURSOR FOR
	SELECT	b.nr_sequencia nr_seq_baixa,
		a.nr_titulo,
		a.cd_estabelecimento
	from	titulo_receber a,
		titulo_receber_liq b
	where	a.nr_titulo = b.nr_titulo
	and	a.ie_origem_titulo = '3'
	and	not exists (	SELECT	1
				from	fis_dados_dmed x
				where	x.nr_titulo_rec = a.nr_titulo)
	and	exists (	select	1
				from	titulo_receber_liq x
				where	x.nr_titulo = a.nr_titulo
				and	to_char(x.dt_recebimento,'yyyy') in ('2020','2021'))
	order by
		a.nr_titulo asc,
		b.nr_sequencia asc,
		a.cd_estabelecimento;

c05 CURSOR FOR
	SELECT	b.nr_sequencia nr_seq_baixa,
		a.nr_titulo,
		a.cd_estabelecimento
	from	titulo_receber a,
		titulo_receber_liq b
	where	a.nr_titulo = b.nr_titulo
	and	a.ie_origem_titulo = '3'
	and	coalesce(a.dt_liquidacao::text, '') = ''
	and	not exists (	SELECT	1
				from	fis_dados_dmed x
				where	x.nr_titulo_rec = a.nr_titulo)
	order by
		a.nr_titulo asc,
		b.nr_sequencia asc,
		a.cd_estabelecimento;

c06 CURSOR FOR
	SELECT	b.nr_sequencia nr_seq_baixa,
		a.nr_titulo,
		a.cd_estabelecimento
	from	titulo_pagar a,
		titulo_pagar_baixa b
	where	a.nr_titulo = b.nr_titulo
	and	not exists (	SELECT	1
				from	fis_dados_dmed x
				where	x.nr_titulo_pag = a.nr_titulo)
	and	exists (	select	1
				from	titulo_pagar_baixa x
				where	x.nr_titulo = a.nr_titulo
				and	to_char(x.dt_baixa,'yyyy') in ('2020','2021'))
	order by
		a.nr_titulo asc,
		b.nr_sequencia asc,
		a.cd_estabelecimento;
	
c07 CURSOR FOR
	SELECT	b.nr_sequencia nr_seq_baixa,
		a.nr_titulo,
		a.cd_estabelecimento
	from	titulo_pagar a,
		titulo_pagar_baixa b
	where	a.nr_titulo = b.nr_titulo
	and	not exists (	SELECT	1
				from	fis_dados_dmed x
				where	x.nr_titulo_pag = a.nr_titulo)
	and	coalesce(a.dt_liquidacao::text, '') = ''
	order by
		a.nr_titulo asc,
		b.nr_sequencia asc,
		a.cd_estabelecimento;
BEGIN

delete from pls_negociacao_mens_fiscal;

delete from fis_dados_dmed;

update titulo_receber
set    ie_pls = 'S'
where  nr_titulo in (	SELECT x.nr_titulo
			from   titulo_receber x
			where  coalesce(x.ie_pls,'N') = 'N'
			and    x.ie_origem_titulo = '4'
			and    exists (	select 1
					from   	titulo_rec_negociado b,
						titulo_receber c
					where   x.nr_seq_negociacao_origem = b.nr_seq_negociacao
					and     c.nr_titulo = b.nr_titulo
					and     c.ie_origem_titulo = '3'));

update 	pls_visible_false
set 	ie_novo_irpf_dmed = 'S';

commit;

for r_c01_w in c01 loop
	begin
		
	qt_tit_w	:= qt_tit_w + 1;
	
	begin
	if (qt_tit_w = 1) then
		pls_fiscal_dados_dmed_pck.gerar_itens_mens_negociacao(r_c01_w.nr_seq_negociacao, 'S', 'BACAINSERIR1');
	end if;
	exception
	when others then
		null;
	end;
	
	begin
	for r_c02_w in c02(r_c01_w.nr_titulo) loop
		begin
		pls_fiscal_dados_dmed_pck.gerar_baixa_tit_rec(r_c01_w.nr_titulo, r_c02_w.nr_seq_baixa, 'S', r_c01_w.cd_estabelecimento, 'BACAINSERIR2');
		end;
	end loop;
	exception
	when others then
		null;
	end;
	
	if (qt_tit_w = r_c01_w.qt_tit_negociacao) then
		qt_tit_w	:= 0;
	end if;
	end;
end loop;

for r_c03_w in c03 loop
	begin
	begin
		pls_fiscal_dados_dmed_pck.gerar_baixa_tit_rec(r_c03_w.nr_titulo, r_c03_w.nr_seq_baixa, 'S', r_c03_w.cd_estabelecimento, 'BACAINSERIR3');
	exception
	when others then
		null;
	end;
	end;
end loop;

for r_c04_w in c04 loop
	begin
	begin
		pls_fiscal_dados_dmed_pck.gerar_baixa_tit_rec(r_c04_w.nr_titulo, r_c04_w.nr_seq_baixa, 'S', r_c04_w.cd_estabelecimento, 'BACAINSERIR4');
	exception
	when others then
		null;
	end;
	end;
end loop;

for r_c05_w in c05 loop
	begin
	begin
		pls_fiscal_dados_dmed_pck.gerar_baixa_tit_rec(r_c05_w.nr_titulo, r_c05_w.nr_seq_baixa, 'S', r_c05_w.cd_estabelecimento, 'BACAINSERIR5');
	exception
	when others then
		null;
	end;
	end;
end loop;

for r_c06_w in c06 loop
	begin
	begin
		pls_fiscal_dados_dmed_pck.gerar_baixa_tit_pag(r_c06_w.nr_titulo, r_c06_w.nr_seq_baixa, 'S', r_c06_w.cd_estabelecimento, 'BACAINSERIR6');
	exception
	when others then
		null;
	end;
	end;
end loop;

for r_c07_w in c07 loop
	begin
	begin
		pls_fiscal_dados_dmed_pck.gerar_baixa_tit_pag(r_c07_w.nr_titulo, r_c07_w.nr_seq_baixa, 'S', r_c07_w.cd_estabelecimento, 'BACAINSERIR7');
	exception
	when others then
		null;
	end;
	end;
end loop;

delete from fis_dados_dmed
where (coalesce(cd_pessoa_pagador::text, '') = '' and coalesce(cd_pessoa_titular::text, '') = '');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_carga_irpf () FROM PUBLIC;
