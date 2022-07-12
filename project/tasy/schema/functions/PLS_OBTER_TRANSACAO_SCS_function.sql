-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_transacao_scs (nr_seq_auditoria_p bigint, ie_tipo_transacao_p text) RETURNS bigint AS $body$
DECLARE


/*
LEGENDA
TOO -  Trans operadora de origem
TOE - Trans operadora executora

IE_TIPO_AUDITORIA
Guia 		- G
Requisição		- R
Execução da requisição - E
*/
nr_retorno_w		bigint;
nr_seq_requisicao_w	bigint;
nr_seq_execucao_w	bigint;
nr_seq_guia_w		bigint;


BEGIN
select	nr_seq_requisicao,
	nr_seq_execucao,
	nr_seq_guia
into STRICT	nr_seq_requisicao_w,
	nr_seq_execucao_w,
	nr_seq_guia_w
from	pls_auditoria
where	nr_sequencia	= nr_seq_auditoria_p;

if (ie_tipo_transacao_p = 'TOO') then
	if (nr_seq_requisicao_w IS NOT NULL AND nr_seq_requisicao_w::text <> '') then
		begin
			select	b.nr_seq_origem
			into STRICT	nr_retorno_w
			from	ptu_resposta_autorizacao	b,
				pls_requisicao			a
			where	a.nr_sequencia			= b.nr_seq_requisicao
			and	a.nr_sequencia			= nr_seq_requisicao_w;
		exception
		when others then
			nr_retorno_w	:= null;
		end;
	elsif (nr_seq_execucao_w IS NOT NULL AND nr_seq_execucao_w::text <> '') then
		begin
			select	c.nr_seq_origem
			into STRICT	nr_retorno_w
			from	ptu_resposta_autorizacao	c,
				pls_execucao_requisicao		b,
				pls_requisicao			a
			where	a.nr_sequencia			= c.nr_seq_requisicao
			and	a.nr_sequencia			= b.nr_seq_requisicao
			and	a.nr_sequencia			= nr_seq_execucao_w;
		exception
		when others then
			nr_retorno_w	:= null;
		end;
	elsif (nr_seq_guia_w IS NOT NULL AND nr_seq_guia_w::text <> '') then
		begin
			select	b.nr_seq_origem
			into STRICT	nr_retorno_w
			from	ptu_resposta_autorizacao	b,
				pls_guia_plano			a
			where	a.nr_sequencia			= b.nr_seq_guia
			and	a.nr_sequencia			= nr_seq_guia_w;
		exception
		when others then
			nr_retorno_w	:= null;
		end;
	end if;
elsif (ie_tipo_transacao_p = 'TOE') then
	if (nr_seq_requisicao_w IS NOT NULL AND nr_seq_requisicao_w::text <> '') then
		begin
			select	b.nr_seq_execucao
			into STRICT	nr_retorno_w
			from	ptu_pedido_autorizacao	b,
				pls_requisicao		a
			where	a.nr_sequencia		= b.nr_seq_requisicao
			and	a.nr_sequencia		= nr_seq_requisicao_w;
		exception
		when others then
			select	max(b.nr_seq_execucao)
			into STRICT	nr_retorno_w
			from	ptu_pedido_compl_aut	b,
				pls_requisicao		a
			where	a.nr_sequencia		= b.nr_seq_requisicao
			and	a.nr_sequencia		= nr_seq_requisicao_w;
		end;
	elsif (nr_seq_execucao_w IS NOT NULL AND nr_seq_execucao_w::text <> '') then
		begin
			select	c.nr_seq_execucao
			into STRICT	nr_retorno_w
			from	ptu_pedido_autorizacao	c,
				pls_execucao_requisicao	b,
				pls_requisicao		a
			where	a.nr_sequencia		= c.nr_seq_requisicao
			and	a.nr_sequencia		= b.nr_seq_requisicao
			and	a.nr_sequencia		= nr_seq_execucao_w;
		exception
		when others then
			select	max(c.nr_seq_execucao)
			into STRICT	nr_retorno_w
			from	ptu_pedido_compl_aut	c,
				pls_execucao_requisicao	b,
				pls_requisicao		a
			where	a.nr_sequencia		= c.nr_seq_requisicao
			and	a.nr_sequencia		= b.nr_seq_requisicao
			and	a.nr_sequencia		= nr_seq_execucao_w;
		end;
	elsif (nr_seq_guia_w IS NOT NULL AND nr_seq_guia_w::text <> '') then
		begin
			select	b.nr_seq_execucao
			into STRICT	nr_retorno_w
			from	ptu_pedido_autorizacao	b,
				pls_guia_plano		a
			where	a.nr_sequencia		= b.nr_seq_guia
			and	a.nr_sequencia		= nr_seq_guia_w;
		exception
		when others then
			select	max(b.nr_seq_execucao)
			into STRICT	nr_retorno_w
			from	ptu_pedido_compl_aut	b,
				pls_guia_plano		a
			where	a.nr_sequencia		= b.nr_seq_guia
			and	a.nr_sequencia		= nr_seq_guia_w;
		end;
	end if;
end if;

return	nr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_transacao_scs (nr_seq_auditoria_p bigint, ie_tipo_transacao_p text) FROM PUBLIC;
