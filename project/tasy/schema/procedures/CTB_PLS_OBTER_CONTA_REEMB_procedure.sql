-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_pls_obter_conta_reemb ( cd_estabelecimento_p bigint, dt_referencia_p timestamp, ie_debito_credito_p text, ie_tipo_contratacao_p text, ie_preco_p text, ie_segmentacao_p text, ie_regulamentacao_p text, ie_participacao_p text, ie_tipo_beneficiario_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_tipo_despesa_p text, nr_seq_conta_p bigint, ie_tipo_segurado_p text, nr_seq_procedimento_p bigint, nr_seq_material_p bigint, ds_parametro_um_p text, ds_parametro_dois_p text, ds_parametro_tres_p text, nr_seq_regra_p INOUT bigint, cd_historico_p INOUT bigint, cd_conta_contabil_p INOUT text, cd_historico_copartic_p INOUT bigint, cd_conta_copartic_p INOUT text, nr_seq_grupo_ans_p INOUT bigint, cd_conta_glosa_p INOUT text, cd_historico_glosa_p INOUT bigint) AS $body$
DECLARE


nr_seq_regra_w			varchar(20);
cd_conta_contabil_w		varchar(20);
cd_historico_w			bigint;
cd_area_procedimento_w		bigint;
cd_especialidade_w		bigint;
cd_grupo_proc_w			bigint;
nr_seq_grupo_ans_w		bigint;
cd_conta_coparticipacao_w	varchar(20);
cd_historico_copartic_w		bigint;
nr_seq_conselho_w		bigint;
ie_tipo_guia_w			varchar(2);
nr_seq_tipo_atendimento_w	bigint;
ie_regime_internacao_w		varchar(1);
cd_medico_executor_w		varchar(10);
ie_tipo_desp_mat_w		varchar(2);
nr_seq_grupo_superior_w		bigint;
nr_seq_segurado_w		bigint;
nr_seq_plano_w			bigint;
nr_seq_sca_w			bigint;
ie_tipo_vinculo_operadora_w	varchar(2);
cd_conta_glosa_w		varchar(20);
cd_historico_glosa_w		bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		cd_conta_contabil,
		cd_historico,
		cd_conta_coparticipacao,
		cd_historico_copartic,
		cd_conta_glosa,
		cd_historico_glosa
	from	pls_regra_ctb_mensal_reemb
	where	cd_estabelecimento	= cd_estabelecimento_p
	and	dt_inicio_vigencia	<= dt_referencia_p
	and	dt_fim_vigencia		>= dt_referencia_p
	and (coalesce(ie_tipo_contratacao, coalesce(ie_tipo_contratacao_p,'0'))	= coalesce(ie_tipo_contratacao_p,'0'))
	and (coalesce(ie_debito_credito, coalesce(ie_debito_credito_p,'0'))	= coalesce(ie_debito_credito_p,'0'))
	and (coalesce(ie_preco, coalesce(ie_preco_p,'0')) 			= coalesce(ie_preco_p,'0'))
	and (coalesce(ie_segmentacao, coalesce(ie_segmentacao_p,'0'))		= coalesce(ie_segmentacao_p,'0'))
	and (coalesce(ie_regulamentacao, coalesce(ie_regulamentacao_p,'0'))	= coalesce(ie_regulamentacao_p,'0'))
	and (coalesce(ie_participacao, coalesce(ie_participacao_p,'0')) 	= coalesce(ie_participacao_p,'0'))
	and (coalesce(ie_tipo_beneficiario, coalesce(ie_tipo_beneficiario_p,'0')) = coalesce(ie_tipo_beneficiario_p,'0'))
	and (coalesce(nr_seq_grupo_ans,coalesce(nr_seq_grupo_superior_w,coalesce(nr_seq_grupo_ans_w,0))) 	= coalesce(nr_seq_grupo_superior_w,coalesce(nr_seq_grupo_ans_w,0)))
	and (coalesce(ie_tipo_segurado, coalesce(ie_tipo_segurado_p,'0'))	= coalesce(ie_tipo_segurado_p,'0'))
	and	((nr_seq_plano		= nr_seq_plano_w) 		or (coalesce(nr_seq_plano::text, '') = ''))
	and	((nr_seq_sca		= nr_seq_sca_w) 		or (coalesce(nr_seq_sca::text, '') = ''))
	and	((ie_tipo_vinculo_operadora = ie_tipo_vinculo_operadora_w) or (coalesce(ie_tipo_vinculo_operadora::text, '') = ''))
	order by	coalesce(nr_seq_plano,0),
			coalesce(nr_seq_sca,0),
			coalesce(ie_regulamentacao,' '),
			coalesce(ie_preco,' '),
			coalesce(ie_tipo_contratacao,' '),
			coalesce(ie_participacao,' '),
			coalesce(ie_tipo_beneficiario,' '),
			coalesce(ie_segmentacao,' '),
			coalesce(ie_debito_credito,' '),
			coalesce(ie_tipo_contratacao,' '),
			coalesce(ie_tipo_vinculo_operadora,' '),
			coalesce(cd_conta_contabil,' '),
			coalesce(dt_inicio_vigencia,clock_timestamp()),
			coalesce(dt_fim_vigencia,clock_timestamp()),
			coalesce(nr_sequencia,0);


