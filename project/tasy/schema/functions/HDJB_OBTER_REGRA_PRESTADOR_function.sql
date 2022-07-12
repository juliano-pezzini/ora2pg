-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hdjb_obter_regra_prestador ( ie_tipo_atendimento_p bigint, ie_tipo_guia_p text, nr_seq_protocolo_p bigint, cd_medico_resp_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
cd_convenio_w		integer;
cd_estabelecimento_w	smallint;


BEGIN

select 	cd_estabelecimento,
	cd_convenio
into STRICT	cd_estabelecimento_w,
	cd_convenio_w
from 	protocolo_convenio
where 	nr_seq_protocolo = nr_seq_protocolo_p;


/*	Substituído o Bloco do IF abaixo pela linha abaixo do bloco, pois segundo Victor HDJB, a regra é buscar 1° do cadastro de Convênio o médico
se não encontrar lá trazer o código genérico 00050001, OS 88412  10-04-2008 Fabrício*/
/*
if	(ie_tipo_atendimento_p = 7) or
	(ie_tipo_guia_p = 'A') then

	ds_retorno_w:=	'00050001';

elsif	(ie_tipo_guia_p in ('I','IC','IO','AI')) then

	ds_retorno_w:= lpad(nvl(substr(obter_medico_convenio(cd_estabelecimento_w,cd_medico_resp_p,cd_convenio_w),1,8),'00050001'),8,0);

end if;
*/
ds_retorno_w:= lpad(coalesce(substr(obter_medico_convenio(cd_estabelecimento_w,cd_medico_resp_p,cd_convenio_w, null, null, null, null,null,null,null,null),1,8),'00050001'),8,0);


return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hdjb_obter_regra_prestador ( ie_tipo_atendimento_p bigint, ie_tipo_guia_p text, nr_seq_protocolo_p bigint, cd_medico_resp_p text) FROM PUBLIC;

