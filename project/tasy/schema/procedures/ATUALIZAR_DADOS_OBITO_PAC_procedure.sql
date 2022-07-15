-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_dados_obito_pac (dt_liberacao_p timestamp, dt_liberacao_old_p timestamp, nm_usuario_p text, nr_atendimento_p bigint, dt_obito_p timestamp, dt_obito_old_p timestamp, cd_cid_direta_p text, ie_rn_p text) AS $body$
DECLARE


cd_pessoa_fisica_w		varchar(10);
ie_atualiza_cid_morte_aih_w	varchar(10) := 'N';
dt_emissao_w			timestamp;
qt_registro_w			bigint;
nr_aih_w			bigint;
nr_seq_aih_w			bigint;


BEGIN
CALL atualizar_dados_pac_obito(dt_liberacao_p, dt_liberacao_old_p, nm_usuario_p, nr_atendimento_p, dt_obito_p, dt_obito_old_p, cd_cid_direta_p, ie_rn_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_dados_obito_pac (dt_liberacao_p timestamp, dt_liberacao_old_p timestamp, nm_usuario_p text, nr_atendimento_p bigint, dt_obito_p timestamp, dt_obito_old_p timestamp, cd_cid_direta_p text, ie_rn_p text) FROM PUBLIC;

