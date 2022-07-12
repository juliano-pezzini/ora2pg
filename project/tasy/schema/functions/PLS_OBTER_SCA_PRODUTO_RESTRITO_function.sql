-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_sca_produto_restrito ( nr_seq_sca_plano_p bigint, nr_seq_segurado_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(10);
qt_registros_w			bigint;
nr_seq_plano_adic_w		bigint;
nr_seq_classificacao_w		bigint;
qt_total_w			bigint;
qt_benef_contrato_w		bigint;

C01 CURSOR FOR
	SELECT	ie_classificacao_sca_contrato,
		qt_dias_inclusao_ops,
		nr_seq_contrato
	from	pls_plano_sca_restricao
	where	nr_seq_plano_sca	= nr_seq_sca_plano_p
	and	ie_situacao		= 'A';

BEGIN

ds_retorno_w	:= 'N';

for r_c01_w in c01 loop
	begin

	if	(r_c01_w.ie_classificacao_sca_contrato = 'S' AND ds_retorno_w = 'N') then
		select	max(nr_seq_plano_adic)
		into STRICT	nr_seq_plano_adic_w
		from	pls_plano_servico_adic
		where	nr_sequencia	= nr_seq_sca_plano_p;

		if (nr_seq_plano_adic_w IS NOT NULL AND nr_seq_plano_adic_w::text <> '') then
			select	nr_seq_classificacao
			into STRICT	nr_seq_classificacao_w
			from	pls_plano
			where	nr_sequencia	= nr_seq_plano_adic_w;

			select	count(1)
			into STRICT	qt_registros_w
			from	pls_plano	b,
				pls_sca_vinculo	a
			where	a.nr_seq_plano		= b.nr_sequencia
			and	a.nr_seq_segurado	= nr_seq_segurado_p
			and	b.nr_seq_classificacao	= nr_seq_classificacao_w;

			if (qt_registros_w > 0) then
				ds_retorno_w	:= 'S';
			end if;
		end if;
	end if;

	if	(r_c01_w.qt_dias_inclusao_ops IS NOT NULL AND r_c01_w.qt_dias_inclusao_ops::text <> '' AND ds_retorno_w = 'N') then
		select 	dt_contratacao - dt_inclusao_operadora
		into STRICT	qt_total_w
		from	pls_segurado
		where	nr_sequencia	= nr_seq_segurado_p;

		if (qt_total_w > r_c01_w.qt_dias_inclusao_ops) then
			ds_retorno_w	:= 'S';
		end if;
	end if;

	if	(r_c01_w.nr_seq_contrato IS NOT NULL AND r_c01_w.nr_seq_contrato::text <> '' AND ds_retorno_w = 'N') then
		select	count(1)
		into STRICT	qt_benef_contrato_w
		from	pls_segurado
		where	nr_seq_contrato = r_c01_w.nr_seq_contrato
		and	nr_sequencia = nr_seq_segurado_p;

		if (qt_benef_contrato_w > 0) then
			ds_retorno_w	:= 'S';
		end if;
	end if;
	end;
end loop;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_sca_produto_restrito ( nr_seq_sca_plano_p bigint, nr_seq_segurado_p bigint) FROM PUBLIC;

