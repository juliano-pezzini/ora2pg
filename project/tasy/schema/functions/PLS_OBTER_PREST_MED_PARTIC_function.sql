-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_prest_med_partic ( nr_seq_particip_p pls_proc_participante.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE

			 
cd_medico_w		pls_proc_participante.cd_medico%type;
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
nr_seq_prestador_w	pls_prestador.nr_sequencia%type;
nr_seq_prest_prot_w	pls_prestador.nr_sequencia%type;
nr_seq_prest_part_w	pls_proc_participante.nr_seq_prestador%type;
ds_retorno_w		varchar(255)	:= '';

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade:	Carregar o prestador vinculado ao médico, obedecendo a seguinte ordem: 
 
	1) Busca um prestador informado diretamente no participante 
	2) Caso não encontre o item 1, busca um prestador vinculado diretamente com a pessoa fisica do medico 
	3) Caso não encontre o item 2, verifica se o médico compoem o corpo clinico 
	do prestador do atendimento, se compor é utilizado o prestador do atendimento 
	4) Caso não encontre o item 3, é utilizado a versão 
	"antiga" da rotina, que busca o vinculo mais recente encontrado para o médico. 
	 
	A criação desta rotina aconteceu em função as alteraçãoes da Glosa 1214, que passa 
	a buscar o prestador do participante conforme os itens 1 , 2 e 3. Amnteriormente a glosa 
	acontecia, mas o nome do Prestador ficada trocado, causando confusão, agora 
	a busca da glosa fica parelha a exibição do nome.	 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ X] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
 
	Ao alterar essa rotina, verificar como está a glosa 1214, na procedure pls_consistir_proc_prestador 
	 
Alterações: 
 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 

BEGIN 
 
-- busca os dados do médico 
select	max(a.cd_medico), 
	max(b.cd_estabelecimento), 
	max(b.nr_seq_prestador_prot), 
	max(a.nr_seq_prestador) 
into STRICT	cd_medico_w, 
	cd_estabelecimento_w, 
	nr_seq_prest_prot_w, 
	nr_seq_prest_part_w 
from	pls_proc_participante	a, 
	pls_conta_proc_v	b 
where	b.nr_sequencia		= a.nr_seq_conta_proc 
and	a.nr_sequencia		= nr_seq_particip_p;
 
nr_seq_prestador_w	:= null;
 
-- Apenas continua se encontrou o prestador do participante ou médico. 
if (cd_medico_w IS NOT NULL AND cd_medico_w::text <> '') or (nr_seq_prest_part_w IS NOT NULL AND nr_seq_prest_part_w::text <> '') then 
 
	-- Se tiver um prestador já informado no participante, utiliza ele 
	if (nr_seq_prest_part_w IS NOT NULL AND nr_seq_prest_part_w::text <> '') then 
		 
		nr_seq_prestador_w	:= nr_seq_prest_part_w;
	 
	else 
	 
		-- se não tem um prestador ja informado, então tenta achar um prestador ativo com o vinculo direto pelo cd_pessoa_fisica (copiado da pls_consistir_proc_prestador)		 
		select	max(nr_sequencia) 
		into STRICT	nr_seq_prestador_w 
		from	pls_prestador 
		where	cd_pessoa_fisica	= cd_medico_w 
		and	cd_estabelecimento	= cd_estabelecimento_w 
		and	ie_situacao		= 'A';
		 
		-- Se não localizou um vinculo ativo direto, verifica se o medico faz parte do corpo clinico do prestador do atendimento. 
		if (coalesce(nr_seq_prestador_w::text, '') = '') then 
		 
			 
			select	max(a.nr_seq_prestador) 
			into STRICT	nr_seq_prestador_w 
			from	pls_prestador		b, 
				pls_prestador_medico	a 
			where	a.nr_seq_prestador	= b.nr_sequencia 
			and	a.cd_medico		= cd_medico_w 
			and	b.cd_estabelecimento	= cd_estabelecimento_w 
			and	b.nr_sequencia		= nr_seq_prest_prot_w 
			and	a.ie_situacao		= 'A' 
			and	b.ie_situacao		= 'A' 
			and	trunc(clock_timestamp(),'dd') between trunc(coalesce(a.dt_inclusao,clock_timestamp()),'dd') and fim_dia(coalesce(a.dt_exclusao,clock_timestamp()));
			 
			 
			-- Se ainda não localizou um prestador, utiliza a versão antiga da rotina 
			if (coalesce(nr_seq_prestador_w::text, '') = '') then 
				 
				nr_seq_prestador_w	:= pls_obter_credenciado(cd_medico_w, cd_estabelecimento_w);
			end if; -- fim utiliza a versão antiga da rotina 
		end if; -- fim verifica se o medico faz parte do corpo clinico do prestador do atendimento. 
	end if;-- fim se já informado no participante 
end if;
 
 
-- Usa NVL aqui, porque a rotina pls_obter_credenciado retorna 0 (zero) para quando não localiza nada (!!!) 
if (coalesce(nr_seq_prestador_w, 0)	> 0) then 
	ds_retorno_w	:= pls_obter_dados_prestador(nr_seq_prestador_w,'N');
	ds_retorno_w	:= ds_retorno_w || ' ('||nr_seq_prestador_w||')';
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_prest_med_partic ( nr_seq_particip_p pls_proc_participante.nr_sequencia%type) FROM PUBLIC;

