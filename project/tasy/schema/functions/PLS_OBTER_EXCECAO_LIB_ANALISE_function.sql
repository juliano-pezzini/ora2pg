-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_excecao_lib_analise ( nr_seq_conta_p bigint, nr_seq_conta_proc_p bigint, nr_seq_regra_p bigint, dados_regra_lib_analise_p pls_cta_valorizacao_pck.dados_regra_lib_analise, nr_seq_analise_p pls_analise_conta.nr_sequencia%type) RETURNS bigint AS $body$
DECLARE

			
nr_retorno_w			bigint := 0;
nr_seq_regra_w			bigint;
nr_seq_ocorrencia_w		bigint;
nr_seq_ocorrencia_benef_w	bigint;
nr_seq_estrut_regra_w		bigint;
ie_estrut_mat_w			varchar(1);
ie_grupo_operadora_w	varchar(1);
nr_seq_grupo_prestador_w	bigint;
ie_grupo_prestador_w		varchar(1);
nr_seq_classif_w		pls_excecao_lib_analise.nr_seq_classif%type;
qt_ocor_classif_w		integer;
ie_continua_regra_w		boolean;
qt_itens_w			integer;
nr_seq_grupo_material_w		pls_excecao_lib_analise.nr_seq_grupo_material%type;
nr_seq_grupo_servico_w		pls_excecao_lib_analise.nr_seq_grupo_servico%type;
nr_seq_grupo_operadora_w	pls_excecao_lib_analise.nr_seq_grupo_operadora%type;
ie_grupo_material_w		varchar(1);


C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_ocorrencia,
		a.nr_seq_estrutura_mat,
		a.nr_seq_grupo_prestador,
		a.nr_seq_classif,
		a.nr_seq_grupo_material,
		a.nr_seq_grupo_servico,
		a.nr_seq_grupo_operadora
	from	pls_excecao_lib_analise	a
	where	a.nr_seq_regra 	= nr_seq_regra_p
	and	ie_situacao 	= 'A'
	and	((coalesce(a.nr_seq_grupo_rec::text, '') = '')	or (a.nr_seq_grupo_rec		= dados_regra_lib_analise_p.nr_seq_grupo_rec))
	and	((coalesce(a.nr_seq_contrato::text, '') = '')	or (a.nr_seq_contrato		= dados_regra_lib_analise_p.nr_seq_contrato))
	and	((coalesce(a.ie_tipo_guia::text, '') = '')	or (a.ie_tipo_guia 		= dados_regra_lib_analise_p.ie_tipo_guia))
	and	((coalesce(a.cd_prestador_exec::text, '') = '')	or (a.cd_prestador_exec		= dados_regra_lib_analise_p.cd_prestador_exec))
	and	((coalesce(a.cd_prestador_prot::text, '') = '')	or (a.cd_prestador_prot		= dados_regra_lib_analise_p.cd_prestador_prot))
	and	((coalesce(a.nr_seq_intercambio::text, '') = '')	or (a.nr_seq_intercambio	= dados_regra_lib_analise_p.nr_seq_intercambio))
	and	((coalesce(a.nr_seq_congenere::text, '') = '')	or (a.nr_seq_congenere		= dados_regra_lib_analise_p.nr_seq_congenere))
	and	((coalesce(a.nr_seq_material::text, '') = '')	or (a.nr_seq_material		= dados_regra_lib_analise_p.nr_seq_material))
	and	((coalesce(a.ie_tipo_segurado::text, '') = '')	or (a.ie_tipo_segurado		= dados_regra_lib_analise_p.ie_tipo_segurado))
	and	((coalesce(a.ie_preco::text, '') = '')	or (a.ie_preco 			= dados_regra_lib_analise_p.ie_preco))	
	and	((coalesce(a.ie_internado::text, '') = '')	or (a.ie_internado 	= 'N')	or (a.ie_internado		= dados_regra_lib_analise_p.ie_internado))
	and	((coalesce(a.ie_tipo_gat::text, '') = '')	or (a.ie_tipo_gat	= 'N')	or (a.ie_tipo_gat		= dados_regra_lib_analise_p.ie_tipo_gat))
	and	((coalesce(a.ie_origem_conta::text, '') = '')	or (ie_origem_conta		= dados_regra_lib_analise_p.ie_origem_conta))
	and	((coalesce(a.nr_seq_tipo_atendimento::text, '') = '') 	or (a.nr_seq_tipo_atendimento	= dados_regra_lib_analise_p.nr_seq_tipo_atendimento))
	and	((coalesce(a.ie_regime_atendimento::text, '') = '') 	or (a.ie_regime_atendimento	= dados_regra_lib_analise_p.ie_regime_atendimento))
	and	((coalesce(a.ie_saude_ocupacional::text, '') = '') 	or (a.ie_saude_ocupacional	= dados_regra_lib_analise_p.ie_saude_ocupacional))
	and	((coalesce(a.nr_seq_tipo_prestador::text, '') = '')	or (a.nr_seq_tipo_prestador	= dados_regra_lib_analise_p.nr_seq_prestador_exec))
	and	((coalesce(a.ie_tipo_despesa_mat::text, '') = '') 	or (a.ie_tipo_despesa_mat	= dados_regra_lib_analise_p.ie_tipo_despesa_mat))
	and	((coalesce(a.ie_tipo_intercambio::text, '') = '') 	or (a.ie_tipo_intercambio = 'A') or (a.ie_tipo_intercambio = dados_regra_lib_analise_p.ie_tipo_intercambio))
	order by 1;


