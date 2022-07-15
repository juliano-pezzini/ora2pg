-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lic_alterar_quantidade_item ( nr_seq_licitacao_p bigint, nr_seq_lic_item_p bigint, qt_item_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_item_w		double precision;
vl_maximo_edital_w		double precision;



BEGIN

select	qt_item,
	coalesce(vl_maximo_edital,0)
into STRICT	qt_item_w,
	vl_maximo_edital_w
from	reg_lic_item
where	nr_seq_licitacao = nr_seq_licitacao_p
and	nr_seq_lic_item = nr_seq_lic_item_p;

update	reg_lic_item
set	qt_item = qt_item_p
where	nr_seq_licitacao = nr_seq_licitacao_p
and	nr_seq_lic_item = nr_seq_lic_item_p;

if (vl_maximo_edital_w > 0) then
	update	reg_lic_item
	set	vl_total_item = (qt_item_p * vl_maximo_edital_w)
	where	nr_seq_licitacao = nr_seq_licitacao_p
	and	nr_seq_lic_item = nr_seq_lic_item_p;
end if;

CALL lic_gerar_hist_alt_item(
	nr_seq_licitacao_p,
	nr_seq_lic_item_p,
	'QT_ITEM',
	'B',
	qt_item_w,
	qt_item_p,
	nm_usuario_p);


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lic_alterar_quantidade_item ( nr_seq_licitacao_p bigint, nr_seq_lic_item_p bigint, qt_item_p bigint, nm_usuario_p text) FROM PUBLIC;

