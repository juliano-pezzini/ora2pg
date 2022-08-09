-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_baca_link_ged (nm_usuario_p text) AS $body$
DECLARE


nr_seq_contrato_w		pls_contrato.nr_sequencia%type;
cd_empresa_w			pls_contrato.cd_operadora_empresa%type;
cd_matricula_familia_w		pls_segurado.cd_matricula_familia%type;
cd_matricula_estipulante_w	pls_segurado.cd_matricula_estipulante%type;
cd_usuario_plano_w		pls_segurado_carteira.cd_usuario_plano%type;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		cd_operadora_empresa
	from	pls_contrato;

C02 CURSOR FOR
	SELECT	a.cd_matricula_familia,
		a.cd_matricula_estipulante,
		(SELECT	max(x.cd_usuario_plano)
		from	pls_segurado_carteira x
		where	a.nr_sequencia = x.nr_seq_segurado)
	from	pls_segurado a
	where	a.nr_seq_contrato = nr_seq_contrato_w
	group by a.cd_matricula_familia;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_contrato_w,
	cd_empresa_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	CALL pls_gerar_link_ged(nr_seq_contrato_w,null,null,cd_empresa_w,'C',null,nm_usuario_p);
	
	open C02;
	loop
	fetch C02 into
		cd_matricula_familia_w,
		cd_matricula_estipulante_w,
		cd_usuario_plano_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		CALL pls_gerar_link_ged(nr_seq_contrato_w,cd_matricula_familia_w,cd_matricula_estipulante_w,cd_empresa_w,'B',cd_usuario_plano_w,nm_usuario_p);
		end;
	end loop;
	close C02;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_baca_link_ged (nm_usuario_p text) FROM PUBLIC;
