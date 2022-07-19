-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_faturas_ptu ( nr_seq_lote_p pls_lote_faturamento.nr_sequencia%type, nr_seq_fatura_p pls_fatura.nr_sequencia%type, ie_commit_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[ ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 

qt_a510_w	integer;

c01 CURSOR(	nr_seq_lote_pc		pls_lote_faturamento.nr_sequencia%type,
		nr_seq_fatura_pc	pls_fatura.nr_sequencia%type) FOR
	SELECT	nr_sequencia
	from	pls_fatura
	where	nr_seq_lote = nr_seq_lote_pc
	and	(nr_seq_lote_pc IS NOT NULL AND nr_seq_lote_pc::text <> '')
	and	coalesce(ie_cancelamento::text, '') = ''
	
union

	SELECT	nr_sequencia
	from	pls_fatura
	where	nr_sequencia = nr_seq_fatura_pc
	and	(nr_seq_fatura_pc IS NOT NULL AND nr_seq_fatura_pc::text <> '')
	and	coalesce(ie_cancelamento::text, '') = '';
	
c02 CURSOR(	nr_seq_pls_fatura_pc	pls_fatura.nr_sequencia%type) FOR
	SELECT	nr_sequencia,
		nr_fatura,
		nr_nota_credito_debito
	from	ptu_fatura
	where	nr_seq_pls_fatura = nr_seq_pls_fatura_pc;
	
c03 CURSOR(	nr_seq_fatura_pc	ptu_fatura.nr_sequencia%type) FOR
        SELECT  nr_sequencia
        from    ptu_nota_cobranca
        where   nr_seq_fatura = nr_seq_fatura_pc;
	
c04 CURSOR(	nr_seq_nota_cobr_pc	ptu_nota_cobranca.nr_sequencia%type) FOR
        SELECT  nr_sequencia
        from    ptu_nota_hospitalar
        where   nr_seq_nota_cobr = nr_seq_nota_cobr_pc;
	
BEGIN

for r_c01_w in c01( nr_seq_lote_p , nr_seq_fatura_p ) loop
	update	pls_fatura
	set	dt_geracao_ptu	 = NULL,
		ds_arquivo	 = NULL
	where	nr_sequencia	= r_c01_w.nr_sequencia;
	
	for r_c02_w in c02( r_c01_w.nr_sequencia ) loop
		select	count(1)
		into STRICT	qt_a510_w
		from	ptu_fat_baixa_interc		a,
			ptu_fat_ret_baixa_interc	b,
			ptu_fat_ret_baixa_dados		c,
			ptu_fat_ret_baixa_status	d
		where	a.nr_sequencia			= b.nr_seq_fat_baixa_interc
		and	b.nr_sequencia			= c.nr_seq_fat_ret_baixa
		and	c.nr_sequencia			= d.nr_seq_fat_ret_baixa_dados
		and	d.ie_status_baixa		= 'S'
		and	a.nr_seq_ptu_fatura		= r_c02_w.nr_sequencia;
		
		if (qt_a510_w > 0) then
			-- A fatura do documento #@NR_DOCUMENTO#@ ja esta na funcao OPS - Modulo de Inadimplencia (A510) e nao pode ser desfeito.
			CALL wheb_mensagem_pck.exibir_mensagem_abort(739824, 'NR_DOCUMENTO=' || coalesce(r_c02_w.nr_fatura, r_c02_w.nr_nota_credito_debito));
		else
			-- LOG
			delete	FROM ptu_log_fat_baixa_ws a
			where	a.nr_seq_fat_baixa_interc in (	SELECT	c.nr_sequencia
								from	ptu_fat_baixa_interc	c
								where	c.nr_seq_ptu_fatura	= r_c02_w.nr_sequencia);
			-- STATUS DO RETORNO
			delete	FROM ptu_fat_ret_baixa_status a
			where	a.nr_seq_fat_ret_baixa_dados in (	SELECT	e.nr_sequencia
									from	ptu_fat_baixa_interc		c,
										ptu_fat_ret_baixa_interc	d,
										ptu_fat_ret_baixa_dados		e
									where	c.nr_sequencia			= d.nr_seq_fat_baixa_interc
									and	d.nr_sequencia			= e.nr_seq_fat_ret_baixa
									and	c.nr_seq_ptu_fatura		= r_c02_w.nr_sequencia);
			-- DADOS RETORNO
			delete	FROM ptu_fat_ret_baixa_dados a
			where	a.nr_seq_fat_ret_baixa	in (	SELECT	d.nr_sequencia
								from	ptu_fat_baixa_interc		c,
									ptu_fat_ret_baixa_interc	d
								where	c.nr_sequencia			= d.nr_seq_fat_baixa_interc
								and	c.nr_seq_ptu_fatura		= r_c02_w.nr_sequencia);
			-- RETORNO
			delete	FROM ptu_fat_ret_baixa_interc a
			where	a.nr_seq_fat_baixa_interc in (	SELECT	c.nr_sequencia
								from	ptu_fat_baixa_interc	c
								where	c.nr_seq_ptu_fatura	= r_c02_w.nr_sequencia);
			-- DADOS COBRANCA
			delete	FROM ptu_fat_baixa_dados a
			where	a.nr_seq_fat_baixa_interc in (	SELECT	c.nr_sequencia
								from	ptu_fat_baixa_interc	c
								where	c.nr_seq_ptu_fatura	= r_c02_w.nr_sequencia);
			-- COBRANCA
			delete	FROM ptu_fat_baixa_interc
			where	nr_seq_ptu_fatura = r_c02_w.nr_sequencia;
		end if;
		
		for r_c03_w in c03( r_c02_w.nr_sequencia ) loop
			delete	FROM ptu_nota_servico_item
			where	nr_seq_nota_servico in (SELECT	nr_sequencia
							from	ptu_nota_servico
							where	nr_seq_nota_cobr = r_c03_w.nr_sequencia);
							
			delete	FROM ptu_nota_servico_proc
			where	nr_seq_nota_servico in (SELECT	nr_sequencia
							from	ptu_nota_servico
							where	nr_seq_nota_cobr = r_c03_w.nr_sequencia);
							
			delete	FROM ptu_nota_servico_mat
			where	nr_seq_nota_servico in (SELECT	nr_sequencia
							from	ptu_nota_servico
							where	nr_seq_nota_cobr = r_c03_w.nr_sequencia);
							
			delete 	FROM ptu_nota_servico
			where	nr_seq_nota_cobr = r_c03_w.nr_sequencia;
			
			delete 	FROM ptu_nota_complemento
			where 	nr_seq_nota_cobr = r_c03_w.nr_sequencia;
			
			delete 	FROM ptu_nota_fiscal
			where 	nr_seq_nota_cobr = r_c03_w.nr_sequencia;
			
			for r_c04_w in c04( r_c03_w.nr_sequencia ) loop
				delete 	FROM ptu_nota_hosp_compl
				where 	nr_seq_nota_hosp = r_c04_w.nr_sequencia;
			end loop;
			
			delete 	FROM ptu_nota_hospitalar
			where 	nr_seq_nota_cobr = r_c03_w.nr_sequencia;
		end loop;
		
		
		
		delete	FROM ptu_nota_servico_item
		where	nr_seq_nota_servico_rrs in (	SELECT	y.nr_sequencia
							from	ptu_nota_cobranca_rrs	x,
								ptu_nota_servico_rrs	y
							where	y.nr_seq_nota_cobr_rrs	= x.nr_sequencia
							and	x.nr_seq_fatura		= r_c02_w.nr_sequencia);
		
		delete	FROM ptu_nota_servico_proc
		where	nr_seq_nota_servico_rrs in (	SELECT	y.nr_sequencia
							from	ptu_nota_cobranca_rrs	x,
								ptu_nota_servico_rrs	y
							where	y.nr_seq_nota_cobr_rrs	= x.nr_sequencia
							and	x.nr_seq_fatura		= r_c02_w.nr_sequencia);
		
		delete	FROM ptu_nota_servico_rrs
		where	nr_seq_nota_cobr_rrs in (	SELECT	x.nr_sequencia
							from	ptu_nota_cobranca_rrs	x
							where	x.nr_seq_fatura		= r_c02_w.nr_sequencia);
							
		delete	FROM ptu_nota_cobranca_rrs
		where	nr_seq_fatura = r_c02_w.nr_sequencia;
		
		delete 	FROM ptu_nota_cobranca
		where 	nr_seq_fatura = r_c02_w.nr_sequencia;
		
		delete 	FROM ptu_fatura_boleto
		where 	nr_seq_fatura = r_c02_w.nr_sequencia;
		
		delete 	FROM ptu_fatura_boleto
		where 	nr_seq_fatura = r_c02_w.nr_sequencia;
		
		delete 	FROM ptu_fatura_corpo
		where 	nr_seq_fatura = r_c02_w.nr_sequencia;
		
		delete 	FROM ptu_fatura_historico
		where 	nr_seq_fatura = r_c02_w.nr_sequencia;
		
		delete 	FROM ptu_a500_historico
		where 	nr_seq_fatura = r_c02_w.nr_sequencia;
		
		delete	FROM ptu_fatura_cedente
		where	nr_seq_fatura = r_c02_w.nr_sequencia;
		
		delete	FROM ptu_fatura_conta_exc
		where	nr_seq_fatura = r_c02_w.nr_sequencia;
	end loop;
	
	delete	FROM ptu_fatura
	where	nr_seq_pls_fatura = r_c01_w.nr_sequencia;
	
	delete	FROM ptu_lote_conta_erro	a
	where (a.nr_seq_lote	= nr_seq_lote_p) or (a.nr_seq_pls_fatura = nr_seq_fatura_p)
	and	a.ie_tipo_critica	= 'PTU';
end loop;


if (coalesce(ie_commit_p, 'N') = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_faturas_ptu ( nr_seq_lote_p pls_lote_faturamento.nr_sequencia%type, nr_seq_fatura_p pls_fatura.nr_sequencia%type, ie_commit_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

