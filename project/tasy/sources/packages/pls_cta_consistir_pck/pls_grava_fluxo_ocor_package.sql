-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_cta_consistir_pck.pls_grava_fluxo_ocor ( nr_seq_lote_p pls_lote_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

	
c_ocor CURSOR(	nr_seq_lote_pc		pls_lote_protocolo_conta.nr_sequencia%type,
			nr_seq_protocolo_pc	pls_protocolo_conta.nr_sequencia%type,
			nr_seq_lote_processo_pc	pls_cta_lote_processo.nr_sequencia%type,
			nr_seq_conta_pc		pls_conta.nr_sequencia%type) FOR			
	SELECT	x.nr_sequencia,
		y.nr_seq_analise
	from	pls_ocorrencia_benef	x,
		pls_conta_v 		y
	where	y.nr_sequencia		= x.nr_seq_conta
	and	y.nr_seq_lote_conta	= nr_seq_lote_pc
	and	x.ie_situacao		= 'I'
	and	x.ie_forma_inativacao	in ('S','US')
	
union all

	SELECT	x.nr_sequencia,
		y.nr_seq_analise
	from	pls_ocorrencia_benef	x,
		pls_conta_v 		y
	where	y.nr_sequencia		= x.nr_seq_conta
	and	y.nr_seq_protocolo	= nr_seq_protocolo_pc
	and	x.ie_situacao		= 'I'
	and	x.ie_forma_inativacao	in ('S','US')
	
union all

	select	x.nr_sequencia,
		y.nr_seq_analise
	from	pls_ocorrencia_benef	x,
		pls_conta_v 		y
	where	y.nr_sequencia		= x.nr_seq_conta
	and	y.nr_sequencia		= nr_seq_conta_pc
	and	x.ie_situacao		= 'I'
	and	x.ie_forma_inativacao	in ('S','US')
	
union all

	select	x.nr_sequencia,
		y.nr_seq_analise
	from	pls_ocorrencia_benef	x,
		pls_conta_v 		y
	where	y.nr_sequencia		= x.nr_seq_conta
	and	exists (select	1
			from	pls_cta_lote_proc_conta p
			where	p.nr_seq_lote_processo = nr_seq_lote_processo_pc
			and	p.nr_seq_conta = y.nr_sequencia)
	and	x.ie_situacao		= 'I'
	and	x.ie_forma_inativacao	in ('S','US');
BEGIN

for c_ocor_w in c_ocor(nr_seq_lote_p, nr_seq_protocolo_p, nr_seq_lote_processo_p, nr_seq_conta_p) loop
	begin
	update	pls_analise_glo_ocor_grupo a
	set	a.ie_status		= 'L'
	where	a.nr_seq_analise	= c_ocor_w.nr_seq_analise
	and	a.ie_status		= 'P'
	and	a.nr_seq_ocor_benef	= c_ocor_w.nr_sequencia;
	end;
end loop;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_consistir_pck.pls_grava_fluxo_ocor ( nr_seq_lote_p pls_lote_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;