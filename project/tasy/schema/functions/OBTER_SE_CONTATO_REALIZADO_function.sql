-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_contato_realizado (nr_seq_lista_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1);
ie_contato_realizado_w	ag_lista_espera_contato.ie_contato_realizado%type;

C01 CURSOR FOR
	SELECT	ie_contato_realizado
	from 	ag_lista_espera_contato
	where 	nr_seq_lista_espera = nr_seq_lista_p;


BEGIN
	ds_retorno_w := 'N';

	if (nr_seq_lista_p IS NOT NULL AND nr_seq_lista_p::text <> '') then
		open C01;
		loop
		fetch C01 into
			ie_contato_realizado_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
				if (ie_contato_realizado_w = 'S') then
					ds_retorno_w := ie_contato_realizado_w;
				end if;
			end;
		end loop;
		close C01;
	end if;

	return	ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_contato_realizado (nr_seq_lista_p text) FROM PUBLIC;
