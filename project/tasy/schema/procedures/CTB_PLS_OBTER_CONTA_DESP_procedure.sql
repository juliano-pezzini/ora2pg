-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_pls_obter_conta_desp ( cd_estabelecimento_p bigint, dt_referencia_p timestamp, ie_debito_credito_p text, ie_tipo_contratacao_p text, ie_preco_p text, ie_segmentacao_p text, ie_regulamentacao_p text, ie_participacao_p text, ie_tipo_beneficiario_p text, ie_tipo_relacao_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_tipo_despesa_p text, nr_seq_conta_p bigint, ie_tipo_segurado_p text, nr_seq_material_p bigint, ie_tipo_vinculo_operadora_p text, nr_seq_segurado_p text, nr_seq_grupo_ans_p text, nr_seq_regra_p INOUT bigint, cd_historico_p INOUT bigint, cd_conta_contabil_p INOUT text, cd_historico_glosa_p INOUT bigint, cd_conta_glosa_p INOUT text, nr_seq_grupo_ans_out_p INOUT bigint) AS $body$
DECLARE


nr_seq_regra_w			varchar(20);
cd_conta_contabil_w		varchar(20);
cd_historico_w			bigint;
cd_area_procedimento_w		integer;
cd_especialidade_w		integer;
cd_grupo_proc_w			bigint;
nr_seq_grupo_ans_w		bigint;
cd_historico_glosa_w		bigint;
cd_conta_contab_glosa_w		varchar(20);
ie_tipo_guia_w			varchar(2);
ie_tipo_grupo_w			varchar(1);
nr_seq_tipo_atendimento_w	bigint;
cd_medico_executor_w		varchar(10);
ie_regime_internacao_w		varchar(1);
nr_seq_conselho_w		bigint;
ie_tipo_desp_mat_w		varchar(2);
nr_seq_prestador_exec_w		bigint;
nr_seq_grupo_superior_w		bigint;
nr_seq_plano_w			bigint;
nr_seq_sca_w			bigint;
ie_liminar_judicial_w		varchar(15);

C01 CURSOR FOR
	SELECT	nr_sequencia,
		cd_conta_contabil,
		cd_historico,
		cd_historico_glosa,
		cd_conta_glosa
	from	pls_regra_ctb_mensal_desp
	where	cd_estabelecimento		= cd_estabelecimento_p
	and	dt_inicio_vigencia		<= dt_referencia_p
	and	dt_fim_vigencia			>= dt_referencia_p
	and	((ie_tipo_contratacao = ie_tipo_contratacao_p) or (coalesce(ie_tipo_contratacao::text, '') = ''))
	and	((ie_debito_credito = ie_debito_credito_p) or (coalesce(ie_debito_credito::text, '') = ''))
	and	((ie_preco = ie_preco_p) or (coalesce(ie_preco::text, '') = ''))
	and	((ie_segmentacao = ie_segmentacao_p) or (coalesce(ie_segmentacao::text, '') = ''))
	and	((ie_regulamentacao = ie_regulamentacao_p) or (coalesce(ie_regulamentacao::text, '') = ''))
	and	((ie_participacao = ie_participacao_p) or (coalesce(ie_participacao::text, '') = ''))
	and	((ie_tipo_beneficiario = ie_tipo_beneficiario_p) or (coalesce(ie_tipo_beneficiario::text, '') = ''))
	and	((ie_tipo_segurado = ie_tipo_segurado_p) or (coalesce(ie_tipo_segurado::text, '') = ''))
	and	((ie_tipo_relacao = ie_tipo_relacao_p) or (coalesce(ie_tipo_relacao::text, '') = ''))
	and	((coalesce(nr_seq_grupo_ans,coalesce(nr_seq_grupo_superior_w,0)) 	= coalesce(nr_seq_grupo_superior_w,coalesce(nr_seq_grupo_ans_p,0))) or (coalesce(nr_seq_grupo_ans::text, '') = ''))
	and	((nr_seq_prestador = nr_seq_prestador_exec_w) or (coalesce(nr_seq_prestador::text, '') = ''))
	and	((ie_tipo_vinculo_operadora = ie_tipo_vinculo_operadora_p) or (coalesce(ie_tipo_vinculo_operadora::text, '') = ''))
	and	((nr_seq_plano = nr_seq_plano_w) or (coalesce(nr_seq_plano::text, '') = ''))
	and	((nr_seq_sca = nr_seq_sca_w) or (coalesce(nr_seq_sca::text, '') = ''))
	and	((ie_liminar_judicial 	= ie_liminar_judicial_w) or (coalesce(ie_liminar_judicial,'T') = 'T'))
	and	((ie_tipo_despesa = ie_tipo_despesa_p) or (coalesce(ie_tipo_despesa::text, '') = ''))
	order by	coalesce(nr_seq_plano,0),
			coalesce(nr_seq_sca,0),
			coalesce(nr_seq_grupo_ans,0),
			coalesce(ie_tipo_vinculo_operadora,'X') desc,
			coalesce(nr_seq_prestador,0),
			coalesce(ie_regulamentacao,'A'),
			coalesce(ie_preco,'A'),
			coalesce(ie_tipo_contratacao,'A'),
			coalesce(ie_participacao,'A'),
			coalesce(ie_tipo_beneficiario,'A'),
			coalesce(ie_segmentacao,'A'),
			coalesce(ie_tipo_relacao,'A'),
			coalesce(ie_debito_credito,'A'),
			coalesce(ie_tipo_contratacao,'A'),
			coalesce(ie_tipo_despesa,'0'),
			--nvl(cd_conta_contabil,'A'),
			coalesce(ie_liminar_judicial,'A'),
			coalesce(dt_inicio_vigencia,clock_timestamp()),
			coalesce(dt_fim_vigencia,clock_timestamp()),
			coalesce(nr_sequencia,0);


