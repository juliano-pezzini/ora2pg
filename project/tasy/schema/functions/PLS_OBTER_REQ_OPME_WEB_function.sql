-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_req_opme_web ( nr_seq_item_p bigint, nr_seq_requisicao_p bigint, ie_origem_proced_p bigint, ie_tipo_p text) RETURNS varchar AS $body$
DECLARE

 
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade:  Obter regra para exigir o prestador informar informações de um determinado material/medicamento 
---------------------------------------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [ ] Tasy (Delphi/Java) [ x ] Portal [ ] Relatórios [ ] Outros: 
 ---------------------------------------------------------------------------------------------------------------------------------------------------- 
Pontos de atenção:  
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
				 
	IE_TIPO_P: 
	P - Procedimento 
	M - Material 
*/ 
 
ds_retorno_w			varchar(1) := 'N';
ie_origem_w			bigint;
cd_area_w			bigint;
cd_especialidade_w		bigint;
cd_grupo_w			bigint;
nr_seq_contrato_w			bigint;
ie_tipo_guia_w			varchar(2);

C01 CURSOR FOR 
	SELECT ds_retorno 
	from (	SELECT 'S' ds_retorno, 
				cd_procedimento, 
				cd_grupo_proc, 
				cd_especialidade, 
				cd_area_procedimento, 
				nr_seq_material 
			from  pls_regra_inform_mat 
			where  coalesce(nr_seq_material,coalesce(nr_seq_item_p,0))		= coalesce(nr_seq_item_p,0) 
			and   coalesce(nr_seq_contrato, coalesce(nr_seq_contrato_w,0))    	= coalesce(nr_seq_contrato_w,0) 
			and	coalesce(ie_tipo_guia, coalesce(ie_tipo_guia_w,0))		= coalesce(ie_tipo_guia_w,0) 
			and	coalesce(cd_procedimento,coalesce(nr_seq_item_p,0))    	= coalesce(nr_seq_item_p,0) 
			and   coalesce(cd_grupo_proc,coalesce(cd_grupo_w,0))         	= coalesce(cd_grupo_w,0) 
			and   coalesce(cd_especialidade, coalesce(cd_especialidade_w,0))   	= coalesce(cd_especialidade_w,0) 
			and	coalesce(ie_origem_proced, coalesce(ie_origem_w,0))   		= coalesce(ie_origem_w,0) 
			and   coalesce(cd_area_procedimento, coalesce(cd_area_w,0))     	= coalesce(cd_area_w,0) 
			and   coalesce(nr_seq_contrato, coalesce(nr_seq_contrato_w,0))    	= coalesce(nr_seq_contrato_w,0) 
			and	coalesce(ie_tipo_guia, coalesce(ie_tipo_guia_w,0))		= coalesce(ie_tipo_guia_w,0) 
			and	clock_timestamp() between dt_inicio_vigencia and coalesce(dt_fim_vigencia, clock_timestamp()) 
			and (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento and (pls_obter_se_controle_estab('RE') = 'S')) 
			
union all
 
			select 'S' ds_retorno, 
				cd_procedimento, 
				cd_grupo_proc, 
				cd_especialidade, 
				cd_area_procedimento, 
				nr_seq_material 
			from  pls_regra_inform_mat 
			where  coalesce(nr_seq_material,coalesce(nr_seq_item_p,0))		= coalesce(nr_seq_item_p,0) 
			and   coalesce(nr_seq_contrato, coalesce(nr_seq_contrato_w,0))    	= coalesce(nr_seq_contrato_w,0) 
			and	coalesce(ie_tipo_guia, coalesce(ie_tipo_guia_w,0))		= coalesce(ie_tipo_guia_w,0) 
			and	coalesce(cd_procedimento,coalesce(nr_seq_item_p,0))    	= coalesce(nr_seq_item_p,0) 
			and   coalesce(cd_grupo_proc,coalesce(cd_grupo_w,0))         	= coalesce(cd_grupo_w,0) 
			and   coalesce(cd_especialidade, coalesce(cd_especialidade_w,0))   	= coalesce(cd_especialidade_w,0) 
			and	coalesce(ie_origem_proced, coalesce(ie_origem_w,0))   		= coalesce(ie_origem_w,0) 
			and   coalesce(cd_area_procedimento, coalesce(cd_area_w,0))     	= coalesce(cd_area_w,0) 
			and   coalesce(nr_seq_contrato, coalesce(nr_seq_contrato_w,0))    	= coalesce(nr_seq_contrato_w,0) 
			and	coalesce(ie_tipo_guia, coalesce(ie_tipo_guia_w,0))		= coalesce(ie_tipo_guia_w,0) 
			and	clock_timestamp() between dt_inicio_vigencia and coalesce(dt_fim_vigencia, clock_timestamp()) 
			and (pls_obter_se_controle_estab('RE') = 'N')) alias71 
	order by		 
		coalesce(cd_procedimento,0), 
		coalesce(cd_grupo_proc,0), 
		coalesce(cd_especialidade,0), 
		coalesce(cd_area_procedimento,0), 
		coalesce(nr_seq_material,0);

	 

BEGIN 
 
select	pls_obter_dados_segurado(nr_seq_segurado, 'NC'), 
	ie_tipo_guia 
into STRICT	nr_seq_contrato_w, 
	ie_tipo_guia_w 
from 	pls_requisicao 
where 	nr_sequencia = nr_seq_requisicao_p;
 
if (ie_tipo_p = 'P') then	 
	SELECT * FROM pls_obter_estrut_proc(nr_seq_item_p, ie_origem_proced_p, cd_area_w, cd_especialidade_w, cd_grupo_w, ie_origem_w) INTO STRICT cd_area_w, cd_especialidade_w, cd_grupo_w, ie_origem_w;
end if;
 
 
open C01;
loop 
fetch C01 into	 
	ds_retorno_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
		ds_retorno_w := 'S';
	end;
end loop;
close C01;
 
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_req_opme_web ( nr_seq_item_p bigint, nr_seq_requisicao_p bigint, ie_origem_proced_p bigint, ie_tipo_p text) FROM PUBLIC;
