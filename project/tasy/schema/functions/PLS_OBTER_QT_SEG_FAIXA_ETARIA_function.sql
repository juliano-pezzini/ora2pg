-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_qt_seg_faixa_etaria ( qt_idade_inicial_p bigint, qt_idade_final_p bigint, ie_tipo_data_p text, dt_inicial_p timestamp, dt_final_p timestamp, ie_situacao_p text, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE

 
qt_beneficiarios_w		bigint;
cd_pessoa_fisica_w		varchar(10);
qt_idade_benef_w		bigint;
nr_seq_segurado_w		bigint;

C01 CURSOR FOR 
	SELECT	a.nr_sequencia 
	from	pls_segurado		a 
	where	ie_tipo_segurado	in ('A','B','R') 
	and (pls_obter_dados_segurado(a.nr_sequencia,'CS')	= ie_situacao_p) 
	and	((ie_tipo_data_p = 'C' and a.dt_contratacao between dt_inicial_p and fim_dia(dt_final_p)) or (ie_tipo_data_p	 = 'A' and a.dt_liberacao between dt_inicial_p and fim_dia(dt_final_p)) or (ie_tipo_data_p	 = 'N')) 
	and	a.cd_estabelecimento	= cd_estabelecimento_p;
	

BEGIN 
qt_beneficiarios_w	:= 0;
 
open C01;
loop 
fetch C01 into	 
	nr_seq_segurado_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	select	cd_pessoa_fisica 
	into STRICT	cd_pessoa_fisica_w 
	from	pls_segurado 
	where	nr_sequencia	= nr_seq_segurado_w;
	 
	qt_idade_benef_w	:= obter_idade_pf(cd_pessoa_fisica_w,clock_timestamp(),'A');
	 
	if (qt_idade_benef_w between qt_idade_inicial_p and qt_idade_final_p) then 
		qt_beneficiarios_w	:= qt_beneficiarios_w + 1;
	end if;	
	 
	end;
end loop;
close C01;
 
return	qt_beneficiarios_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_qt_seg_faixa_etaria ( qt_idade_inicial_p bigint, qt_idade_final_p bigint, ie_tipo_data_p text, dt_inicial_p timestamp, dt_final_p timestamp, ie_situacao_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
