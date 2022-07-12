-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_considera_sae (cd_setor_atendimento_p bigint, cd_pessoa_fisica_p text, nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
ie_considerar_sae_w 		varchar(1);
qt_idade_w			varchar(10);
ie_paciente_isolamento_w	varchar(1);
cd_tipo_acomodacao_w		bigint;
cd_convenio_w			convenio.cd_convenio%type;
nr_seq_classif_w		atendimento_paciente.nr_seq_classificacao%type;
ie_dependente_w			pessoa_fisica.ie_dependente%type;
nr_Seq_interno_w		atend_categoria_convenio.nr_Seq_interno%type;
cd_categoria_w			atend_categoria_convenio.cd_categoria%type;
cd_plano_convenio_w		atend_categoria_convenio.cd_plano_convenio%type;
ie_tipo_atendimento_w	atendimento_paciente.ie_tipo_atendimento%type;


BEGIN 
 
select	obter_idade_pf(cd_pessoa_fisica_p,clock_timestamp(),'A'), 
	obter_dados_pf(cd_pessoa_fisica_p, 'DP') 
into STRICT	qt_idade_w, 
	ie_dependente_w
;
 
select obter_se_pac_isolamento(nr_atendimento_p), 
	obter_dados_categ_conv(nr_atendimento_p,'A'), 
	Obter_Atecaco_atendimento(nr_atendimento_p), 
	obter_classif_atendimento(nr_atendimento_p), 
	Obter_Tipo_Atendimento(nr_atendimento_p) 
into STRICT	ie_paciente_isolamento_w, 
	cd_tipo_acomodacao_w, 
	nr_Seq_interno_w, 
	nr_seq_classif_w, 
	ie_tipo_atendimento_w
;
 
select	max(cd_convenio), 
		max(cd_categoria), 
		max(cd_plano_convenio) 
into STRICT	cd_convenio_w, 
		cd_categoria_w, 
		cd_plano_convenio_w 
from	atend_categoria_convenio 
where	nr_seq_interno = nr_Seq_interno_w 
and		nr_atendimento = nr_atendimento_p;
 
 
select	coalesce(max(ie_considerar_sae),'N') 
into STRICT	ie_considerar_sae_w 
from	regra_acompanhante_dieta 
where 	((cd_setor_atendimento = cd_setor_atendimento_p) or (coalesce(cd_setor_atendimento::text, '') = '')) 
and	((cd_tipo_acomodacao = cd_tipo_acomodacao_w) or (coalesce(cd_tipo_acomodacao::text, '') = '')) 
and	((qt_idade_w between coalesce(qt_idade_de,0) and coalesce(qt_idade_ate,999)) or ((coalesce(ie_pac_deficiente, 'N')) = 'S' and (ie_dependente_w = 'S'))) 
and (ie_paciente_isolamento_w = ie_isolado) 
and	((cd_convenio = coalesce(cd_convenio_w, 0)) or (coalesce(cd_convenio::text, '') = '')) 
and		((cd_categoria = coalesce(cd_categoria_w, 'XPTO')) or (coalesce(cd_categoria::text, '') = '')) 
and		((cd_plano_convenio = coalesce(cd_plano_convenio_w, 'XPTO')) or (coalesce(cd_plano_convenio::text, '') = '')) 
and		((ie_tipo_atendimento = coalesce(ie_tipo_atendimento_w, 0)) or (coalesce(ie_tipo_atendimento::text, '') = '')) 
and ((nr_seq_classificacao = coalesce(nr_seq_classif_w, 0)) or (coalesce(nr_seq_classificacao::text, '') = ''));
 
return	ie_considerar_sae_w;
 
end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_considera_sae (cd_setor_atendimento_p bigint, cd_pessoa_fisica_p text, nr_atendimento_p bigint) FROM PUBLIC;

