-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_estr_somen_itens_aut ( nr_seq_estrutura_p pls_ocorrencia_estrutura.nr_sequencia%type, nr_seq_guia_p pls_guia_plano.nr_sequencia%type, nr_seq_requisicao_p pls_requisicao.nr_sequencia%type, nr_seq_execucao_p pls_execucao_requisicao.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Validar se todos os itens do atendimento estão na estrutura, não devendo haver
outros itens que não fazem parte da estrutura.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
qt_itens_estrutura_w		bigint;
ie_estrutura_w			varchar(1)	:= 'N';
ie_existe_fora_estrut_w		varchar(1)	:= 'N';
ie_retorno_w			varchar(1)	:= 'N';

C01 CURSOR FOR
	SELECT	cd_procedimento,
		ie_origem_proced
	from	pls_guia_plano_proc
	where	nr_seq_guia	= nr_seq_guia_p
	group 	by cd_procedimento,
                ie_origem_proced
        order 	by 1;

C02 CURSOR FOR
	SELECT	nr_seq_material
	from	pls_guia_plano_mat
	where	nr_seq_guia	= nr_seq_guia_p
	group 	by nr_seq_material
        order 	by 1;
C03 CURSOR FOR
	SELECT	cd_procedimento,
		ie_origem_proced
	from	pls_requisicao_proc
	where	nr_seq_requisicao	= nr_seq_requisicao_p
	group 	by cd_procedimento,
                ie_origem_proced
        order 	by 1;

C04 CURSOR FOR
	SELECT	nr_seq_material
	from	pls_requisicao_mat
	where	nr_seq_requisicao	= nr_seq_requisicao_p
	group 	by nr_seq_material
        order 	by 1;

C05 CURSOR FOR
	SELECT	cd_procedimento,
		ie_origem_proced
	from	pls_execucao_req_item
	where	nr_seq_execucao		= nr_seq_execucao_p
	and	coalesce(nr_seq_material::text, '') = ''
	group 	by cd_procedimento,
                ie_origem_proced
        order 	by 1;

C06 CURSOR FOR
	SELECT	nr_seq_material
	from	pls_execucao_req_item
	where	nr_seq_execucao		= nr_seq_execucao_p
	and	coalesce(cd_procedimento::text, '') = ''
	group 	by nr_seq_material
        order 	by 1;
BEGIN
/*Verificado quantas regras existem nas estrutura (valendo somente procedimento e material)*/

select	count(*)
into STRICT	qt_itens_estrutura_w
from	pls_ocorrencia_estrut_item
where	((cd_procedimento IS NOT NULL AND cd_procedimento::text <> '') or (nr_seq_material IS NOT NULL AND nr_seq_material::text <> ''))
and	nr_seq_estrutura = nr_seq_estrutura_p
and	ie_estrutura = 'S';

if (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then
	for r_C01_w in C01 loop
		begin
			/*Obtem se o procedimento faz parte da estrutura*/

			select  CASE WHEN count(nr_sequencia)=0 THEN 'N'  ELSE 'S' END
			into STRICT	ie_estrutura_w
			from    pls_ocorrencia_estrut_item a
			where   nr_seq_estrutura        = nr_seq_estrutura_p
			and     a.cd_procedimento 	= r_C01_w.cd_procedimento
			and     a.ie_origem_proced 	= r_C01_w.ie_origem_proced
			and	ie_estrutura =  'S';

			/*Se a regra selecionda diz que este procedimento não faz parte da estrtura*/

			if (coalesce(ie_estrutura_w,'N') = 'N') then
				ie_existe_fora_estrut_w	:= 'S';
				exit;
			end if;
		end;
	end loop;
	for r_C02_w in C02 loop
		begin
			select  CASE WHEN count(nr_sequencia)=0 THEN 'N'  ELSE 'S' END
			into STRICT	ie_estrutura_w
			from    pls_ocorrencia_estrut_item a
			where   nr_seq_estrutura        = nr_seq_estrutura_p
			and	nr_seq_material		= r_C02_w.nr_seq_material
			and	ie_estrutura =  'S';

			/*Se a regra selecionda diz que este procedimento não faz parte da estrtura*/

			if (coalesce(ie_estrutura_w,'N') = 'N') then
				ie_existe_fora_estrut_w	:= 'S';
				exit;
			end if;
		end;
	end loop;
elsif (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then
	for r_C03_w in C03 loop
		begin
			/*Obtem se o procedimento faz parte da estrutura*/

			select  CASE WHEN count(nr_sequencia)=0 THEN 'N'  ELSE 'S' END
			into STRICT	ie_estrutura_w
			from    pls_ocorrencia_estrut_item a
			where   nr_seq_estrutura        = nr_seq_estrutura_p
			and     a.cd_procedimento 	= r_C03_w.cd_procedimento
			and     a.ie_origem_proced 	= r_C03_w.ie_origem_proced
			and	ie_estrutura =  'S';

			/*Se a regra selecionda diz que este procedimento não faz parte da estrtura*/

			if (coalesce(ie_estrutura_w,'N') = 'N') then
				ie_existe_fora_estrut_w	:= 'S';
				exit;
			end if;
		end;
	end loop;
	for r_C04_w in C04 loop
		begin
			select  CASE WHEN count(nr_sequencia)=0 THEN 'N'  ELSE 'S' END
			into STRICT	ie_estrutura_w
			from    pls_ocorrencia_estrut_item a
			where   nr_seq_estrutura        = nr_seq_estrutura_p
			and	nr_seq_material		= r_C04_w.nr_seq_material
			and	ie_estrutura =  'S';

			/*Se a regra selecionda diz que este procedimento não faz parte da estrtura*/

			if (coalesce(ie_estrutura_w,'N') = 'N') then
				ie_existe_fora_estrut_w	:= 'S';
				exit;
			end if;
		end;
	end loop;
elsif (nr_seq_execucao_p IS NOT NULL AND nr_seq_execucao_p::text <> '') then
	for r_C05_w in C05 loop
		begin
			/*Obtem se o procedimento faz parte da estrutura*/

			select  CASE WHEN count(nr_sequencia)=0 THEN 'N'  ELSE 'S' END
			into STRICT	ie_estrutura_w
			from    pls_ocorrencia_estrut_item a
			where   nr_seq_estrutura        = nr_seq_estrutura_p
			and     a.cd_procedimento 	= r_C05_w.cd_procedimento
			and     a.ie_origem_proced 	= r_C05_w.ie_origem_proced
			and	ie_estrutura =  'S';

			/*Se a regra selecionda diz que este procedimento não faz parte da estrtura*/

			if (coalesce(ie_estrutura_w,'N') = 'N') then
				ie_existe_fora_estrut_w	:= 'S';
				exit;
			end if;
		end;
	end loop;
	for r_C06_w in C06 loop
		begin
			select  CASE WHEN count(nr_sequencia)=0 THEN 'N'  ELSE 'S' END
			into STRICT	ie_estrutura_w
			from    pls_ocorrencia_estrut_item a
			where   nr_seq_estrutura        = nr_seq_estrutura_p
			and	nr_seq_material		= r_C06_w.nr_seq_material
			and	ie_estrutura =  'S';

			/*Se a regra selecionda diz que este procedimento não faz parte da estrtura*/

			if (coalesce(ie_estrutura_w,'N') = 'N') then
				ie_existe_fora_estrut_w	:= 'S';
				exit;
			end if;
		end;
	end loop;
end if;

/*Caso exista item no atendimento fora da estrutura deve gerar a ocorrência*/

if (ie_existe_fora_estrut_w = 'S') then
	ie_retorno_w	:= ie_existe_fora_estrut_w;

/*Valida se todos  itens da estrutura estão no atendimento*/

else
	ie_retorno_w	:= pls_obter_estr_ocor_todos_aut(nr_seq_estrutura_p, nr_seq_guia_p, nr_seq_requisicao_p, nr_seq_execucao_p);
end if;

return  ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_estr_somen_itens_aut ( nr_seq_estrutura_p pls_ocorrencia_estrutura.nr_sequencia%type, nr_seq_guia_p pls_guia_plano.nr_sequencia%type, nr_seq_requisicao_p pls_requisicao.nr_sequencia%type, nr_seq_execucao_p pls_execucao_requisicao.nr_sequencia%type) FROM PUBLIC;
