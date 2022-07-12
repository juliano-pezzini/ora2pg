-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dt_vigencia_material ( cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, dt_vigencia_p timestamp, cd_material_p bigint, cd_tipo_acomodacao_p bigint, ie_tipo_atendimento_p bigint, cd_setor_atendimento_p bigint, cd_cgc_fornecedor_p text, qt_idade_p bigint, nr_sequencia_p bigint, opcao_p text) RETURNS timestamp AS $body$
DECLARE

 
vl_material_w		double precision 	:= 0;	
dt_ult_vigencia_w	timestamp;
cd_tab_preco_mat_w	bigint;
ie_origem_preco_w	varchar(05);
dt_retorno_w		timestamp;
nr_seq_bras_preco_w	bigint;
nr_seq_mat_bras_w	bigint;
nr_seq_conv_bras_w	bigint;
nr_seq_conv_simpro_w	bigint;
nr_seq_mat_simpro_w	bigint;
nr_seq_simpro_preco_w	bigint;
nr_seq_ajuste_mat_w	bigint;

 
/* DV - Data Vigência*/
 
 

BEGIN 
 
SELECT * FROM define_preco_material( 
		cd_estabelecimento_p, cd_convenio_p, cd_categoria_p, dt_vigencia_p, cd_material_p, cd_tipo_acomodacao_p, ie_tipo_atendimento_p, cd_setor_atendimento_p, cd_cgc_fornecedor_p, qt_idade_p, nr_sequencia_p, null, null, null, null, null, null, null, null, vl_material_w, dt_ult_vigencia_w, cd_tab_preco_mat_w, ie_origem_preco_w, nr_seq_bras_preco_w, nr_seq_mat_bras_w, nr_seq_conv_bras_w, nr_seq_conv_simpro_w, nr_seq_mat_simpro_w, nr_seq_simpro_preco_w, nr_seq_ajuste_mat_w) INTO STRICT vl_material_w, dt_ult_vigencia_w, cd_tab_preco_mat_w, ie_origem_preco_w, nr_seq_bras_preco_w, nr_seq_mat_bras_w, nr_seq_conv_bras_w, nr_seq_conv_simpro_w, nr_seq_mat_simpro_w, nr_seq_simpro_preco_w, nr_seq_ajuste_mat_w;
 
if (opcao_p = 'DV') then 
	dt_retorno_w	:= dt_ult_vigencia_w;
end if;
 
Return dt_retorno_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dt_vigencia_material ( cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, dt_vigencia_p timestamp, cd_material_p bigint, cd_tipo_acomodacao_p bigint, ie_tipo_atendimento_p bigint, cd_setor_atendimento_p bigint, cd_cgc_fornecedor_p text, qt_idade_p bigint, nr_sequencia_p bigint, opcao_p text) FROM PUBLIC;

