-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_entrada_visitante ( nr_sequencia_p bigint, ie_controle_p text, nr_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w			bigint;


BEGIN


select 	nextval('atendimento_visita_seq')
into STRICT	nr_sequencia_w
;

insert into atendimento_visita(
	nr_sequencia,
	nr_atendimento,
	dt_atualizacao,
	nm_usuario,
	dt_entrada,
	nr_seq_tipo,
	dt_saida,
	ds_observacao,
	cd_pessoa_fisica,
	nr_seq_controle,
	nm_visitante,
	cd_setor_atendimento,
	nr_identidade,
	nr_telefone,
	dt_nascimento)
SELECT	nr_sequencia_w,
	nr_atendimento_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	null,
	null,
	null,
	cd_pessoa_lib,
	null,
	substr(NM_PESSOA_LIBERACAO,1,60),
	null,
	nr_identidade,
	null,
	null
from	ATENDIMENTO_VISITA_LIB
where	nr_sequencia	= nr_sequencia_p;


commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_entrada_visitante ( nr_sequencia_p bigint, ie_controle_p text, nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;

