-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_atualizar_medico_creden ( nm_usuario_p text) AS $body$
DECLARE



cd_pessoa_fisica_w	varchar(20);

c01 CURSOR FOR
SELECT	b.cd_pessoa_fisica
from	medico b
where	ie_corpo_clinico = 'S'
and 	not exists (	select	x.cd_medico
			from 	sus_medico_credenciamento x
			where 	x.cd_medico = b.cd_pessoa_fisica);

BEGIN

open 	c01;
loop
fetch c01 	into
		cd_pessoa_fisica_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		insert into sus_medico_credenciamento(	nr_sequencia,
						cd_medico,
						dt_atualizacao,
						ie_auditor,
						ie_conveniado,
						ie_credenciamento,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						ie_situacao)
		SELECT	nextval('sus_medico_credenciamento_seq'),
			b.cd_pessoa_fisica,
                        clock_timestamp(),
			'N',
			'S',
			'30',
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			'A'
		from 	medico b
		where 	ie_corpo_clinico = 'S'
		and 	not exists (	SELECT x.cd_medico
					from 	sus_medico_credenciamento x
					where 	x.cd_medico = b.cd_pessoa_fisica);
		end;
end loop;
close c01;
commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_atualizar_medico_creden ( nm_usuario_p text) FROM PUBLIC;

