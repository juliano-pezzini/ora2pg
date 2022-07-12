-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_anticipo (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w 	 varchar(10) := 'N';
ie_nota_credito_w  operacao_nota.ie_nota_credito%type;
cd_operacao_nf_w   operacao_nota.cd_operacao_nf%type;
qt_anticipo_w    integer;


BEGIN

/*
se for obter_se_anticipo = 'S'

clave = 84111506
clave unid = ACT
descricao = Aplicación de anticipo

se for obter_se_anticipo NÃO for 'S'

clave = cod interno do proc
unid = do item na nota
descricão = do item da nota

*/
select coalesce(cd_operacao_nf,0)
into STRICT   cd_operacao_nf_w
from   nota_fiscal
where  nr_sequencia = nr_sequencia_p;


if (cd_operacao_nf_w <> 0) then

	select coalesce(ie_nota_credito,'N')
	into STRICT   ie_nota_credito_w
	from   operacao_nota
	where  cd_operacao_nf = cd_operacao_nf_w;

	if (ie_nota_credito_w = 'S') then

		select count(*)
		into STRICT   qt_anticipo_w
		from   fis_tipo_relacao
		where  nr_seq_nota = nr_sequencia_p
		and    cd_tipo_relacao = '07';

		if (qt_anticipo_w > 0) then

		    ds_retorno_w := 'S';

		end if;


	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_anticipo (nr_sequencia_p bigint) FROM PUBLIC;

