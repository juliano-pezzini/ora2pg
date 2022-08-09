-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_dados_contrato ( nr_seq_contrato_p bigint, ie_campo_dado_p text, ie_valor_informacao_p text, ie_tipo_historico_p text, ds_historico_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


ds_update_w			varchar(4000);


BEGIN

ds_update_w := 	' update	pls_contrato ' ||
		' set	' || ie_campo_dado_p || ' = ' || chr(39) || ie_valor_informacao_p || chr(39) || ',' ||
		'	nm_usuario = ' || chr(39) || nm_usuario_p || chr(39) ||
		' where	nr_sequencia = ' || to_char(nr_seq_contrato_p);

CALL Exec_sql_Dinamico('Tasy',ds_update_w);

insert into pls_contrato_historico(	nr_sequencia, cd_estabelecimento, nr_seq_contrato, dt_historico, dt_atualizacao,
		ie_tipo_historico, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, ds_historico,
		ds_observacao)
	values (	nextval('pls_contrato_historico_seq'), cd_estabelecimento_p, nr_seq_contrato_p, clock_timestamp(), clock_timestamp(),
		ie_tipo_historico_p, nm_usuario_p, clock_timestamp(), nm_usuario_p, ds_historico_p,
		'pls_alterar_dados_contrato');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_dados_contrato ( nr_seq_contrato_p bigint, ie_campo_dado_p text, ie_valor_informacao_p text, ie_tipo_historico_p text, ds_historico_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
