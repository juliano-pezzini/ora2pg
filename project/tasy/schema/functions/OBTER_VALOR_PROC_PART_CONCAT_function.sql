-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_proc_part_concat ( cd_Estabelecimento_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_tipo_atendimento_p bigint, cd_medico_p text, ie_clinica_p bigint, nr_seq_proc_interno_p bigint) RETURNS varchar AS $body$
DECLARE

 
cd_convenio_w		integer;			
cd_categoria_w		varchar(10);
ds_categoria_w		varchar(100);
vl_procedimento_w	double precision;
vl_Retorno_w		double precision;

ds_retorno_w		varchar(255);

c01 CURSOR FOR 
	SELECT	cd_categoria, 
		ds_categoria 
	from	categoria_convenio 
	where	cd_convenio = cd_convenio_w;


BEGIN 
ds_retorno_w := '';
SELECT * FROM obter_convenio_particular(cd_estabelecimento_p, cd_convenio_w, cd_categoria_w) INTO STRICT cd_convenio_w, cd_categoria_w;
open C01;
loop 
fetch C01 into	 
	cd_categoria_w, 
	ds_categoria_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	 
	select	obter_preco_proced(	cd_estabelecimento_p, 
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
			null, 
			nr_seq_proc_interno_p) 
	into STRICT	vl_procedimento_w 
	;	
	 
	if (vl_procedimento_w > 0) then 
		ds_retorno_w := ds_retorno_w || ';' || 
				' - '||wheb_mensagem_pck.get_texto(802911)||' '||ds_categoria_w||': '||Campo_Mascara_virgula_casas(vl_procedimento_w,2);
	end if;
	 
end loop;
close C01;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_proc_part_concat ( cd_Estabelecimento_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_tipo_atendimento_p bigint, cd_medico_p text, ie_clinica_p bigint, nr_seq_proc_interno_p bigint) FROM PUBLIC;
