-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--O Parametro nr_seq_regra_especifica_p apenas a passado quando se deseja verificar se uma detemirminada regra a valida para uma conta. Caso deseja obter uma regra deve

--ser passado nulo para esse parametro



CREATE OR REPLACE FUNCTION pls_conversao_itens_pck.obter_seq_regra_conv ( dt_atendimento_p pls_conta.dt_atendimento%type, nr_seq_contrato_p pls_contrato.nr_sequencia%type, nr_seq_intercambio_p pls_segurado.nr_seq_intercambio%type, nr_seq_prestador_prot_p pls_protocolo_conta.nr_seq_prestador%type, nr_seq_congenere_seg_p pls_segurado.nr_seq_congenere%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_procedimento_p procedimento.cd_procedimento%type, ie_origem_proced_p procedimento.ie_origem_proced%type, nr_seq_regra_especifica_p pls_conv_item_fat.nr_sequencia%type) RETURNS bigint AS $body$
DECLARE


nr_seq_regra_w 		pls_conv_item_fat.nr_sequencia%type;
ie_nao_lanca_w		boolean     := false;
qt_registros_w		integer := 0;
				
--Regras de conversao de itens pas.	

c_regra CURSOR(dt_atendimento_referencia_pc		pls_conta.dt_atendimento_referencia%type,
		nr_seq_contrato_pc			pls_contrato.nr_sequencia%type,
		nr_seq_intercambio_pc			pls_intercambio.nr_sequencia%type,
		nr_seq_prestador_prot_pc		pls_conta_v.nr_seq_prestador_prot%type,
		nr_seq_congenere_pc			pls_conta_v.nr_seq_congenere_seg%type) FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_grupo_prestador,
		a.nr_seq_grupo_operadora,
		a.ie_considera_todos_itens,
		(pls_obter_se_prestador_grupo(a.nr_seq_grupo_prestador, nr_seq_prestador_prot_pc)) ie_grupo_prest,
		(pls_se_grupo_preco_operadora(a.nr_seq_grupo_operadora, nr_seq_congenere_pc)) ie_grupo_preco_operadora,
		(SELECT count(1)
		from	pls_conv_item_princ b
		where 	b.nr_seq_regra = a.nr_sequencia) qt_itens,
		(select	count(1)
		 from	pls_conv_item_fat_exce x
		 where	x.nr_seq_regra = a.nr_sequencia) qt_regra_excecao
	from	pls_conv_item_fat a
	where	dt_atendimento_referencia_pc between dt_inicio_vigencia_ref and dt_fim_vigencia_ref
	and	((coalesce(a.nr_seq_contrato::text, '') = '') or (a.nr_seq_contrato = nr_seq_contrato_pc))
	and	((coalesce(a.nr_seq_intercambio::text, '') = '') or (a.nr_seq_intercambio = nr_seq_intercambio_pc))
	and	((a.nr_sequencia = nr_seq_regra_especifica_p) or (coalesce(nr_seq_regra_especifica_p::text, '') = ''))
	order by 
		qt_itens desc,
		nr_seq_contrato,
		nr_seq_intercambio,
		nr_seq_grupo_prestador,
		nr_seq_grupo_operadora;
		
--Cursor de procedimentos na conta(Item principal da regra)				

c_item_princ CURSOR( 	nr_seq_analise_pc	pls_conta.nr_seq_analise%type,
			nr_seq_regra_pc		pls_conv_item_fat.nr_sequencia%type,
			cd_procedimento_pc	procedimento.cd_procedimento%type,
			ie_origem_proced_pc	procedimento.ie_origem_proced%type) FOR
	SELECT	a.cd_procedimento,
		a.ie_origem_proced,
		a.ie_desc_grau_anest,
		a.nr_seq_regra,
		a.nr_seq_grupo_material
	from	pls_conv_item_princ	a
	where	a.nr_seq_regra		= nr_seq_regra_pc
	and	(nr_seq_regra_especifica_p IS NOT NULL AND nr_seq_regra_especifica_p::text <> '')
	and	exists (SELECT	1
			from	pls_conta_proc_v	x
			where	x.nr_seq_analise	= nr_seq_analise_pc
			and	x.ie_status		in ('L','S')
			and	x.cd_procedimento	= a.cd_procedimento
			and	x.ie_origem_proced	= a.ie_origem_proced)
	
