-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_proc_ge ( nr_seq_proc_interno_p bigint, nr_atendimento_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE

 
/* 
ie_opcao_p 
'P' = cd_procedimento 
"I" = ie_origem_proced 
*/
 
 
nr_seq_atecaco_w		bigint;
cd_convenio_w			integer;
cd_categoria_w			varchar(10);
cd_plano_w			varchar(10);
cd_tipo_acomodacao_w		smallint;
cd_procedimento_w		bigint;
ie_origem_proced_w		integer;			
 

BEGIN 
 
nr_seq_atecaco_w := Obter_Atecaco_atendimento(nr_atendimento_p);
 
select	cd_convenio, 
	cd_categoria, 
	cd_plano_convenio, 
	cd_tipo_acomodacao 
into STRICT	cd_convenio_w, 
	cd_categoria_w, 
	cd_plano_w, 
	cd_tipo_acomodacao_w 
from	atend_categoria_convenio 
where	nr_seq_interno = nr_seq_atecaco_w;
 
SELECT * FROM obter_proc_tab_interno_conv(nr_seq_proc_interno_p, wheb_usuario_pck.get_cd_estabelecimento, cd_convenio_w, cd_categoria_w, cd_plano_w, null, cd_procedimento_w, ie_origem_proced_w, null, clock_timestamp(), cd_tipo_acomodacao_w, null, null, null, null, null, null, null) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
 
					 
 
if (ie_opcao_p = 'P') then 
 
	return	cd_procedimento_w;
 
elsif (ie_opcao_p = 'I') then 
 
	return ie_origem_proced_w;
 
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_proc_ge ( nr_seq_proc_interno_p bigint, nr_atendimento_p bigint, ie_opcao_p text) FROM PUBLIC;
