-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_sus_proc_interno ( nr_seq_proc_interno_p bigint, ie_opcao_p bigint, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE

				 
/*IE_OPCAO_P: 
1 - valor hospitalar 
2 - valor ambulatorial 
*/
				 
cd_procedimento_sus_w		bigint;
ie_origem_proced_sus_w		bigint := 7;
cd_convenio_w			integer;
vl_item_sus_w			double precision := 0;


BEGIN 
 
select	max(cd_convenio_sus) 
into STRICT	cd_convenio_w 
from	parametro_faturamento 
where	cd_estabelecimento = cd_estabelecimento_p;
 
SELECT * FROM obter_procedimento_tab_interna(nr_seq_proc_interno_p, cd_convenio_w, cd_estabelecimento_p, clock_timestamp(), cd_procedimento_sus_w, ie_origem_proced_sus_w) INTO STRICT cd_procedimento_sus_w, ie_origem_proced_sus_w;
	 
if (ie_opcao_p <> 1) then 
	begin 
	 
	select	coalesce(sus_obter_preco_proced(cd_estabelecimento_p,clock_timestamp(),8,cd_procedimento_sus_w,ie_origem_proced_sus_w,2),0) 
	into STRICT	vl_item_sus_w 
	;
	 
	end;
else 
	begin 
	 
	select	coalesce(sus_obter_preco_proced(cd_estabelecimento_p,clock_timestamp(),1,cd_procedimento_sus_w,ie_origem_proced_sus_w,1),0) 
	into STRICT	vl_item_sus_w 
	;
	 
	end;
end if;
 
return coalesce(vl_item_sus_w,0);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_sus_proc_interno ( nr_seq_proc_interno_p bigint, ie_opcao_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

