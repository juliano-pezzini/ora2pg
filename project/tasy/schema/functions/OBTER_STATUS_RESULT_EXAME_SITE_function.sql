-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_result_exame_site (nr_prescricao_p bigint, nr_sequencia_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
 
ie_restringe_result_w	varchar(1);
ds_status_w		varchar(15);
ie_retorno_w		varchar(1);

BEGIN
 
ie_retorno_w := 'L';
 
ds_status_w := obter_ds_status_result_exame(nr_prescricao_p, nr_sequencia_p,nm_usuario_p,cd_estabelecimento_p);
 
if (ds_status_w = obter_desc_expressao(347424)) then --verificar se está bloqueado 
 
	ie_restringe_result_w := obter_se_exame_bloqueado(nr_sequencia_p, nr_prescricao_p);
 
	if (ie_restringe_result_w = 'S') then 
		ie_retorno_w := 'B';
	else 
		ie_retorno_w := 'P';
	end if;
end if;
 
return	ie_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_result_exame_site (nr_prescricao_p bigint, nr_sequencia_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
