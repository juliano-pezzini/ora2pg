-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_sip_pck.remove_contas_analise_pendente ( nr_seq_lote_p pls_lote_sip.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


ie_retorno_w	varchar(1) := 'N';
tb_rowid_w	pls_util_cta_pck.t_rowid;

C01 CURSOR( nr_seq_lote_pc pls_lote_sip.nr_sequencia%type) FOR
	SELECT a.oid
	from   sip_nv_dados a,
	       pls_conta b,
	       pls_analise_conta c
	where  nr_seq_lote_sip = nr_seq_lote_pc
	and    a.nr_seq_conta = b.nr_sequencia
	and    b.nr_seq_analise = c.nr_sequencia
	and    c.ie_status <> 'T';


BEGIN

obter_param_usuario( 1231, 14,null,nm_usuario_p,cd_estabelecimento_p, ie_retorno_w);
if (coalesce(ie_retorno_w,'N')= 'S') then
	open C01(nr_seq_lote_p);
	loop
		-- Limpando registros do ultimo loop

		tb_rowid_w.delete;
		
		-- Pegar os novos registros 

		fetch C01
		bulk collect into tb_rowid_w
		limit current_setting('pls_sip_pck.qt_registro_transacao_w')::integer;
		
		-- se nao veio nada aborta

		exit when tb_rowid_w.count = 0;
		
		-- Limpa do banco.

		forall i in tb_rowid_w.first .. tb_rowid_w.last 
			delete	FROM sip_nv_dados
			where	rowid = tb_rowid_w(i);	
		commit;
	end loop;
	close C01;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_sip_pck.remove_contas_analise_pendente ( nr_seq_lote_p pls_lote_sip.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;