union all

		select	a.cd_procedimento,
		a.ie_origem_proced,
		a.ie_desc_grau_anest,
		a.nr_seq_regra,
		a.nr_seq_grupo_material
	from	pls_conv_item_princ	a
	where	a.nr_seq_regra		= nr_seq_regra_pc 
	and	coalesce(nr_seq_regra_especifica_p::text, '') = ''
	and	exists (select	1
			from	pls_conta_proc_v	x
			where	x.nr_seq_analise	= nr_seq_analise_pc
			and	x.ie_status		in ('L','S')
			and	x.cd_procedimento	= a.cd_procedimento
			and	coalesce(x.nr_seq_regra_conv::text, '') = ''
			and	x.ie_origem_proced	= a.ie_origem_proced);	
		
c_excecao CURSOR(nr_seq_regra_pc	pls_conv_item_fat.nr_sequencia%type) FOR
	SELECT	nr_seq_grupo_prestador,
		nr_seq_grupo_operadora
	from	pls_conv_item_fat_exce
	where	nr_seq_regra	= nr_seq_regra_pc;

c_grupo_mat CURSOR(nr_seq_grupo_material_pc	pls_preco_material.nr_seq_grupo%type) FOR
	SELECT	nr_seq_material
	from	pls_preco_material
	where	nr_seq_grupo = nr_seq_grupo_material_pc
	and	(nr_seq_material IS NOT NULL AND nr_seq_material::text <> '');				

--Cursor para verificar validaaao de todos os itens da regra.		

C06 CURSOR(	nr_seq_analise_pc	pls_conta.nr_seq_analise%type,
			nr_seq_regra_pc		pls_conv_item_fat.nr_sequencia%type) FOR
	SELECT (SELECT	count(1)
		 from	pls_conta_proc_v	x
		 where	x.nr_seq_analise	= nr_seq_analise_pc
		 and	x.ie_status		in ('L','S')
		 and	x.cd_procedimento	= a.cd_procedimento
		 and	x.ie_origem_proced	= a.ie_origem_proced) qt_itens_regra,
		a.cd_procedimento
	from	pls_conv_item_princ a
	where	a.nr_seq_regra		= nr_seq_regra_pc;			

