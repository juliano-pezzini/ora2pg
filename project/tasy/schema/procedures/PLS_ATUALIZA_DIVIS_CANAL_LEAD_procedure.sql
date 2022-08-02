-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualiza_divis_canal_lead ( nr_seq_solicitacao_p bigint, nr_seq_solic_vendedor_p bigint, ie_vendedor_base_p text, tx_repasse_p bigint, tx_repasse_total_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_divisao_repasse_w	varchar(2) := null;


BEGIN

update	pls_solicitacao_vendedor
set	ie_vendedor_base = ie_vendedor_base_p,
	tx_repasse = coalesce(tx_repasse_p,0),
	nm_usuario = nm_usuario_p,
	dt_atualizacao = clock_timestamp()
where	nr_sequencia = nr_seq_solic_vendedor_p;

if (tx_repasse_total_p = 0) then
	ie_divisao_repasse_w	:= 'N';
elsif (tx_repasse_total_p = 100) then
	ie_divisao_repasse_w	:= 'S';
end if;

if (ie_divisao_repasse_w IS NOT NULL AND ie_divisao_repasse_w::text <> '') then
	update	pls_solicitacao_comercial
	set	ie_divisao_repasse = ie_divisao_repasse_w,
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where	nr_sequencia = nr_seq_solicitacao_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualiza_divis_canal_lead ( nr_seq_solicitacao_p bigint, nr_seq_solic_vendedor_p bigint, ie_vendedor_base_p text, tx_repasse_p bigint, tx_repasse_total_p bigint, nm_usuario_p text) FROM PUBLIC;

