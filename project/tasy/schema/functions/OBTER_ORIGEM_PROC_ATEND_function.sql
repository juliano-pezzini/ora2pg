-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_origem_proc_atend ( nr_atendimento_p bigint, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE

 
cd_convenio_w		integer;
cd_categoria_w 		varchar(10);
ie_tipo_atend_w		smallint;
ie_tipo_conv_w		smallint;
ie_origem_proced_w	bigint;


BEGIN 
 
cd_convenio_w 	:= obter_convenio_atendimento(nr_atendimento_p);
cd_categoria_w 	:= obter_categoria_atendimento(nr_atendimento_p);
 
Select	ie_tipo_atendimento, 
	ie_tipo_convenio 
into STRICT	ie_tipo_atend_w, 
	ie_tipo_conv_w	 
from 	atendimento_paciente 
where 	nr_atendimento = nr_atendimento_p;
 
ie_origem_proced_w := obter_origem_proced_cat(cd_estabelecimento_p, ie_tipo_atend_w, ie_tipo_conv_w, cd_convenio_w, cd_categoria_w);
 
return	ie_origem_proced_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_origem_proc_atend ( nr_atendimento_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
