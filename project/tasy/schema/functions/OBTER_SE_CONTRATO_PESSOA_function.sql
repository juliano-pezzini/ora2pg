-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_contrato_pessoa ( nr_seq_contrato_p bigint, cd_pessoa_fisica_p text, ie_origem_p text) RETURNS varchar AS $body$
DECLARE


/*
Origem
NF = Nota Fiscal
OC = Ordem Compra
IR = Inspeção Recebimento
*/
cd_pessoa_contratada_w			varchar(10);
ie_pessoa_contrato_w			varchar(1) := 'N';
qt_registro_w				bigint;


BEGIN

select	cd_pessoa_contratada
into STRICT	cd_pessoa_contratada_w
from	contrato
where	nr_sequencia = nr_seq_contrato_p;

if (cd_pessoa_contratada_w IS NOT NULL AND cd_pessoa_contratada_w::text <> '') and (cd_pessoa_contratada_w = cd_pessoa_fisica_p) then
	ie_pessoa_contrato_w := 'S';
end if;

if (ie_pessoa_contrato_w = 'N') then

	select	count(*)
	into STRICT	qt_registro_w
	from	contrato a,
		contrato_fornec_lib b
	where	a.nr_sequencia = b.nr_seq_contrato
	and	((a.nr_sequencia = nr_seq_contrato_p) or (a.cd_contrato in (	SELECT	cd_contrato
										from	contrato
										where	nr_sequencia = nr_seq_contrato_p)))
	and	b.cd_pessoa_fisica = cd_pessoa_fisica_p
	and	(((ie_origem_p = 'NF') and (coalesce(b.ie_nota_fiscal,'S') = 'S')) or
		((ie_origem_p = 'OC') and (coalesce(b.ie_ordem_compra,'S') = 'S')) or (ie_origem_p = 'IR' and coalesce(b.ie_inspecao,'S') = 'S'));

	if (qt_registro_w > 0) then
		ie_pessoa_contrato_w := 'S';
	end if;
end if;


return	ie_pessoa_contrato_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_contrato_pessoa ( nr_seq_contrato_p bigint, cd_pessoa_fisica_p text, ie_origem_p text) FROM PUBLIC;

