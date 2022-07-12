-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_permite_gerar_nfse () RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(1) := 'S';
qt_servico_w		bigint;
ie_sair_w		varchar(1) := 'N';
nr_seq_nota_fiscal_w	bigint;

C01 CURSOR FOR
	SELECT	nr_seq_nota_fiscal
	from	w_nota_fiscal
	order by
		nr_seq_nota_fiscal;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_nota_fiscal_w;
EXIT WHEN NOT FOUND or ie_sair_w = 'S';  /* apply on C01 */
	begin

	select	count(*)
	into STRICT	qt_servico_w
	from (
		SELECT	obter_dados_grupo_servico_item(obter_item_servico_proced(b.cd_procedimento, b.ie_origem_proced), 'CD')
		from	nota_fiscal a,
			nota_fiscal_item b
		where	a.nr_sequencia = b.nr_sequencia
		and   	coalesce(b.cd_material::text, '') = ''
		and   	a.nr_sequencia = nr_seq_nota_fiscal_w
		group by
			obter_dados_grupo_servico_item(obter_item_servico_proced(b.cd_procedimento, b.ie_origem_proced), 'CD')
		) alias6;

	if (qt_servico_w > 1) then
		ie_retorno_w	:= 'N';
		ie_sair_w	:= 'S';
	else
		ie_retorno_w	:= 'S';
	end if;

	end;
end loop;
close C01;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_permite_gerar_nfse () FROM PUBLIC;

