-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_local_atend_bio ( ie_acao_p text, nr_seq_finger_p bigint, nr_seq_maquina_p bigint, ds_chave_ativacao_p text, ds_serial_p text, dt_ativacao_licenca_p timestamp, dt_fim_licenca_p timestamp, ie_fornecedor_p text, nm_usuario_web_p text, nm_usuario_p text) AS $body$
DECLARE


/*ie_acao_p
I - Insert
U - Update
*/
BEGIN

if (ie_acao_p = 'I') then

	insert into local_atend_med_maq_finger(
			nr_sequencia, dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_maquina,
			ds_chave_ativacao, ds_serial, dt_ativacao_licenca,
			dt_fim_licenca,	nm_usuario_ativacao, ie_fornecedor)
		values (	nextval('local_atend_med_maq_finger_seq'), clock_timestamp(), nm_usuario_p,
			clock_timestamp(), nm_usuario_p, nr_seq_maquina_p,
			ds_chave_ativacao_p, ds_serial_p, dt_ativacao_licenca_p,
			dt_fim_licenca_p, nm_usuario_web_p, ie_fornecedor_p);

elsif (ie_acao_p = 'U' and (nr_seq_finger_p IS NOT NULL AND nr_seq_finger_p::text <> '')) then

	update	local_atend_med_maq_finger
	set	dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p,
		ds_chave_ativacao = ds_chave_ativacao_p,
		ds_serial = ds_serial_p,
		dt_ativacao_licenca = dt_ativacao_licenca_p,
		dt_fim_licenca = dt_fim_licenca_p,
		ie_fornecedor = ie_fornecedor_p,
		nm_usuario_ativacao = nm_usuario_web_p
	where	nr_sequencia = nr_seq_finger_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_local_atend_bio ( ie_acao_p text, nr_seq_finger_p bigint, nr_seq_maquina_p bigint, ds_chave_ativacao_p text, ds_serial_p text, dt_ativacao_licenca_p timestamp, dt_fim_licenca_p timestamp, ie_fornecedor_p text, nm_usuario_web_p text, nm_usuario_p text) FROM PUBLIC;
