-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_tit_pagar_baixa ( nr_titulo_p bigint, nr_sequencia_p bigint, nm_usuario_p text, ie_commit_p text default 'S') AS $body$
DECLARE


cd_estabelecimento_w		smallint;


BEGIN

select	max(cd_estabelecimento)
into STRICT	cd_estabelecimento_w
from	titulo_pagar
where	nr_titulo	= nr_titulo_p;

CALL pls_gerar_classif_ops_tit_pg(nr_titulo_p, nr_sequencia_p, nm_usuario_p);

/* francisco - os 80633 - 01/03/2008 */

CALL atualiza_tributo_baixa(nr_titulo_p,nr_sequencia_p,nm_usuario_p);

CALL gerar_movto_tit_baixa(nr_titulo_p,nr_sequencia_p,'P',nm_usuario_p,'N');

CALL atualizar_saldo_tit_pagar(nr_titulo_p,nm_usuario_p);

CALL Gerar_W_Tit_Pag_imposto(nr_titulo_p,nm_usuario_p);

CALL gerar_titulo_ir(nr_titulo_p,nr_sequencia_p,nm_usuario_p,ie_commit_p);

CALL gerar_titulo_pagar_baixa_cc(nr_titulo_p,nr_sequencia_p,'N',nm_usuario_p);

CALL ratear_baixa_tit_pagar_nc(nr_titulo_p,nr_sequencia_p,nm_usuario_p);

CALL gerar_alerta_baixa_tit_pagar(nr_titulo_p,nr_sequencia_p,cd_estabelecimento_w,nm_usuario_p);

if (coalesce(ie_commit_p,'S') = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_tit_pagar_baixa ( nr_titulo_p bigint, nr_sequencia_p bigint, nm_usuario_p text, ie_commit_p text default 'S') FROM PUBLIC;

