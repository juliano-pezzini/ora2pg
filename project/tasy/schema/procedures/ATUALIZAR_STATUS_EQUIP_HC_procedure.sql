-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_status_equip_hc ( nr_seq_equipamento_p bigint, nm_usuario_p text, ie_tipo_status_p text) AS $body$
DECLARE


nr_status_w	hc_parametro.nr_status_ini_equip%type;


BEGIN

select	max(CASE WHEN ie_tipo_status_p='I' THEN  nr_status_ini_equip  ELSE nr_status_fim_equip END )
into STRICT	nr_status_w
from	hc_parametro;

if (nr_status_w IS NOT NULL AND nr_status_w::text <> '') then

	update 	man_equipamento
	set	nr_seq_status = nr_status_w,
		nm_usuario    = nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia = nr_seq_equipamento_p;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_status_equip_hc ( nr_seq_equipamento_p bigint, nm_usuario_p text, ie_tipo_status_p text) FROM PUBLIC;

