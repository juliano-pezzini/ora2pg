-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_atrib_estrutura_conta (nr_seq_estrut_orig_p bigint, nr_seq_estrut_dest_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert into convenio_estrut_atrib(nr_sequencia, nm_atributo, nr_seq_atributo,
	dt_atualizacao, nm_usuario, nm_alias, ds_mascara, ie_totaliza,
	ie_quebra, qt_tamanho, ie_imprime, ie_soma_total, ie_conversao,
	nm_tabela_conversao, nm_atributo_conversao, ie_soma_estrutura,
	QT_TAM_FONTE, nr_seq_interno, ie_estender, nr_seq_ordem, ie_ordena_decrescente)
SELECT 	nr_seq_estrut_dest_p,
	nm_atributo, nr_seq_atributo, clock_timestamp(),
	nm_usuario_p,
	nm_alias, ds_mascara, ie_totaliza, ie_quebra,
	qt_tamanho, ie_imprime, ie_soma_total,
	ie_conversao, nm_tabela_conversao,
	nm_atributo_conversao, ie_soma_estrutura,
	QT_TAM_FONTE, nextval('convenio_estrut_atrib_seq'),
	ie_estender, nr_seq_ordem, ie_ordena_decrescente
from 	convenio_estrut_atrib
where 	nr_sequencia = nr_seq_estrut_orig_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_atrib_estrutura_conta (nr_seq_estrut_orig_p bigint, nr_seq_estrut_dest_p bigint, nm_usuario_p text) FROM PUBLIC;
