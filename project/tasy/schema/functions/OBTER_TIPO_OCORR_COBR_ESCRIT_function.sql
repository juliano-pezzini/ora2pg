-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tipo_ocorr_cobr_escrit (nr_seq_titulo_escrit_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(1)	:= null;
nr_seq_ocorrencia_ret_w	bigint;


BEGIN

if (nr_seq_titulo_escrit_p IS NOT NULL AND nr_seq_titulo_escrit_p::text <> '') then
	select	nr_seq_ocorrencia_ret
	into STRICT	nr_seq_ocorrencia_ret_w
	from	titulo_receber_cobr
	where	nr_sequencia	= nr_seq_titulo_escrit_p;

	if (nr_seq_ocorrencia_ret_w IS NOT NULL AND nr_seq_ocorrencia_ret_w::text <> '') then
		select	coalesce(max(ie_rejeitado),'N')
		into STRICT	ie_retorno_w
		from	banco_ocorr_escrit_ret
		where	nr_sequencia	= nr_seq_ocorrencia_ret_w;
	end if;
end if;

return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_ocorr_cobr_escrit (nr_seq_titulo_escrit_p bigint) FROM PUBLIC;

