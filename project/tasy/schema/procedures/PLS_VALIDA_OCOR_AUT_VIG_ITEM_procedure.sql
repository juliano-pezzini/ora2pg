-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_valida_ocor_aut_vig_item ( nr_seq_ocor_combinada_p bigint, nr_seq_ocorrencia_p bigint, nr_seq_segurado_p bigint, nr_seq_motivo_glosa_p bigint, nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, nr_seq_execucao_p bigint, ie_utiliza_filtro_p text, nr_seq_param1_p bigint, nr_seq_param2_p bigint, nr_seq_param3_p bigint, nr_seq_param4_p bigint, nr_seq_param5_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: 
Procedure utilizada para validar a vigência dos itens. 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [x] Tasy (Delphi/Java) [x] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
 Rotina utilizada para geração de ocorrência na Autorização / Requisição e Execução 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
ie_gerar_ocorrencia_w		varchar(2);
ie_mat_proc_inativo_w		varchar(2);

nr_seq_guia_proc_w		bigint;
nr_seq_guia_mat_w		bigint;
nr_seq_req_proc_w		bigint;
nr_seq_req_mat_w		bigint;
nr_seq_exec_item_w		bigint;

dt_autorizacao_w		timestamp;
dt_requisicao_w			timestamp;
dt_execucao_w			timestamp;

cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
nr_seq_material_w		bigint;

ie_situacao_validacao_w		varchar(2);
ie_regra_w			varchar(2);
ie_tipo_ocorrencia_w		varchar(2);
nr_seq_oc_benef_w		bigint;

C01 CURSOR FOR 
	SELECT	nr_sequencia, 
		cd_procedimento, 
		ie_origem_proced 
	from	pls_guia_plano_proc 
	where	nr_seq_guia		= nr_seq_guia_p;

C02 CURSOR FOR 
	SELECT	nr_sequencia, 
		nr_seq_material 
	from	pls_guia_plano_mat 
	where	nr_seq_guia		= nr_seq_guia_p;

C03 CURSOR FOR 
	SELECT	nr_sequencia, 
		cd_procedimento, 
		ie_origem_proced 
	from	pls_requisicao_proc 
	where	nr_seq_requisicao	= nr_seq_requisicao_p;

C04 CURSOR FOR 
	SELECT	nr_sequencia, 
		nr_seq_material 
	from	pls_requisicao_mat 
	where	nr_seq_requisicao	= nr_seq_requisicao_p;

C05 CURSOR FOR 
	SELECT	nr_sequencia, 
		cd_procedimento, 
		ie_origem_proced 
	from	pls_execucao_req_item 
	where	nr_seq_execucao		= nr_seq_execucao_p 
	and	coalesce(nr_seq_material::text, '') = '';

C06 CURSOR FOR 
	SELECT	nr_sequencia, 
		nr_seq_material 
	from	pls_execucao_req_item 
	where	nr_seq_execucao		= nr_seq_execucao_p 
	and	coalesce(cd_procedimento::text, '') = '';


BEGIN 
 
begin 
	select	ie_valida_vigencia_item 
	into STRICT	ie_situacao_validacao_w 
	from	pls_validacao_aut_vig_item 
	where	nr_seq_ocor_aut_combinada = nr_seq_ocor_combinada_p 
	and	ie_situacao = 'A';
exception 
when others then 
	ie_situacao_validacao_w := 'N';
end;
 
 
if (ie_situacao_validacao_w = 'S') then 
	if (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then 
		begin 
			select	dt_solicitacao 
			into STRICT	dt_autorizacao_w 
			from	pls_guia_plano 
			where	nr_sequencia = 	nr_seq_guia_p;	
		exception 
		when others then 
			dt_autorizacao_w := clock_timestamp();
		end;
 
		open C01;
		loop 
		fetch C01 into 
			nr_seq_guia_proc_w, 
			cd_procedimento_w, 
			ie_origem_proced_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin 
			ie_mat_proc_inativo_w := pls_obter_se_proc_inativo(cd_procedimento_w,ie_origem_proced_w,dt_autorizacao_w);
 
			ie_gerar_ocorrencia_w	:= 'S';
 
			if (ie_utiliza_filtro_p	= 'S') then 
				SELECT * FROM pls_gerar_ocor_aut_filtro(	nr_seq_ocor_combinada_p, nr_seq_guia_p, nr_seq_requisicao_p, nr_seq_execucao_p, nr_seq_guia_proc_w, null, null, null, null, cd_procedimento_w, ie_origem_proced_w, null, null, null, nr_seq_ocorrencia_p, null, null, null, nm_usuario_p, ie_regra_w, ie_tipo_ocorrencia_w) INTO STRICT ie_regra_w, ie_tipo_ocorrencia_w;
 
				if (ie_regra_w	= 'S') then 
					ie_gerar_ocorrencia_w	:= 'S';
				elsif (ie_regra_w	in ('E','N')) then 
					ie_gerar_ocorrencia_w	:= 'N';
				end if;
			end if;
 
			if (ie_gerar_ocorrencia_w	= 'S') and (ie_mat_proc_inativo_w = 'N') then 
				nr_seq_oc_benef_w := pls_inserir_ocorrencia(	nr_seq_segurado_p, nr_seq_ocorrencia_p, null, nr_seq_guia_p, null, nr_seq_guia_proc_w, null, nr_seq_ocor_combinada_p, nm_usuario_p, null, nr_seq_motivo_glosa_p, 1, cd_estabelecimento_p, 'N', null, nr_seq_oc_benef_w, null, null, null, null);
 
				CALL pls_atualizar_status_ocor_comb(	nr_seq_ocorrencia_p, nr_seq_ocor_combinada_p, nr_seq_motivo_glosa_p, 
								nr_seq_guia_p, nr_seq_requisicao_p, nr_seq_execucao_p, 
								nr_seq_guia_proc_w, null, null, 
								null, null, null, 
								nm_usuario_p, cd_estabelecimento_p);
			end if;
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
			ie_mat_proc_inativo_w := pls_obter_se_mat_inativo(nr_seq_material_w,dt_autorizacao_w);
 
			ie_gerar_ocorrencia_w	:= 'S';
 
			if (ie_utiliza_filtro_p	= 'S') then 
				SELECT * FROM pls_gerar_ocor_aut_filtro(	nr_seq_ocor_combinada_p, nr_seq_guia_p, nr_seq_requisicao_p, nr_seq_execucao_p, null, nr_seq_guia_mat_w, null, null, null, null, null, nr_seq_material_w, null, null, nr_seq_ocorrencia_p, null, null, null, nm_usuario_p, ie_regra_w, ie_tipo_ocorrencia_w) INTO STRICT ie_regra_w, ie_tipo_ocorrencia_w;
 
				if (ie_regra_w	= 'S') then 
					ie_gerar_ocorrencia_w	:= 'S';
				elsif (ie_regra_w	in ('E','N')) then 
					ie_gerar_ocorrencia_w	:= 'N';
				end if;
			end if;
 
			if (ie_gerar_ocorrencia_w	= 'S') and (ie_mat_proc_inativo_w = 'N') then 
				nr_seq_oc_benef_w := pls_inserir_ocorrencia(	nr_seq_segurado_p, nr_seq_ocorrencia_p, null, nr_seq_guia_p, null, null, nr_seq_guia_mat_w, nr_seq_ocor_combinada_p, nm_usuario_p, null, nr_seq_motivo_glosa_p, 2, cd_estabelecimento_p, 'N', null, nr_seq_oc_benef_w, null, null, null, null);
 
				CALL pls_atualizar_status_ocor_comb(	nr_seq_ocorrencia_p, nr_seq_ocor_combinada_p, nr_seq_motivo_glosa_p, 
								nr_seq_guia_p, nr_seq_requisicao_p, nr_seq_execucao_p, 
								null, nr_seq_guia_mat_w, null, 
								null, null, null, 
								nm_usuario_p, cd_estabelecimento_p);
			end if;
			end;
		end loop;
		close C02;
 
	elsif (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then 
		begin 
			select	dt_requisicao 
			into STRICT	dt_requisicao_w 
			from	pls_requisicao 
			where	nr_sequencia = 	nr_seq_requisicao_p;
		exception 
		when others then 
			dt_requisicao_w := clock_timestamp();
		end;
 
		open C03;
		loop 
		fetch C03 into 
			nr_seq_req_proc_w, 
			cd_procedimento_w, 
			ie_origem_proced_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin 
			ie_mat_proc_inativo_w := pls_obter_se_proc_inativo(cd_procedimento_w,ie_origem_proced_w,dt_requisicao_w);
 
			ie_gerar_ocorrencia_w	:= 'S';
 
			if (ie_utiliza_filtro_p	= 'S') then 
				SELECT * FROM pls_gerar_ocor_aut_filtro(	nr_seq_ocor_combinada_p, nr_seq_guia_p, nr_seq_requisicao_p, nr_seq_execucao_p, null, null, nr_seq_req_proc_w, null, null, cd_procedimento_w, ie_origem_proced_w, null, null, null, nr_seq_ocorrencia_p, null, null, null, nm_usuario_p, ie_regra_w, ie_tipo_ocorrencia_w) INTO STRICT ie_regra_w, ie_tipo_ocorrencia_w;
 
				if (ie_regra_w	= 'S') then 
					ie_gerar_ocorrencia_w	:= 'S';
				elsif (ie_regra_w	in ('E','N')) then 
					ie_gerar_ocorrencia_w	:= 'N';
				end if;
			end if;
 
			if (ie_gerar_ocorrencia_w	= 'S') and (ie_mat_proc_inativo_w = 'N') then 
				nr_seq_oc_benef_w := pls_inserir_ocorrencia(	nr_seq_segurado_p, nr_seq_ocorrencia_p, nr_seq_requisicao_p, null, null, nr_seq_req_proc_w, null, nr_seq_ocor_combinada_p, nm_usuario_p, null, nr_seq_motivo_glosa_p, 5, cd_estabelecimento_p, 'N', null, nr_seq_oc_benef_w, null, null, null, null);
 
				CALL pls_atualizar_status_ocor_comb(	nr_seq_ocorrencia_p, nr_seq_ocor_combinada_p, nr_seq_motivo_glosa_p, 
								nr_seq_guia_p, nr_seq_requisicao_p, nr_seq_execucao_p, 
								null, null, nr_seq_req_proc_w, 
								null, null, null, 
								nm_usuario_p, cd_estabelecimento_p);
			end if;
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
			ie_mat_proc_inativo_w := pls_obter_se_mat_inativo(nr_seq_material_w,dt_requisicao_w);
 
			ie_gerar_ocorrencia_w	:= 'S';
 
			if (ie_utiliza_filtro_p	= 'S') then 
				SELECT * FROM pls_gerar_ocor_aut_filtro(	nr_seq_ocor_combinada_p, nr_seq_guia_p, nr_seq_requisicao_p, nr_seq_execucao_p, null, null, null, nr_seq_req_mat_w, null, null, null, nr_seq_material_w, null, null, nr_seq_ocorrencia_p, null, null, null, nm_usuario_p, ie_regra_w, ie_tipo_ocorrencia_w) INTO STRICT ie_regra_w, ie_tipo_ocorrencia_w;
 
				if (ie_regra_w	= 'S') then 
					ie_gerar_ocorrencia_w	:= 'S';
				elsif (ie_regra_w	in ('E','N')) then 
					ie_gerar_ocorrencia_w	:= 'N';
				end if;
			end if;
 
			if (ie_gerar_ocorrencia_w	= 'S') and (ie_mat_proc_inativo_w = 'N') then 
				nr_seq_oc_benef_w := pls_inserir_ocorrencia(	nr_seq_segurado_p, nr_seq_ocorrencia_p, nr_seq_requisicao_p, null, null, null, nr_seq_req_mat_w, nr_seq_ocor_combinada_p, nm_usuario_p, null, nr_seq_motivo_glosa_p, 6, cd_estabelecimento_p, 'N', null, nr_seq_oc_benef_w, null, null, null, null);
 
				CALL pls_atualizar_status_ocor_comb(	nr_seq_ocorrencia_p, nr_seq_ocor_combinada_p, nr_seq_motivo_glosa_p, 
								nr_seq_guia_p, nr_seq_requisicao_p, nr_seq_execucao_p, 
								null, null, null, 
								nr_seq_req_mat_w, null, null, 
								nm_usuario_p, cd_estabelecimento_p);
			end if;
			end;
		end loop;
		close C04;
 
	elsif (nr_seq_execucao_p IS NOT NULL AND nr_seq_execucao_p::text <> '') then 
		begin 
			select	dt_execucao 
			into STRICT	dt_execucao_w 
			from	pls_execucao_requisicao 
			where	nr_sequencia = 	nr_seq_execucao_p;
		exception 
		when others then 
			dt_execucao_w := clock_timestamp();
		end;
 
		open C05;
		loop 
		fetch C05 into 
			nr_seq_exec_item_w, 
			cd_procedimento_w, 
			ie_origem_proced_w;
		EXIT WHEN NOT FOUND; /* apply on C05 */
			begin 
			ie_mat_proc_inativo_w := pls_obter_se_proc_inativo(cd_procedimento_w,ie_origem_proced_w,dt_execucao_w);
 
			ie_gerar_ocorrencia_w	:= 'S';
 
			if (ie_utiliza_filtro_p	= 'S') then 
				SELECT * FROM pls_gerar_ocor_aut_filtro(	nr_seq_ocor_combinada_p, nr_seq_guia_p, nr_seq_requisicao_p, nr_seq_execucao_p, null, null, null, null, nr_seq_exec_item_w, cd_procedimento_w, ie_origem_proced_w, null, null, null, nr_seq_ocorrencia_p, null, null, null, nm_usuario_p, ie_regra_w, ie_tipo_ocorrencia_w) INTO STRICT ie_regra_w, ie_tipo_ocorrencia_w;
 
				if (ie_regra_w	= 'S') then 
					ie_gerar_ocorrencia_w	:= 'S';
				elsif (ie_regra_w	in ('E','N')) then 
					ie_gerar_ocorrencia_w	:= 'N';
				end if;
			end if;
 
			if (ie_gerar_ocorrencia_w	= 'S') and (ie_mat_proc_inativo_w = 'N') then 
				nr_seq_oc_benef_w := pls_inserir_ocorrencia(	nr_seq_segurado_p, nr_seq_ocorrencia_p, nr_seq_requisicao_p, null, null, nr_seq_exec_item_w, null, nr_seq_ocor_combinada_p, nm_usuario_p, null, nr_seq_motivo_glosa_p, 10, cd_estabelecimento_p, 'N', nr_seq_execucao_p, nr_seq_oc_benef_w, null, null, null, null);
 
				CALL pls_atualizar_status_ocor_comb(	nr_seq_ocorrencia_p, nr_seq_ocor_combinada_p, nr_seq_motivo_glosa_p, 
								nr_seq_guia_p, nr_seq_requisicao_p, nr_seq_execucao_p, 
								null, null, null, 
								null, nr_seq_exec_item_w, null, 
								nm_usuario_p, cd_estabelecimento_p);
			end if;
			end;
		end loop;
		close C05;
 
		open C06;
		loop 
		fetch C06 into 
			nr_seq_exec_item_w, 
			nr_seq_material_w;
		EXIT WHEN NOT FOUND; /* apply on C06 */
			begin 
			ie_mat_proc_inativo_w := pls_obter_se_mat_inativo(nr_seq_material_w,dt_execucao_w);
 
			ie_gerar_ocorrencia_w	:= 'S';
 
			if (ie_utiliza_filtro_p	= 'S') then 
				SELECT * FROM pls_gerar_ocor_aut_filtro(	nr_seq_ocor_combinada_p, nr_seq_guia_p, nr_seq_requisicao_p, nr_seq_execucao_p, null, null, null, null, nr_seq_exec_item_w, null, null, nr_seq_material_w, null, null, nr_seq_ocorrencia_p, null, null, null, nm_usuario_p, ie_regra_w, ie_tipo_ocorrencia_w) INTO STRICT ie_regra_w, ie_tipo_ocorrencia_w;
 
				if (ie_regra_w	= 'S') then 
					ie_gerar_ocorrencia_w	:= 'S';
				elsif (ie_regra_w	in ('E','N')) then 
					ie_gerar_ocorrencia_w	:= 'N';
				end if;
			end if;
 
			if (ie_gerar_ocorrencia_w	= 'S') and (ie_mat_proc_inativo_w = 'N') then 
				nr_seq_oc_benef_w := pls_inserir_ocorrencia(	nr_seq_segurado_p, nr_seq_ocorrencia_p, nr_seq_requisicao_p, null, null, null, nr_seq_exec_item_w, nr_seq_ocor_combinada_p, nm_usuario_p, null, nr_seq_motivo_glosa_p, 11, cd_estabelecimento_p, 'N', nr_seq_execucao_p, nr_seq_oc_benef_w, null, null, null, null);
 
				CALL pls_atualizar_status_ocor_comb(	nr_seq_ocorrencia_p, nr_seq_ocor_combinada_p, nr_seq_motivo_glosa_p, 
								nr_seq_guia_p, nr_seq_requisicao_p, nr_seq_execucao_p, 
								null, null, null, 
								null, null, nr_seq_exec_item_w, 
								nm_usuario_p, cd_estabelecimento_p);
			end if;
			end;
		end loop;
		close C06;
	end if;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_valida_ocor_aut_vig_item ( nr_seq_ocor_combinada_p bigint, nr_seq_ocorrencia_p bigint, nr_seq_segurado_p bigint, nr_seq_motivo_glosa_p bigint, nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, nr_seq_execucao_p bigint, ie_utiliza_filtro_p text, nr_seq_param1_p bigint, nr_seq_param2_p bigint, nr_seq_param3_p bigint, nr_seq_param4_p bigint, nr_seq_param5_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

