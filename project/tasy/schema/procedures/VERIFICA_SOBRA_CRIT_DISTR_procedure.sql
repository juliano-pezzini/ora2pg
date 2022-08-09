-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE verifica_sobra_crit_distr ( nr_seq_tabela_p bigint, dt_mes_referencia_p timestamp, cd_estabelecimento_p bigint, ds_retorno_p INOUT text) AS $body$
DECLARE


cd_tabela_custo_w			integer;
nr_seq_distribuicao_w		bigint;
nr_seq_tabela_crit_w		bigint;


c01 CURSOR FOR
SELECT	b.nr_seq_distribuicao
from	criterio_distr_orc b
where	b.nr_seq_tabela	= nr_seq_tabela_crit_w
and	(b.qt_base_distribuicao - (cus_obter_qt_distribuicao(b.cd_sequencia_criterio)) <> 0);


BEGIN

ds_retorno_p := '';

select	max(nr_seq_tabela_param)
into STRICT	nr_seq_tabela_crit_w
from	tabela_parametro
where	nr_seq_tabela		= nr_seq_tabela_p
and	nr_seq_parametro	= 2;

open c01;
loop
fetch c01 into
	nr_seq_distribuicao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	ds_retorno_p := substr(ds_retorno_p ||nr_seq_distribuicao_w ||' - ',1,255);
	end;
end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE verifica_sobra_crit_distr ( nr_seq_tabela_p bigint, dt_mes_referencia_p timestamp, cd_estabelecimento_p bigint, ds_retorno_p INOUT text) FROM PUBLIC;
