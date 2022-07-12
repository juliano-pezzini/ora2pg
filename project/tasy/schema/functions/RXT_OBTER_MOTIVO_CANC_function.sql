-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rxt_obter_motivo_canc (nr_seq_motivo_canc_p bigint) RETURNS varchar AS $body$
DECLARE


				ds_retorno_w varchar(255) := null;


BEGIN

	if not(coalesce(nr_seq_motivo_canc_p::text, '') = '') then
		select ds_motivo_cancelamento
		into STRICT	ds_retorno_w
		from	RXT_MOTIVO_CANC_TRATAMENTO
		where	nr_Sequencia = nr_seq_motivo_canc_p;
		return ds_retorno_w;
	else
		return null;
	end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rxt_obter_motivo_canc (nr_seq_motivo_canc_p bigint) FROM PUBLIC;
