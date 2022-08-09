-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rop_baixa_peca ( nr_sequencia_p bigint, cd_motivo_baixa_p bigint, ds_observacao_p text, cd_local_baixa_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_observacao_w			varchar(255);
ds_observacao_ww		varchar(255);
ds_observacao_peca_w		varchar(255);


BEGIN

ds_observacao_w	:= substr(ds_observacao_p,1,255);

select	ds_observacao
into STRICT	ds_observacao_peca_w
from	rop_roupa
where	nr_sequencia	= nr_sequencia_p;

ds_observacao_ww	:= ds_observacao_peca_w;

if (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') then
	ds_observacao_ww := substr(ds_observacao_ww || chr(13) || chr(10) || ds_observacao_w,1,255);
end if;

update	rop_roupa
set	nm_usuario	= nm_usuario_p,
	dt_baixa	= clock_timestamp(),
	ie_situacao	= 'I',
	cd_motivo_baixa	= cd_motivo_baixa_p,
	cd_local_baixa = cd_local_baixa_p,
	ds_observacao	= ds_observacao_ww
where	nr_sequencia	= nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rop_baixa_peca ( nr_sequencia_p bigint, cd_motivo_baixa_p bigint, ds_observacao_p text, cd_local_baixa_p bigint, nm_usuario_p text) FROM PUBLIC;
