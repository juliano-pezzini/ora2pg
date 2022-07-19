-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_indice_reajuste ( nr_seq_contrato_p bigint, nr_seq_indice_reajuste_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_indice_reajuste_w	bigint;
ds_indice_reajuste_antigo_w	varchar(30);
ds_indice_reajuste_novo_w	varchar(30);


BEGIN

select	nr_seq_indice_reajuste
into STRICT	nr_seq_indice_reajuste_w
from	pls_contrato
where	nr_sequencia = nr_seq_contrato_p;

select  max(ds_moeda)
into STRICT	ds_indice_reajuste_antigo_w
from    moeda
where 	cd_moeda = nr_seq_indice_reajuste_w;

select  max(ds_moeda)
into STRICT	ds_indice_reajuste_novo_w
from    moeda
where 	cd_moeda = nr_seq_indice_reajuste_p;

update	pls_contrato
set	nr_seq_indice_reajuste = CASE WHEN nr_seq_indice_reajuste_p=0 THEN null  ELSE nr_seq_indice_reajuste_p END ,
	dt_atualizacao = clock_timestamp(),
	nm_usuario = nm_usuario_p
where	nr_sequencia = nr_seq_contrato_p;

insert into pls_contrato_historico(	nr_sequencia, cd_estabelecimento, nr_seq_contrato, dt_historico, ie_tipo_historico,
		dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, ds_historico,
		ds_observacao)
	values (	nextval('pls_contrato_historico_seq'), cd_estabelecimento_p, nr_seq_contrato_p, clock_timestamp(), '51',
		clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 'De: ' || ds_indice_reajuste_antigo_w || '. Para: ' || ds_indice_reajuste_novo_w,
		'pls_alterar_indice_reajuste');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_indice_reajuste ( nr_seq_contrato_p bigint, nr_seq_indice_reajuste_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

