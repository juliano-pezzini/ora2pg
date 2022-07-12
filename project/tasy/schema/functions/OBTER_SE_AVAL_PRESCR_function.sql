-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_aval_prescr ( nr_prescricao_p bigint, nr_seq_avaliacao_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w		varchar(1) := 'N';
cd_pessoa_fisica_w	varchar(10);
			

BEGIN 
 
select	cd_pessoa_fisica 
into STRICT	cd_pessoa_fisica_w 
from	prescr_medica 
where 	nr_prescricao = nr_prescricao_p;
 
select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
into STRICT	ds_retorno_w 
from	MED_AVALIACAO_PACIENTE 
where	nr_sequencia = nr_seq_avaliacao_p 
and	nr_prescricao in (SELECT nr_prescricao from prescr_medica 
			where cd_pessoa_fisica = cd_pessoa_fisica_w);
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_aval_prescr ( nr_prescricao_p bigint, nr_seq_avaliacao_p bigint) FROM PUBLIC;

