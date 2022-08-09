-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE rc_proced AS (nr_seq_guia_proc_r	pls_guia_plano_proc.nr_sequencia%type);
CREATE TYPE rc_material AS (nr_seq_guia_mat_r	pls_guia_plano_mat.nr_sequencia%type);
CREATE TYPE rc_proced_req AS (nr_seq_req_proc_r	pls_requisicao_proc.nr_sequencia%type);
CREATE TYPE rc_material_req AS (nr_seq_req_mat_r	pls_requisicao_mat.nr_sequencia%type);


CREATE OR REPLACE PROCEDURE pls_valida_ocor_aut_fundacao ( nr_seq_ocor_combinada_p bigint, nr_seq_ocorrencia_p bigint, nr_seq_segurado_p bigint, nr_seq_motivo_glosa_p bigint, nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, nr_seq_execucao_p bigint, ie_utiliza_filtro_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Atualizar a guia conforme a geração da ocorrência combinada 
 
 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ X ] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção:performance 
 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
type 	tb_proced 	is table	of rc_proced		index by integer;
type 	tb_material 	is table	of rc_material		index by integer;
type 	tb_proced_req 	is table	of rc_proced_req		index by integer;
type 	tb_material_req 	is table	of rc_material_req		index by integer;
tb_proced_w		tb_proced;
tb_material_w		tb_material;
tb_proced_req_w		tb_proced_req;
tb_material_req_w		tb_material_req;

nr_seq_segurado_w		bigint;
nr_seq_motivo_glosa_w		bigint;
nr_seq_guia_proc_w			bigint;
nr_seq_ops_congenere_w		bigint;
nr_seq_oc_benef_w		bigint;
nr_seq_guia_mat_w			bigint;
ie_gerar_ocorrencia_w		varchar(2);	
ie_tipo_item_w			varchar(2);
ie_regra_w			varchar(2);
ie_gerou_ocor_cabecalho_w	varchar(2);
ie_tipo_ocorrencia_w		varchar(2);
cd_procedimento_w		varchar(10);
ie_origem_proced_w		varchar(2);
nr_seq_material_w		bigint;
nr_indice_w			bigint	:= 0;
nr_seq_req_proc_w		bigint;
nr_proc_req_w			bigint;
ie_origem_proc_req_w	bigint;
nr_seq_req_mat_w		bigint;

 
C01 CURSOR FOR 
	SELECT 	nr_sequencia, 
		cd_procedimento, 
		ie_origem_proced 
	from 	pls_guia_plano_proc 
	where 	nr_seq_guia = nr_seq_guia_p;
	
C02 CURSOR FOR 
	SELECT 	nr_sequencia, 
		nr_seq_material 
	from 	pls_guia_plano_mat 
	where 	nr_seq_guia = nr_seq_guia_p;
	
C03 CURSOR FOR 
	SELECT 	nr_sequencia, 
		cd_procedimento, 
		ie_origem_proced 
	from 	pls_requisicao_proc 
	where 	nr_seq_requisicao = nr_seq_requisicao_p;

C04 CURSOR FOR 
	SELECT 	nr_sequencia, 
		nr_seq_material 
	from 	pls_requisicao_mat 
	where 	nr_seq_requisicao = nr_seq_requisicao_p;	
	 
 
BEGIN 
 
