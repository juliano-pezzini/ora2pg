-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_regra_natureza_op ( cd_operacao_nf_p bigint) RETURNS varchar AS $body$
DECLARE



ds_retorno_w		varchar(1);
qt_existe_w		integer;
cd_estabelecimento_w	bigint;


BEGIN

cd_estabelecimento_w	:= wheb_usuario_pck.get_cd_estabelecimento;
ds_retorno_w		:= 'N';

select	count(*)
into STRICT	qt_existe_w
from	operacao_nota_nat
where	cd_operacao_nf	= cd_operacao_nf_p
and	cd_estabelecimento = cd_estabelecimento_w;

if (qt_existe_w > 0) then
	ds_retorno_w		:= 'S';
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_regra_natureza_op ( cd_operacao_nf_p bigint) FROM PUBLIC;

