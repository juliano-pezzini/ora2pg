-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*PROCEDURE*/

/*Procedure de graçâo de dados dos registros*/

CREATE OR REPLACE PROCEDURE fis_sef_edoc_reg_geral_pck.fis_gerar_dados_edoc ( nr_seq_controle_p bigint) AS $body$
BEGIN

CALL CALL fis_sef_edoc_reg_geral_pck.fis_gerar_dados_usuario_edoc();

/*Chamada da procedure que carrega os dados da tabela fis_sef_edoc_controle nas variaveis globais da pck*/

CALL CALL fis_sef_edoc_reg_geral_pck.fis_gerar_dados_controle_edoc(nr_seq_controle_p);

CALL fis_sef_edoc_reg_geral_pck.fis_limpa_dados_edoc(nr_seq_controle_p);

if (current_setting('fis_sef_edoc_reg_geral_pck.ie_tipo_arquivo_w')::fis_sef_edoc_controle.ie_tipo_arquivo%type = 1) then
	CALL fis_sef_edoc_reg_extrato_pck.fis_gerar_dados_edoc_extrato(nr_seq_controle_p);
elsif (current_setting('fis_sef_edoc_reg_geral_pck.ie_tipo_arquivo_w')::fis_sef_edoc_controle.ie_tipo_arquivo%type = 2) then
	CALL fis_sef_edoc_reg_lfpd05_pck.fis_gerar_dados_edoc_icms(nr_seq_controle_p);
elsif (current_setting('fis_sef_edoc_reg_geral_pck.ie_tipo_arquivo_w')::fis_sef_edoc_controle.ie_tipo_arquivo%type = 7) then
	CALL fis_sef_edoc_reg_lfpd12_pck.fis_gerar_dados(nr_seq_controle_p);
end if;

/*Chamada da procedure que gera os dados dos registros 0000 dos arquivos*/

CALL fis_sef_edoc_reg_geral_pck.fis_gerar_reg_0000_edoc();

/*Chamada da procedure que gera os dados dos registros 0005 dos arquivos*/

CALL fis_sef_edoc_reg_geral_pck.fis_gerar_reg_0005_edoc();

if (current_setting('fis_sef_edoc_reg_geral_pck.ie_tipo_arquivo_w')::fis_sef_edoc_controle.ie_tipo_arquivo%type in (2,4,5,6,7)) then
	/*Chamada da procedure que gera os dados dos registros 0025 dos arquivos*/

	CALL fis_sef_edoc_reg_geral_pck.fis_gerar_reg_0025_edoc();
end if;

/*Chamada da procedure que gera os dados dos registros 0030 dos arquivos*/

CALL fis_sef_edoc_reg_geral_pck.fis_gerar_reg_0030_edoc();

/*Chamada da procedure que gera os dados dos registros 0100 dos arquivos*/

CALL fis_sef_edoc_reg_geral_pck.fis_gerar_reg_0100_edoc();

if (current_setting('fis_sef_edoc_reg_geral_pck.ie_tipo_arquivo_w')::fis_sef_edoc_controle.ie_tipo_arquivo%type in (1,2,3,4,6,7)) then
	/*ATENÇÃO - O 0175 É CHAMANDO DENTRO DO 0150
	Chamada da procedure que gera os dados dos registros 0150 dos arquivos*/
	CALL fis_sef_edoc_reg_geral_pck.fis_gerar_reg_0150_edoc();
end if;

if (current_setting('fis_sef_edoc_reg_geral_pck.ie_tipo_arquivo_w')::fis_sef_edoc_controle.ie_tipo_arquivo%type in (1,5,7)) then
	/*Chamada da procedure que gera os dados dos registros 0200 dos arquivos*/

	CALL fis_sef_edoc_reg_geral_pck.fis_gerar_reg_0200_edoc();
end if;

if (current_setting('fis_sef_edoc_reg_geral_pck.ie_tipo_arquivo_w')::fis_sef_edoc_controle.ie_tipo_arquivo%type in (1,2,5)) then
	/*Chamada da procedure que gera os dados dos registros 0400 dos arquivos*/

	CALL fis_sef_edoc_reg_geral_pck.fis_gerar_reg_0400_edoc();
end if;

if (current_setting('fis_sef_edoc_reg_geral_pck.ie_tipo_arquivo_w')::fis_sef_edoc_controle.ie_tipo_arquivo%type in (1,2,4,5,6,7)) then
	/*Chamada da procedure que gera os dados dos registros 0450 dos arquivos*/

	CALL fis_sef_edoc_reg_geral_pck.fis_gerar_reg_0450_edoc();
end if;


END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_sef_edoc_reg_geral_pck.fis_gerar_dados_edoc ( nr_seq_controle_p bigint) FROM PUBLIC;