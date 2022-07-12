-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ptu_aviso_pck.obter_seq_aviso_cob ( cd_unimed_origem_p ptu_aviso_arquivo.cd_unimed_origem%type, dt_transacao_p text, cd_cnpj_origem_p ptu_aviso_arquivo.cd_cnpj_origem%type, cd_cpf_origem_p ptu_aviso_arquivo.cd_cpf_origem%type, nr_lote_p ptu_aviso_arquivo.nr_lote%type, nr_guia_prestador_p ptu_aviso_conta.nr_guia_prestador%type, nr_carteira_benef_p ptu_aviso_conta.nr_carteira_benef%type) RETURNS bigint AS $body$
DECLARE


nr_retorno_w	ptu_aviso_arquivo.nr_sequencia%type;


BEGIN

select	max(t.nr_sequencia)
into STRICT	nr_retorno_w
from (	SELECT	a.nr_sequencia
	from	ptu_aviso_arquivo		a,
		ptu_aviso_protocolo		b,
		ptu_aviso_conta			c
	where	b.nr_seq_arquivo		= a.nr_sequencia
	and	c.nr_seq_aviso_protocolo	= b.nr_sequencia
	and	a.cd_unimed_origem		= lpad(cd_unimed_origem_p, 4,'0')
	and	trunc(a.dt_transacao, 'dd')	= to_date(dt_transacao_p, 'yyyy-mm-dd') -- verificar com a Unimed Brasil sobre esse campo
	and	c.cd_cnpj_executante		= cd_cnpj_origem_p
	and	(cd_cnpj_origem_p IS NOT NULL AND cd_cnpj_origem_p::text <> '')
	and	a.nr_lote			= nr_lote_p
	and	c.nr_guia_prestador		= nr_guia_prestador_p
	and	substr(c.nr_carteira_benef,4,13)= lpad(nr_carteira_benef_p, 13, '0')
	
union all

	SELECT	a.nr_sequencia
	from	ptu_aviso_arquivo		a,
		ptu_aviso_protocolo		b,
		ptu_aviso_conta			c
	where	b.nr_seq_arquivo		= a.nr_sequencia
	and	c.nr_seq_aviso_protocolo	= b.nr_sequencia
	and	a.cd_unimed_origem		= lpad(cd_unimed_origem_p, 4,'0')
	and	trunc(a.dt_transacao, 'dd')	= to_date(dt_transacao_p, 'yyyy-mm-dd') -- verificar com a Unimed Brasil sobre esse campo
	and	c.cd_cpf_executante		= cd_cpf_origem_p
	and	(cd_cpf_origem_p IS NOT NULL AND cd_cpf_origem_p::text <> '')
	and	a.nr_lote			= nr_lote_p
	and	c.nr_guia_prestador		= nr_guia_prestador_p
	and	substr(c.nr_carteira_benef,4,13)= lpad(nr_carteira_benef_p, 13, '0')) t;
	
return nr_retorno_w;


END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ptu_aviso_pck.obter_seq_aviso_cob ( cd_unimed_origem_p ptu_aviso_arquivo.cd_unimed_origem%type, dt_transacao_p text, cd_cnpj_origem_p ptu_aviso_arquivo.cd_cnpj_origem%type, cd_cpf_origem_p ptu_aviso_arquivo.cd_cpf_origem%type, nr_lote_p ptu_aviso_arquivo.nr_lote%type, nr_guia_prestador_p ptu_aviso_conta.nr_guia_prestador%type, nr_carteira_benef_p ptu_aviso_conta.nr_carteira_benef%type) FROM PUBLIC;
