-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE finalizar_coleta_doacao_js ( nr_seq_doacao_p bigint, cd_pessoa_coleta_p text, ie_status_p text, nr_sec_saude_p san_doacao.nr_sec_saude%type, qt_coletada_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_mensagem_p INOUT text, dt_fim_coleta_p timestamp default clock_timestamp()) AS $body$
DECLARE


ie_registra_coletor_usuario_w	varchar(1);
dt_fim_coleta_w                 timestamp;


BEGIN

dt_fim_coleta_w := to_date(to_char(clock_timestamp(),'dd/mm/yyyy') ||' '|| to_char(coalesce(dt_fim_coleta_p,clock_timestamp()),'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss');

CALL finalizar_coleta_doacao(
	nr_seq_doacao_p,
	cd_pessoa_coleta_p,
	ie_status_p,
	qt_coletada_p,
	nm_usuario_p,
        dt_fim_coleta_w);

if (coalesce(nr_sec_saude_p::text, '') = '') then
	begin
	ds_mensagem_p := san_gerar_numero_secretaria(
		nr_seq_doacao_p, cd_estabelecimento_p, nm_usuario_p, ds_mensagem_p);
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE finalizar_coleta_doacao_js ( nr_seq_doacao_p bigint, cd_pessoa_coleta_p text, ie_status_p text, nr_sec_saude_p san_doacao.nr_sec_saude%type, qt_coletada_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_mensagem_p INOUT text, dt_fim_coleta_p timestamp default clock_timestamp()) FROM PUBLIC;

