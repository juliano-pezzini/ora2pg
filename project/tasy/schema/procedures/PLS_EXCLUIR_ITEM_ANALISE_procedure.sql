-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_excluir_item_analise ( ds_sequencia_itens_p text, cd_estabelecimento_p bigint, nr_seq_analise_p bigint, nm_usuario_p text ) AS $body$
DECLARE

 
ds_sequencia_itens_w 	 	varchar(4000);
nr_seq_item_w   	 	bigint;
nr_seq_item_ww   		bigint;
ie_tipo_item_w   		varchar(1);
nr_seq_proc_w   		bigint;
nr_seq_mat_w   		bigint;
nr_seq_analise_conta_item_w 	bigint;
nr_seq_proc_partic_w  	bigint;
nr_seq_partic_w   		bigint;
ie_origem_analise_w  		smallint;
nr_seq_conta_proc_w  		bigint;
nr_seq_conta_ww   		bigint;
qt_participante_w		bigint 	:= 0;

C01 CURSOR FOR 
 SELECT 	nr_sequencia 
 from 	pls_analise_conta_item 
 where 	nr_seq_w_resumo_conta = nr_seq_item_w 
 and 		nr_seq_analise = nr_seq_analise_p 
 order by 1;

C02 CURSOR FOR 
 SELECT 	nr_sequencia 
 from 	pls_proc_participante 
 where 	nr_seq_conta_proc = nr_seq_proc_w 
 order by 1;

C03 CURSOR FOR 
 SELECT 	nr_sequencia 
 from 	pls_analise_conta_item 
 where 	nr_seq_proc_partic = nr_seq_proc_partic_w 
 and 		nr_seq_analise  = nr_seq_analise_p 
 order by 1;
C04 CURSOR FOR
 SELECT nr_sequencia 
 from pls_analise_conta_item 
 where ((nr_seq_conta_proc  = nr_seq_proc_w) 
 or (nr_seq_conta_mat  = nr_seq_mat_w) 
 or (nr_seq_proc_partic = nr_seq_partic_w))  
 and nr_seq_analise = nr_seq_analise_p 
 order by 1;


BEGIN 
select max(ie_origem_analise) 
into STRICT 	ie_origem_analise_w 
from 	pls_analise_conta 
where 	nr_sequencia = nr_seq_analise_p;
 
ds_sequencia_itens_w := ds_sequencia_itens_p;
 
