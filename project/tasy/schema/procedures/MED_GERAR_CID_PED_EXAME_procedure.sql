-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE med_gerar_cid_ped_exame (nr_seq_pedido_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_cliente_w	bigint;
ds_cid_w		varchar(4000);
ds_doenca_w		varchar(4000);
cd_cid_doenca_w		varchar(10);
ds_cid_doenca_w		varchar(240);

c01 CURSOR FOR
	SELECT	a.cd_doenca_cid,
		b.ds_doenca_cid
	from	cid_doenca b,
		med_pac_cid a
	where	a.cd_doenca_cid	= b.cd_doenca_cid
	and	a.nr_seq_cliente	= nr_seq_cliente_w
	--and 	not a.ie_status		in ('I', 'V')
	and	a.ie_status		in ('A', 'C');


BEGIN

select	nr_seq_cliente
into STRICT	nr_seq_cliente_w
from	med_pedido_exame
where	nr_sequencia	= nr_seq_pedido_p;

open	c01;
loop
fetch	c01 into
	cd_cid_doenca_w,
	ds_cid_doenca_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	ds_cid_w	:= ds_cid_w || cd_cid_doenca_w || ' - ';
	ds_doenca_w	:= ds_doenca_w || ds_cid_doenca_w || ' - ';

	end;
end loop;
close c01;

update	med_pedido_exame
set	ds_cid		   = substr(ds_cid_w,1,2000),
	ds_diagnostico_cid = substr(ds_doenca_w,1,2000)
where	nr_sequencia	= nr_seq_pedido_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_gerar_cid_ped_exame (nr_seq_pedido_p bigint, nm_usuario_p text) FROM PUBLIC;

