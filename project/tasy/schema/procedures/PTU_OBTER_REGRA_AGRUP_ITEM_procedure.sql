-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_obter_regra_agrup_item ( nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, cd_servico_p ptu_nota_servico.cd_servico%type, ie_item_pacote_p text, ie_tipo_tabela_p ptu_nota_servico.ie_tipo_tabela%type, ie_agrupa_p INOUT pls_regra_agrup_item_ptu.ie_agrupamento%type, nr_seq_regra_agrup_p INOUT pls_regra_agrup_item_ptu.nr_sequencia%type, ie_agrupa_hora_p INOUT pls_regra_agrup_item_ptu.ie_agrupa_hora%type ) AS $body$
DECLARE

					
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Obter regra de agrupamento de item no PTU.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[ ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atenção:

Alterações:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
cd_procedimento_w		procedimento.cd_procedimento%type;
ie_origem_proced_w		procedimento.ie_origem_proced%type;
dt_referencia_w			pls_conta_proc.dt_procedimento%type;
nr_seq_regra_w			pls_regra_agrup_item_ptu.nr_sequencia%type;
ie_agrupa_w			pls_regra_agrup_item_ptu.ie_agrupamento%type;
ie_agrupa_hora_w		pls_regra_agrup_item_ptu.ie_agrupa_hora%type;
nr_seq_material_w		pls_material.nr_sequencia%type;
nr_seq_grupo_rec_w		procedimento.nr_seq_grupo_rec%type;
nr_seq_grupo_ser_w              pls_regra_agrup_item_ptu.nr_seq_grupo_servico%type;
ie_serv_lib_w                   varchar(10);

C01 CURSOR(	dt_referencia_pc	pls_conta_proc.dt_procedimento%type,
		cd_procedimento_pc	procedimento.cd_procedimento%type,
		ie_origem_proced_pc	procedimento.ie_origem_proced%type,
		nr_seq_grupo_rec_pc	procedimento.nr_seq_grupo_rec%type) FOR
	SELECT	nr_sequencia,
		ie_agrupamento,
		ie_agrupa_hora,
                nr_seq_grupo_servico
	from	pls_regra_agrup_item_ptu
	where	ie_tipo_validacao = 'P'
	and	dt_referencia_pc between dt_inicio_vigencia and dt_fim_vigencia_ref
	and	((coalesce(cd_procedimento::text, '') = '') or ((cd_procedimento = cd_procedimento_pc) and (ie_origem_proced = ie_origem_proced_pc or coalesce(ie_origem_proced_pc::text, '') = '')))
	and	((coalesce(nr_seq_grupo_rec::text, '') = '') or (nr_seq_grupo_rec = nr_seq_grupo_rec_pc))
	order by
		coalesce(nr_seq_grupo_rec, 1),
		coalesce(cd_procedimento, 1),
		CASE WHEN ie_agrupamento='S' THEN  1 WHEN ie_agrupamento='N' THEN  2 END;
		
C02 CURSOR(	dt_referencia_pc	pls_conta_proc.dt_procedimento%type,
		nr_seq_material_pc	pls_material.nr_sequencia%type,
		cd_servico_pc		ptu_nota_servico.cd_servico%type)FOR
	SELECT	nr_sequencia,
		ie_agrupamento,
		ie_agrupa_hora
	from	pls_regra_agrup_item_ptu		
	where	ie_tipo_validacao = 'M'	
	and	dt_referencia_pc between dt_inicio_vigencia and dt_fim_vigencia_ref
	and	((coalesce(nr_seq_material::text, '') = '') or (nr_seq_material = nr_seq_material_pc))
	and	(((coalesce(cd_material_inicial::text, '') = '') and (coalesce(cd_material_final::text, '') = '')) or (cd_servico_pc between cd_material_inicial and cd_material_final))
	order by
		coalesce(cd_material_inicial, 1),
		coalesce(cd_material_final, 1),
		coalesce(nr_seq_material, 1),
		CASE WHEN ie_agrupamento='S' THEN  1 WHEN ie_agrupamento='N' THEN  2 END;
		
BEGIN

nr_seq_regra_w		:= null;
ie_agrupa_w		:= 'S';
ie_agrupa_hora_w	:= 'N';

if (nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '') then
	select	cd_procedimento,
		ie_origem_proced,
		dt_procedimento,
                nr_seq_grupo_serv
	into STRICT	cd_procedimento_w,
		ie_origem_proced_w,
		dt_referencia_w,
                nr_seq_grupo_ser_w
	from	pls_conta_proc
	where	nr_sequencia = nr_seq_conta_proc_p;
	
	select	max(nr_seq_grupo_rec)
	into STRICT	nr_seq_grupo_rec_w
	from	procedimento
	where	cd_procedimento = cd_procedimento_w
	and	ie_origem_proced = ie_origem_proced_w;

	for r_C01_w in C01(dt_referencia_w, cd_procedimento_w, ie_origem_proced_w, nr_seq_grupo_rec_w) loop
		nr_seq_regra_w		:= r_C01_w.nr_sequencia;
		ie_agrupa_w		:= r_C01_w.ie_agrupamento;
		ie_agrupa_hora_w	:= r_C01_w.ie_agrupa_hora;
	end loop;
	
	-- Se for item de pacote	
	if (ie_item_pacote_p = 'S') and (coalesce(nr_seq_regra_w::text, '') = '') then
		
		if (ie_tipo_tabela_p in (0,1,4)) then -- Procedimentos
			for r_C01_w in C01( dt_referencia_w, cd_servico_p, null, nr_seq_grupo_rec_w ) loop
				
				ie_serv_lib_w := 'S';
				if (r_C01_w.nr_seq_grupo_servico IS NOT NULL AND r_C01_w.nr_seq_grupo_servico::text <> '') then
					ie_serv_lib_w	:= pls_se_grupo_preco_servico(r_C01_w.nr_seq_grupo_servico,cd_procedimento_w,ie_origem_proced_w);
				end if;
				
                                if (ie_serv_lib_w = 'S') then
                                        nr_seq_regra_w		:= r_C01_w.nr_sequencia;
				        ie_agrupa_w 		:= r_C01_w.ie_agrupamento;
					ie_agrupa_hora_w	:= r_C01_w.ie_agrupa_hora;
                                end if;

			end loop;
			
			
		elsif (ie_tipo_tabela_p in (2,3)) then -- Materiais
			for r_C02_w in C02( dt_referencia_w, null, cd_servico_p ) loop
				nr_seq_regra_w		:= r_C02_w.nr_sequencia;
				ie_agrupa_w 		:= r_C02_w.ie_agrupamento;
				ie_agrupa_hora_w	:= r_C02_w.ie_agrupa_hora;
			end loop;
		end if;
	end if;
	
elsif (nr_seq_conta_mat_p IS NOT NULL AND nr_seq_conta_mat_p::text <> '') then
	select	nr_seq_material,
		dt_atendimento
	into STRICT	nr_seq_material_w,
		dt_referencia_w
	from	pls_conta_mat
	where	nr_sequencia = nr_seq_conta_mat_p;
	
	for r_C02_w in C02(dt_referencia_w, nr_seq_material_w, cd_servico_p)loop
		nr_seq_regra_w		:= r_C02_w.nr_sequencia;
		ie_agrupa_w 		:= r_C02_w.ie_agrupamento;
		ie_agrupa_hora_w	:= r_C02_w.ie_agrupa_hora;
	end loop;
end if;

nr_seq_regra_agrup_p := nr_seq_regra_w;
ie_agrupa_p		:= ie_agrupa_w;
ie_agrupa_hora_p	:= coalesce(ie_agrupa_hora_w, 'N');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_obter_regra_agrup_item ( nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, cd_servico_p ptu_nota_servico.cd_servico%type, ie_item_pacote_p text, ie_tipo_tabela_p ptu_nota_servico.ie_tipo_tabela%type, ie_agrupa_p INOUT pls_regra_agrup_item_ptu.ie_agrupamento%type, nr_seq_regra_agrup_p INOUT pls_regra_agrup_item_ptu.nr_sequencia%type, ie_agrupa_hora_p INOUT pls_regra_agrup_item_ptu.ie_agrupa_hora%type ) FROM PUBLIC;

