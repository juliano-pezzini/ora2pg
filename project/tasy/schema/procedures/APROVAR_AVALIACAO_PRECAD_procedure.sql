-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE aprovar_avaliacao_precad ( nr_seq_avaliacao_p bigint, nr_seq_processo_precad_p bigint, ie_tipo_pre_cadastro_p text, cd_estabelecimento_p bigint, nm_usuario_p text ) AS $body$
BEGIN

update pre_cad_avaliacao
set dt_aprovacao = clock_timestamp(), nm_usuario_aprov = nm_usuario_p 
where nr_sequencia = nr_seq_avaliacao_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE aprovar_avaliacao_precad ( nr_seq_avaliacao_p bigint, nr_seq_processo_precad_p bigint, ie_tipo_pre_cadastro_p text, cd_estabelecimento_p bigint, nm_usuario_p text ) FROM PUBLIC;
