-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cus_calc_ajuste_orc_html (cd_estabelecimento_p bigint, nr_seq_tabela_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_tabela_custo_w	bigint;


BEGIN

cd_tabela_custo_w := obter_tab_custo_html(nr_seq_tabela_p);

CALL cus_calcular_ajuste_orc(cd_estabelecimento_p,
			 cd_tabela_custo_w,
			 nr_seq_tabela_p,
			 nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cus_calc_ajuste_orc_html (cd_estabelecimento_p bigint, nr_seq_tabela_p bigint, nm_usuario_p text) FROM PUBLIC;

