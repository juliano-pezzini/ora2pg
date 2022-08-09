-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gpi_gerar_real_movto_financ ( nr_seq_projeto_p bigint, nr_seq_orcamento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_etapa_gpi_w		bigint;
nr_sequencia_w			bigint;
qt_registro_w			bigint;
vl_realizado_w			double precision;

c01 CURSOR FOR
SELECT	a.nr_seq_etapa_gpi,
	a.vl_transacao
from	movto_trans_financ a
where	a.nr_seq_proj_gpi	= nr_seq_projeto_p
and	(a.nr_seq_etapa_gpi IS NOT NULL AND a.nr_seq_etapa_gpi::text <> '')
and	coalesce(vl_transacao,0) <> 0;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_etapa_gpi_w,
	vl_realizado_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	max(nr_sequencia)
	into STRICT	nr_sequencia_w
	from	gpi_orc_item a
	where	nr_seq_orcamento	= nr_seq_orcamento_p
	and	nr_seq_etapa	= nr_seq_etapa_gpi_w;

	update	gpi_orc_item
	set	vl_realizado	= coalesce(vl_realizado,0) + vl_realizado_w,
		ie_origem_real	= 'F'
	where	nr_sequencia	= nr_sequencia_w;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gpi_gerar_real_movto_financ ( nr_seq_projeto_p bigint, nr_seq_orcamento_p bigint, nm_usuario_p text) FROM PUBLIC;
