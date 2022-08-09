-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_pls_obter_conta_repasse ( cd_estabelecimento_p bigint, dt_referencia_p timestamp, ie_debito_credito_p text, ie_tipo_contratacao_p text, ie_preco_p text, ie_segmentacao_p text, ie_regulamentacao_p text, ie_participacao_p text, ie_tipo_beneficiario_p text, ie_tipo_segurado_p text, cd_pessoa_fisica_p text, cd_cgc_p text, nr_seq_regra_p INOUT bigint, cd_historico_p INOUT bigint, cd_conta_contabil_p INOUT text, ie_tipo_movimento_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
	- Para movimentos dos tipo 'lançamentos adicionais', não é considerado o campo IE_TIPO_SEGURADO_P pois não há como obter esse campo a partir dos lançamentos adicionais.
-------------------------------------------------------------------------------------------------------------------
Referências:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_regra_w			pls_regra_ctb_mensal_venda.nr_sequencia%type;
cd_conta_contabil_w		pls_regra_ctb_mensal_venda.cd_conta_contabil%type;
cd_historico_w			pls_regra_ctb_mensal_venda.cd_historico%type;
ie_conta_pf_pj_w		pls_regra_ctb_mensal_venda.ie_conta_pf_pj%type;

c_regra CURSOR FOR
	SELECT	nr_sequencia,
		cd_conta_contabil,
		cd_historico,
		ie_conta_pf_pj
	from	pls_regra_ctb_mensal_venda
	where	cd_estabelecimento						= cd_estabelecimento_p
	and	dt_inicio_vigencia						<= dt_referencia_p
	and	coalesce(dt_fim_vigencia, dt_referencia_p)				>= dt_referencia_p
	and (coalesce(ie_tipo_contratacao,coalesce(ie_tipo_contratacao_p,'0'))	= coalesce(ie_tipo_contratacao_p,'0'))
	and (coalesce(ie_tipo_movimento,coalesce(ie_tipo_movimento_p,'0'))		= coalesce(ie_tipo_movimento_p,'0'))
	and (coalesce(ie_debito_credito,coalesce(ie_debito_credito_p,'0'))		= coalesce(ie_debito_credito_p,'0'))
	and (coalesce(ie_preco,coalesce(ie_preco_p,'0'))				= coalesce(ie_preco_p,'0'))
	and (coalesce(ie_segmentacao,coalesce(ie_segmentacao_p,'0'))			= coalesce(ie_segmentacao_p,'0'))
	and (coalesce(ie_regulamentacao,coalesce(ie_regulamentacao_p,'0'))		= coalesce(ie_regulamentacao_p,'0'))
	and (coalesce(ie_participacao,coalesce(ie_participacao_p,'0')) 		= coalesce(ie_participacao_p,'0'))
	and (coalesce(ie_tipo_beneficiario,coalesce(ie_tipo_beneficiario_p,'0'))	= coalesce(ie_tipo_beneficiario_p,'0'))
	and	((coalesce(ie_tipo_segurado,coalesce(ie_tipo_segurado_p,'0')) 		= coalesce(ie_tipo_segurado_p,'0'))
	or (coalesce(ie_tipo_movimento_p,'0')					= 'VA'))
	and (coalesce(coalesce(cd_pessoa_fisica,cd_pessoa_fisica_p),'0')		= coalesce(cd_pessoa_fisica_p,'0'))
	and (coalesce(coalesce(cd_cgc,cd_cgc_p),'0')					= coalesce(cd_cgc_p,'0'))
	order by
		coalesce(ie_tipo_movimento,'IM'),
		coalesce(ie_regulamentacao,'A'),
		coalesce(ie_preco,'A'),
		coalesce(ie_tipo_contratacao,'A'),
		coalesce(ie_participacao,'A'),
		coalesce(ie_tipo_beneficiario,'A'),
		coalesce(ie_segmentacao,'A'),
		coalesce(ie_debito_credito,'A'),
		coalesce(ie_tipo_contratacao,'A'),
		coalesce(cd_conta_contabil,'A'),
		coalesce(cd_pessoa_fisica, ' '),
		coalesce(cd_cgc, ' '),
		coalesce(dt_inicio_vigencia,clock_timestamp()),
		coalesce(dt_fim_vigencia,clock_timestamp()),
		coalesce(nr_sequencia,0),
		coalesce(ie_conta_pf_pj, 'N');


BEGIN
open c_regra;
loop
fetch c_regra into
	nr_seq_regra_w,
	cd_conta_contabil_w,
	cd_historico_w,
	ie_conta_pf_pj_w;
EXIT WHEN NOT FOUND; /* apply on c_regra */
end loop;
close c_regra;

if ( coalesce(ie_conta_pf_pj_w, 'N') = 'S' ) then
	if ( coalesce(cd_cgc_p, 'n/a') <> 'n/a' ) then
		cd_conta_contabil_p := obter_conta_contab_pj( obter_empresa_estab(cd_estabelecimento_p), cd_estabelecimento_p, cd_cgc_p, 'P' , dt_referencia_p );
	elsif ( coalesce(cd_pessoa_fisica_p, 'n/a') <> 'n/a' ) then
		cd_conta_contabil_p := obter_conta_contab_pf( obter_empresa_estab(cd_estabelecimento_p), cd_pessoa_fisica_p, 'P', dt_referencia_p );
	end if;
end if;

if ( coalesce(cd_conta_contabil_p, 'n/a') = 'n/a' ) then
	cd_conta_contabil_p	:= coalesce(cd_conta_contabil_w,'0');
end if;

nr_seq_regra_p		:= coalesce(nr_seq_regra_w,0);
cd_historico_p		:= coalesce(cd_historico_w,0);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_pls_obter_conta_repasse ( cd_estabelecimento_p bigint, dt_referencia_p timestamp, ie_debito_credito_p text, ie_tipo_contratacao_p text, ie_preco_p text, ie_segmentacao_p text, ie_regulamentacao_p text, ie_participacao_p text, ie_tipo_beneficiario_p text, ie_tipo_segurado_p text, cd_pessoa_fisica_p text, cd_cgc_p text, nr_seq_regra_p INOUT bigint, cd_historico_p INOUT bigint, cd_conta_contabil_p INOUT text, ie_tipo_movimento_p text) FROM PUBLIC;
