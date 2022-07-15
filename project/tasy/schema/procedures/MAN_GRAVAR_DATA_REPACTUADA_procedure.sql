-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_gravar_data_repactuada ( nm_usuario_p text, ie_data_ini_p text, ie_data_fim_p text, nr_seq_ordem_p bigint) AS $body$
DECLARE


dt_inicio_repactuado_w		timestamp;
dt_fim_repactuado_w		timestamp;


BEGIN
select	a.dt_inicio_repactuado,
	a.dt_fim_repactuado
into STRICT	dt_inicio_repactuado_w,
	dt_fim_repactuado_w
from	man_ordem_servico a
where	a.nr_sequencia = nr_seq_ordem_p;

insert	into man_ordem_repactuada_log(	nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					nr_seq_ordem,
					dt_ini_repactuada,
					dt_fim_repactuada)
				values (	nextval('man_ordem_repactuada_log_seq'),
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_ordem_p,
					dt_inicio_repactuado_w,
					dt_fim_repactuado_w);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_gravar_data_repactuada ( nm_usuario_p text, ie_data_ini_p text, ie_data_fim_p text, nr_seq_ordem_p bigint) FROM PUBLIC;

