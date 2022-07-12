-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*Procedure que carrega os dados da tabela fis_sef_edoc_controle nas variaveis globais da pck*/

CREATE OR REPLACE PROCEDURE fis_sef_edoc_reg_lfpd05_pck.fis_gerar_dados_controle_edoc ( nr_seq_controle_p bigint, nr_seq_regra_p bigint) AS $body$
BEGIN

begin

select	a.cd_estabelecimento,
	a.dt_inicio_apuracao,
	a.dt_fim_apuracao,
	a.cd_ver,
	a.ie_retificadora,
	a.cd_ctd,
	a.nr_sequencia,
	a.ie_tipo_arquivo,
	b.nr_seq_modelo_nf,
	b.ie_tipo_data,
	coalesce(a.nr_cod_0450,0)
into STRICT	current_setting('fis_sef_edoc_reg_lfpd05_pck.cd_estabelecimento_w')::fis_sef_edoc_controle.cd_estabelecimento%type,
	current_setting('fis_sef_edoc_reg_lfpd05_pck.dt_inicio_apuracao_w')::fis_sef_edoc_controle.dt_inicio_apuracao%type,
	current_setting('fis_sef_edoc_reg_lfpd05_pck.dt_fim_apuracao_w')::fis_sef_edoc_controle.dt_fim_apuracao%type,
	current_setting('fis_sef_edoc_reg_lfpd05_pck.cd_ver_w')::fis_sef_edoc_controle.cd_ver%type,
	current_setting('fis_sef_edoc_reg_lfpd05_pck.ie_retificadora_w')::fis_sef_edoc_controle.ie_retificadora%type,
	current_setting('fis_sef_edoc_reg_lfpd05_pck.cd_ctd_w')::fis_sef_edoc_controle.cd_ctd%type,
	current_setting('fis_sef_edoc_reg_lfpd05_pck.nr_seq_controle_w')::fis_sef_edoc_controle.nr_sequencia%type,
	current_setting('fis_sef_edoc_reg_lfpd05_pck.ie_tipo_arquivo_w')::fis_sef_edoc_controle.ie_tipo_arquivo%type,
	current_setting('fis_sef_edoc_reg_lfpd05_pck.nr_seq_modelo_nf_w')::fis_sef_edoc_regra.nr_seq_modelo_nf%type,
	current_setting('fis_sef_edoc_reg_lfpd05_pck.ie_tipo_data_w')::fis_sef_edoc_regra.ie_tipo_data%type,
	current_setting('fis_sef_edoc_reg_lfpd05_pck.nr_cod_0450_w')::fis_sef_edoc_controle.nr_cod_0450%type
from	fis_sef_edoc_controle a,
	fis_sef_edoc_regra b
where	a.nr_sequencia		= b.nr_seq_controle
and	a.nr_sequencia		= nr_seq_controle_p
and 	b.nr_sequencia		= nr_seq_regra_p;

exception
when others then
	PERFORM set_config('fis_sef_edoc_reg_lfpd05_pck.cd_estabelecimento_w', null, false);
	PERFORM set_config('fis_sef_edoc_reg_lfpd05_pck.dt_inicio_apuracao_w', null, false);
	PERFORM set_config('fis_sef_edoc_reg_lfpd05_pck.dt_fim_apuracao_w', null, false);
	PERFORM set_config('fis_sef_edoc_reg_lfpd05_pck.cd_ver_w', null, false);
	PERFORM set_config('fis_sef_edoc_reg_lfpd05_pck.ie_retificadora_w', null, false);
	PERFORM set_config('fis_sef_edoc_reg_lfpd05_pck.cd_ctd_w', null, false);
	PERFORM set_config('fis_sef_edoc_reg_lfpd05_pck.nr_seq_controle_w', null, false);
	PERFORM set_config('fis_sef_edoc_reg_lfpd05_pck.ie_tipo_arquivo_w', null, false);
	PERFORM set_config('fis_sef_edoc_reg_lfpd05_pck.nr_seq_modelo_nf_w', null, false);
	PERFORM set_config('fis_sef_edoc_reg_lfpd05_pck.ie_tipo_data_w', null, false);
	PERFORM set_config('fis_sef_edoc_reg_lfpd05_pck.nr_cod_0450_w', null, false);
end;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_sef_edoc_reg_lfpd05_pck.fis_gerar_dados_controle_edoc ( nr_seq_controle_p bigint, nr_seq_regra_p bigint) FROM PUBLIC;
