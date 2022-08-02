-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_excluir_contrato_prog_reaj ( nr_seq_prog_reaj_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
nr_seq_lote_w		pls_prog_reaj_colet_lote.nr_sequencia%type;
nr_seq_contrato_w	pls_contrato.nr_sequencia%type;
nr_contrato_w		pls_contrato.nr_contrato%type;
ie_status_w		pls_prog_reaj_coletivo.ie_status%type;
		

BEGIN 
 
select	coalesce(max(ie_status),'N') 
into STRICT	ie_status_w 
from	pls_prog_reaj_coletivo 
where	nr_sequencia = nr_seq_prog_reaj_p;
 
--Apenas em negociação 
if (ie_status_w = 'N') then 
	delete	from pls_prog_reaj_documentacao 
	where	nr_seq_prog_reaj = nr_seq_prog_reaj_p;
 
	select	b.nr_seq_lote, 
		a.nr_sequencia, 
		a.nr_contrato	 
	into STRICT	nr_seq_lote_w, 
		nr_seq_contrato_w, 
		nr_contrato_w	 
	from	pls_contrato		a, 
		pls_prog_reaj_coletivo	b 
	where	a.nr_sequencia = b.nr_seq_contrato 
	and	b.nr_sequencia = nr_seq_prog_reaj_p;
			 
	insert into pls_log_prog_reaj_col(	nr_sequencia, cd_estabelecimento, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, 
			nm_usuario_nrec, nr_seq_lote_prog, nr_seq_contrato, ds_mensagem, ie_acao) 
		values (	nextval('pls_log_prog_reaj_col_seq'), cd_estabelecimento_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 
			nm_usuario_p, nr_seq_lote_w, nr_seq_contrato_w, 'O contrato ' || nr_contrato_w || ' foi excluído manualmente pela opção de botão direito "Excluir contrato".', 'E');
 
	delete	from pls_prog_reaj_coletivo 
	where	nr_sequencia = nr_seq_prog_reaj_p;
 
	commit;
else 
	--Não é possível excluir o contrato, pois o mesmo já foi liberado. 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(835051);
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_excluir_contrato_prog_reaj ( nr_seq_prog_reaj_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

