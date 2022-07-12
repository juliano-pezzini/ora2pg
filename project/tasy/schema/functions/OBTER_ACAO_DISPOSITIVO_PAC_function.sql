-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_acao_dispositivo_pac ( nr_seq_dispositivo_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


nr_seq_proc_interno_w	bigint;


BEGIN

if (nr_seq_dispositivo_p > 0) and (ie_opcao_p	= 'P') then

	select   coalesce(max(nr_seq_proc_interno),0) cd
	into STRICT     nr_seq_proc_interno_w
	from     dispositivo_proc_interno
	where    ie_acao in ('I','U')
	and      ie_situacao = 'A'
	and      nr_seq_dispositivo = nr_seq_dispositivo_p
	and      nr_seq_apres = (SELECT min(nr_seq_apres)
				 from   dispositivo_proc_interno
				 where  nr_seq_dispositivo = nr_seq_dispositivo_p);

elsif (nr_seq_dispositivo_p > 0) and (ie_opcao_p	= 'SAE') then

	select   coalesce(MAX(nr_seq_proc),0) cd
	into STRICT     nr_seq_proc_interno_w
	from     PE_PROC_DISPOSITIVO
	where    ie_acao in ('I','U')
	and      nr_seq_dispositivo = nr_seq_dispositivo_p;

end if;

return	nr_seq_proc_interno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_acao_dispositivo_pac ( nr_seq_dispositivo_p bigint, ie_opcao_p text) FROM PUBLIC;

