-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION same_obter_estab_solic (nr_seq_solic_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


cd_Estabelecimento_solic_w	bigint;
cd_Estabelecimento_w		bigint;

cd_estabelecimento_retorno_w	bigint;

/*
P - Estabelecimento do prontuário
S - Estabelecimento solicitado
*/
BEGIN

select	a.cd_estabelecimento,
	a.cd_estabelecimento_solic
into STRICT	cd_Estabelecimento_w,
	cd_Estabelecimento_solic_w
from	same_solic_pront a
where	a.nr_sequencia = nr_seq_solic_p;

if ( ie_opcao_p = 'P' ) then
	cd_estabelecimento_retorno_w := cd_estabelecimento_w;
elsif ( ie_opcao_p = 'S' ) then
	cd_estabelecimento_retorno_w := cd_estabelecimento_solic_w;
end if;

return	cd_estabelecimento_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION same_obter_estab_solic (nr_seq_solic_p bigint, ie_opcao_p text) FROM PUBLIC;

