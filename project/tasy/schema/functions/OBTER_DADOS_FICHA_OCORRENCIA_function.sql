-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_ficha_ocorrencia ( nr_ficha_ocorrencia_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE



ds_retorno_w	varchar(255) := '';

/*
AT - Número atendimento
L  - Data de liberação
E  - Data de enceramento
*/
BEGIN

if (nr_ficha_ocorrencia_p IS NOT NULL AND nr_ficha_ocorrencia_p::text <> '') then

	if (ie_opcao_p = 'AT') then

		select	max(nr_atendimento)
		into STRICT	ds_retorno_w
		from	cih_ficha_ocorrencia
		where	nr_ficha_ocorrencia 	= nr_ficha_ocorrencia_p;

		else if (ie_opcao_p = 'L') then

			select	to_char(dt_liberacao,'dd/MM/yyyy')
			into STRICT	ds_retorno_w
			from	cih_ficha_ocorrencia
			where	nr_ficha_ocorrencia 	= nr_ficha_ocorrencia_p;

			else	if (ie_opcao_p = 'E')then

				select	to_char(dt_encerramento,'dd/MM/yyyy')
				into STRICT	ds_retorno_w
				from	cih_ficha_ocorrencia
				where	nr_ficha_ocorrencia 	= nr_ficha_ocorrencia_p;
			end if;
		end if;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_ficha_ocorrencia ( nr_ficha_ocorrencia_p bigint, ie_opcao_p text) FROM PUBLIC;

