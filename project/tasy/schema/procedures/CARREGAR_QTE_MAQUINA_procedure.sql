-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE carregar_qte_maquina (nr_sequencia_p bigint) AS $body$
DECLARE


vl_inf_w		varchar(100);
id_inf_w		varchar(50);
cd_cnpj_w	varchar(14);

C01 CURSOR FOR
	SELECT	COUNT(DISTINCT ds_maquina),
		Obter_Cgc_Estabelecimento(Obter_Estabelecimento_Ativo),
		Obter_Global_Name
	FROM	TASY_CONTROLE_LOGIN
	WHERE	dt_acesso BETWEEN TO_DATE ((	SELECT	MAX(a.dt_versao)
						FROM	APLICACAO_TASY_VERSAO a
						WHERE	TRUNC(a.dt_versao) <> TRUNC(clock_timestamp())),'dd/mm/yy')
						AND	Fim_Dia(TO_DATE(clock_timestamp(), 'dd/mm/yy'))
	AND ds_aplicacao = 'TasySwing'
	AND (ds_maquina IS NOT NULL AND ds_maquina::text <> '')
	GROUP BY Obter_Cgc_Estabelecimento(Obter_Estabelecimento_Ativo);


BEGIN

open c01;
loop
fetch c01 into
	vl_inf_w,
	cd_cnpj_w,
	id_inf_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
        begin

        CALL insert_inf_base_cliente(
            nr_sequencia_p,
            vl_inf_w,
            id_inf_w,
            cd_cnpj_w,
            null,
            'Tasy');
        end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE carregar_qte_maquina (nr_sequencia_p bigint) FROM PUBLIC;
