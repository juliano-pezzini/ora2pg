-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_cancelar_inventario ( nr_sequencia_p bigint, nm_usuario_p text, cd_motivo_cancel_p bigint, ds_observacao_p text) AS $body$
DECLARE


ds_observacao_w		varchar(255);

BEGIN
select	ds_observacao
into STRICT	ds_observacao_w
from	inventario
where	nr_sequencia = nr_sequencia_p;

if (ds_observacao_p IS NOT NULL AND ds_observacao_p::text <> '') then
	begin
	if (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') then
		ds_observacao_w := substr(ds_observacao_w || chr(13) || chr(10) || ds_observacao_p,1,255);
	else
		ds_observacao_w := substr(ds_observacao_p,1,255);
	end if;
	end;
end if;

update  inventario
set     nr_seq_motivo_cancel    = cd_motivo_cancel_p,
	ds_observacao		= ds_observacao_w
where   nr_sequencia            = nr_sequencia_p;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_cancelar_inventario ( nr_sequencia_p bigint, nm_usuario_p text, cd_motivo_cancel_p bigint, ds_observacao_p text) FROM PUBLIC;

