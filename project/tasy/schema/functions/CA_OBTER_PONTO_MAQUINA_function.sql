-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ca_obter_ponto_maquina (nr_seq_analise_p bigint) RETURNS varchar AS $body$
DECLARE


ie_ponto_maq_w	varchar(3);
nr_seq_maquina_dialise_w	bigint;
nr_seq_ponto_w				bigint;
nr_seq_ponto_agua_w			bigint;


BEGIN

if (coalesce(nr_seq_analise_p,0) > 0) then

	select	coalesce(max(nr_seq_maquina_dialise),0),
			coalesce(max(nr_seq_ponto),0),
			coalesce(max(nr_seq_ponto_agua),0)
	into STRICT	nr_seq_maquina_dialise_w,
			nr_seq_ponto_w,
			nr_seq_ponto_agua_w
	from	hd_analise_agua
	where	nr_sequencia = nr_seq_analise_p;

	if (nr_seq_maquina_dialise_w > 0) then
		ie_ponto_maq_w := 'M';
	elsif ((nr_seq_ponto_w > 0) or (nr_seq_ponto_agua_w > 0)) then
		ie_ponto_maq_w := 'P';
	end if;
end if;

return	ie_ponto_maq_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ca_obter_ponto_maquina (nr_seq_analise_p bigint) FROM PUBLIC;
