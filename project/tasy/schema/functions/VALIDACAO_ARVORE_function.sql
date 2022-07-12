-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION validacao_arvore ( nr_sequencia_p bigint, ie_medicamento_p text, cd_medico_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint) RETURNS varchar AS $body$
DECLARE

 
ie_retorno_w varchar(1);
			

BEGIN 
 
select CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
into STRICT 	ie_retorno_w	 
from med_medic_padrao 
where nr_seq_grupo_medic = nr_sequencia_p 
and ((ie_medicamento_p = 'U' and cd_medico = cd_medico_p) or  
   (ie_medicamento_p = 'I' and	((cd_estabelecimento = cd_estabelecimento_p 
and coalesce(cd_medico::text, '') = '') or (coalesce(cd_estabelecimento::text, '') = '' and coalesce(cd_medico::text, '') = '')))) 
and ((ie_medicamento_p = 'I' and obter_se_mostra_medic_espec(nr_sequencia, obter_especialidade_medico(cd_medico_p, 'C')) = 'S') or (ie_medicamento_p = 'U')) 
and ((ie_medicamento_p = 'I' and obter_se_mostra_medic_perfil(nr_sequencia, cd_perfil_p) = 'S') or (ie_medicamento_p = 'U')) 
and ie_situacao = 'A';
 
return	ie_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION validacao_arvore ( nr_sequencia_p bigint, ie_medicamento_p text, cd_medico_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint) FROM PUBLIC;

