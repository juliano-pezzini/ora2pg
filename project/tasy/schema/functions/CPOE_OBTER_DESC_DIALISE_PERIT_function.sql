-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_desc_dialise_perit ( ie_tipo_peritoneal_p text, NR_SEQ_PROTOCOLO_P bigint, dt_lib_suspensao_p timestamp default null, dt_suspensao_p timestamp default null, ie_administracao_p text default null) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(500);

		function bold( ds_valor_p text) return text is

		;
BEGIN
		return '<strong>' ||ds_valor_p||'</strong>';

		end;

begin

if (NR_SEQ_PROTOCOLO_P IS NOT NULL AND NR_SEQ_PROTOCOLO_P::text <> '') then
	select	ds_npt
	into STRICT 	ds_retorno_w
	from	protocolo_npt
	where 	nr_sequencia = NR_SEQ_PROTOCOLO_P;
end if;


ds_retorno_w := bold(ds_retorno_w) || cpoe_obter_sigla_tipo_adm(ie_administracao_p);


if (dt_lib_suspensao_p IS NOT NULL AND dt_lib_suspensao_p::text <> '') and (dt_suspensao_p IS NOT NULL AND dt_suspensao_p::text <> '') and (dt_suspensao_p <=clock_timestamp()) then
	ds_retorno_w	:= '<del> '||ds_retorno_w|| '</del>';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_desc_dialise_perit ( ie_tipo_peritoneal_p text, NR_SEQ_PROTOCOLO_P bigint, dt_lib_suspensao_p timestamp default null, dt_suspensao_p timestamp default null, ie_administracao_p text default null) FROM PUBLIC;
