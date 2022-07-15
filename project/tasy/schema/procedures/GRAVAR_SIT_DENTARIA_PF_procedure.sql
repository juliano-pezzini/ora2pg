-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_sit_dentaria_pf ( nr_seq_conta_p bigint, cd_pessoa_fisica_p bigint, ie_tipo_guia_p text, nm_usuario_p text) AS $body$
DECLARE


qt_guia_odonto_w		smallint;
qt_pls_lote_anexo_cta_imp_w	smallint;
nr_seq_anexo_cta_imp_w		bigint;
nr_seq_anexo_odo_cta_imp_w	bigint;
cd_situacao_inicial_w		varchar(20);
cd_dente_w			varchar(20);
dt_autorizacao_w		timestamp;
ie_sinais_doenca_periodont_w	varchar(1);
ie_alter_tecido_mole_w		varchar(1);
nr_seq_fis_boca_sit_w		bigint;
nr_seq_fis_boca_situacao_w	bigint;
cd_regiao_boca_w		varchar(20);
cd_pessoa_fisica_w		bigint;
dt_situacao_final_w		bigint;
dt_atualizacao_w		timestamp;
qt_registro_w			bigint;
dt_fim_tratamento_w		timestamp;
dt_atendimento_w		timestamp;
dt_max_atendimento_w		timestamp;

C01 CURSOR FOR
	SELECT 	nr_sequencia,
		cd_dente,
		cd_situacao_inicial
	from	pls_lote_anexo_odo_cta_imp
	where	nr_seq_anexo_cta_imp = nr_seq_anexo_cta_imp_w;

C02 CURSOR FOR
	SELECT	distinct a.cd_regiao_boca
	from	pls_conta_proc_v a
	where	a.cd_pessoa_fisica_conta = cd_pessoa_fisica_w
	and	a.dt_procedimento between dt_autorizacao_w and coalesce(dt_fim_tratamento_w,clock_timestamp());


BEGIN
/* Esta procedure não será mais utilizada, a nova procedure para este processo é a PLS_GRAVAR_SIT_DENTARIA_PF, devido sua nomenclatura documentada de forma incorreta
*/
null;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_sit_dentaria_pf ( nr_seq_conta_p bigint, cd_pessoa_fisica_p bigint, ie_tipo_guia_p text, nm_usuario_p text) FROM PUBLIC;