BEGIN
open C01;
loop
fetch C01 into	
	nr_seq_regra_w,
	nr_seq_ocorrencia_w,
	nr_seq_estrut_regra_w,
	nr_seq_grupo_prestador_w,
	nr_seq_classif_w,
	nr_seq_grupo_material_w,
	nr_seq_grupo_servico_w,
	nr_seq_grupo_operadora_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ie_continua_regra_w := true;
	-- Foi adicionado os filtros de grupo de servico e grupo de material. 

	--	Estes filtros nao devem estar no cursor principal por questoes de desempenho,.

	--	Para verificar se um determinado procedimento ou material esta em um grupo, podera ser necessario navegar

	--	por varios "niveis" de agrupamentos (por exemplo, um grupo de servico pode ser apenas cadastrado um grupo de procedimento, entao sera necessario 

	--	verificar se o grupo de procedimento contem o procedimento existente.

	--	Como esta rotina e utilizada na geracao da analise, ela pode impactar diretamente na performance da importacao do XML, 

	--	por isso ela so e testada se a regra possuir de fato alguma informacao de grupo

	--	Caso nao possuir nenhuma informacao de grupo de servico ou material, devera continuar normalmente.


	--	Se possuir alguma informacao e os dados passados por parametros tambem forem condizentes, por exemplo, 

	--	a regra tem um grup de consultas contendo o 10101012, e veio por parametro o 10101012, a regra ira prosseguir normalmente

	
	-- A principio pode paracer que botando esta validacao dentro do cursor, vai ter um custo maior por causa da troca de contexto, 

	--	mas por experiencia de negocio, esses filtros serao raramente utilizados, entao sera melhor ter algumas trocas de contexto 

	--	extra, por conta de poucas regras, do que prejudicar o plano de execucao de todas as regras.

	
	-- Tambem foi "separado" o cedigo, permitindo fazer estas "validacaes especiais" para a performance do codigo, onde

	--	por uma variavel boolean sera controlado se vai prossegur com a regra ou nao, facilitando a criacao de mais validacoes especiais iguais a esta.

	
	-- Se foi informado grupo de material na regra, verifica se o material passado esta contido no grupo
	if	(ie_continua_regra_w AND nr_seq_grupo_material_w IS NOT NULL AND nr_seq_grupo_material_w::text <> '') then
		ie_grupo_material_w := coalesce(pls_se_grupo_preco_material(nr_seq_grupo_material_w, dados_regra_lib_analise_p.nr_seq_material),'N');
		
		
		-- se nao identificar o material no grupo da regra, nao prossegue com a regra
		if (ie_grupo_material_w = 'N') then
					
			ie_continua_regra_w := false;
		end if;
	end if;
	
	-- Se foi informdo grupo de servico na regra, sera verificado o procedimento
	if	(ie_continua_regra_w AND nr_seq_grupo_servico_w IS NOT NULL AND nr_seq_grupo_servico_w::text <> '') then
		select	count(1)
		into STRICT	qt_itens_w
		from (	SELECT	1
			from	table(pls_grupos_pck.obter_procs_grupo_servico(nr_seq_grupo_servico_w, dados_regra_lib_analise_p.ie_origem_proced,dados_regra_lib_analise_p.cd_procedimento))) t;
			
		-- se tem um grupo mas nao localizou o procedimento, nao prossegue com a regra
		if (qt_itens_w = 0) then
			
			ie_continua_regra_w := false;
		end if;
	end if;
	
	-- se as regras especiais nao barraram o processamento...
	if (ie_continua_regra_w) then
	
		ie_estrut_mat_w		:= 'S';
		ie_grupo_prestador_w	:= 'S';
		ie_grupo_operadora_w	:= 'S';
		if (nr_seq_estrut_regra_w IS NOT NULL AND nr_seq_estrut_regra_w::text <> '') then
			if (pls_obter_se_mat_estrutura(dados_regra_lib_analise_p.nr_seq_material, nr_seq_estrut_regra_w) = 'N') then
				ie_estrut_mat_w	:= 'N';
			end if;
		end if;
		
		if (nr_seq_grupo_prestador_w IS NOT NULL AND nr_seq_grupo_prestador_w::text <> '') and (ie_estrut_mat_w = 'S') then
			ie_grupo_prestador_w := pls_obter_se_grupo_prestador(dados_regra_lib_analise_p.nr_seq_prestador_exec, nr_seq_grupo_prestador_w);
		end if;
		
		if (nr_seq_grupo_operadora_w IS NOT NULL AND nr_seq_grupo_operadora_w::text <> '') and (ie_estrut_mat_w = 'S') and (ie_grupo_prestador_w = 'S') then
			ie_grupo_operadora_w	:= pls_se_grupo_preco_operadora(nr_seq_grupo_operadora_w, dados_regra_lib_analise_p.nr_seq_congenere);
		end if;
		
		if (ie_estrut_mat_w = 'S') and (ie_grupo_operadora_w = 'S') and (ie_grupo_prestador_w = 'S') then
			if (coalesce(nr_seq_ocorrencia_w,0)  = 0) and (coalesce(nr_seq_classif_w::text, '') = '')then
				nr_retorno_w := nr_seq_regra_w;	
				exit;
			elsif (nr_seq_classif_w IS NOT NULL AND nr_seq_classif_w::text <> '') then
		
			        select	sum(qt)
				into STRICT	qt_ocor_classif_w
				from (	SELECT	count(1) qt
						from	pls_conta		a,
							pls_conta_proc		b,
							pls_ocorrencia_benef	c,
							pls_ocorrencia		d
						where	a.nr_sequencia		= b.nr_seq_conta
						and	b.nr_sequencia		= c.nr_seq_conta_proc
						and	c.nr_seq_ocorrencia	= d.nr_sequencia
						and	a.nr_seq_analise	= nr_seq_analise_p
						and	d.nr_seq_classif	= nr_seq_classif_w
						
union all

						SELECT	count(1) qt
						from	pls_conta		a,
							pls_conta_mat		b,
							pls_ocorrencia_benef	c,
							pls_ocorrencia		d
						where	a.nr_sequencia		= b.nr_seq_conta
						and	b.nr_sequencia		= c.nr_seq_conta_mat
						and	c.nr_seq_ocorrencia	= d.nr_sequencia
						and	a.nr_seq_analise	= nr_seq_analise_p
						and	d.nr_seq_classif	= nr_seq_classif_w
						
union all

						select	count(1) qt
						from	pls_conta		a,
							pls_ocorrencia_benef	c,
							pls_ocorrencia		d
						where	a.nr_sequencia		= c.nr_seq_conta
						and	c.nr_seq_ocorrencia	= d.nr_sequencia
						and	a.nr_seq_analise	= nr_seq_analise_p
						and	d.nr_seq_classif	= nr_seq_classif_w
					) alias5;
			
			        if (coalesce(qt_ocor_classif_w, 0) > 0) then
					nr_retorno_w := nr_seq_regra_w;
					exit;
				end if;

			else
				select	max(nr_sequencia)
				into STRICT	nr_seq_ocorrencia_benef_w
				from	pls_ocorrencia_benef
				where	nr_seq_conta = nr_seq_conta_p
				and	nr_seq_ocorrencia = nr_seq_ocorrencia_w;
				
				if (coalesce(nr_seq_ocorrencia_benef_w::text, '') = '') then
					select	max(nr_sequencia)
					into STRICT	nr_seq_ocorrencia_benef_w
					from	pls_ocorrencia_benef
					where	nr_seq_conta_proc = nr_seq_conta_proc_p
					and	nr_seq_ocorrencia = nr_seq_ocorrencia_w;
				end if;
				
				if (coalesce(nr_seq_ocorrencia_benef_w,0) > 0) then
					nr_retorno_w := nr_seq_regra_w;	
					exit;
				end if;
			end if;
			
		end if;
		
		
	end if; -- if continua
		
	end;
end loop;
close C01;

return	nr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_excecao_lib_analise ( nr_seq_conta_p bigint, nr_seq_conta_proc_p bigint, nr_seq_regra_p bigint, dados_regra_lib_analise_p pls_cta_valorizacao_pck.dados_regra_lib_analise, nr_seq_analise_p pls_analise_conta.nr_sequencia%type) FROM PUBLIC;
