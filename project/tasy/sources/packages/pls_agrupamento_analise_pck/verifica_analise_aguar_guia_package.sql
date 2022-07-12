-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

--Rotina que ira verificar se existem analises com o mesmo numero de guia aguardando



CREATE OR REPLACE PROCEDURE pls_agrupamento_analise_pck.verifica_analise_aguar_guia ( nr_seq_lote_p pls_lote_protocolo_conta.nr_sequencia%type, nm_usuario_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


C_conta CURSOR(nr_seq_lote_pc		pls_protocolo_conta.nr_seq_lote_conta%type) FOR
	SELECT	c.nr_sequencia,
		c.cd_guia_ref cd_guia_referencia,
		c.nr_seq_segurado,
		c.nr_seq_lote_conta,
		c.nr_seq_analise
	from	pls_conta_v	c
	where	nr_seq_lote_conta 	= nr_seq_lote_pc
	and	ie_tipo_guia		= '5'
	and	ie_status		!= 'C'
	and	ie_origem_conta		!= 'A';
	
C_analise CURSOR(	cd_guia_referencia_pc		pls_conta.cd_guia_referencia%type,
			nr_seq_segurado_pc		pls_conta_v.nr_seq_segurado%type) FOR
	SELECT	a.nr_sequencia nr_seq_analise,
		b.nr_sequencia nr_seq_conta
	from	pls_analise_conta	a,
		pls_conta		b
	where	a.ie_status		= 'X'
	and	a.nr_seq_segurado	= nr_seq_segurado_pc
	and	a.cd_guia		= cd_guia_referencia_pc
	and	a.nr_sequencia		= b.nr_seq_analise;
BEGIN

for r_c_conta_w in C_conta(nr_seq_lote_p) loop
	begin
	
	for r_c_analise_w in C_analise(r_c_conta_w.cd_guia_referencia, r_c_conta_w.nr_seq_segurado) loop
		begin
		CALL pls_agrupamento_analise_pck.vincula_conta_analise_exist( 	r_c_analise_w.nr_seq_conta, r_c_conta_w.nr_seq_analise, nm_usuario_p,
						cd_estabelecimento_p);
		end;
	end loop;
	
	end;
end loop;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_agrupamento_analise_pck.verifica_analise_aguar_guia ( nr_seq_lote_p pls_lote_protocolo_conta.nr_sequencia%type, nm_usuario_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;