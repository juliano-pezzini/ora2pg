-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE eup_verif_bloqueio_inf_conv_js ( cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, ie_tipo_atendimento_p bigint, cd_plano_p text, cd_carater_int_p text, ie_clinica_p bigint, nr_seq_classificacao_p bigint, cd_procedencia_p bigint, ie_bloqueia_guia_p INOUT text, ie_bloqueia_senha_p INOUT text, ie_bloqueia_plano_p INOUT text, ie_bloqueia_carteira_p INOUT text, ie_bloqueia_validade_p INOUT text, ie_bloqueia_usuario_p INOUT text) AS $body$
BEGIN
 
 
ie_bloqueia_guia_p := obter_se_exige_guia_senha(cd_convenio_p, ie_tipo_atendimento_p, 1,'G', cd_estabelecimento_p, cd_carater_int_p, ie_clinica_p, null, null, nr_seq_classificacao_p, null, cd_categoria_p, cd_plano_p, cd_procedencia_p);
 
ie_bloqueia_senha_p := obter_se_exige_guia_senha(cd_convenio_p, ie_tipo_atendimento_p, 1,'S', cd_estabelecimento_p, cd_carater_int_p, ie_clinica_p, null, null, nr_seq_classificacao_p, null,cd_categoria_p, cd_plano_p, cd_procedencia_p);
 
ie_bloqueia_plano_p := obter_se_exige_guia_senha(cd_convenio_p, ie_tipo_atendimento_p, 1, 'P', cd_estabelecimento_p, cd_carater_int_p, ie_clinica_p, null, null, nr_seq_classificacao_p, null, cd_categoria_p, cd_plano_p, cd_procedencia_p);
 
ie_bloqueia_carteira_p := obter_se_exige_guia_senha(cd_convenio_p, ie_tipo_atendimento_p, 1, 'C', cd_estabelecimento_p, cd_carater_int_p, ie_clinica_p, null, null, nr_seq_classificacao_p, null,cd_categoria_p, cd_plano_p, cd_procedencia_p);
 
ie_bloqueia_validade_p := obter_se_exige_guia_senha(cd_convenio_p, ie_tipo_atendimento_p, 1, 'V', cd_estabelecimento_p, cd_carater_int_p, ie_clinica_p, null, null, nr_seq_classificacao_p, null, cd_categoria_p, cd_plano_p, cd_procedencia_p);
 
ie_bloqueia_usuario_p := obter_se_exige_guia_senha(cd_convenio_p, ie_tipo_atendimento_p, 1, 'U', cd_estabelecimento_p, cd_carater_int_p, ie_clinica_p, null, null, nr_seq_classificacao_p, null, cd_categoria_p, cd_plano_p, cd_procedencia_p);
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE eup_verif_bloqueio_inf_conv_js ( cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, ie_tipo_atendimento_p bigint, cd_plano_p text, cd_carater_int_p text, ie_clinica_p bigint, nr_seq_classificacao_p bigint, cd_procedencia_p bigint, ie_bloqueia_guia_p INOUT text, ie_bloqueia_senha_p INOUT text, ie_bloqueia_plano_p INOUT text, ie_bloqueia_carteira_p INOUT text, ie_bloqueia_validade_p INOUT text, ie_bloqueia_usuario_p INOUT text) FROM PUBLIC;