while(position(',' in ds_sequencia_itens_w) <> 0) loop 
 begin    
 
 
 nr_seq_item_w  := substr(ds_sequencia_itens_w,1,position(',' in ds_sequencia_itens_w)-1);
 ds_sequencia_itens_w := substr(ds_sequencia_itens_w,position(',' in ds_sequencia_itens_w)+1,255);
  
 select nr_seq_item, 
	 ie_tipo_item, 
	 nr_seq_partic_proc, 
	 nr_Seq_conta 
 into STRICT  nr_seq_item_ww, 
	 ie_tipo_item_w, 
	 nr_seq_partic_w, 
	 nr_Seq_conta_ww 
 from w_pls_resumo_conta 
 where nr_sequencia = nr_seq_item_w 
 and nr_seq_analise = nr_seq_analise_p;
  
 if (ie_tipo_item_w = 'P') then 
  nr_seq_proc_w := nr_seq_item_ww;
  nr_seq_mat_w := null;
  nr_seq_partic_w := null;
 elsif (ie_tipo_item_w = 'M') then 
  nr_seq_mat_w  := nr_seq_item_ww;
  nr_seq_proc_w := null;
  nr_seq_partic_w := null;
 elsif (ie_tipo_item_w = 'R') then 
  select max(nr_seq_conta_proc) 
  into STRICT nr_seq_conta_proc_w 
  from pls_proc_participante 
  where nr_sequencia = nr_seq_partic_w;
  
  nr_seq_mat_w  := null;
  nr_seq_proc_w := null;
 end if;
 
 open C01;
 loop 
 fetch C01 into  
  nr_seq_analise_conta_item_w;
 EXIT WHEN NOT FOUND; /* apply on C01 */
  begin 
  delete FROM pls_analise_parecer_item 
  where nr_seq_item = nr_seq_analise_conta_item_w;
 
  delete FROM pls_analise_conta_item_log 
  where nr_seq_analise_item = nr_seq_analise_conta_item_w;
   
  delete FROM pls_analise_conta_item 
  where nr_sequencia = nr_seq_analise_conta_item_w;
   
  end;
 end loop;
 close C01;
  
 open C04;
 loop 
 fetch C04 into  
  nr_seq_analise_conta_item_w;
 EXIT WHEN NOT FOUND; /* apply on C04 */
  begin 
   
  delete FROM pls_analise_parecer_item 
  where nr_seq_item = nr_seq_analise_conta_item_w;
 
  delete FROM pls_analise_conta_item_log 
  where nr_seq_analise_item = nr_seq_analise_conta_item_w;
   
  delete FROM pls_analise_conta_item 
  where nr_sequencia = nr_seq_analise_conta_item_w;
   
  end;
 end loop;
 close C04;
  
   commit;
 if (ie_tipo_item_w in ('P', 'M')) then   
  delete FROM w_pls_resumo_conta 
  where (nr_seq_conta_proc = nr_seq_proc_w or nr_seq_conta_mat = nr_seq_mat_w) 
  and nr_seq_analise = nr_seq_analise_p;
 elsif (ie_tipo_item_w = 'R') then 
  delete FROM w_pls_resumo_conta 
  where nr_seq_partic_proc  = nr_seq_partic_w 
  and nr_seq_analise  = nr_seq_analise_p;
 end if;
  
 delete FROM pls_ocorrencia_benef 
 where coalesce(nr_seq_guia_plano::text, '') = '' 
 and coalesce(nr_seq_requisicao::text, '') = '' 
 and ((nr_seq_proc   = nr_seq_proc_w) 
 or (nr_seq_mat   = nr_seq_mat_w) 
 or (nr_seq_proc_partic = nr_seq_partic_w));
  
 delete FROM pls_conta_glosa 
 where ((coalesce(nr_seq_conta_proc,0) = nr_seq_proc_w) 
 or (coalesce(nr_seq_conta_mat,0) = nr_seq_mat_w));
  
 open C02;
 loop 
 fetch C02 into  
  nr_seq_proc_partic_w;
 EXIT WHEN NOT FOUND; /* apply on C02 */
  begin 
   
  open C03;
  loop 
  fetch C03 into  
   nr_seq_analise_conta_item_w;
  EXIT WHEN NOT FOUND; /* apply on C03 */
   begin 
    
   delete FROM pls_analise_parecer_item 
   where nr_seq_item = nr_seq_analise_conta_item_w;
    
   end;
  end loop;
  close C03;
   
  delete FROM pls_analise_conta_item 
  where nr_seq_proc_partic = nr_seq_proc_partic_w;
   
  delete FROM pls_ocorrencia_benef  
  where coalesce(nr_seq_guia_plano::text, '') = '' 
  and coalesce(nr_seq_requisicao::text, '') = '' 
  and coalesce(nr_seq_conta_pos_estab::text, '') = '' 
  and nr_seq_proc_partic = nr_seq_proc_partic_w;
   
  delete FROM pls_conta_glosa 
  where nr_seq_proc_partic = nr_seq_proc_partic_w;
   
  delete FROM pls_analise_fluxo_item 
  where nr_seq_proc_partic = nr_seq_proc_partic_w;
   
  delete FROM pls_proc_participante 
  where nr_sequencia = nr_seq_proc_partic_w;
   
  end;
 end loop;
 close C02;
  
 /*vai sincronizar a analise pos-estabelecido para que não haja inconsistencia de integridade durante a deleção*/
 
 CALL pls_atualizar_conta_pos_estab( nr_Seq_conta_ww, nr_seq_proc_w,nr_seq_mat_w, nr_seq_analise_p,'N',cd_estabelecimento_p, nm_usuario_p);
  
 if (ie_tipo_item_w = 'P')	then 
  
	CALL pls_delete_conta_medica_resumo(nr_seq_conta_ww,nr_seq_proc_w,null,nm_usuario_P);
 
 elsif (ie_tipo_item_w = 'M')	then 
	CALL pls_delete_conta_medica_resumo(nr_seq_conta_ww,null,nr_seq_mat_w,nm_usuario_P);
 end if;
 
 delete FROM pls_analise_fluxo_item 
 where	 nr_seq_conta_proc = nr_seq_proc_w;
  
 delete FROM pls_conta_proc 
 where nr_sequencia = nr_seq_proc_w;
  
 delete FROM pls_analise_fluxo_item 
 where	 nr_seq_conta_mat = nr_seq_mat_w;
  
 delete FROM pls_conta_mat 
 where nr_sequencia = nr_seq_mat_w;
  
 delete FROM pls_analise_fluxo_item 
 where	 nr_seq_proc_partic = nr_seq_proc_partic_w;
  
 delete FROM pls_proc_participante 
 where nr_sequencia = nr_seq_partic_w;
  
 if (ie_origem_analise_w = 3) and (ie_tipo_item_w = 'R') then   
  CALL pls_remover_proc_partic_ptu(nr_seq_item_ww, cd_estabelecimento_p, nm_usuario_p);
 end if;
  
 end;
end loop;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_excluir_item_analise ( ds_sequencia_itens_p text, cd_estabelecimento_p bigint, nr_seq_analise_p bigint, nm_usuario_p text ) FROM PUBLIC;

