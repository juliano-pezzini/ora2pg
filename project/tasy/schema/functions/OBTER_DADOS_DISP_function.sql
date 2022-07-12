-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_disp ( nr_seq_disp_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
CN	-	Classificação NISS
*/
ie_classif_disp_niss_w	varchar(15);
ds_retorno_w		varchar(255);


BEGIN

if (nr_seq_disp_p > 0) then
	select	ie_classif_disp_niss
	into STRICT	ie_classif_disp_niss_w
	from	dispositivo
	where	nr_sequencia	=	nr_seq_disp_p;
end if;

if (ie_opcao_p = 'CN') then
	ds_retorno_w	:= ie_classif_disp_niss_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_disp ( nr_seq_disp_p bigint, ie_opcao_p text) FROM PUBLIC;
