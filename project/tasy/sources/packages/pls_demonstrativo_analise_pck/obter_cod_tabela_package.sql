-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_demonstrativo_analise_pck.obter_cod_tabela ( cd_procedimento_p procedimento.cd_procedimento%type, ie_origem_proced_p procedimento.ie_origem_proced%type, cd_tipo_tabela_imp_p pls_conta_proc.cd_tipo_tabela_imp%type, dt_procedimento_p pls_conta_proc.dt_procedimento_referencia%type, nr_seq_material_p pls_material.nr_sequencia%type, ie_origem_preco_imp_p pls_conta_mat.ie_origem_preco_imp%type, ie_tipo_despesa_p pls_conta_proc.ie_tipo_despesa%type, cd_versao_tiss_p pls_versao_tiss.cd_versao_tiss%type) RETURNS varchar AS $body$
DECLARE

	
cd_tabela_w		pls_rel_an_itens.cd_tabela%type;
ie_tipo_despesa_w	pls_material.ie_tipo_despesa%type;
	

BEGIN
if (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') then

	select	max(ie_tipo_tabela)
	into STRICT	cd_tabela_w
	from	pls_procedimento_vigencia
	where	cd_procedimento = cd_procedimento_p
	and	ie_origem_proced = ie_origem_proced_p
	and	dt_procedimento_p between dt_inicio_vigencia and coalesce(dt_fim_vigencia, dt_procedimento_p);
	
	if (coalesce(cd_tabela_w::text, '') = '') then
		
		if (cd_versao_tiss_p = '3.02.00') then
			
			if (coalesce(cd_tipo_tabela_imp_p::text, '') = '') then
				
				if (ie_origem_proced_p = 4) then
					cd_tabela_w := '00';
				elsif (ie_tipo_despesa_p = '2') then
					cd_tabela_w := '18';
				elsif (ie_tipo_despesa_p = '4') then
					cd_tabela_w := '98';
				elsif (ie_tipo_despesa_p = '3') then
					cd_tabela_w := '00';
				elsif (ie_tipo_despesa_p = '1') then
					cd_tabela_w := '22';
				end if;
			else
				cd_tabela_w := cd_tipo_tabela_imp_p;
			end if;
		else
			if (ie_origem_proced_p = 4) then
				cd_tabela_w := '00';
			elsif (ie_tipo_despesa_p = '2') then
				cd_tabela_w := '18';
			elsif (ie_tipo_despesa_p = '4') then
				cd_tabela_w := '98';
			elsif (ie_tipo_despesa_p = '3') then
				cd_tabela_w := '00';
			elsif (ie_tipo_despesa_p = '1') then
				cd_tabela_w := '22';
			end if;
		end if;
	end if;
else
	select	max(ie_tipo_tabela)
	into STRICT	cd_tabela_w
	from	pls_material
	where	nr_sequencia = nr_seq_material_p;
	
	if (coalesce(cd_tabela_w::text, '') = '') then
		
		if (cd_versao_tiss_p = '3.02.00') then
			
			if (coalesce(ie_origem_preco_imp_p::text, '') = '') then
				
				select	max(ie_tipo_despesa)
				into STRICT	ie_tipo_despesa_w
				from	pls_material
				where	nr_sequencia = nr_seq_material_p;
				
				if (ie_tipo_despesa_w = 1) then
					cd_tabela_w := '20';
				elsif (ie_tipo_despesa_w = 2) then
					cd_tabela_w := '19';
				else
					cd_tabela_w := '00';
				end if;
			else
				cd_tabela_w := ie_origem_preco_imp_p;
			end if;
		else
			if (coalesce(ie_origem_preco_imp_p::text, '') = '') then
				select	max(ie_tipo_despesa)
				into STRICT	ie_tipo_despesa_w
				from	pls_material
				where	nr_sequencia = nr_seq_material_p;
				
				if (ie_tipo_despesa_w = 1) then
					cd_tabela_w := '20';
				elsif (ie_tipo_despesa_w = 2) then
					cd_tabela_w := '19';
				else
					cd_tabela_w := '00';
				end if;
			else
				cd_tabela_w := ie_origem_preco_imp_p;
			end if;
		end if;
	end if;
end if;

return cd_tabela_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_demonstrativo_analise_pck.obter_cod_tabela ( cd_procedimento_p procedimento.cd_procedimento%type, ie_origem_proced_p procedimento.ie_origem_proced%type, cd_tipo_tabela_imp_p pls_conta_proc.cd_tipo_tabela_imp%type, dt_procedimento_p pls_conta_proc.dt_procedimento_referencia%type, nr_seq_material_p pls_material.nr_sequencia%type, ie_origem_preco_imp_p pls_conta_mat.ie_origem_preco_imp%type, ie_tipo_despesa_p pls_conta_proc.ie_tipo_despesa%type, cd_versao_tiss_p pls_versao_tiss.cd_versao_tiss%type) FROM PUBLIC;
