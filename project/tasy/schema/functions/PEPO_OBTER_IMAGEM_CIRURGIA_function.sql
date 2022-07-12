-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pepo_obter_imagem_cirurgia (ie_status_cirurgia_p text) RETURNS bigint AS $body$
DECLARE


nr_seq_retorno_w	bigint := 0;


BEGIN

if (ie_status_cirurgia_p in (3,4)) then
	select	nr_sequencia
	into STRICT	nr_seq_retorno_w
	from	tasy_padrao_imagem
	where	nr_sequencia = 460;
end if;


return	nr_seq_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pepo_obter_imagem_cirurgia (ie_status_cirurgia_p text) FROM PUBLIC;
