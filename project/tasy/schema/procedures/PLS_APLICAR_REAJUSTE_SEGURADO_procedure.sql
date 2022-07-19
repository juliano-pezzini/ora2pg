-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_aplicar_reajuste_segurado ( nr_seq_contrato_p bigint, nr_seq_intercambio_p bigint, nr_seq_reajuste_p bigint, dt_mesano_referencia_p timestamp, ie_commit_p text, nm_usuario_p text, cd_estabelecimento_p bigint ) AS $body$
DECLARE


nr_sequencia_w			bigint;
nr_seq_lote_referencia_w	bigint;
nr_contrato_w			bigint;


BEGIN

select	nextval('pls_lote_reaj_segurado_seq')
into STRICT	nr_sequencia_w
;

select	max(nr_seq_lote_referencia)
into STRICT	nr_seq_lote_referencia_w
from	pls_reajuste
where	nr_sequencia	= nr_seq_reajuste_p;

if (coalesce(nr_seq_lote_referencia_w::text, '') = '') then
	nr_seq_lote_referencia_w	:= nr_seq_reajuste_p;
end if;

begin
select	nr_contrato
into STRICT	nr_contrato_w
from	pls_contrato	a
where	nr_sequencia	= nr_seq_contrato_p;
exception
when others then
	nr_contrato_w	:= null;
end;

insert into pls_lote_reaj_segurado(nr_sequencia, dt_atualizacao, nm_usuario,
	ie_status, dt_mesano_referencia, nr_seq_contrato,
	ie_tipo_contratacao, cd_estabelecimento, nr_seq_reajuste,
	nr_seq_intercambio,nr_seq_lote_referencia, nr_contrato)
values (nr_sequencia_w, clock_timestamp(), nm_usuario_p,
	'1', dt_mesano_referencia_p, CASE WHEN nr_seq_contrato_p=0 THEN null  ELSE nr_seq_contrato_p END ,
	'C', cd_estabelecimento_p, nr_seq_reajuste_p,
	nr_seq_intercambio_p,nr_seq_lote_referencia_w, nr_contrato_w);

CALL pls_gerar_preco_segurado(nr_sequencia_w,'C', 'N', nm_usuario_p,
			cd_estabelecimento_p);

if (coalesce(ie_commit_p,'S') = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_aplicar_reajuste_segurado ( nr_seq_contrato_p bigint, nr_seq_intercambio_p bigint, nr_seq_reajuste_p bigint, dt_mesano_referencia_p timestamp, ie_commit_p text, nm_usuario_p text, cd_estabelecimento_p bigint ) FROM PUBLIC;