BEGIN

select	a.ie_tipo_guia,
	a.nr_seq_tipo_atendimento,
	a.ie_regime_internacao,
	a.nr_seq_segurado,
	a.cd_medico_executor
into STRICT	ie_tipo_guia_w,
	nr_seq_tipo_atendimento_w,
	ie_regime_internacao_w,
	nr_seq_segurado_w,
	cd_medico_executor_w
from	pls_conta a
where	a.nr_sequencia	= nr_seq_conta_p;

if (coalesce(cd_medico_executor_w,'X') = 'X') then
	select	coalesce(max(cd_medico),'')
	into STRICT	cd_medico_executor_w
	from	pls_proc_participante
	where	nr_seq_conta_proc	= nr_seq_procedimento_p;
end if;

select	max(nr_seq_conselho)
into STRICT	nr_seq_conselho_w
from	pessoa_fisica
where	cd_pessoa_fisica	= cd_medico_executor_w;

if (coalesce(nr_seq_material_p,0) > 0) then
	select	coalesce(max(ie_tipo_despesa),'')
	into STRICT	ie_tipo_desp_mat_w
	from	pls_conta_mat
	where	nr_sequencia	= nr_seq_material_p;
end if;

select	pls_obter_grupo_ans(cd_procedimento_p, ie_origem_proced_p, nr_seq_conselho_w,
			nr_seq_tipo_atendimento_w, ie_tipo_guia_w, ie_regime_internacao_w,
			ie_tipo_desp_mat_w, 'G', cd_estabelecimento_p)
into STRICT	nr_seq_grupo_ans_w
;

select	max(nr_seq_grupo_superior)
into STRICT	nr_seq_grupo_superior_w
from	ans_grupo_despesa
where	nr_sequencia	= nr_seq_grupo_ans_w;

