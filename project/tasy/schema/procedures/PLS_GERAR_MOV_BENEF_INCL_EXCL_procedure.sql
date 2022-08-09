-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_mov_benef_incl_excl ( nr_seq_plano_p bigint, nr_seq_contrato_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, nm_usuario_p text, ie_tipo_movimentacao_p text) AS $body$
DECLARE


--Váriaveis
nr_seq_plano_w		bigint;
nr_seq_contrato_w	bigint;
--Cursor que busca todos numeros de sequencia do pls_segurado  que estejam entre as datas passadas por parâmetro.
BEGIN

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_mov_benef_incl_excl ( nr_seq_plano_p bigint, nr_seq_contrato_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, nm_usuario_p text, ie_tipo_movimentacao_p text) FROM PUBLIC;
