-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_mov_benef_imp_pck.definir_movimentacao ( nr_seq_lote_p pls_mov_benef_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

C03 CURSOR FOR
	SELECT	a.*,
		(SELECT	max(x.nr_sequencia)
		from	pls_segurado x,
			pls_segurado_carteira y
		where	x.nr_sequencia = y.nr_seq_segurado
		and	y.cd_usuario_plano = a.cd_usuario_plano) nr_seq_segurado_existente,
		(select	max(x.nr_sequencia)
		from	pls_mov_benef_contrato x
		where	x.nr_seq_lote = nr_seq_lote_p
		and	x.nr_contrato = a.nr_contrato) nr_seq_mov_contrato_existente,
		(select	max(x.nr_sequencia)
		from	pls_intercambio x
		where	x.nr_contrato_origem	= a.nr_contrato) nr_seq_intercambio_existente
	from	pls_mov_benef_segurado a
	where	a.nr_seq_lote = nr_seq_lote_p
	order by 1;
BEGIN

for r_c03_w in C03 loop
	begin
	
	update	pls_mov_benef_segurado
	set	ie_tipo_movimentacao	= CASE WHEN r_c03_w.nr_seq_segurado_existente = NULL THEN 'I'  ELSE CASE WHEN r_c03_w.dt_fim_compartilhamento = NULL THEN 'A'  ELSE 'E' END  END ,
		nr_seq_segurado		= r_c03_w.nr_seq_segurado_existente,
		nr_seq_mov_contrato	= r_c03_w.nr_seq_mov_contrato_existente,
		nr_seq_intercambio	= r_c03_w.nr_seq_intercambio_existente
	where	nr_sequencia		= r_c03_w.nr_sequencia;
	end;
end loop;
commit;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mov_benef_imp_pck.definir_movimentacao ( nr_seq_lote_p pls_mov_benef_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