if (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then 
	begin 
		select	nr_seq_segurado 
		into STRICT	nr_seq_segurado_w 
		from	pls_guia_plano 
		where	nr_sequencia	= nr_seq_guia_p;
	exception 
	when others then 
		nr_seq_segurado_w		:= null;
	end;
elsif (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then 
	begin 
		select	nr_seq_segurado 
		into STRICT	nr_seq_segurado_w 
		from	pls_requisicao 
		where	nr_sequencia	= nr_seq_requisicao_p;
	exception 
	when others then 
		nr_seq_segurado_w		:= null;
	end;
end if;
 
begin 
	select	nr_seq_ops_congenere 
	into STRICT	nr_seq_ops_congenere_w 
	from	pls_segurado 
	where	nr_sequencia	= nr_seq_segurado_w;
exception 
when others then 
	nr_seq_ops_congenere_w	:= null;
end;
 
begin 
	select	ie_valida_benef_fundacao 
	into STRICT	ie_gerar_ocorrencia_w 
	from	pls_validacao_aut_fundacao 
	where	nr_seq_ocor_aut_combinada	= nr_seq_ocor_combinada_p 
	and	ie_situacao 	= 'A';
exception 
when others then 
	ie_gerar_ocorrencia_w	:= null;
end;
 
if ((nr_seq_ops_congenere_w IS NOT NULL AND nr_seq_ops_congenere_w::text <> '') and ie_gerar_ocorrencia_w = 'S') then 
 
	if (ie_utiliza_filtro_p = 'S') then 
	 
		ie_gerar_ocorrencia_w	:= 'N';
		nr_indice_w		:= 0;
		tb_proced_w.Delete;
		open C01;
		loop 
		fetch C01 into	 
			nr_seq_guia_proc_w, 
			cd_procedimento_w, 
			ie_origem_proced_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin 
			/* Tratamento para filtros */
 
			SELECT * FROM pls_gerar_ocor_aut_filtro(	nr_seq_ocor_combinada_p, nr_seq_guia_p, null, null, nr_seq_guia_proc_w, null, null, null, null, cd_procedimento_w, ie_origem_proced_w, null, ie_gerou_ocor_cabecalho_w, null, nr_seq_ocorrencia_p, null, null, null, nm_usuario_p, ie_regra_w, ie_tipo_ocorrencia_w ) INTO STRICT ie_regra_w, ie_tipo_ocorrencia_w;
				 
				if (ie_regra_w	= 'S') then 
					nr_indice_w	:= nr_indice_w + 1;
					tb_proced_w[nr_indice_w].nr_seq_guia_proc_r	:= nr_seq_guia_proc_w;
				end if;
			end;
		end loop;
		close C01;
		 
		for i in 1..nr_indice_w loop 
			nr_seq_oc_benef_w := pls_inserir_ocorrencia(	nr_seq_segurado_p, nr_seq_ocorrencia_p, null, nr_seq_guia_p, null, tb_proced_w[i].nr_seq_guia_proc_r, null, nr_seq_ocor_combinada_p, nm_usuario_p, null, nr_seq_motivo_glosa_p, 1, cd_estabelecimento_p, 'N', null, nr_seq_oc_benef_w, null, null, null, null);
						 
			CALL pls_atualizar_status_ocor_comb(	nr_seq_ocorrencia_p, nr_seq_ocor_combinada_p, nr_seq_motivo_glosa_p, 
							nr_seq_guia_p, nr_seq_requisicao_p, nr_seq_execucao_p, 
							tb_proced_w[i].nr_seq_guia_proc_r, null, null, 
							null, null, null, 
							nm_usuario_p, cd_estabelecimento_p);
		end loop;
		 
		nr_indice_w	:= 0;
		tb_material_w.Delete;
		open C02;
		loop 
		fetch C02 into	 
			nr_seq_guia_mat_w, 
			nr_seq_material_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin 
			/* Tratamento para filtros */
 
			SELECT * FROM pls_gerar_ocor_aut_filtro(	nr_seq_ocor_combinada_p, nr_seq_guia_p, null, null, null, nr_seq_guia_mat_w, null, null, null, null, null, nr_seq_material_w, ie_gerou_ocor_cabecalho_w, null, nr_seq_ocorrencia_p, null, null, null, nm_usuario_p, ie_regra_w, ie_tipo_ocorrencia_w ) INTO STRICT ie_regra_w, ie_tipo_ocorrencia_w;
 
							 
			if (ie_regra_w	= 'S') then 
				nr_indice_w	:= nr_indice_w + 1;
				tb_material_w[nr_indice_w].nr_seq_guia_mat_r	:= nr_seq_guia_mat_w;
			end if;
			end;
		end loop;
		close C02;
		 
		for i in 1..nr_indice_w loop 
			nr_seq_oc_benef_w := pls_inserir_ocorrencia(	nr_seq_segurado_p, nr_seq_ocorrencia_p, null, nr_seq_guia_p, null, null, tb_material_w[i].nr_seq_guia_mat_r, nr_seq_ocor_combinada_p, nm_usuario_p, null, nr_seq_motivo_glosa_p, 2, cd_estabelecimento_p, 'N', null, nr_seq_oc_benef_w, null, null, null, null);
						 
			CALL pls_atualizar_status_ocor_comb(	nr_seq_ocorrencia_p, nr_seq_ocor_combinada_p, nr_seq_motivo_glosa_p, 
							nr_seq_guia_p, nr_seq_requisicao_p, nr_seq_execucao_p, 
							null, tb_material_w[i].nr_seq_guia_mat_r, null, 
							null, null, null, 
							nm_usuario_p, cd_estabelecimento_p);
		end loop;		
		 
		nr_indice_w		:= 0;
		tb_proced_req_w.Delete;
		open C03;
		loop 
		fetch C03 into	 
			nr_seq_req_proc_w,	 
			nr_proc_req_w, 
			ie_origem_proc_req_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin 
			/* Tratamento para filtros */
 
			SELECT * FROM pls_gerar_ocor_aut_filtro(	nr_seq_ocor_combinada_p, null, nr_seq_requisicao_p, null, null, null, nr_seq_req_proc_w, null, null, nr_proc_req_w, ie_origem_proc_req_w, null, ie_gerou_ocor_cabecalho_w, null, nr_seq_ocorrencia_p, null, null, null, nm_usuario_p, ie_regra_w, ie_tipo_ocorrencia_w ) INTO STRICT ie_regra_w, ie_tipo_ocorrencia_w;
				 
				if (ie_regra_w	= 'S') then 
					nr_indice_w	:= nr_indice_w + 1;
					tb_proced_req_w[nr_indice_w].nr_seq_req_proc_r	:= nr_seq_req_proc_w;
				end if;
			end;
		end loop;
		close C03;
		 
		for i in 1..nr_indice_w loop 
			nr_seq_oc_benef_w := pls_inserir_ocorrencia(	nr_seq_segurado_p, nr_seq_ocorrencia_p, nr_seq_requisicao_p, null, null, tb_proced_req_w[i].nr_seq_req_proc_r, null, nr_seq_ocor_combinada_p, nm_usuario_p, null, nr_seq_motivo_glosa_p, 1, cd_estabelecimento_p, 'N', null, nr_seq_oc_benef_w, null, null, null, null);
						 
			CALL pls_atualizar_status_ocor_comb(	nr_seq_ocorrencia_p, nr_seq_ocor_combinada_p, nr_seq_motivo_glosa_p, 
							nr_seq_guia_p, nr_seq_requisicao_p, nr_seq_execucao_p, 
							null, null, tb_proced_req_w[i].nr_seq_req_proc_r, 
							null, null, null, 
							nm_usuario_p, cd_estabelecimento_p);
		end loop;
		 
		nr_indice_w	:= 0;
		tb_material_req_w.Delete;
		open C04;
		loop 
		fetch C04 into	 
			nr_seq_req_mat_w, 
			nr_seq_material_w;
		EXIT WHEN NOT FOUND; /* apply on C04 */
			begin 
			/* Tratamento para filtros */
 
			SELECT * FROM pls_gerar_ocor_aut_filtro(	nr_seq_ocor_combinada_p, null, nr_seq_requisicao_p, null, null, null, null, nr_seq_req_mat_w, null, null, null, nr_seq_material_w, ie_gerou_ocor_cabecalho_w, null, nr_seq_ocorrencia_p, null, null, null, nm_usuario_p, ie_regra_w, ie_tipo_ocorrencia_w ) INTO STRICT ie_regra_w, ie_tipo_ocorrencia_w;
 
							 
			if (ie_regra_w	= 'S') then 
				nr_indice_w	:= nr_indice_w + 1;
				tb_material_req_w[nr_indice_w].nr_seq_req_mat_r	:= nr_seq_req_mat_w;
			end if;
			end;
		end loop;
		close C04;
		 
		for i in 1..nr_indice_w loop 
			nr_seq_oc_benef_w := pls_inserir_ocorrencia(	nr_seq_segurado_p, nr_seq_ocorrencia_p, nr_seq_requisicao_p, null, null, null, tb_material_req_w[i].nr_seq_req_mat_r, nr_seq_ocor_combinada_p, nm_usuario_p, null, nr_seq_motivo_glosa_p, 2, cd_estabelecimento_p, 'N', null, nr_seq_oc_benef_w, null, null, null, null);
						 
			CALL pls_atualizar_status_ocor_comb(	nr_seq_ocorrencia_p, nr_seq_ocor_combinada_p, nr_seq_motivo_glosa_p, 
							nr_seq_guia_p, nr_seq_requisicao_p, nr_seq_execucao_p, 
							null, null, null, 
							tb_material_req_w[i].nr_seq_req_mat_r, null, null, 
							nm_usuario_p, cd_estabelecimento_p);
		end loop;
		 
		tb_proced_w.Delete;
		tb_material_w.Delete;
		tb_proced_req_w.Delete;
		tb_material_req_w.Delete;
	else 
	 
		open C01;
		loop 
		fetch C01 into	 
			nr_seq_guia_proc_w, 
			cd_procedimento_w, 
			ie_origem_proced_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin 
			nr_seq_oc_benef_w := pls_inserir_ocorrencia(	nr_seq_segurado_p, nr_seq_ocorrencia_p, null, nr_seq_guia_p, null, nr_seq_guia_proc_w, null, nr_seq_ocor_combinada_p, nm_usuario_p, null, nr_seq_motivo_glosa_p, 1, cd_estabelecimento_p, 'N', null, nr_seq_oc_benef_w, null, null, null, null);
 
			CALL pls_atualizar_status_ocor_comb(	nr_seq_ocorrencia_p, nr_seq_ocor_combinada_p, nr_seq_motivo_glosa_p, 
							nr_seq_guia_p, nr_seq_requisicao_p, nr_seq_execucao_p, 
							nr_seq_guia_proc_w, null, null, 
							null, null, null, 
							nm_usuario_p, cd_estabelecimento_p);
			end;
		end loop;
		close C01;
		 
		open C02;
		loop 
		fetch C02 into	 
			nr_seq_guia_mat_w, 
			nr_seq_material_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin 
			nr_seq_oc_benef_w := pls_inserir_ocorrencia(	nr_seq_segurado_p, nr_seq_ocorrencia_p, null, nr_seq_guia_p, null, null, nr_seq_guia_mat_w, nr_seq_ocor_combinada_p, nm_usuario_p, null, nr_seq_motivo_glosa_p, 2, cd_estabelecimento_p, 'N', null, nr_seq_oc_benef_w, null, null, null, null);
 
			CALL pls_atualizar_status_ocor_comb(	nr_seq_ocorrencia_p, nr_seq_ocor_combinada_p, nr_seq_motivo_glosa_p, 
							nr_seq_guia_p, nr_seq_requisicao_p, nr_seq_execucao_p, 
							null, nr_seq_guia_mat_w, null, 
							null, null, null, 
							nm_usuario_p, cd_estabelecimento_p);
			end;
		end loop;
		close C02;
 
		if (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then 
			 
			open C03;
			loop 
			fetch C03 into 
				nr_seq_req_proc_w,	 
				nr_proc_req_w, 
				ie_origem_proc_req_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */
				begin 
				 
				nr_seq_oc_benef_w := pls_inserir_ocorrencia(	nr_seq_segurado_p, nr_seq_ocorrencia_p, nr_seq_requisicao_p, null, null, nr_seq_req_proc_w, null, nr_seq_ocor_combinada_p, nm_usuario_p, null, nr_seq_motivo_glosa_p, 1, cd_estabelecimento_p, 'N', null, nr_seq_oc_benef_w, null, null, null, null);
	 
				CALL pls_atualizar_status_ocor_comb(	nr_seq_ocorrencia_p, nr_seq_ocor_combinada_p, nr_seq_motivo_glosa_p, 
								nr_seq_guia_p, nr_seq_requisicao_p, nr_seq_execucao_p, 
								null, null, nr_seq_req_proc_w, 
								null, null, null, 
								nm_usuario_p, cd_estabelecimento_p);
				 
				end;
			end loop;
			close C03;
			 
			open C04;
			loop 
			fetch C04 into	 
				nr_seq_req_mat_w, 
				nr_seq_material_w;
			EXIT WHEN NOT FOUND; /* apply on C04 */
				begin 
				 
				nr_seq_oc_benef_w := pls_inserir_ocorrencia(	nr_seq_segurado_p, nr_seq_ocorrencia_p, nr_seq_requisicao_p, null, null, null, nr_seq_req_mat_w, nr_seq_ocor_combinada_p, nm_usuario_p, null, nr_seq_motivo_glosa_p, 2, cd_estabelecimento_p, 'N', null, nr_seq_oc_benef_w, null, null, null, null);
							 
				CALL pls_atualizar_status_ocor_comb(	nr_seq_ocorrencia_p, nr_seq_ocor_combinada_p, nr_seq_motivo_glosa_p, 
								nr_seq_guia_p, nr_seq_requisicao_p, nr_seq_execucao_p, 
								null, null, null, 
								nr_seq_req_mat_w, null, null, 
								nm_usuario_p, cd_estabelecimento_p);					
				 
				end;
			end loop;
			close C04;
		 
		end if;
	end if;
	 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_valida_ocor_aut_fundacao ( nr_seq_ocor_combinada_p bigint, nr_seq_ocorrencia_p bigint, nr_seq_segurado_p bigint, nr_seq_motivo_glosa_p bigint, nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, nr_seq_execucao_p bigint, ie_utiliza_filtro_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
