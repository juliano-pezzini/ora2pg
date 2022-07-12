-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_gerar_contas_a700_pck.fechar_lote_prot_conta_a700 ( nr_seq_protocolo_p pls_conta.nr_seq_protocolo%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type ) AS $body$
DECLARE


nr_seq_lote_conta_w	pls_protocolo_conta.nr_seq_lote_conta%type;

BEGIN

select	max(nr_seq_lote_conta)
into STRICT	nr_seq_lote_conta_w
from	pls_protocolo_conta
where	nr_sequencia	= nr_seq_protocolo_p;

if (nr_seq_lote_conta_w IS NOT NULL AND nr_seq_lote_conta_w::text <> '') then
	update	pls_lote_protocolo_conta
	set	dt_geracao_analise	= clock_timestamp(),
		ie_status		= 'A',
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	nr_sequencia		= nr_seq_lote_conta_w;
end if;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_contas_a700_pck.fechar_lote_prot_conta_a700 ( nr_seq_protocolo_p pls_conta.nr_seq_protocolo%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type ) FROM PUBLIC;