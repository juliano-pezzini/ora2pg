-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_orc_regras_metricas ( nr_seq_cenario_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w			bigint;
nr_seq_metrica_w			bigint;
cd_centro_custo_w			bigint;
nr_seq_mes_ref_w			bigint;
dt_mes_inic_w				timestamp;
dt_mes_fim_w				timestamp;
ie_regra_w				varchar(20);
pr_aplicar_w				double precision;
ie_sobrepor_w				varchar(20);
qt_fixa_w				double precision;
cd_estabelecimento_w			bigint;
cd_empresa_w				bigint;
qt_leito_w				bigint;
tx_ocupacao_w				double precision;

C01 CURSOR FOR
SELECT	nr_sequencia,
	cd_estabelecimento,
	cd_centro_custo,
	nr_seq_mes_ref,
	dt_mes_inic,
	dt_mes_fim,
	ie_regra,
	pr_aplicar,
	ie_sobrepor,
	qt_fixa,
	nr_seq_metrica,
	qt_leito,
	tx_ocupacao
from	Ctb_regra_metrica
where	nr_seq_cenario	= nr_seq_cenario_p
order by nr_seq_regra;


BEGIN

delete from ctb_cen_metrica
where	nr_seq_cenario = nr_seq_cenario_p;

select	cd_empresa
into STRICT	cd_empresa_w
from	ctb_orc_cenario
where	nr_sequencia			= nr_seq_cenario_p;

OPEN C01;
LOOP
FETCH C01 into
	nr_sequencia_w,
	cd_estabelecimento_w,
	cd_centro_custo_w,
	nr_seq_mes_ref_w,
	dt_mes_inic_w,
	dt_mes_fim_w,
	ie_regra_w,
	pr_aplicar_w,
	ie_sobrepor_w,
	qt_fixa_w,
	nr_seq_metrica_w,
	qt_leito_w,
	tx_ocupacao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	CALL CTB_Aplicar_Regra_Metrica(
			nr_seq_cenario_p,
			nr_sequencia_w,
			cd_centro_custo_w,
			nr_seq_mes_ref_w,
			nr_seq_metrica_w,
			dt_mes_inic_w,
			dt_mes_fim_w,
			ie_regra_w,
			pr_aplicar_w,
			ie_sobrepor_w,
			qt_fixa_w,
			qt_leito_w,
			tx_ocupacao_w,
			cd_empresa_w,
			cd_estabelecimento_w,
			nm_usuario_p);
END LOOP;
CLOSE C01;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_orc_regras_metricas ( nr_seq_cenario_p bigint, nm_usuario_p text) FROM PUBLIC;
