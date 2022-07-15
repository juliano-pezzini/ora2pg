-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE define_glosa_material ( cd_estabelecimento_p bigint, cd_material_p bigint, dt_referencia_p timestamp, cd_convenio_p bigint, cd_categoria_p text, cd_tipo_acomodacao_p bigint, ie_tipo_atendimento_p bigint, cd_setor_atendimento_p bigint, qt_idade_p bigint, cd_proc_referencia_p bigint, ie_origem_proced_p bigint, nr_sequencia_p bigint, nr_seq_proc_interno_p bigint, cd_plano_p text, dt_entrada_p timestamp, nr_seq_origem_p bigint, nr_seq_cobertura_p bigint, qt_dias_internacao_p bigint, cd_usuario_convenio_P text, ie_glosa_p INOUT text, pr_glosa_p INOUT bigint, vl_glosa_p INOUT bigint, cd_motivo_exc_conta_p INOUT bigint, ie_autor_particular_p INOUT text, cd_convenio_glosa_p INOUT bigint, cd_categoria_glosa_p INOUT text, nr_seq_regra_ajuste_p INOUT bigint) AS $body$
DECLARE


tx_ajuste_w		double precision	:= 0;
vl_negociado_w		double precision	:= 0;
ie_preco_informado_w   	varchar(1)		:= '';
ie_glosa_w   		varchar(1)		:= 'L';
tx_brasindice_pfb_w	REGRA_AJUSTE_MATERIAL.TX_BRASINDICE_PFB%type    := 0; -- number(15,4)	:= 0;
tx_brasindice_pmc_w	CONVENIO_BRASINDICE.TX_BRASINDICE_PMC%type      := 0;--number(15,4)	:= 0;
tx_pmc_neg_w		CONVENIO_BRASINDICE.TX_PMC_NEG%type             := 0;--number(15,4)	:= 0;
tx_pmc_pos_w		CONVENIO_BRASINDICE.TX_PMC_POS%type             := 0;--number(15,4)	:= 0;
tx_afaturar_w		double precision	:= 0;
tx_simpro_pfb_w		double precision;
tx_simpro_pmc_w		double precision;
ie_origem_preco_w		varchar(05);
ie_precedencia_w		varchar(01);
pr_glosa_w		double precision	:= 0;
vl_glosa_w		double precision	:= 0;
cd_tabela_preco_w		bigint;
cd_motivo_exc_conta_w	bigint;
nr_seq_regra_w		bigint;
ie_autor_particular_w	varchar(1)	:= 'N';
cd_convenio_glosa_ww	integer:= 0;
cd_categoria_glosa_ww	varchar(10):= ' ';
nr_atendimento_w		bigint;
ie_atend_retorno_w		varchar(01);
tx_pfb_neg_w		CONVENIO_BRASINDICE.TX_PFB_NEG%type     := 0;--number(15,4)	:= 0;
tx_pfb_pos_w		CONVENIO_BRASINDICE.TX_PFB_POS%type     := 0;--number(15,4)	:= 0;
vl_neutro_w		varchar(10);
tx_simpro_pos_pfb_w	double precision;
tx_simpro_neg_pfb_w	double precision;
tx_simpro_pos_pmc_w	double precision;
tx_simpro_neg_pmc_w	double precision;
nr_seq_regra_lanc_w	bigint;
nr_seq_lib_dieta_conv_w	bigint;
ie_clinica_w		integer;
ie_estrangeiro_w		varchar(1);
dt_material_w			timestamp;
cd_pessoa_fisica_w		atendimento_paciente.cd_pessoa_fisica%type;	
nr_seq_classif_atend_w		atendimento_paciente.nr_seq_classificacao%type;


BEGIN

if (coalesce(nr_sequencia_p,0) > 0) then
	select	coalesce(max(nr_atendimento),0),
		coalesce(max(nr_seq_regra_lanc),0),
			max(dt_atendimento)
	into STRICT	nr_atendimento_w,
		nr_seq_regra_lanc_w,
			dt_material_w
	from	material_atend_paciente
	where	nr_sequencia	= nr_sequencia_p;
	
	if (coalesce(nr_atendimento_w,0) > 0) then
		select	CASE WHEN coalesce(nr_atend_original::text, '') = '' THEN  'N'  ELSE 'S' END ,
				cd_pessoa_fisica
		into STRICT	ie_atend_retorno_w,
				cd_pessoa_fisica_w
		from	atendimento_paciente
		where	nr_atendimento = nr_atendimento_w;
		
		select	max(ie_clinica),
			max(nr_seq_classificacao)
		into STRICT	ie_clinica_w,
			nr_seq_classif_atend_w
		from	atendimento_paciente
		where	nr_atendimento = nr_atendimento_w;
		
		select	coalesce(max((obter_dados_categ_conv(nr_atendimento_w,'LDC'))::numeric ),0)
		into STRICT	nr_seq_lib_dieta_conv_w
		;		
	end if;
	
