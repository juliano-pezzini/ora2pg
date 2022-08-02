-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_lote_comissao_pf ( nr_seq_lote_p bigint, ie_opcao_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

/* 
ie_opcao_p 
	G = Gerar lote 
	D = Desfazer lote 
	L = Liberar lote 
*/
 
 
dt_referencia_w			timestamp;
ie_benef_proposta_w		varchar(1);
cd_pessoa_fisica_w		varchar(10);
cd_cgc_w			varchar(100);
nr_seq_bonificacao_w		bigint;
nr_seq_indicacao_venda_w	bigint;
nr_seq_proposta_w		bigint;
vl_proposta_benef_w		double precision;
vl_proposta_w			double precision;
vl_benef_w			double precision;
vl_total_indicacao_w		double precision;
nr_seq_segurado_prop_w		bigint;
vl_comissao_benef_w		double precision;
tx_bonificacao_w		double precision;
vl_bonificacao_w		double precision;
ds_observacao_w			varchar(255);
qt_titulos_w			bigint;
ds_beneficiario_proposta_w	varchar(4000);

C01 CURSOR FOR 
	SELECT	'B', 
		b.cd_pessoa_fisica, 
		b.cd_cgc, 
		b.nr_seq_bonificacao, 
		c.nr_sequencia 
	from	pls_proposta_beneficiario	a, 
		pls_indicacao_venda		b, 
		pls_proposta_adesao		c 
	where	b.nr_seq_segurado_prop = a.nr_sequencia 
	and	a.nr_seq_proposta = c.nr_sequencia 
	and ((b.cd_pessoa_fisica IS NOT NULL AND b.cd_pessoa_fisica::text <> '') or (b.cd_cgc IS NOT NULL AND b.cd_cgc::text <> '')) 
	and	coalesce(b.nr_seq_lote_comissao::text, '') = '' 
	and	trunc(c.dt_inicio_proposta,'month') = dt_referencia_w 
	group by	b.nr_seq_bonificacao, 
			b.cd_pessoa_fisica, 
			b.cd_cgc, 
			c.nr_sequencia 
	
union all
 
	SELECT	'P', 
		b.cd_pessoa_fisica, 
		b.cd_cgc, 
		b.nr_seq_bonificacao, 
		c.nr_sequencia 
	from	pls_proposta_beneficiario	a, 
		pls_indicacao_venda		b, 
		pls_proposta_adesao		c 
	where	b.nr_seq_proposta = c.nr_sequencia 
	and	a.nr_seq_proposta = c.nr_sequencia 
	and ((b.cd_pessoa_fisica IS NOT NULL AND b.cd_pessoa_fisica::text <> '') or (b.cd_cgc IS NOT NULL AND b.cd_cgc::text <> '')) 
	and	coalesce(b.nr_seq_lote_comissao::text, '') = '' 
	and	trunc(c.dt_inicio_proposta,'month') = dt_referencia_w 
	and	not exists (select	1 
				from	pls_proposta_beneficiario	x, 
					pls_indicacao_venda		y, 
					pls_proposta_adesao		z 
				where	y.nr_seq_segurado_prop	= x.nr_sequencia 
				and	x.nr_seq_proposta = z.nr_sequencia 
				and	trunc(z.dt_inicio_proposta,'month') = dt_referencia_w 
				and	x.nr_sequencia = a.nr_sequencia) 
	group by	b.nr_seq_bonificacao, 
			b.cd_pessoa_fisica, 
			b.cd_cgc, 
			c.nr_sequencia;

C02 CURSOR FOR 
	SELECT	'B', 
		b.nr_sequencia, 
		b.nr_seq_proposta, 
		b.nr_seq_segurado_prop 
	from	pls_proposta_beneficiario	a, 
		pls_indicacao_venda		b, 
		pls_proposta_adesao		c 
	where	b.nr_seq_segurado_prop = a.nr_sequencia 
	and	a.nr_seq_proposta = c.nr_sequencia 
	and ((b.cd_pessoa_fisica IS NOT NULL AND b.cd_pessoa_fisica::text <> '') or (b.cd_cgc IS NOT NULL AND b.cd_cgc::text <> '')) 
	and	coalesce(b.nr_seq_lote_comissao::text, '') = '' 
	and (b.cd_pessoa_fisica = cd_pessoa_fisica_w or b.cd_cgc = cd_cgc_w) 
	and	b.nr_seq_bonificacao = nr_seq_bonificacao_w 
	and	c.nr_sequencia = nr_seq_proposta_w 
	and	trunc(c.dt_inicio_proposta,'month') = dt_referencia_w 
	group by	b.nr_sequencia, 
			b.nr_seq_proposta, 
			b.nr_seq_segurado_prop 
	
union all
 
	SELECT	'P', 
		b.nr_sequencia,	 
		b.nr_seq_proposta, 
		b.nr_seq_segurado_prop 
	from	pls_proposta_beneficiario	a, 
		pls_indicacao_venda		b, 
		pls_proposta_adesao		c 
	where	b.nr_seq_proposta = c.nr_sequencia 
	and	a.nr_seq_proposta = c.nr_sequencia 
	and ((b.cd_pessoa_fisica IS NOT NULL AND b.cd_pessoa_fisica::text <> '') or (b.cd_cgc IS NOT NULL AND b.cd_cgc::text <> '')) 
	and	coalesce(b.nr_seq_lote_comissao::text, '') = '' 
	and (b.cd_pessoa_fisica = cd_pessoa_fisica_w or b.cd_cgc = cd_cgc_w) 
	and	b.nr_seq_bonificacao = nr_seq_bonificacao_w 
	and	c.nr_sequencia = nr_seq_proposta_w 
	and	trunc(c.dt_inicio_proposta,'month') = dt_referencia_w 
	and	not exists (select	1 
				from	pls_proposta_beneficiario	x, 
					pls_indicacao_venda		y, 
					pls_proposta_adesao		z 
				where	y.nr_seq_segurado_prop = x.nr_sequencia 
				and	x.nr_seq_proposta = z.nr_sequencia 
				and	trunc(z.dt_inicio_proposta,'month') = dt_referencia_w 
				and	x.nr_sequencia = a.nr_sequencia) 
	group by	b.nr_sequencia, 
			b.nr_seq_proposta, 
			b.nr_seq_segurado_prop;


BEGIN 
 
select	trunc(dt_referencia,'month') 
into STRICT	dt_referencia_w 
from	pls_lote_comissao_pf 
where	nr_sequencia	= nr_seq_lote_p;
 
if (ie_opcao_p = 'D') then 
	select	count(*) 
	into STRICT	qt_titulos_w 
	from	pls_comissao_pf 
	where	nr_seq_lote	= nr_seq_lote_p 
	and	(nr_titulo IS NOT NULL AND nr_titulo::text <> '');
	 
	if (qt_titulos_w > 0) then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(224788);
		/* Mensagem: Não é possível desfazer o lote de comissão pois já foram gerados títulos para o mesmo! */
 
	else 
		update	pls_indicacao_venda 
		set	nr_seq_lote_comissao	 = NULL 
		where	nr_seq_lote_comissao	= nr_seq_lote_p;
		 
		delete	from	pls_comissao_pf 
		where	nr_seq_lote = nr_seq_lote_p;
	end if;
elsif (ie_opcao_p = 'L') then 
	update	pls_lote_comissao_pf 
	set	nm_usuario_liberacao	= nm_usuario_p, 
		dt_liberacao		= clock_timestamp() 
	where	nr_sequencia		= nr_seq_lote_p;
elsif (ie_opcao_p = 'G') then 
	open C01;
	loop 
	fetch C01 into	 
		ie_benef_proposta_w, 
		cd_pessoa_fisica_w, 
		cd_cgc_w, 
		nr_seq_bonificacao_w, 
		nr_seq_proposta_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		ds_beneficiario_proposta_w	:= '';
		 
		select	max(a.tx_bonificacao), 
			max(a.vl_bonificacao) 
		into STRICT	tx_bonificacao_w, 
			vl_bonificacao_w 
		from	pls_bonificacao_regra	a, 
			pls_bonificacao		b 
		where	a.nr_seq_bonificacao	= b.nr_sequencia 
		and	b.nr_sequencia		= nr_seq_bonificacao_w;
		 
		open C02;
		loop 
		fetch C02 into	 
			ie_benef_proposta_w, 
			nr_seq_indicacao_venda_w, 
			nr_seq_proposta_w, 
			nr_seq_segurado_prop_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin 
			 
			vl_benef_w		:= 0;
			vl_comissao_benef_w	:= 0;
			if (coalesce(ds_beneficiario_proposta_w::text, '') = '') then 
				ds_beneficiario_proposta_w	:= nr_seq_segurado_prop_w;
			else 
				ds_beneficiario_proposta_w	:= ds_beneficiario_proposta_w || ', '|| nr_seq_segurado_prop_w;
			end if;
			 
			if (ie_benef_proposta_w = 'B') then 
				select	pls_obter_total_proposta_benef(nr_seq_segurado_prop_w) 
				into STRICT	vl_benef_w 
				;
				 
				vl_comissao_benef_w	:= ((coalesce(tx_bonificacao_w,0)/100) * coalesce(vl_benef_w,0)) + coalesce(vl_bonificacao_w,0); /* Calcula o vlaor a ser pago pela indicação */
				ds_observacao_w	:= 'Comissão gerada pela indicação do(s) beneficiário(s): '||ds_beneficiario_proposta_w;
			elsif (ie_benef_proposta_w = 'P') then 
				SELECT * FROM pls_calcular_propos_benef(nr_seq_proposta_w, vl_proposta_benef_w, vl_proposta_w) INTO STRICT vl_proposta_benef_w, vl_proposta_w;
				 
				vl_comissao_benef_w	:= ((coalesce(tx_bonificacao_w,0)/100) * coalesce(vl_proposta_w,0)) + coalesce(vl_bonificacao_w,0); /* Calcula o vlaor a ser pago pela indicação */
				ds_observacao_w	:= 'Comissão gerada pela indicação da proposta '||nr_seq_proposta_w;
			end if;
			 
			update	pls_indicacao_venda 
			set	nr_seq_lote_comissao	= nr_seq_lote_p 
			where	nr_sequencia		= nr_seq_indicacao_venda_w;
			 
			vl_total_indicacao_w	:= coalesce(vl_total_indicacao_w,0) + coalesce(vl_comissao_benef_w,0);
			end;
		end loop;
		close C02;
		 
		insert	into	pls_comissao_pf(	nr_sequencia, nr_seq_lote, dt_atualizacao, 
				nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, 
				cd_pessoa_fisica, cd_cgc, vl_indicacao, ds_observacao) 
			values (	nextval('pls_comissao_pf_seq'), nr_seq_lote_p, clock_timestamp(), 
				nm_usuario_p, clock_timestamp(), nm_usuario_p, 
				cd_pessoa_fisica_w, cd_cgc_w, vl_total_indicacao_w, ds_observacao_w);
		vl_total_indicacao_w	:= 0;
		end;
	end loop;
	close C01;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_lote_comissao_pf ( nr_seq_lote_p bigint, ie_opcao_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

