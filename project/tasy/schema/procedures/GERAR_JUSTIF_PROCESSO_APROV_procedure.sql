-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_justif_processo_aprov ( nr_sequencia_p bigint, ds_observacao_p text, nm_usuario_p text) AS $body$
DECLARE


ds_observacao_w			varchar(2000);
ds_observacao_ww			varchar(2000);


BEGIN

begin
select	ds_observacao
into STRICT	ds_observacao_w
from	processo_aprov_compra
where	nr_sequencia	= nr_sequencia_p;
exception when others then
	ds_observacao_w	:= '';
end;

ds_observacao_ww	:= 	substr(ds_observacao_w || chr(13) || chr(10) ||
				nm_usuario_p || ': ' || ds_observacao_p,1,2000);

update	processo_aprov_compra
set	ds_observacao = ds_observacao_ww
where	nr_sequencia = nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_justif_processo_aprov ( nr_sequencia_p bigint, ds_observacao_p text, nm_usuario_p text) FROM PUBLIC;

