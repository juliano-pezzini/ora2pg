-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_nf_ref_consumo ( nr_seq_nf_ref_p bigint, ie_opcao_p text, nr_prescricao_p bigint default null) RETURNS varchar AS $body$
DECLARE


/*Passar como parâmetro a sequencia da nota de referencia*/

nr_sequencia_w		bigint;
nr_nota_fiscal_w	varchar(255);
ds_retorno_w		varchar(255);
nr_atendimento_w	atendimento_paciente.nr_atendimento%type;


BEGIN
if (coalesce(nr_prescricao_p,0) > 0) then
	begin
	nr_atendimento_w	:= obter_atendimento_prescr(nr_prescricao_p);

	select	coalesce(max(a.nr_sequencia),0)
	into STRICT	nr_sequencia_w
	from	nota_fiscal a,
		nota_fiscal_item b
	where	a.nr_sequencia = b.nr_sequencia
	and	a.nr_seq_nf_ref_consumo = nr_seq_nf_ref_p
	and	b.nr_atendimento = nr_atendimento_w
	and	coalesce(nr_prescricao, nr_prescricao_p) = nr_prescricao_p;
	end;
else
	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_sequencia_w
	from	nota_fiscal
	where	nr_seq_nf_ref_consumo = nr_seq_nf_ref_p;
end if;

if (nr_sequencia_w > 0) then
	select	nr_nota_fiscal
	into STRICT	nr_nota_fiscal_w
	from	nota_fiscal
	where	nr_Sequencia = nr_sequencia_w;
end if;

if (ie_opcao_p = 'NF') then
	ds_retorno_w := nr_nota_fiscal_w;
elsif (ie_opcao_p = 'SEQ') then
	ds_retorno_w := nr_sequencia_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_nf_ref_consumo ( nr_seq_nf_ref_p bigint, ie_opcao_p text, nr_prescricao_p bigint default null) FROM PUBLIC;
