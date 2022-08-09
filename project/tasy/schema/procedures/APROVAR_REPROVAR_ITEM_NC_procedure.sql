-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE aprovar_reprovar_item_nc ( nr_sequencia_p bigint, ds_parecer_p text, ie_aprov_reprov_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_nc_w			bigint;
qt_registro_w			bigint;


BEGIN
if (ie_aprov_reprov_p = 'A') then

	update	nc_curva_abc_item
	set
		dt_aprovacao		= clock_timestamp(),
		nm_usuario_aprov		= nm_usuario_p,
		ds_parecer		= ds_parecer_p,
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p,
		ie_curva_atual		= ie_curva_item
	where	nr_sequencia		= nr_sequencia_p
	and	coalesce(dt_aprovacao::text, '') = ''
	and	coalesce(dt_reprovacao::text, '') = '';

elsif (ie_aprov_reprov_p = 'R') then

	update	nc_curva_abc_item
	set	dt_reprovacao		= clock_timestamp(),
		nm_usuario_reprov		= nm_usuario_p,
		ds_parecer		= ds_parecer_p,
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p
	where	nr_sequencia		= nr_sequencia_p
	and	coalesce(dt_aprovacao::text, '') = ''
	and	coalesce(dt_reprovacao::text, '') = '';
end if;

select	nr_seq_nc
into STRICT	nr_seq_nc_w
from	nc_curva_abc_item
where	nr_sequencia = nr_sequencia_p;

select	count(*)
into STRICT	qt_registro_w
from	nc_curva_abc_item
where	nr_seq_nc = nr_seq_nc_w
and	coalesce(dt_aprovacao::text, '') = ''
and	coalesce(dt_reprovacao::text, '') = '';

if (qt_registro_w = 0) then

	update	nc_curva_abc
	set	dt_fim_analise		= clock_timestamp(),
		nm_usuario_analise	= nm_usuario_p
	where	nr_sequencia		= nr_seq_nc_w;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE aprovar_reprovar_item_nc ( nr_sequencia_p bigint, ds_parecer_p text, ie_aprov_reprov_p text, nm_usuario_p text) FROM PUBLIC;
