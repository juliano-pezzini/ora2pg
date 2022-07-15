-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desfazer_baixa_item_acha_perd ( nm_usuario_p text, nr_seq_item_p bigint, nr_seq_atend_achado_p bigint) AS $body$
DECLARE


dt_baixa_w	timestamp;


BEGIN

if (coalesce(nr_seq_item_p,0) > 0) then

	update	atend_achado_perdido_item
	set	dt_baixa                      = NULL,
		nm_usuario                   = nm_usuario_p,
		dt_atualizacao		     = clock_timestamp(),
		nr_seq_status_achado_perdido  = NULL,
		nr_seq_tipo_baixa             = NULL,
		cd_pessoa_retirada            = NULL,
		nm_pessoa_retirada            = NULL,
		cd_cnpj_doacao                = NULL,
		nm_pessoa_juridica_doacao     = NULL,
		cd_pessoa_doacao              = NULL,
		nm_pessoa_doacao              = NULL,
		ds_obs_baixa		      = NULL
	where	nr_sequencia  = nr_seq_item_p;

	select	dt_baixa
	into STRICT	dt_baixa_w
	from	atend_achado_perdido
	where	nr_sequencia = nr_seq_atend_achado_p;

	if (dt_baixa_w IS NOT NULL AND dt_baixa_w::text <> '') then

		update	atend_achado_perdido
		set	dt_baixa  = NULL,
			nm_usuario = nm_usuario_p
		where	nr_sequencia = nr_seq_atend_achado_p;

	end if;


end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desfazer_baixa_item_acha_perd ( nm_usuario_p text, nr_seq_item_p bigint, nr_seq_atend_achado_p bigint) FROM PUBLIC;

