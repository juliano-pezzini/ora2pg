-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_mot_just_desdobra_lote ( nr_seq_lote_p bigint, nr_seq_motivo_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(2000) := '';


BEGIN

if (ie_opcao_p = 'J') then
	if (coalesce(nr_seq_lote_p,0) > 0) and (coalesce(nr_seq_motivo_p,0) > 0) then

		select	substr(MAX(ds_log),1,500) ds_log
		into STRICT	ds_retorno_w
		from	ap_lote_historico
		where	nr_seq_lote = nr_seq_lote_p
		and	nr_seq_mot_desdobrar = nr_seq_motivo_p;

	end if;
elsif (ie_opcao_p = 'M') then
	if (coalesce(nr_seq_motivo_p,0) > 0) then
	
		select	MAX(ds_motivo)
		into STRICT	ds_retorno_w
		from	motivo_desdobrar_lote
		where	nr_sequencia = nr_seq_motivo_p;
	
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_mot_just_desdobra_lote ( nr_seq_lote_p bigint, nr_seq_motivo_p bigint, ie_opcao_p text) FROM PUBLIC;
