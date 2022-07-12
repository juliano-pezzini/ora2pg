-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--procedure  utilizada para retornar o cdigo do Tipo de Tabela TISS



CREATE OR REPLACE PROCEDURE pls_gerencia_envio_ans_pck.obter_tipo_tabela_tiss ( cd_procedimento_p procedimento.cd_procedimento%type, ie_origem_proc_p procedimento.ie_origem_proced%type, nr_seq_pacote_p pls_pacote.nr_sequencia%type, ie_tipo_despesa_p pls_conta_mat.ie_tipo_despesa%type, nr_seq_material_p pls_conta_mat.nr_seq_material%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_tipo_tabela_p INOUT tiss_tipo_tabela.cd_tabela_xml%type, nr_seq_regra_p INOUT pls_regra_tabela_tiss.nr_sequencia%type, ie_origem_tab_ref_p INOUT pls_monitor_tiss_proc.ie_origem_tab_ref%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Trazer o cdigo de tabela do TISS
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[  ]  Objetos do dicionrio [x ] Tasy (Delphi/Java) [ x ] Portal [ x ]  Relatrios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de ateno:  Rotina utilizada nos relatrios, portal e Tasy
Se existir registro na tabela TUSS os cdigos enviados para o material ou medicamento dever ser
00 Tabela prpria das operadoras
18 Dirias, taxas e gases medicinais
19 Materiais e rteses, Prteses e Materiais Especiais (OPME)
20 Medicamentos
22 Procedimentos e eventos em sade
98 Tabela Prpria de Pacotes
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


cd_tipo_tabela_w	varchar(2);
nr_seq_regra_w		pls_regra_tabela_tiss.nr_sequencia%type;


BEGIN

if (current_setting('pls_gerencia_envio_ans_pck.ie_origem_regra_conv_tab_w')::pls_monitor_tiss_param.ie_origem_regra_conv_tab%type = 'T') then
	-- Validao feita para procedimentos

	if (ie_origem_proc_p IS NOT NULL AND ie_origem_proc_p::text <> '') then

		-- Se tiver pacote retorna o cdigo do pacote

		if (nr_seq_pacote_p IS NOT NULL AND nr_seq_pacote_p::text <> '') then
			cd_tipo_tabela_w := '98';

		-- Procedimentos codificao TUSS

		elsif ( ie_origem_proc_p = '8' ) then
			select	CASE WHEN max(ie_tipo_despesa_p)='1' THEN '22' WHEN max(ie_tipo_despesa_p)='2' THEN '18' WHEN max(ie_tipo_despesa_p)='3' THEN '18'  ELSE '00' END
			into STRICT	cd_tipo_tabela_w
			;
		else
			cd_tipo_tabela_w := '00';
		end if;

	-- Validao aplicada somente para materiais e medicamentos

	else
		--aaschlote 19/11/2014 - Conforme visto com Carlos da Unimed Rio Preto, pode ser cadastrado o tipo de tabela tiss dentro do material

		select	max(ie_tipo_tabela)
		into STRICT	cd_tipo_tabela_w
		from	pls_material
		where	nr_sequencia	= nr_seq_material_p;

		if (coalesce(cd_tipo_tabela_w::text, '') = '') then
			select	CASE WHEN max(ie_tipo_despesa_p)='2' THEN '20' WHEN max(ie_tipo_despesa_p)='3' THEN '19' WHEN max(ie_tipo_despesa_p)='7' THEN '19' WHEN max(ie_tipo_despesa_p)='1' THEN '18'  ELSE '00' END
			into STRICT	cd_tipo_tabela_w
			;
		end if;
	end if;

	if (cd_tipo_tabela_w IS NOT NULL AND cd_tipo_tabela_w::text <> '') then
		ie_origem_tab_ref_p := 'T';
	end if;
else
	SELECT * FROM pls_gerencia_envio_ans_pck.obter_regra_tipo_tabela_tiss(cd_procedimento_p, ie_origem_proc_p, nr_seq_material_p, cd_estabelecimento_p, ie_tipo_despesa_p, cd_tipo_tabela_w, nr_seq_regra_w) INTO STRICT cd_tipo_tabela_w, nr_seq_regra_w;
end if;

if (coalesce(cd_tipo_tabela_w::text, '') = '') then
	if (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') and (ie_origem_proc_p IS NOT NULL AND ie_origem_proc_p::text <> '') then
		select	max(ie_tipo_tabela)
		into STRICT	cd_tipo_tabela_w
		from	pls_procedimento_vigencia
		where	cd_procedimento = cd_procedimento_p
		and	ie_origem_proced = ie_origem_proc_p
		and	clock_timestamp() between dt_inicio_vigencia and coalesce(dt_fim_vigencia, clock_timestamp());

		if (cd_tipo_tabela_w IS NOT NULL AND cd_tipo_tabela_w::text <> '') then
			ie_origem_tab_ref_p := 'C';
		end if;

	else
		if (nr_seq_material_p IS NOT NULL AND nr_seq_material_p::text <> '') then
			select	max(ie_tipo_tabela)
			into STRICT	cd_tipo_tabela_w
			from	pls_material
			where	nr_sequencia = nr_seq_material_p;

			if (cd_tipo_tabela_w IS NOT NULL AND cd_tipo_tabela_w::text <> '') then
				ie_origem_tab_ref_p := 'C';
			end if;
		else
			cd_tipo_tabela_w := '00';
			ie_origem_tab_ref_p := 'C';
		end if;
	end if;
end if;

cd_tipo_tabela_p := cd_tipo_tabela_w;
nr_seq_regra_p := nr_seq_regra_w;

if (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') then
	ie_origem_tab_ref_p := 'R';
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_envio_ans_pck.obter_tipo_tabela_tiss ( cd_procedimento_p procedimento.cd_procedimento%type, ie_origem_proc_p procedimento.ie_origem_proced%type, nr_seq_pacote_p pls_pacote.nr_sequencia%type, ie_tipo_despesa_p pls_conta_mat.ie_tipo_despesa%type, nr_seq_material_p pls_conta_mat.nr_seq_material%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_tipo_tabela_p INOUT tiss_tipo_tabela.cd_tabela_xml%type, nr_seq_regra_p INOUT pls_regra_tabela_tiss.nr_sequencia%type, ie_origem_tab_ref_p INOUT pls_monitor_tiss_proc.ie_origem_tab_ref%type) FROM PUBLIC;