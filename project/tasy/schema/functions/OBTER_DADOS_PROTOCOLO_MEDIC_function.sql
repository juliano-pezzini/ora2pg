-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_protocolo_medic (nr_seq_protocolo_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


cd_tipo_protocolo_w		bigint;
cd_protocolo_w			bigint;
nr_sequencia_w			bigint;

/*
ie_opcao_p
TP - tipo protocolo
CP - código do protocolo
NR - sequencia do protocolo
*/
BEGIN

if (nr_seq_protocolo_p > 0) then

	select	max(b.cd_tipo_protocolo),
		max(a.cd_protocolo),
		max(a.nr_sequencia)
	into STRICT	cd_tipo_protocolo_w,
		cd_protocolo_w,
		nr_sequencia_w
	from	protocolo_medicacao a,
		protocolo b
	where	a.nr_seq_interna = nr_seq_protocolo_p
	and	a.cd_protocolo = b.cd_protocolo;

end if;


if (ie_opcao_p = 'TP') then
	return cd_tipo_protocolo_w;

elsif (ie_opcao_p = 'CP') then
	return cd_protocolo_w;

elsif (ie_opcao_p = 'NR') then
	return nr_sequencia_w;
end if;

return	0;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_protocolo_medic (nr_seq_protocolo_p bigint, ie_opcao_p text) FROM PUBLIC;