end if;

/* SE PESSOA ESTRANGEIRA, RESIDENTE OU NACIONAL*/

if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
	ie_estrangeiro_w := obter_se_residente_estrangeiro(	cd_pessoa_fisica_w,
														cd_estabelecimento_p, 
														dt_material_w);
end if;
													
SELECT * FROM obter_regra_ajuste_mat(cd_estabelecimento_p, cd_convenio_p, cd_categoria_p, cd_material_p, dt_referencia_p, cd_tipo_acomodacao_p, ie_tipo_atendimento_p, cd_setor_atendimento_p, qt_idade_p, nr_sequencia_p, cd_plano_p, cd_proc_referencia_p, ie_origem_proced_p, nr_seq_proc_interno_p, dt_entrada_p, tx_ajuste_w, vl_negociado_w, ie_preco_informado_w, ie_glosa_w, tx_brasindice_pfb_w, tx_brasindice_pmc_w, tx_pmc_neg_w, tx_pmc_pos_w, tx_afaturar_w, tx_simpro_pfb_w, tx_simpro_pmc_w, ie_origem_preco_w, ie_precedencia_w, pr_glosa_w, vl_glosa_w, cd_tabela_preco_w, cd_motivo_exc_conta_w, nr_seq_regra_w, ie_autor_particular_w, cd_convenio_glosa_ww, cd_categoria_glosa_ww, ie_atend_retorno_w, tx_pfb_neg_w, tx_pfb_pos_w, vl_neutro_w, tx_simpro_pos_pfb_w, tx_simpro_neg_pfb_w, tx_simpro_pos_pmc_w, tx_simpro_neg_pmc_w, nr_seq_origem_p, nr_seq_cobertura_p, qt_dias_internacao_p, nr_seq_regra_lanc_w, nr_seq_lib_dieta_conv_w, ie_clinica_w, cd_usuario_convenio_p, nr_seq_classif_atend_w, ie_estrangeiro_w) INTO STRICT tx_ajuste_w, vl_negociado_w, ie_preco_informado_w, ie_glosa_w, tx_brasindice_pfb_w, tx_brasindice_pmc_w, tx_pmc_neg_w, tx_pmc_pos_w, tx_afaturar_w, tx_simpro_pfb_w, tx_simpro_pmc_w, ie_origem_preco_w, ie_precedencia_w, pr_glosa_w, vl_glosa_w, cd_tabela_preco_w, cd_motivo_exc_conta_w, nr_seq_regra_w, ie_autor_particular_w, cd_convenio_glosa_ww, cd_categoria_glosa_ww, tx_pfb_neg_w, tx_pfb_pos_w, vl_neutro_w, tx_simpro_pos_pfb_w, tx_simpro_neg_pfb_w, tx_simpro_pos_pmc_w, tx_simpro_neg_pmc_w;

ie_glosa_p 			:= ie_glosa_w;
pr_glosa_p 			:= pr_glosa_w;
vl_glosa_p			:= vl_glosa_w;
cd_motivo_exc_conta_p	:= cd_motivo_exc_conta_w;
ie_autor_particular_p	:=	ie_autor_particular_w;
cd_convenio_glosa_p		:= cd_convenio_glosa_ww;
cd_categoria_glosa_p		:= cd_categoria_glosa_ww;
nr_seq_regra_ajuste_p		:= nr_seq_regra_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE define_glosa_material ( cd_estabelecimento_p bigint, cd_material_p bigint, dt_referencia_p timestamp, cd_convenio_p bigint, cd_categoria_p text, cd_tipo_acomodacao_p bigint, ie_tipo_atendimento_p bigint, cd_setor_atendimento_p bigint, qt_idade_p bigint, cd_proc_referencia_p bigint, ie_origem_proced_p bigint, nr_sequencia_p bigint, nr_seq_proc_interno_p bigint, cd_plano_p text, dt_entrada_p timestamp, nr_seq_origem_p bigint, nr_seq_cobertura_p bigint, qt_dias_internacao_p bigint, cd_usuario_convenio_P text, ie_glosa_p INOUT text, pr_glosa_p INOUT bigint, vl_glosa_p INOUT bigint, cd_motivo_exc_conta_p INOUT bigint, ie_autor_particular_p INOUT text, cd_convenio_glosa_p INOUT bigint, cd_categoria_glosa_p INOUT text, nr_seq_regra_ajuste_p INOUT bigint) FROM PUBLIC;

