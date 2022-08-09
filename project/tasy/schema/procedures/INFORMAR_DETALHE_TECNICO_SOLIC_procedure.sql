-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE informar_detalhe_tecnico_solic ( nr_solic_compra_p bigint, nr_item_solic_compra_p bigint, ds_titulo_p text, ds_detalhe_p text, nm_usuario_p text) AS $body$
BEGIN

if (nr_solic_compra_p IS NOT NULL AND nr_solic_compra_p::text <> '') then
		insert into solic_compra_item_detalhe(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_solic_compra,
				nr_item_solic_compra,
				ds_titulo,
				ds_detalhe)
		values (	nextval('solic_compra_item_detalhe_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_solic_compra_p,
				nr_item_solic_compra_p,
				ds_titulo_p,
				ds_detalhe_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE informar_detalhe_tecnico_solic ( nr_solic_compra_p bigint, nr_item_solic_compra_p bigint, ds_titulo_p text, ds_detalhe_p text, nm_usuario_p text) FROM PUBLIC;
