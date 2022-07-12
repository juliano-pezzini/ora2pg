-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_faturamento_pck.obter_tipo_pes_prest_ptu ( nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, ie_origem_conta_p pls_conta.ie_origem_conta%type, nr_seq_conta_princ_p pls_conta.nr_seq_conta_princ%type, nr_seq_proc_princ_p pls_conta_proc.nr_seq_proc_princ%type) RETURNS varchar AS $body$
DECLARE

					
ie_tipo_pessoa_prest_ptu_w	ptu_nota_servico.ie_tipo_pessoa_prestador%type := 'A';
nr_seq_conta_princ_w		pls_conta.nr_seq_conta_princ%type;


BEGIN
if (ie_origem_conta_p = 'A') then
	if (nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '') then
		select	coalesce(max(s.ie_tipo_pessoa_prestador), 'A')
		into STRICT	ie_tipo_pessoa_prest_ptu_w
		from	ptu_nota_servico s,
			ptu_nota_cobranca c,
			ptu_fatura f
		where	f.nr_sequencia	= c.nr_seq_fatura
		and	c.nr_sequencia	= s.nr_seq_nota_cobr
		and	coalesce(f.nr_seq_pls_fatura::text, '') = ''
		and	s.nr_seq_conta_proc = nr_seq_conta_proc_p;
		
		if (coalesce(ie_tipo_pessoa_prest_ptu_w::text, '') = '') then
			-- Tenta buscar pelo item principal
			select	coalesce(max(s.ie_tipo_pessoa_prestador),'A')
			into STRICT	ie_tipo_pessoa_prest_ptu_w
			from	ptu_nota_servico s,
				ptu_nota_cobranca c,
				ptu_fatura f
			where	f.nr_sequencia	= c.nr_seq_fatura
			and	c.nr_sequencia	= s.nr_seq_nota_cobr
			and	coalesce(f.nr_seq_pls_fatura::text, '') = ''			
			and	s.nr_seq_conta_proc = nr_seq_proc_princ_p;
							
			-- Se nao achou atraves do item principal, tenta busca a informacao da conta A500,
			if (coalesce(ie_tipo_pessoa_prest_ptu_w::text, '') = '') then
				select	coalesce(max(a.ie_tipo_pessoa_prestador),'A')
				into STRICT	ie_tipo_pessoa_prest_ptu_w
				from	ptu_nota_servico	a,
					ptu_nota_cobranca	b,
					pls_conta		c
				where	b.nr_sequencia		= a.nr_seq_nota_cobr
				and	b.nr_sequencia		= c.nr_seq_nota_cobranca
				and	c.nr_sequencia		= nr_seq_conta_p;
			end if;
			
			-- Se nao achou atraves da conta, tenta busca a informacao da conta A500 atraves da conta principal do atendimento se houver, se nao encontrar usa o valor padrao "A - Ambos"
			if (coalesce(ie_tipo_pessoa_prest_ptu_w::text, '') = '') and (nr_seq_conta_princ_p IS NOT NULL AND nr_seq_conta_princ_p::text <> '') then
				select	coalesce(max(a.ie_tipo_pessoa_prestador), 'A')
				into STRICT	ie_tipo_pessoa_prest_ptu_w
				from	ptu_nota_servico	a,
					ptu_nota_cobranca	b,
					pls_conta		c
				where	b.nr_sequencia		= a.nr_seq_nota_cobr
				and	b.nr_sequencia		= c.nr_seq_nota_cobranca
				and	c.nr_sequencia		= nr_seq_conta_princ_p;
			end if;
		end if;
	else
		select	coalesce(max(s.ie_tipo_pessoa_prestador), 'A')
		into STRICT	ie_tipo_pessoa_prest_ptu_w
		from	ptu_nota_servico s,
			ptu_nota_cobranca c,
			ptu_fatura f
		where	f.nr_sequencia	= c.nr_seq_fatura
		and	c.nr_sequencia	= s.nr_seq_nota_cobr
		and	coalesce(f.nr_seq_pls_fatura::text, '') = ''
		and	s.nr_seq_conta_mat = nr_seq_conta_mat_p;
	end if;
end if;

return coalesce(ie_tipo_pessoa_prest_ptu_w,'A');

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_faturamento_pck.obter_tipo_pes_prest_ptu ( nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, ie_origem_conta_p pls_conta.ie_origem_conta%type, nr_seq_conta_princ_p pls_conta.nr_seq_conta_princ%type, nr_seq_proc_princ_p pls_conta_proc.nr_seq_proc_princ%type) FROM PUBLIC;
