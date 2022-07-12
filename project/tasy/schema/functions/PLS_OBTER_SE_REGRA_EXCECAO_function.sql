-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_regra_excecao ( nr_seq_ocorrencia_p bigint, nr_seq_requisicao_p bigint, nr_seq_guia_plano_p bigint, nr_seq_conta_p bigint, nr_seq_proc_p bigint, nr_seq_mat_p bigint, dt_emissao_p timestamp, ie_tipo_item_p bigint, nr_seq_prestador_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_material_p bigint, nr_seq_segurado_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


/* NÃO UTILIZAR MAIS ESSA FUNCTION, FOI CRIADA UMA PARA CADA AREA:
	- PLS_OBTER_SE_REGRA_EXCECAO_AUT
	- PLS_OBTER_SE_REGRA_EXCECAO_CON
	- PLS_OBTER_SE_REGRA_EXCECAO_EXE
*/
qt_ocorrencia_w			bigint;
qt_dias_w			bigint;
ie_porte_anestesico_w		varchar(1);
nr_seq_estrutura_w		bigint;
ds_retorno_w			varchar(1) := 'N';
cd_procedimento_w		bigint;
ie_origem_proced_w		integer;
ie_estrutura_w			varchar(1);
ie_porte_w			varchar(1);
cd_medico_executor_regra_w	varchar(10);
ie_medico_exec_solic_w		varchar(1);
nr_seq_proc_espec_w		bigint;
ie_oc_medico_exec_w		varchar(1);
ie_espec_solic_proc_w		varchar(1);
nr_seq_grupo_contrato_w		bigint;


BEGIN

ds_retorno_w	:= '';

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_regra_excecao ( nr_seq_ocorrencia_p bigint, nr_seq_requisicao_p bigint, nr_seq_guia_plano_p bigint, nr_seq_conta_p bigint, nr_seq_proc_p bigint, nr_seq_mat_p bigint, dt_emissao_p timestamp, ie_tipo_item_p bigint, nr_seq_prestador_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_material_p bigint, nr_seq_segurado_p bigint, nm_usuario_p text) FROM PUBLIC;

