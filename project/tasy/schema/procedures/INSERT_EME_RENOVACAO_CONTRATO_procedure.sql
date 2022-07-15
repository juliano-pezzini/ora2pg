-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_eme_renovacao_contrato ( nr_sequencia_p bigint, dt_validade_p timestamp, ds_observacao_p text) AS $body$
BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (dt_validade_p IS NOT NULL AND dt_validade_p::text <> '') then
	begin
	update	eme_contrato
	set	dt_validade = dt_validade_p
	where	nr_sequencia = nr_sequencia_p;
	commit;

	insert into eme_renovacao_contrato(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				ds_observacao,
				dt_renovacao,
				dt_validade,
				nr_seq_contrato)
			values (nextval('eme_renovacao_contrato_seq'),
				clock_timestamp(),
				wheb_usuario_pck.get_nm_usuario,
				clock_timestamp(),
				wheb_usuario_pck.get_nm_usuario,
				ds_observacao_p,
				clock_timestamp(),
				dt_validade_p,
				nr_sequencia_p
				);
	commit;

	end;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_eme_renovacao_contrato ( nr_sequencia_p bigint, dt_validade_p timestamp, ds_observacao_p text) FROM PUBLIC;

