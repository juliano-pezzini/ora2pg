-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE html_param_converter_log ( nm_tabela_p text, nr_seq_tabela_p bigint, cd_estab_param_p bigint, cd_perfil_param_p bigint, nm_usuario_param_p text, cd_funcao_p bigint, nr_seq_param_p bigint, vl_parametro_p text, nr_seq_lote_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_log_w		varchar(2000);
nr_sequencia_w		log_tasy.nr_sequencia%type;


BEGIN

ds_log_w	:= substr(wheb_mensagem_pck.get_texto(988534,
						'CD_FUNCAO=' || to_char(cd_funcao_p) ||
						';NR_PARAM=' || to_char(nr_seq_param_p) ||
						';VL_PARAM=' || vl_parametro_p ||
						';CD_ESTAB=' || to_char(cd_estab_param_p) ||
						';CD_PERFIL=' || to_char(cd_perfil_param_p) ||
						';NM_USUARIO=' || nm_usuario_param_p ||
						';NM_TABELA=' || nm_tabela_p ||
						';NR_SEQ_TABELA=' || to_char(nr_seq_tabela_p) ||
						';NR_LOTE=' || to_char(nr_seq_lote_p)),1,2000);

select	nextval('log_tasy_seq')
into STRICT	nr_sequencia_w
;

insert into log_tasy(
	dt_atualizacao,
	nm_usuario,
	cd_log,
	ds_log,
	nr_sequencia)
values (clock_timestamp(),
	nm_usuario_p,
	1635,
	ds_log_w,
	nr_sequencia_w);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE html_param_converter_log ( nm_tabela_p text, nr_seq_tabela_p bigint, cd_estab_param_p bigint, cd_perfil_param_p bigint, nm_usuario_param_p text, cd_funcao_p bigint, nr_seq_param_p bigint, vl_parametro_p text, nr_seq_lote_p bigint, nm_usuario_p text) FROM PUBLIC;
