-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_remover_conta_fat_critica ( nm_usuario_p text, nr_seq_lote_fat_p pls_lote_faturamento.nr_sequencia%type, nr_seq_pls_fatura_p pls_fatura.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

						
nr_seq_fat_conta_w	pls_fatura_conta.nr_sequencia%type;

-- Obter as contas com criticas
c01 CURSOR FOR

	SELECT	nr_seq_conta
	from	ptu_lote_conta_erro
	where	nr_seq_lote		= nr_seq_lote_fat_p
	and	nr_seq_pls_fatura	= nr_seq_pls_fatura_p;
	
BEGIN

for r_c01_w in c01  loop

	-- obter a sequencia da conta da pls_fatura_conta para passar no paramentro de remover a conta da fatura
	select	max(pfc.nr_sequencia)
	into STRICT	nr_seq_fat_conta_w
	from	pls_fatura_conta	pfc,
		pls_fatura_evento	pfe,
		pls_fatura		pf
	where	pfe.nr_sequencia	= pfc.nr_seq_fatura_evento
	and	pf.nr_sequencia		= pfe.nr_seq_fatura
	and	pf.nr_sequencia		= nr_seq_pls_fatura_p
	and	pfc.nr_seq_conta	= r_c01_w.nr_seq_conta;

	if (nr_seq_fat_conta_w IS NOT NULL AND nr_seq_fat_conta_w::text <> '') then
	
		-- Remover as contas com criticas da fatura
		CALL pls_remover_conta_fatura( nr_seq_fat_conta_w, 'S', cd_estabelecimento_p, nm_usuario_p);
	end if;
end loop;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_remover_conta_fat_critica ( nm_usuario_p text, nr_seq_lote_fat_p pls_lote_faturamento.nr_sequencia%type, nr_seq_pls_fatura_p pls_fatura.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;

