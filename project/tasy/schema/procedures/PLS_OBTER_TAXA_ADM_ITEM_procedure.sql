-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_taxa_adm_item ( cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_material_p bigint, nr_seq_prestador_exec_p bigint, nm_usuario_p text, ie_preco_p pls_plano.ie_preco%type, ie_tipo_segurado_p pls_segurado.ie_tipo_segurado%type, nr_seq_contrato_p pls_segurado.nr_seq_contrato%type, dt_validar_p timestamp, tx_adm_p INOUT bigint, vl_fixo_p INOUT pls_prestador_taxa_item.vl_fixo%type, nr_seq_regra_p INOUT pls_prestador_taxa_item.nr_sequencia%type) AS $body$
DECLARE


tx_adm_w				double precision := 0;
ie_origem_proced_w		bigint;
cd_grupo_proc_w			bigint;
cd_especialidade_w		bigint;
cd_area_procedimento_w	bigint;
ie_grupo_material_w		varchar(1);
ie_estrut_mat_w			varchar(1);
qt_regra_w				integer;
nr_seq_regra_retorno_w	pls_prestador_taxa_item.nr_sequencia%type;
vl_fixo_w				pls_prestador_taxa_item.vl_fixo%type := 0;
ie_grupo_serv_w			varchar(1);
ie_grupo_contrato_w		varchar(1);

C01 CURSOR FOR
	SELECT	tx_item,
			nr_seq_grupo_material,
			nr_seq_estrut_mat,
			nr_sequencia	nr_seq_regra,
			vl_fixo,
			nr_seq_grupo_contrato,
			nr_seq_grupo_servico
	from	pls_prestador_taxa_item
	where	nr_seq_prestador = nr_seq_prestador_exec_p
	and		((coalesce(cd_procedimento::text, '') = '') or (cd_procedimento = cd_procedimento_p AND ie_origem_proced = ie_origem_proced_p))
	and		((coalesce(cd_area_procedimento::text, '') = '') or (cd_area_procedimento = cd_area_procedimento_w))
	and		((coalesce(cd_especialidade::text, '') = '') or (cd_especialidade = cd_especialidade_w))
	and		((coalesce(cd_grupo_proc::text, '') = '') or (cd_grupo_proc = cd_grupo_proc_w))
	and		((coalesce(nr_seq_material::text, '') = '') or (nr_seq_material = nr_seq_material_p))
	and		((coalesce(ie_preco::text, '') = '') or (ie_preco = ie_preco_p))
	and		((coalesce(ie_tipo_segurado::text, '') = '') or (ie_tipo_segurado = ie_tipo_segurado_p))
	and 	dt_validar_p between dt_inicio_vigencia_ref and dt_fim_vigencia_ref
	order by 	coalesce(cd_procedimento,0),
            coalesce(cd_area_procedimento,0),
            coalesce(cd_especialidade,0),
            coalesce(cd_grupo_proc,0),
            coalesce(nr_seq_material,0),
            coalesce(ie_preco,0),
            coalesce(ie_tipo_segurado,0),
            coalesce(nr_seq_grupo_contrato,0),
            coalesce(nr_seq_grupo_servico,0);
	
BEGIN

select	count(1)
into STRICT	qt_regra_w
from	pls_prestador_taxa_item;

if (qt_regra_w	> 0) then
	SELECT * FROM pls_obter_estrut_proc(cd_procedimento_p, ie_origem_proced_p, cd_area_procedimento_w, cd_especialidade_w, cd_grupo_proc_w, ie_origem_proced_w) INTO STRICT cd_area_procedimento_w, cd_especialidade_w, cd_grupo_proc_w, ie_origem_proced_w;
			
	for r_c01_w in C01() loop
		begin
			
			ie_grupo_material_w 	:= 'S';
			ie_estrut_mat_w			:= 'S';
			ie_grupo_serv_w			:= 'S';
			ie_grupo_contrato_w		:= 'S';
			
			if (r_c01_w.nr_seq_grupo_material IS NOT NULL AND r_c01_w.nr_seq_grupo_material::text <> '') then
				ie_grupo_material_w	:= pls_se_grupo_preco_material(r_c01_w.nr_seq_grupo_material, nr_seq_material_p);
			end if;
			
			if (r_c01_w.nr_seq_estrut_mat IS NOT NULL AND r_c01_w.nr_seq_estrut_mat::text <> '') then
				ie_estrut_mat_w	:= pls_obter_se_mat_estrutura(nr_seq_material_p, r_c01_w.nr_seq_estrut_mat);
			end if;
			
			if (r_c01_w.nr_seq_grupo_servico IS NOT NULL AND r_c01_w.nr_seq_grupo_servico::text <> '') then
			
				ie_grupo_serv_w	:= pls_se_grupo_preco_servico( r_c01_w.nr_seq_grupo_servico, cd_procedimento_p, ie_origem_proced_p);
			
			end if;
			
			if (r_c01_w.nr_seq_grupo_contrato IS NOT NULL AND r_c01_w.nr_seq_grupo_contrato::text <> '') then
			
				ie_grupo_contrato_w	:= pls_se_grupo_preco_contrato( r_c01_w.nr_seq_grupo_contrato, nr_seq_contrato_p, null);
			
			end if;
			
			if ( ie_grupo_material_w 	= 'S') and ( ie_estrut_mat_w	= 'S') and ( ie_grupo_serv_w	= 'S') and ( ie_grupo_contrato_w = 'S') then
				tx_adm_w := r_c01_w.tx_item;
				vl_fixo_w := r_c01_w.vl_fixo;
				nr_seq_regra_retorno_w := r_c01_w.nr_seq_regra;
			end if;
			
		end;
	end loop;
	
end if;

tx_adm_p 		:= tx_adm_w;
vl_fixo_p		:= vl_fixo_w;
nr_seq_regra_p	:= nr_seq_regra_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_taxa_adm_item ( cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_material_p bigint, nr_seq_prestador_exec_p bigint, nm_usuario_p text, ie_preco_p pls_plano.ie_preco%type, ie_tipo_segurado_p pls_segurado.ie_tipo_segurado%type, nr_seq_contrato_p pls_segurado.nr_seq_contrato%type, dt_validar_p timestamp, tx_adm_p INOUT bigint, vl_fixo_p INOUT pls_prestador_taxa_item.vl_fixo%type, nr_seq_regra_p INOUT pls_prestador_taxa_item.nr_sequencia%type) FROM PUBLIC;