/*insert into log_xxxtasy values (sysdate, 'Wheb', 3099,
	'cd_estabelecimento_p= '	||chr(39)|| cd_estabelecimento_p 	||chr(39)|| ';dt_referencia_p= ' 	  ||chr(39)|| dt_referencia_p 		||chr(39)||
	';ie_debito_credito_p= '	||chr(39)|| ie_debito_credito_p 	||chr(39)|| ';ie_tipo_contratacao_p= '	  ||chr(39)|| ie_tipo_contratacao_p	||chr(39)||
	';ie_preco_p= ' 		||chr(39)|| ie_preco_p 			||chr(39)|| ';ie_segmentacao_p= '	  ||chr(39)|| ie_segmentacao_p		||chr(39)||
	';ie_regulamentacao_p= ' 	||chr(39)|| ie_regulamentacao_p 	||chr(39)|| ';ie_participacao_p= '	  ||chr(39)|| ie_participacao_p		||chr(39)||
	';ie_tipo_beneficiario_p= ' 	||chr(39)|| ie_tipo_beneficiario_p 	||chr(39)|| ';ie_tipo_desp_mat_w= '	  ||chr(39)|| ie_tipo_desp_mat_w	||chr(39)||
	';cd_procedimento_p= ' 		||chr(39)|| cd_procedimento_p 		||chr(39)|| ';ie_origem_proced_p= '	  ||chr(39)|| ie_origem_proced_p	||chr(39)||
	';ie_tipo_despesa_p= ' 		||chr(39)|| ie_tipo_despesa_p 		||chr(39)|| ';nr_seq_conta_p= '	   	  ||chr(39)|| nr_seq_conta_p		||chr(39)||
	';ie_tipo_segurado_p= ' 	||chr(39)|| ie_tipo_segurado_p 		||chr(39)|| ';nr_seq_grupo_superior_w= '  ||chr(39)|| nr_seq_grupo_superior_w 	||chr(39)||
	';nr_seq_conselho_w= ' 		||chr(39)|| nr_seq_conselho_w 		||chr(39)|| ';nr_seq_tipo_atendimento_w= '||chr(39)|| nr_seq_tipo_atendimento_w	||chr(39)||
	';ie_tipo_guia_w= ' 		||chr(39)|| ie_tipo_guia_w 		||chr(39)|| ';ie_regime_internacao_w= '   ||chr(39)|| ie_regime_internacao_w 	||chr(39)||
	';nr_seq_grupo_ans_w= ' 	||chr(39)|| nr_seq_grupo_ans_w 		||chr(39)|| ';nr_seq_sca_w='		  ||chr(39)|| nr_seq_sca_w 		||chr(39)||
	';nr_seq_plano_w='		||chr(39)|| nr_seq_plano_w		||chr(39)|| ';nr_seq_grupo_superior_w='   ||chr(39)|| nr_seq_grupo_superior_w 	||chr(39));
	commit;*/
if (coalesce(nr_seq_segurado_w,0) <> 0) then
	begin
	select	nr_seq_plano,
		ie_tipo_vinculo_operadora
	into STRICT	nr_seq_plano_w,
		ie_tipo_vinculo_operadora_w
	from	pls_segurado
	where	nr_sequencia = nr_seq_segurado_w;
	exception
	when others then
		nr_seq_plano_w			:= null;
		ie_tipo_vinculo_operadora_w	:= null;
	end;

	begin
	select	a.nr_seq_plano
	into STRICT	nr_seq_sca_w
	from	pls_sca_vinculo	a,
		pls_segurado	b
	where	a.nr_seq_segurado	= b.nr_sequencia
	and	b.nr_sequencia		= nr_seq_segurado_w;
	exception
	when others then
		nr_seq_sca_w	:= null;
	end;
end if;

open C01;
loop
fetch C01 into
	nr_seq_regra_w,
	cd_conta_contabil_w,
	cd_historico_w,
	cd_conta_coparticipacao_w,
	cd_historico_copartic_w,
	cd_conta_glosa_w,
	cd_historico_glosa_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
end loop;
close C01;

cd_conta_contabil_p	:= coalesce(cd_conta_contabil_w,'0');
nr_seq_regra_p		:= coalesce(nr_seq_regra_w,0);
cd_historico_p		:= coalesce(cd_historico_w,0);
cd_historico_copartic_p	:= cd_historico_copartic_w;
cd_conta_copartic_p	:= cd_conta_coparticipacao_w;
nr_seq_grupo_ans_p	:= coalesce(nr_seq_grupo_ans_w,0);
cd_conta_glosa_p	:= cd_conta_glosa_w;
cd_historico_glosa_p	:= coalesce(cd_historico_glosa_w,0);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_pls_obter_conta_reemb ( cd_estabelecimento_p bigint, dt_referencia_p timestamp, ie_debito_credito_p text, ie_tipo_contratacao_p text, ie_preco_p text, ie_segmentacao_p text, ie_regulamentacao_p text, ie_participacao_p text, ie_tipo_beneficiario_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_tipo_despesa_p text, nr_seq_conta_p bigint, ie_tipo_segurado_p text, nr_seq_procedimento_p bigint, nr_seq_material_p bigint, ds_parametro_um_p text, ds_parametro_dois_p text, ds_parametro_tres_p text, nr_seq_regra_p INOUT bigint, cd_historico_p INOUT bigint, cd_conta_contabil_p INOUT text, cd_historico_copartic_p INOUT bigint, cd_conta_copartic_p INOUT text, nr_seq_grupo_ans_p INOUT bigint, cd_conta_glosa_p INOUT text, cd_historico_glosa_p INOUT bigint) FROM PUBLIC;
