-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_gerar_lote_anexo (cd_estabelecimento_p bigint, cd_convenio_p bigint, nm_usuario_p text, ie_tiss_tipo_anexo_p text, dt_inicial_p timestamp, dt_final_p timestamp, nr_seq_lote_anexo_p bigint) AS $body$
DECLARE



nr_seq_anexo_guia_w		bigint;
ie_data_lote_anexo_w		tiss_parametros_convenio.ie_data_lote_anexo%type;
c01 CURSOR FOR
SELECT	a.nr_sequencia
from	tiss_anexo_guia a,
	autorizacao_convenio b
where	a.nr_sequencia_autor		= b.nr_sequencia
and	b.cd_convenio			= cd_convenio_p
and	b.cd_estabelecimento		= cd_estabelecimento_p
and	b.ie_tiss_tipo_anexo_autor 	= ie_tiss_tipo_anexo_p
and	coalesce(a.nr_seq_lote_anexo::text, '') = ''
and	((ie_data_lote_anexo_w = 'A' AND b.dt_autorizacao	between dt_inicial_p and dt_final_p) or
	(ie_data_lote_anexo_w = 'P' AND b.dt_entrada_prevista between dt_inicial_p and dt_final_p));


BEGIN

select	coalesce(max(ie_data_lote_anexo),'A')
into STRICT	ie_data_lote_anexo_w
from	tiss_parametros_convenio
where	cd_estabelecimento 	= cd_estabelecimento_p
and	cd_convenio		= cd_convenio_p;

open C01;
loop
fetch C01 into
	nr_seq_anexo_guia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	update	tiss_anexo_guia
	set	nr_seq_lote_anexo	= nr_seq_lote_anexo_p,
		dt_inclusao_lote	= clock_timestamp(),
		nm_usuario_incl_lote	= nm_usuario_p
	where	nr_sequencia		= nr_seq_anexo_guia_w;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_gerar_lote_anexo (cd_estabelecimento_p bigint, cd_convenio_p bigint, nm_usuario_p text, ie_tiss_tipo_anexo_p text, dt_inicial_p timestamp, dt_final_p timestamp, nr_seq_lote_anexo_p bigint) FROM PUBLIC;
