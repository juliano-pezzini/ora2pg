-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ple_obter_status_acao ( nr_seq_ordem_serv_p bigint) RETURNS varchar AS $body$
DECLARE


ds_status_ordem_w		varchar(255);
dt_validacao_pe_w		timestamp;
dt_fim_previsto_w		timestamp;
ie_status_ordem_w		varchar(1);


BEGIN

select	ie_status_ordem,
		dt_validacao_pe,
		dt_fim_previsto
into STRICT	ie_status_ordem_w,
		dt_validacao_pe_w,
		dt_fim_previsto_w
from	man_ordem_servico
where	nr_sequencia	= nr_seq_ordem_serv_p;


if (ie_status_ordem_w = '1') then

	ds_status_ordem_w	:= obter_desc_expressao(283054);--'Aberta';
end if;

if (ie_status_ordem_w = '2') then

	ds_status_ordem_w	:= obter_desc_expressao(296477);--'Processo';
end if;

if (ie_status_ordem_w = '3') then

	ds_status_ordem_w	:= obter_desc_expressao(303118);--'Concluída';
end if;

if (ie_status_ordem_w = '3') and (dt_validacao_pe_w IS NOT NULL AND dt_validacao_pe_w::text <> '') then

	ds_status_ordem_w	:= obter_desc_expressao(331746);--'Validado';
end if;

if (dt_fim_previsto_w IS NOT NULL AND dt_fim_previsto_w::text <> '') and (dt_fim_previsto_w < trunc(clock_timestamp())) and (ie_status_ordem_w <> '3') then

	ds_status_ordem_w	:= obter_desc_expressao(302650);--'Atrasada';
end if;

return	ds_status_ordem_w;

end 	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ple_obter_status_acao ( nr_seq_ordem_serv_p bigint) FROM PUBLIC;
