-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_particular_proced ( cd_Estabelecimento_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_tipo_atendimento_p bigint, cd_medico_p text, ie_clinica_p bigint, nr_seq_proc_interno_p bigint, nr_seq_exame_p bigint) RETURNS bigint AS $body$
DECLARE

 
cd_convenio_w		integer;			
cd_categoria_w		varchar(10);
vl_procedimento_w	double precision;
vl_Retorno_w		double precision;


BEGIN 
 
SELECT * FROM obter_convenio_particular(cd_estabelecimento_p, cd_convenio_w, cd_categoria_w) INTO STRICT cd_convenio_w, cd_categoria_w;
 
select	obter_preco_proced( 
				cd_estabelecimento_p, 
				cd_convenio_w, 
				cd_categoria_w, 
				clock_timestamp(), 
				cd_procedimento_p, 
				ie_origem_proced_p, 
				null, 
				ie_tipo_atendimento_p, 
				null, 
				cd_medico_p, 
				null, 
				null, 
				null, 
				ie_clinica_p, 
				null, 
				'P', 
				nr_seq_exame_p, 
				nr_seq_proc_interno_p) 
into STRICT	vl_procedimento_w
;
 
vl_retorno_w	:= vl_procedimento_w;
 
return	vl_Retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_particular_proced ( cd_Estabelecimento_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_tipo_atendimento_p bigint, cd_medico_p text, ie_clinica_p bigint, nr_seq_proc_interno_p bigint, nr_seq_exame_p bigint) FROM PUBLIC;