BEGIN

select	a.ie_tipo_guia,
	a.nr_seq_tipo_atendimento,
	a.cd_medico_executor,
	a.ie_regime_internacao,
	a.nr_seq_prestador_exec,
	(select CASE WHEN count(1)=0 THEN  'N'  ELSE 'S' END
	from 	pls_guia_liminar_judicial 	g
	where	g.nr_seq_guia 	= a.nr_seq_guia) ie_liminar_judicial
into STRICT	ie_tipo_guia_w,
	nr_seq_tipo_atendimento_w,
	cd_medico_executor_w,
	ie_regime_internacao_w,
	nr_seq_prestador_exec_w,
	ie_liminar_judicial_w
from	pls_conta a
where	nr_sequencia = nr_seq_conta_p;

select	max(nr_seq_conselho)
into STRICT	nr_seq_conselho_w
from	pessoa_fisica
where	cd_pessoa_fisica	= cd_medico_executor_w;

/*
select	pls_obter_grupo_ans(cd_procedimento_p, ie_origem_proced_p, nr_seq_conselho_w,
			nr_seq_tipo_atendimento_w, ie_tipo_guia_w, ie_regime_internacao_w,
			ie_tipo_desp_mat_w, 'G', nvl(cd_estabelecimento_p,0))
into	nr_seq_grupo_ans_w
from	dual;
*/
select	max(nr_seq_grupo_superior)
into STRICT	nr_seq_grupo_superior_w
from	ans_grupo_despesa
where	nr_sequencia	= nr_seq_grupo_ans_p;

if (coalesce(nr_seq_segurado_p,0) <> 0) then
	begin
	select	nr_seq_plano
	into STRICT	nr_seq_plano_w
	from	pls_segurado
	where	nr_sequencia = nr_seq_segurado_p;
	exception
	when others then
		nr_seq_plano_w	:= null;
	end;

	select	max(a.nr_seq_plano)
	into STRICT	nr_seq_sca_w
	from	pls_sca_vinculo	a,
		pls_segurado	b
	where	a.nr_seq_segurado	= b.nr_sequencia
	and	b.nr_sequencia		= nr_seq_segurado_p;
end if;

open C01;
loop
fetch C01 into
	nr_seq_regra_w,
	cd_conta_contabil_w,
	cd_historico_w,
	cd_historico_glosa_w,
	cd_conta_contab_glosa_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
end loop;
close C01;

cd_conta_contabil_p	:= coalesce(cd_conta_contabil_w,'0');
nr_seq_regra_p		:= coalesce(nr_seq_regra_w,0);
cd_historico_p		:= coalesce(cd_historico_w,0);
cd_historico_glosa_p	:= coalesce(cd_historico_glosa_w,0);
cd_conta_glosa_p	:= coalesce(cd_conta_contab_glosa_w,'0');
nr_seq_grupo_ans_out_p	:= coalesce(nr_seq_grupo_ans_w,0);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_pls_obter_conta_desp ( cd_estabelecimento_p bigint, dt_referencia_p timestamp, ie_debito_credito_p text, ie_tipo_contratacao_p text, ie_preco_p text, ie_segmentacao_p text, ie_regulamentacao_p text, ie_participacao_p text, ie_tipo_beneficiario_p text, ie_tipo_relacao_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_tipo_despesa_p text, nr_seq_conta_p bigint, ie_tipo_segurado_p text, nr_seq_material_p bigint, ie_tipo_vinculo_operadora_p text, nr_seq_segurado_p text, nr_seq_grupo_ans_p text, nr_seq_regra_p INOUT bigint, cd_historico_p INOUT bigint, cd_conta_contabil_p INOUT text, cd_historico_glosa_p INOUT bigint, cd_conta_glosa_p INOUT text, nr_seq_grupo_ans_out_p INOUT bigint) FROM PUBLIC;