BEGIN
		
	for r_regra in c_regra(dt_atendimento_p, nr_seq_contrato_p, nr_seq_intercambio_p,
				nr_seq_prestador_prot_p, nr_seq_congenere_seg_p) loop
							
		nr_seq_regra_w := r_regra.nr_sequencia;					
				
		--Inicialmente nao ha para impedir o lanaamento do item, entao a variavel de controle de nao lanaamento inicial como false.

		ie_nao_lanca_w	:= false;
	
		if (r_regra.nr_seq_grupo_prestador IS NOT NULL AND r_regra.nr_seq_grupo_prestador::text <> '') and (r_regra.ie_grupo_prest = 'N') then
			ie_nao_lanca_w := true;
		end if;
		
		if (r_regra.nr_seq_grupo_operadora IS NOT NULL AND r_regra.nr_seq_grupo_operadora::text <> '') and ( r_regra.ie_grupo_preco_operadora = 'N') then
			ie_nao_lanca_w := true;
		end if;
		
		--Se regra ainda esta valida, entao prossegue.

		if (not ie_nao_lanca_w) then
		
			if (r_regra.ie_considera_todos_itens = 'S') then			
				for r_C06 in C06( nr_seq_analise_p, r_regra.nr_sequencia) loop
				
					if (r_C06.qt_itens_regra = 0) then
						ie_nao_lanca_w := true;
						exit;
					end if;
				end loop;
				if (C06%ISOPEN) then
					close C06;
				end if;
			end if;
		
			--Se regra ainda esta valida, entao prossegue.

			if (not ie_nao_lanca_w) then
				
				--Verifica regras de exceaao da regra atual.

				if (r_regra.qt_regra_excecao > 0) then
					for r_excecao in c_excecao(r_regra.nr_sequencia) loop
					
						if (r_excecao.nr_seq_grupo_operadora IS NOT NULL AND r_excecao.nr_seq_grupo_operadora::text <> '') then
							if (pls_se_grupo_preco_operadora(r_excecao.nr_seq_grupo_operadora, nr_seq_congenere_seg_p) = 'S') then
								ie_nao_lanca_w	:= true;
								exit;
							end if;
						end if;
						
						if (r_excecao.nr_seq_grupo_prestador IS NOT NULL AND r_excecao.nr_seq_grupo_prestador::text <> '') then				
							if (pls_obter_se_prestador_grupo(r_excecao.nr_seq_grupo_prestador, nr_seq_prestador_prot_p) = 'S') then
								ie_nao_lanca_w	:= true;
								exit;
							end if;				
						end if;
					end loop;
					
					if (c_excecao%ISOPEN) then
						close c_excecao;
					end if;	
				end if;
				
				if (not ie_nao_lanca_w) then
					--Inicia marcando como regra invalida, ata achar ao menos um registro valido(Se entrar no praximo loop for isso ocorre)

					ie_nao_lanca_w := true;
					--Percorre o cursor de itens na conta(Item principal da regra).

					for r_item_princ in c_item_princ(nr_seq_analise_p, r_regra.nr_sequencia , cd_procedimento_p,
									ie_origem_proced_p) loop
					
						--Como encontrou ao menos um registro apto, entao marca como regra valida ata esse momento

						ie_nao_lanca_w := false;
						--Se tiver grupo de material informado

						
						if (r_item_princ.nr_seq_grupo_material IS NOT NULL AND r_item_princ.nr_seq_grupo_material::text <> '') then
							
							ie_nao_lanca_w	:= true;							
							--Percorre as sequencias de materiais do grupo informado. Se algum dos materiais do grupo nao estiver presente 

							-- na conta, entao regra nao sera valida

							for r_grupo_mat in c_grupo_mat(r_item_princ.nr_seq_grupo_material) loop
								
								select	count(1)
								into STRICT	qt_registros_w
								from	pls_conta_mat_v		x
								where	x.nr_seq_analise	= nr_seq_analise_p
								and	x.ie_status		in ('L','S')
								and	x.nr_seq_material	= r_grupo_mat.nr_seq_material;
								
								if (qt_registros_w > 0) then
									ie_nao_lanca_w	:= false;
									exit;
								end if;
							end loop;
							
							if (c_grupo_mat%ISOPEN) then
								close c_grupo_mat;
							end if;	
						end if;
					end loop;
				end if;
			end if;
		end if;
		
		if (not ie_nao_lanca_w) then
			exit;
		end if;
	end loop;
	
	if ( ie_nao_lanca_w ) then
		return null;
	else
		return nr_seq_regra_w;
	end if;
	
end;
									

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_conversao_itens_pck.obter_seq_regra_conv ( dt_atendimento_p pls_conta.dt_atendimento%type, nr_seq_contrato_p pls_contrato.nr_sequencia%type, nr_seq_intercambio_p pls_segurado.nr_seq_intercambio%type, nr_seq_prestador_prot_p pls_protocolo_conta.nr_seq_prestador%type, nr_seq_congenere_seg_p pls_segurado.nr_seq_congenere%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_procedimento_p procedimento.cd_procedimento%type, ie_origem_proced_p procedimento.ie_origem_proced%type, nr_seq_regra_especifica_p pls_conv_item_fat.nr_sequencia%type) FROM PUBLIC;