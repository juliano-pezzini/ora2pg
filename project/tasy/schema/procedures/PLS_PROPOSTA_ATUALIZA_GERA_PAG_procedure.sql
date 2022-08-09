-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_proposta_atualiza_gera_pag ( nr_seq_proposta_p bigint, cd_cgc_estipulante_p text, cd_estipulante_p text, nm_usuario_p text, qt_pagador_p INOUT bigint) AS $body$
BEGIN

if (nr_seq_proposta_p IS NOT NULL AND nr_seq_proposta_p::text <> '') then
	begin
	CALL pls_proposta_atualiza_dados(
		nr_seq_proposta_p,
		nm_usuario_p);

/*	pls_proposta_gerar_pagador(
		nr_seq_proposta_p,
		nm_usuario_p);	*/
	if (coalesce(cd_cgc_estipulante_p::text, '') = '') then
		select	count(*)
		into STRICT	qt_pagador_p
		from	pls_proposta_pagador
		where	nr_seq_proposta	= nr_seq_proposta_p
		and	cd_cgc_pagador	= cd_cgc_estipulante_p;
	elsif (cd_estipulante_p IS NOT NULL AND cd_estipulante_p::text <> '') then
		select	count(*)
		into STRICT	qt_pagador_p
		from	pls_proposta_pagador
		where	nr_seq_proposta	= nr_seq_proposta_p
		and	cd_pagador	= cd_estipulante_p;
	end if;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_proposta_atualiza_gera_pag ( nr_seq_proposta_p bigint, cd_cgc_estipulante_p text, cd_estipulante_p text, nm_usuario_p text, qt_pagador_p INOUT bigint) FROM PUBLIC;
