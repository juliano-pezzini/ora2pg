-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_dia_prazo_fornec (cd_pessoa_fisica_p text, cd_cgc_fornecedor_p text) RETURNS bigint AS $body$
DECLARE


nr_sequencia_w			nota_fiscal.nr_sequencia%type;
dt_atualizacao_estoque_w	nota_fiscal.dt_atualizacao_estoque%type;
nr_ordem_compra_w		nota_fiscal_item.nr_ordem_compra%type;
dt_ordem_compra_w		ordem_compra.dt_ordem_compra%type;
qt_dias_w			bigint;


BEGIN

if ((cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') or (cd_cgc_fornecedor_p IS NOT NULL AND cd_cgc_fornecedor_p::text <> '')) then

	select	max(nf.nr_sequencia)
	into STRICT	nr_sequencia_w
	from	nota_fiscal nf,
		nota_fiscal_item nfi
	where	nf.nr_sequencia = nfi.nr_sequencia
	and (nf.cd_cgc_emitente = cd_cgc_fornecedor_p
	or	nf.cd_pessoa_fisica = cd_pessoa_fisica_p)
	and	(nfi.nr_ordem_compra IS NOT NULL AND nfi.nr_ordem_compra::text <> '')
	and	(nf.dt_atualizacao_estoque IS NOT NULL AND nf.dt_atualizacao_estoque::text <> '');

	if (nr_sequencia_w > 0) then
		select	max(dt_atualizacao_estoque)
		into STRICT	dt_atualizacao_estoque_w
		from	nota_fiscal
		where	nr_sequencia = nr_sequencia_w;

		select	max(nr_ordem_compra)
		into STRICT	nr_ordem_compra_w
		from	nota_fiscal_item
		where	nr_sequencia = nr_sequencia_w;

		if (nr_ordem_compra_w IS NOT NULL AND nr_ordem_compra_w::text <> '') then
			select	max(dt_ordem_compra)
			into STRICT	dt_ordem_compra_w
			from	ordem_compra
			where	nr_ordem_compra = nr_ordem_compra_w;

			if (dt_ordem_compra_w IS NOT NULL AND dt_ordem_compra_w::text <> '') then
				select	obter_dias_entre_datas(dt_ordem_compra_w, dt_atualizacao_estoque_w)
				into STRICT	qt_dias_w
				;
			end if;
		end if;
	end if;
end if;

return	qt_dias_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_dia_prazo_fornec (cd_pessoa_fisica_p text, cd_cgc_fornecedor_p text) FROM PUBLIC;
