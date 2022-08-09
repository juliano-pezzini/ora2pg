-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE aval_pre_anest_atribdblclick ( nr_atendimento_p bigint, cd_estabelecimento_p bigint, cd_convenio_p INOUT bigint, ie_origem_proced_p INOUT bigint) AS $body$
DECLARE

 
cd_convenio_w		integer	:= 0;
cd_categoria_w		varchar(10);
ie_tipo_atendimento_w	smallint;
ie_tipo_convenio_w		smallint;
ie_origem_proced_w	bigint	:= 1;


BEGIN 
 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then 
 
	cd_convenio_w	:= obter_convenio_atendimento(nr_atendimento_p);
	cd_categoria_w	:= obter_categoria_atendimento(nr_atendimento_p);
	 
	select	ie_tipo_atendimento, 
		ie_tipo_convenio 
	into STRICT	ie_tipo_atendimento_w, 
		ie_tipo_convenio_w 
	from	atendimento_paciente 
	where	nr_atendimento = nr_atendimento_p;
 
	ie_origem_proced_w	:= obter_Origem_Proced_Cat(cd_estabelecimento_p, ie_tipo_atendimento_w, ie_tipo_convenio_w, cd_convenio_w, cd_categoria_w);
 
end if;
 
cd_convenio_p		:= cd_convenio_w;
ie_origem_proced_p	:= ie_origem_proced_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE aval_pre_anest_atribdblclick ( nr_atendimento_p bigint, cd_estabelecimento_p bigint, cd_convenio_p INOUT bigint, ie_origem_proced_p INOUT bigint) FROM PUBLIC;
