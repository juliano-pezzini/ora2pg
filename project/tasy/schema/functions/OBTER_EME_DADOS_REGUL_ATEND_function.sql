-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_eme_dados_regul_atend ( nr_atendimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
nr_sequencia_w		bigint;
ie_tipo_regulacao_w	varchar(01);
nr_seq_tipo_servico_w	bigint;

/*
TP - Tipo regulação
TS - Tipo serviço
*/
BEGIN
select	max(nr_sequencia)
into STRICT	nr_sequencia_w
from	eme_regulacao
where	nr_atendimento = nr_atendimento_p;

if (coalesce(nr_sequencia_w,0) > 0) then
	begin
	select	ie_tipo_regulacao,
		nr_seq_tipo_servico
	into STRICT	ie_tipo_regulacao_w,
		nr_seq_tipo_servico_w
	from	eme_regulacao
	where	nr_sequencia = nr_sequencia_w;
	end;
end if;

if (ie_opcao_p = 'TP') then
	ds_retorno_w := ie_tipo_regulacao_w;
elsif (ie_opcao_p = 'TS') then
	ds_retorno_w := nr_seq_tipo_servico_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_eme_dados_regul_atend ( nr_atendimento_p bigint, ie_opcao_p text) FROM PUBLIC;
