-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_entao_regra_preco_cta_pck.obter_se_proc_estrutura ( cd_procedimento_p pls_conta_proc.cd_procedimento%type, ie_origem_proced_p pls_conta_proc.ie_origem_proced%type, cd_area_procedimento_p pls_prestador_taxa_item.cd_area_procedimento%type, cd_especialidade_p pls_prestador_taxa_item.cd_especialidade%type, cd_grupo_proc_p pls_prestador_taxa_item.cd_grupo_proc%type) RETURNS varchar AS $body$
DECLARE


ie_origem_proced_w	pls_conta_proc.ie_origem_proced%type;
cd_grupo_proc_w		pls_prestador_taxa_item.cd_grupo_proc%type;
cd_especialidade_w	pls_prestador_taxa_item.cd_especialidade%type;
cd_area_procedimento_w	pls_prestador_taxa_item.cd_area_procedimento%type;
ie_valido_w		varchar(1);


BEGIN
-- inicia sendo válido
ie_valido_w := 'S';

-- só verifica caso tenha algum campo de procedimento informado
if (cd_area_procedimento_p IS NOT NULL AND cd_area_procedimento_p::text <> '') or (cd_especialidade_p IS NOT NULL AND cd_especialidade_p::text <> '') or (cd_grupo_proc_p IS NOT NULL AND cd_grupo_proc_p::text <> '') then

	-- se precisa verificar e não foi passado um procedimento então não é válido
	if (coalesce(cd_procedimento_p::text, '') = '') then 

		ie_valido_w := 'N';
	-- senão faz a verificação
	else
		
		pls_obter_estrut_proc(	cd_procedimento_p, ie_origem_proced_p, cd_area_procedimento_w,
					cd_especialidade_w, cd_grupo_proc_w, ie_origem_proced_w);
		
		-- se tem alguma area informada verifica se é a mesma do procedimento
		if (cd_area_procedimento_p IS NOT NULL AND cd_area_procedimento_p::text <> '') then
		
			-- se for diferente é inválida
			if (cd_area_procedimento_p != cd_area_procedimento_w) then
				
				ie_valido_w := 'N';
			end if;
		end if;
		
		-- se tem alguma especialidade informada verifica se é a mesma do procedimento
		if (cd_especialidade_p IS NOT NULL AND cd_especialidade_p::text <> '') then
		
			-- se for diferente é inválida
			if (cd_especialidade_p != cd_especialidade_w) then
				
				ie_valido_w := 'N';
			end if;
		end if;
		
		-- se tem algum grupo informado verifica se é o mesmo do procedimento
		if (cd_grupo_proc_p IS NOT NULL AND cd_grupo_proc_p::text <> '') then
		
			-- se for diferente é inválida
			if (cd_grupo_proc_p != cd_grupo_proc_w) then
				
				ie_valido_w := 'N';
			end if;
		end if;
	end if;
end if;

return ie_valido_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_entao_regra_preco_cta_pck.obter_se_proc_estrutura ( cd_procedimento_p pls_conta_proc.cd_procedimento%type, ie_origem_proced_p pls_conta_proc.ie_origem_proced%type, cd_area_procedimento_p pls_prestador_taxa_item.cd_area_procedimento%type, cd_especialidade_p pls_prestador_taxa_item.cd_especialidade%type, cd_grupo_proc_p pls_prestador_taxa_item.cd_grupo_proc%type) FROM PUBLIC;