-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_atualizar_mes_reaj_pck.alterar_dt_contratacao_benef ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, dt_contratacao_p pls_segurado.dt_contratacao%type, nr_mes_reajuste_p pls_segurado.nr_mes_reajuste%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


nr_mes_reajuste_w	pls_segurado.nr_mes_reajuste%type;


BEGIN

nr_mes_reajuste_w	:= (to_char(dt_contratacao_p,'mm'))::numeric;

if (nr_mes_reajuste_w <> nr_mes_reajuste_p) then
	CALL pls_atualizar_mes_reaj_pck.att_mes_reajuste_benef(nr_seq_segurado_p, nr_mes_reajuste_w, 'N', nm_usuario_p);
end if;

CALL pls_atualizar_mes_reaj_pck.atualizar_mes_reajuste_sca(nr_seq_segurado_p, null, nr_mes_reajuste_w, 'N', nm_usuario_p);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_mes_reaj_pck.alterar_dt_contratacao_benef ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, dt_contratacao_p pls_segurado.dt_contratacao%type, nr_mes_reajuste_p pls_segurado.nr_mes_reajuste%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
