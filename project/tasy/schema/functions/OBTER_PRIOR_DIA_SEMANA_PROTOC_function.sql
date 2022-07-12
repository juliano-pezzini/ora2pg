-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_prior_dia_semana_protoc (dt_referencia_p timestamp, cd_protocolo_p bigint, nr_seq_medicacao_p bigint) RETURNS varchar AS $body$
DECLARE


ie_segunda_w		varchar(1);
ie_terca_w		varchar(1);
ie_quarta_w		varchar(1);
ie_quinta_w		varchar(1);
ie_sexta_w		varchar(1);
ie_sabado_w		varchar(1);
ie_domingo_w		varchar(1);
ie_dia_semana_w		varchar(1);
ds_retorno_w		varchar(255)	:= '';
ie_data_invalida_w	boolean	:= false;




BEGIN

select	coalesce(ie_segunda,'N'),
		coalesce(ie_terca,'N'),
		coalesce(ie_quarta,'N'),
		coalesce(ie_quinta,'N'),
		coalesce(ie_sexta,'N'),
		coalesce(ie_sabado,'N'),
		coalesce(ie_domingo,'N')
into STRICT	ie_segunda_w,
	ie_terca_w,
	ie_quarta_w,
	ie_quinta_w,
	ie_sexta_w,
	ie_sabado_w,
	ie_domingo_w
from	protocolo_medicacao
where	cd_protocolo	= cd_protocolo_p
and	nr_sequencia	= nr_seq_medicacao_p;

ie_dia_semana_w	:= to_char(pkg_date_utils.get_WeekDay(dt_referencia_p));

if (ie_segunda_w	= 'S') or (ie_terca_w	= 'S') or ( ie_quarta_w	= 'S') or (ie_quinta_w	= 'S') or (ie_sexta_w	= 'S') or (ie_sabado_w	= 'S') or (ie_domingo_w	= 'S') then


	if (ie_dia_semana_w	= 1) and (ie_domingo_w	= 'N') then
		ie_data_invalida_w	:= true;
	elsif (ie_dia_semana_w	= 2) and (ie_segunda_w	= 'N') then
		ie_data_invalida_w	:= true;
	elsif (ie_dia_semana_w	= 3) and (ie_terca_w	= 'N') then
		ie_data_invalida_w	:= true;
	elsif (ie_dia_semana_w	= 4) and (ie_quarta_w	= 'N') then
		ie_data_invalida_w	:= true;
	elsif (ie_dia_semana_w	= 5) and (ie_quinta_w	= 'N') then
		ie_data_invalida_w	:= true;
	elsif (ie_dia_semana_w	= 6) and (ie_sexta_w	= 'N') then
		ie_data_invalida_w	:= true;
	elsif (ie_dia_semana_w	= 7) and (ie_sabado_w	= 'N') then
		ie_data_invalida_w	:= true;
	end if;

	if (ie_data_invalida_w) then

		if (ie_domingo_w	= 'S')then
			ds_retorno_w	:= ds_retorno_w || obter_desc_expressao(288200) || ',';
		end if;

		if (ie_segunda_w	= 'S')then
			ds_retorno_w	:= ds_retorno_w || obter_desc_expressao(298106) || ',';
		end if;

		if (ie_terca_w	= 'S')then
			ds_retorno_w	:= ds_retorno_w || obter_desc_expressao(299302) || ',';
		end if;

		if (ie_quarta_w	= 'S')then
			ds_retorno_w	:= ds_retorno_w || obter_desc_expressao(297139) || ',';
		end if;

		if (ie_quinta_w	= 'S')then
			ds_retorno_w	:= ds_retorno_w || obter_desc_expressao(297214) || ',';
		end if;

		if ( ie_sexta_w	= 'S')then
			ds_retorno_w	:= ds_retorno_w ||obter_desc_expressao(298488) || ',';
		end if;

		if ( ie_sabado_w	= 'S')then
			ds_retorno_w	:= ds_retorno_w || obter_desc_expressao(297960) || ',';
		end if;

		ds_retorno_w:= 'Este protocolo tem como prioridade no(s) dias '||ds_retorno_w;
		ds_retorno_w := ds_retorno_w || 'deseja gerar com essa data?';
	end if;

end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_prior_dia_semana_protoc (dt_referencia_p timestamp, cd_protocolo_p bigint, nr_seq_medicacao_p bigint) FROM PUBLIC;

