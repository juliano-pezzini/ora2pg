-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_repasse_titulo ( nr_titulo_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


vl_repasse_titulo_w			double precision	:= 0;
vl_repasse_w				double precision;
vl_titulo_w				double precision;
vl_titulos_repasse_w			double precision;
nr_repasse_terceiro_w			bigint;

/* Opção
R - Repasse
L - Liberado
G - Glosado
M - Maior
I - Valor líquido dos vencimentos
LI - Valor liberado somente de procedimentos e materiais
*/
BEGIN

if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') then

	select	max(nr_repasse_terceiro)
	into STRICT	nr_repasse_terceiro_w
	from	titulo_pagar
	where	nr_titulo	= nr_titulo_p;

	if (nr_repasse_terceiro_w IS NOT NULL AND nr_repasse_terceiro_w::text <> '') then

		select	coalesce(obter_valor_repasse(nr_repasse_terceiro_w,ie_opcao_p),0)
		into STRICT	vl_repasse_w
		;

		select	coalesce(sum(vl_titulo),0)
		into STRICT	vl_titulos_repasse_w
		from	titulo_pagar
		where	nr_repasse_terceiro	= nr_repasse_terceiro_w
		and	coalesce(nr_seq_tributo::text, '') = ''
		and	ie_situacao		<> 'D';

		select	coalesce(max(vl_titulo),0)
		into STRICT	vl_titulo_w
		from	titulo_pagar
		where	nr_titulo	= nr_titulo_p;

		if (vl_titulo_w <> 0) then
			vl_repasse_titulo_w	:= ((dividir_sem_round(vl_repasse_w,vl_titulos_repasse_w)) * vl_titulo_w);
		else
			vl_repasse_titulo_w	:= vl_repasse_w;
		end if;

	end if;
end if;

RETURN vl_repasse_titulo_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_repasse_titulo ( nr_titulo_p bigint, ie_opcao_p text) FROM PUBLIC;
