-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE justificar_leitura_autorizacao ( ds_biometria_p text, nr_seq_autorizacao_p bigint, nm_usuario_p text, nr_atendimento_p bigint, ie_biometria_p text, ie_guias_p text) AS $body$
DECLARE


nr_seq_autorizacao_w	bigint;

c01 CURSOR FOR
SELECT 	nr_sequencia
from	autorizacao_convenio
where	nr_atendimento = nr_atendimento_p;



BEGIN
if (ie_guias_p = 'S') then
	begin
	open c01;
	loop
	fetch c01 into	nr_seq_autorizacao_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

	insert 	into	autorizacao_convenio_bio(nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_autorizacao,
						dt_leitura,
						ds_biometria,
						ie_biometria)
					values (nextval('autorizacao_convenio_bio_seq'),
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						nr_seq_autorizacao_w,
						clock_timestamp(),
						substr(ds_biometria_p,1,4000),
						ie_biometria_p);
	end loop;
	close c01;
	end;

else
	insert 	into	autorizacao_convenio_bio(nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_autorizacao,
						dt_leitura,
						ds_biometria,
						ie_biometria)
					values (nextval('autorizacao_convenio_bio_seq'),
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						nr_seq_autorizacao_p,
						clock_timestamp(),
						substr(ds_biometria_p,1,4000),
						ie_biometria_p);

end if;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE justificar_leitura_autorizacao ( ds_biometria_p text, nr_seq_autorizacao_p bigint, nm_usuario_p text, nr_atendimento_p bigint, ie_biometria_p text, ie_guias_p text) FROM PUBLIC;

