-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rp_inserir_lista_espera (nr_seq_modelo_p text, cd_pessoa_fisica_p text, nm_usuario_p text) AS $body$
BEGIN

insert into rp_lista_espera_modelo(nr_sequencia,
				   dt_atualizacao,
				   nm_usuario,
				   dt_atualizacao_nrec,
				   nm_usuario_nrec,
				   nr_seq_modelo,
				   cd_pessoa_fisica,
				   dt_inclusao_lista,
				   ie_status,
				   cd_estabelecimento)
			values (nextval('rp_lista_espera_modelo_seq'),
				  clock_timestamp(),
				  nm_usuario_p,
				  clock_timestamp(),
				  nm_usuario_p,
				  nr_seq_modelo_p,
				  cd_pessoa_fisica_p,
				  clock_timestamp(),
				  'A',
				  wheb_usuario_pck.get_cd_estabelecimento);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rp_inserir_lista_espera (nr_seq_modelo_p text, cd_pessoa_fisica_p text, nm_usuario_p text) FROM PUBLIC;
