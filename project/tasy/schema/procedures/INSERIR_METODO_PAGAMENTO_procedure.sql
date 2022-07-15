-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_metodo_pagamento ( cd_tipo_p text, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE



cd_tipo_recebimento_w		tipo_recebimento.cd_tipo_recebimento%type;


BEGIN

if (cd_tipo_p IS NOT NULL AND cd_tipo_p::text <> '') then
	

	insert into fis_metodo_pagamento(
		nr_sequencia,	
		cd_tipo_recebimento,
		dt_atualizacao,
		nm_usuario,
		nr_seq_nota
		)values (
		nextval('fis_metodo_pagamento_seq'),
		cd_tipo_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_sequencia_p);	

	end if;


commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_metodo_pagamento ( cd_tipo_p text, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

