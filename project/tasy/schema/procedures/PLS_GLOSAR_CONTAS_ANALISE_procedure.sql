-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_glosar_contas_analise ( nr_seq_analise_p bigint, nr_seq_grupo_atual_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text ) AS $body$
DECLARE

 
nr_seq_conta_w		bigint;
ds_retorno_w		varchar(4000);	
nr_seq_item_analise_w	bigint;
				
C01 CURSOR FOR 
	SELECT	nr_sequencia 
	from	pls_conta 
	where	nr_seq_analise = nr_seq_analise_p 
	order by 1;
				

BEGIN 
 
update	pls_analise_conta 
set	ie_atende_glosado	= 'S' 
where	nr_sequencia 		= nr_seq_analise_p;
 
open C01;
loop 
fetch C01 into	 
	nr_seq_conta_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	CALL pls_gerar_w_analise_glosa_ocor(nr_seq_analise_p, nr_seq_conta_w, null, null, null, null, 'N', nm_usuario_p);
	 
	 
	CALL pls_analise_glosar_item(nr_seq_analise_p, nr_seq_conta_w, null, null, null, null, 
				null, 'Glosado em pré-análise', cd_estabelecimento_p, 
				nr_seq_grupo_atual_p, 'N', 'N', 'N', 'S', nm_usuario_p,null);
	 
		 
	/*update	pls_analise_conta_item 
	set	ie_status 			= 'N', 
		nm_usuario			= nm_usuario_p, 
		dt_atualizacao 			= sysdate, 
		ie_situacao 			= 'A' --Ativar a glosa/ocorrencia		 
	where	nr_sequencia			in (	select	a.nr_sequencia			--No caso de existir a glosa 1001 
							from	pls_analise_conta_item 		a, 
								pls_conta_glosa 		b, 
								tiss_motivo_glosa		c 
							where	a.nr_seq_glosa 			= b.nr_sequencia 
							and	b.nr_seq_motivo_glosa		= c.nr_sequencia 
							and	c.cd_motivo_tiss		= '1001' 
							and	a.nr_seq_conta			= nr_seq_conta_w 
							union 
							select	a.nr_sequencia			--No caso de existir a ocorrencia vinculada 1001 
							from	pls_analise_conta_item 		a, 
								pls_ocorrencia_benef 		b, 
								tiss_motivo_glosa		c, 
								pls_ocorrencia			d 
							where	a.nr_seq_ocorrencia		= b.nr_sequencia 
							and	b.nr_seq_ocorrencia		= d.nr_sequencia 
							and	d.nr_seq_motivo_glosa		= c.nr_sequencia 
							and	c.cd_motivo_tiss		= '1001' 
							and	a.nr_seq_conta			= nr_seq_conta_w 
							and	nvl(d.ie_glosa,'N')		= 'S'	); 
	 
	pls_glosar_item_conta(nr_seq_conta_w, 0, 0, 
			   nm_usuario_p, cd_estabelecimento_p);		 
			 
	pls_fechar_conta_sem_aud(nr_seq_analise_p, cd_estabelecimento_p, nm_usuario_p, 
				 ds_retorno_w	); 
			 
	pls_liberar_analise_grupo(nr_seq_analise_p, nm_usuario_p, nr_seq_grupo_atual_p, 'N', cd_estabelecimento_p); 
	 
	pls_fechar_conta_analise('', nr_seq_analise_p, nr_seq_grupo_atual_p, 
				 'N', cd_estabelecimento_p, nm_usuario_p);*/
 
	 
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_glosar_contas_analise ( nr_seq_analise_p bigint, nr_seq_grupo_atual_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text ) FROM PUBLIC;

