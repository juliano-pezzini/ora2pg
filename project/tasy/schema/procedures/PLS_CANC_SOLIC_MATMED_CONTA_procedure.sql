-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_canc_solic_matmed_conta ( nr_seq_conta_p pls_conta.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type ) AS $body$
DECLARE

 
cd_guia_ref_w			pls_conta.cd_guia_referencia%type;
nr_seq_segurado_w		pls_conta.nr_seq_segurado%type;
nr_seq_guia_w			pls_guia_plano.nr_sequencia%type;

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Efetuar cancelamento das solicitações de materiais\medicamentos 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ X ] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
--Solicitações , considerando a guia e o segurado, que estejam em análise ou aguardando justificativa 
C01 CURSOR(	nr_seq_segurado_pc	pls_conta.nr_seq_segurado%type, 
		nr_seq_guia_pc		pls_guia_plano.nr_sequencia%type)FOR 
	SELECT	nr_sequencia 
	from	pls_solic_lib_mat_med 
	where	nr_seq_segurado = nr_seq_segurado_pc 
	and	nr_seq_guia	= nr_seq_guia_pc 
	and	ie_status in (1,2);

BEGIN 
 
select	max(b.nr_seq_segurado), 
	max(coalesce(b.cd_guia_referencia,b.cd_guia)), 
	max(nr_seq_guia) 
into STRICT	nr_seq_segurado_w, 
	cd_guia_ref_w, 
	nr_seq_guia_w 
from	pls_conta b 
where	b.nr_sequencia	= nr_seq_conta_p;
 
if (coalesce(nr_seq_guia_w::text, '') = '') then 
	select	max(nr_sequencia) 
	into STRICT	nr_seq_guia_w 
	from	pls_guia_plano 
	where	cd_guia 	= cd_guia_ref_w 
	and	nr_seq_segurado = nr_seq_segurado_w;
end if;
for r_C01_w in C01(	nr_seq_segurado_w, nr_seq_guia_w) loop 
		 
	CALL pls_atualizar_mat_med_solic(r_C01_w.nr_sequencia, 'R', nm_usuario_p,'N', 'Negado devido a geração da análise para a guia em questão');	
 
end loop;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_canc_solic_matmed_conta ( nr_seq_conta_p pls_conta.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type ) FROM PUBLIC;

