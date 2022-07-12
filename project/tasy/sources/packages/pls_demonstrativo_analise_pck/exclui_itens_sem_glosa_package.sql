-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_demonstrativo_analise_pck.exclui_itens_sem_glosa (nr_seq_versao_p pls_rel_an_conta.nr_seq_versao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


nr_seq_conta_ant_w	pls_conta.nr_sequencia%type := -1;
nr_paginas_w		integer := 0;

	
C00 CURSOR( nr_seq_versao_pc	pls_rel_an_conta.nr_seq_versao%type) FOR
	SELECT	a.nr_sequencia nr_seq_item,
		CASE WHEN  dados_regra_demonstrativo_w.ie_agrup_atendimento ='N' THEN  b.nr_sequencia  ELSE coalesce((	SELECT 	max(nr_sequencia)
	from	pls_rel_an_conta	b,
		pls_rel_an_itens	a
	where	a.nr_seq_an_conta	= b.nr_sequencia
	and	b.nr_seq_versao		= nr_seq_versao_pc
	and	a.vl_glosa		<> 0;

current_setting('pls_demonstrativo_analise_pck.c01')::CURSOR( CURSOR( nr_seq_versao_pc	pls_rel_an_conta.nr_seq_versao%type) FOR
	SELECT	a.nr_sequencia nr_seq_item
	from	pls_rel_an_conta	b,
		pls_rel_an_itens	a
	where	a.nr_seq_an_conta	= b.nr_sequencia
	and	b.nr_seq_versao		= nr_seq_versao_pc
	and	a.vl_glosa		= 0;
	
BEGIN

for r_C01_w in current_setting('pls_demonstrativo_analise_pck.c01')::CURSOR((nr_seq_versao_p) loop

	delete 	from pls_rel_an_itens
	where	nr_sequencia = r_C01_w.nr_seq_item;

end loop;

--Limpa toda as paginas dos itens 

update	pls_rel_an_itens
set	nr_seq_an_pagina  = NULL
where	nr_seq_an_conta	   in (	SELECT 	nr_sequencia
				from	pls_rel_an_conta
				where	nr_seq_versao = nr_seq_versao_p);
				
--Deleta todas as paginas da versao em geracao do demonstrativo. Necessario fazer isso, pois

--se um item e excluido, todas as paginas a partir da pagina que ele pertence devem ser recalculadas.

delete	from pls_rel_an_pagina
where	nr_seq_an_conta  in (	SELECT 	nr_sequencia
				from	pls_rel_an_conta
				where	nr_seq_versao = nr_seq_versao_p);

for r_C00_w in C00(nr_seq_versao_p) loop
	
	PERFORM set_config('pls_demonstrativo_analise_pck.qt_reg_conta_w', current_setting('pls_demonstrativo_analise_pck.qt_reg_conta_w')::integer + 1, false);
	--Recrio todas as paginas conforme a necessidade e atualizo a informacao da pagina nos itens.

	if	((nr_seq_conta_ant_w <> r_C00_w.nr_seq_rel_an_conta_principal) or (current_setting('pls_demonstrativo_analise_pck.qt_reg_conta_w')::integer = 17)) then
		nr_paginas_w	:= nr_paginas_w + 1;
		insert into	pls_rel_an_pagina(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
				nr_seq_an_conta,nr_pagina)
		values (	nextval('pls_rel_an_pagina_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
				r_C00_w.nr_seq_rel_an_conta_principal,nr_paginas_w)
		returning nr_sequencia into current_setting('pls_demonstrativo_analise_pck.nr_seq_an_paginas_w')::pls_rel_an_pagina.nr_sequencia%type;
			
		nr_seq_conta_ant_w := r_C00_w.nr_seq_rel_an_conta_principal;
		PERFORM set_config('pls_demonstrativo_analise_pck.qt_reg_conta_w', 0, false);
	end if;
	
	update pls_rel_an_itens set nr_seq_an_pagina = current_setting('pls_demonstrativo_analise_pck.nr_seq_an_paginas_w')::pls_rel_an_pagina.nr_sequencia%type where nr_sequencia = r_C00_w.nr_seq_item;

end loop;

end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_demonstrativo_analise_pck.exclui_itens_sem_glosa (nr_seq_versao_p pls_rel_an_conta.nr_seq_versao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;