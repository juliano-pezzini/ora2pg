-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_tipo_anexo_item ( nr_seq_proc_req_p pls_requisicao_proc.nr_sequencia%type, nr_seq_mat_req_p pls_requisicao_mat.nr_sequencia%type, nr_seq_proc_aut_p pls_guia_plano_proc.nr_sequencia%type, nr_seq_mat_aut_p pls_guia_plano_mat.nr_sequencia%type, cd_procedimento_p procedimento.cd_procedimento%type, ie_origem_proced_p procedimento.ie_origem_proced%type, nr_seq_material_p pls_material.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Atualizar o tipo de anexo no procedimento e material, conforme regra 
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_tipo_anexo_w			pls_regra_anexo_guia.ie_tipo_anexo%type;
ie_tipo_atend_tiss_w		pls_regra_anexo_guia_itens.ie_tipo_atend_tiss%type;
ie_tipo_atendimento_w		varchar(2);



BEGIN

--Se for lancamento de material busca primeiramente a regra somente para o material. 

--Se for procedimento verifica as regras de procedimentos
if (nr_seq_material_p IS NOT NULL AND nr_seq_material_p::text <> '') then
	
	begin
		with query_tmp as (
			select *
			from (	select 	a.ie_tipo_anexo,	
					b.ie_tipo_atend_tiss,
					b.nr_sequencia,
					1 ie_ordem
				from	pls_regra_anexo_guia a,
					pls_regra_anexo_guia_itens b
				where	b.nr_seq_regra_anexo_guia = a.nr_sequencia
				and	a.dt_inicio_vigencia <= trunc(clock_timestamp())
				and (coalesce(a.dt_fim_vigencia::text, '') = '' or a.dt_fim_vigencia > trunc(clock_timestamp()))
				and	b.ie_situacao = 'A'
				and	coalesce(b.cd_procedimento::text, '') = ''
				and	b.nr_seq_material = nr_seq_material_p
				and	coalesce(b.nr_seq_estrut_mat::text, '') = ''
				and (coalesce(a.cd_estabelecimento, wheb_usuario_pck.get_cd_estabelecimento) = wheb_usuario_pck.get_cd_estabelecimento and pls_obter_se_controle_estab('RE') = 'S')
				
union all

				select 	a.ie_tipo_anexo,	
					b.ie_tipo_atend_tiss,
					b.nr_sequencia,
					1 ie_ordem
				from	pls_regra_anexo_guia a,
					pls_regra_anexo_guia_itens b
				where	b.nr_seq_regra_anexo_guia = a.nr_sequencia
				and	a.dt_inicio_vigencia <= trunc(clock_timestamp())
				and (coalesce(a.dt_fim_vigencia::text, '') = '' or a.dt_fim_vigencia > trunc(clock_timestamp()))
				and	b.ie_situacao = 'A'
				and	coalesce(b.cd_procedimento::text, '') = ''
				and	b.nr_seq_material = nr_seq_material_p
				and	coalesce(b.nr_seq_estrut_mat::text, '') = ''
				and (pls_obter_se_controle_estab('RE') = 'N')
				
union all
	
				select 	a.ie_tipo_anexo,
					b.ie_tipo_atend_tiss,
					b.nr_sequencia,
					2 ie_ordem			
				from	pls_regra_anexo_guia a,
					pls_regra_anexo_guia_itens b
				where	b.nr_seq_regra_anexo_guia = a.nr_sequencia
				and	a.dt_inicio_vigencia <= trunc(clock_timestamp())
				and (coalesce(a.dt_fim_vigencia::text, '') = '' or a.dt_fim_vigencia > trunc(clock_timestamp()))
				and	b.ie_situacao = 'A'
				and	coalesce(b.cd_procedimento::text, '') = ''
				and	coalesce(b.nr_seq_material::text, '') = ''
				and (coalesce(a.cd_estabelecimento, wheb_usuario_pck.get_cd_estabelecimento) = wheb_usuario_pck.get_cd_estabelecimento and pls_obter_se_controle_estab('RE') = 'S')
				and	exists ( select 1
						 from pls_estrutura_material_v es
						 where es.nr_seq_estrutura  = b.nr_seq_estrut_mat
						 and	es.nr_seq_material  = nr_seq_material_p)
				
union all

				select 	a.ie_tipo_anexo,
					b.ie_tipo_atend_tiss,
					b.nr_sequencia,
					2 ie_ordem			
				from	pls_regra_anexo_guia a,
					pls_regra_anexo_guia_itens b
				where	b.nr_seq_regra_anexo_guia = a.nr_sequencia
				and	a.dt_inicio_vigencia <= trunc(clock_timestamp())
				and (coalesce(a.dt_fim_vigencia::text, '') = '' or a.dt_fim_vigencia > trunc(clock_timestamp()))
				and	b.ie_situacao = 'A'
				and	coalesce(b.cd_procedimento::text, '') = ''
				and	coalesce(b.nr_seq_material::text, '') = ''
				and (pls_obter_se_controle_estab('RE') = 'N')
				and	exists ( select 1
						 from pls_estrutura_material_v es
						 where es.nr_seq_estrutura  = b.nr_seq_estrut_mat
						 and	es.nr_seq_material  = nr_seq_material_p)) alias45
			order by ie_ordem, nr_sequencia desc
		)
		select	ie_tipo_anexo,
			ie_tipo_atend_tiss
		into STRICT	ie_tipo_anexo_w,
			ie_tipo_atend_tiss_w
		from	query_tmp LIMIT 1;	
	exception
	when others then
		ie_tipo_anexo_w := null;
	end;
	
else
	begin
		with query_tmp as (
			select 	*
			from (
				select 	a.ie_tipo_anexo ie_tipo_anexo,
					b.nr_sequencia nr_sequencia,
					b.ie_tipo_atend_tiss
				from	pls_regra_anexo_guia a,
					pls_regra_anexo_guia_itens b
				where	b.nr_seq_regra_anexo_guia = a.nr_sequencia
				and	a.dt_inicio_vigencia <= trunc(clock_timestamp())
				and (coalesce(a.dt_fim_vigencia::text, '') = '' or a.dt_fim_vigencia > trunc(clock_timestamp()))
				and	b.ie_situacao = 'A'
				and	coalesce(b.nr_seq_material::text, '') = ''
				and	b.cd_procedimento  = cd_procedimento_p
				and	b.ie_origem_proced = ie_origem_proced_p
				and (coalesce(a.cd_estabelecimento, wheb_usuario_pck.get_cd_estabelecimento) = wheb_usuario_pck.get_cd_estabelecimento and pls_obter_se_controle_estab('RE') = 'S')
				
union all

				select 	a.ie_tipo_anexo ie_tipo_anexo,
					b.nr_sequencia nr_sequencia,
					b.ie_tipo_atend_tiss
				from	pls_regra_anexo_guia a,
					pls_regra_anexo_guia_itens b
				where	b.nr_seq_regra_anexo_guia = a.nr_sequencia
				and	a.dt_inicio_vigencia <= trunc(clock_timestamp())
				and (coalesce(a.dt_fim_vigencia::text, '') = '' or a.dt_fim_vigencia > trunc(clock_timestamp()))
				and	b.ie_situacao = 'A'
				and	coalesce(b.nr_seq_material::text, '') = ''
				and	b.cd_procedimento  = cd_procedimento_p
				and	b.ie_origem_proced = ie_origem_proced_p
				and (pls_obter_se_controle_estab('RE') = 'N')) alias19
			order by nr_sequencia desc
		)
		select	ie_tipo_anexo,
			ie_tipo_atend_tiss
		into STRICT	ie_tipo_anexo_w,
			ie_tipo_atend_tiss_w
		from	query_tmp LIMIT 1;
	exception
	when others then
		ie_tipo_anexo_w := null;
	end;	
end if;

--Se o anexo estiver sendo lancado no Procedimento da  Autorizacao
if (nr_seq_proc_aut_p IS NOT NULL AND nr_seq_proc_aut_p::text <> '') then
	
	if (ie_tipo_atend_tiss_w IS NOT NULL AND ie_tipo_atend_tiss_w::text <> '') then
		select	ie_tipo_atend_tiss
		into STRICT	ie_tipo_atendimento_w
		from	pls_guia_plano	a,
			pls_guia_plano_proc b
		where	b.nr_sequencia = nr_seq_proc_aut_p
		and	a.nr_sequencia = b.nr_seq_guia;
		
		if (ie_tipo_atendimento_w = ie_tipo_atend_tiss_w) then
		
			update	pls_guia_plano_proc
			set	dt_atualizacao 	= clock_timestamp(),
				nm_usuario	= nm_usuario_p,
				ie_tipo_anexo	= ie_tipo_anexo_w
			where	nr_sequencia	= nr_seq_proc_aut_p;	
		end if;
		
	else
		update	pls_guia_plano_proc
		set	dt_atualizacao 	= clock_timestamp(),
			nm_usuario	= nm_usuario_p,
			ie_tipo_anexo	= ie_tipo_anexo_w
		where	nr_sequencia	= nr_seq_proc_aut_p;	
	end if;
	
--Se o anexo estiver sendo lancado no Material da  Autorizacao
elsif (nr_seq_mat_aut_p IS NOT NULL AND nr_seq_mat_aut_p::text <> '') then
	
	if (ie_tipo_atend_tiss_w IS NOT NULL AND ie_tipo_atend_tiss_w::text <> '') then
		select	ie_tipo_atend_tiss
		into STRICT	ie_tipo_atendimento_w
		from	pls_guia_plano	a,
			pls_guia_plano_mat b
		where	b.nr_sequencia = nr_seq_mat_aut_p
		and	a.nr_sequencia = b.nr_seq_guia;
		
		if (ie_tipo_atendimento_w = ie_tipo_atend_tiss_w) then
		
			update	pls_guia_plano_mat
			set	dt_atualizacao 	= clock_timestamp(),
				nm_usuario	= nm_usuario_p,
				ie_tipo_anexo	= ie_tipo_anexo_w
			where	nr_sequencia	= nr_seq_mat_aut_p;
			
		end if;
		
	else		
		update	pls_guia_plano_mat
		set	dt_atualizacao 	= clock_timestamp(),
			nm_usuario	= nm_usuario_p,
			ie_tipo_anexo	= ie_tipo_anexo_w
		where	nr_sequencia	= nr_seq_mat_aut_p;
	end if;
	
--Se o anexo estiver sendo lancado no Procedimento da  Requisicao
elsif (nr_seq_proc_req_p IS NOT NULL AND nr_seq_proc_req_p::text <> '') then	
		
	if (ie_tipo_atend_tiss_w IS NOT NULL AND ie_tipo_atend_tiss_w::text <> '') then
		select	ie_tipo_atendimento
		into STRICT	ie_tipo_atendimento_w
		from	pls_requisicao	a,
			pls_requisicao_proc b
		where	b.nr_sequencia = nr_seq_proc_req_p
		and	a.nr_sequencia = b.nr_seq_requisicao;
		
		if (ie_tipo_atendimento_w = ie_tipo_atend_tiss_w) then		
			update	pls_requisicao_proc
			set	dt_atualizacao 	= clock_timestamp(),
				nm_usuario	= nm_usuario_p,
				ie_tipo_anexo	= ie_tipo_anexo_w
			where	nr_sequencia	= nr_seq_proc_req_p;
		end if;
		
	else
		update	pls_requisicao_proc
		set	dt_atualizacao 	= clock_timestamp(),
			nm_usuario	= nm_usuario_p,
			ie_tipo_anexo	= ie_tipo_anexo_w
		where	nr_sequencia	= nr_seq_proc_req_p;
	end if;

--Se o anexo estiver sendo lancado no Material da  Requisicao
elsif (nr_seq_mat_req_p IS NOT NULL AND nr_seq_mat_req_p::text <> '') then	
	
	if (ie_tipo_atend_tiss_w IS NOT NULL AND ie_tipo_atend_tiss_w::text <> '') then
		select	ie_tipo_atendimento
		into STRICT	ie_tipo_atendimento_w
		from	pls_requisicao	a,
			pls_requisicao_mat b
		where	b.nr_sequencia = nr_seq_mat_req_p
		and	a.nr_sequencia = b.nr_seq_requisicao;
		
		if (ie_tipo_atendimento_w = ie_tipo_atend_tiss_w) then		
			update	pls_requisicao_mat
			set	dt_atualizacao 	= clock_timestamp(),
				nm_usuario	= nm_usuario_p,
				ie_tipo_anexo	= ie_tipo_anexo_w
			where	nr_sequencia	= nr_seq_mat_req_p;
		end if;
		
	else		
		update	pls_requisicao_mat
		set	dt_atualizacao 	= clock_timestamp(),
			nm_usuario	= nm_usuario_p,
			ie_tipo_anexo	= ie_tipo_anexo_w
		where	nr_sequencia	= nr_seq_mat_req_p;
	end if;
	
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_tipo_anexo_item ( nr_seq_proc_req_p pls_requisicao_proc.nr_sequencia%type, nr_seq_mat_req_p pls_requisicao_mat.nr_sequencia%type, nr_seq_proc_aut_p pls_guia_plano_proc.nr_sequencia%type, nr_seq_mat_aut_p pls_guia_plano_mat.nr_sequencia%type, cd_procedimento_p procedimento.cd_procedimento%type, ie_origem_proced_p procedimento.ie_origem_proced%type, nr_seq_material_p pls_material.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
