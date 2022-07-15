-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE bsc_gerar_informacoes (cd_empresa_p bigint, cd_estabelecimento_p bigint, cd_estab_indicador_p bigint, cd_ano_p bigint, nr_seq_edicao_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;
cd_estab_indicador_w	bigint	:= coalesce(cd_estab_indicador_p,0);
nr_seq_edicao_w		bigint	:= coalesce(nr_seq_edicao_p,0);

c01 CURSOR FOR
SELECT	nr_sequencia
from	bsc_indicador
where (cd_estab_exclusivo	= cd_estab_indicador_w or cd_estab_indicador_w = 0)
and (somente_numero(bsc_obter_edicao_indicador(nr_sequencia,'C'))	= nr_seq_edicao_w or nr_seq_edicao_w = 0)
and	ie_situacao = 'A';


BEGIN

open c01;
loop
fetch C01 into
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	CALL bsc_gerar_inf_indicador(cd_empresa_p,cd_estabelecimento_p,nr_sequencia_w,null,cd_ano_p,nm_usuario_p);
	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE bsc_gerar_informacoes (cd_empresa_p bigint, cd_estabelecimento_p bigint, cd_estab_indicador_p bigint, cd_ano_p bigint, nr_seq_edicao_p bigint, nm_usuario_p text) FROM PUBLIC;

