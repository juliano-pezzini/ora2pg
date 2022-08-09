-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_resumo_consulta_pep_js ( cd_pessoa_fisica_p text, nm_procedure_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_laudo_w	bigint;
ds_resumo_w	text;
ds_laudo_w	text;
ds_consulta_w	text;

c01 CURSOR FOR
SELECT	nr_seq_laudo,
	ds_resumo
from 	w_oft_resumo_consulta
where 	cd_pessoa_fisica = cd_pessoa_fisica_p
and 	nm_usuario = nm_usuario_p
order by
	nr_sequencia;


BEGIN
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (nm_procedure_p IS NOT NULL AND nm_procedure_p::text <> '') then
	begin
	CALL exec_sql_dinamico('','begin gerar_resumo_oftalmo_pkg.' || nm_procedure_p || '(' || chr(39) || cd_pessoa_fisica_p || chr(39) || ','
											|| chr(39) || nm_usuario_p || chr(39) || ','
											|| 'null' || '); end;');

	CALL exec_sql_dinamico('Tasy','truncate table w_valor_long');

	open c01;
	loop
	fetch c01 into	nr_seq_laudo_w,
			ds_resumo_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		if (nr_seq_laudo_w IS NOT NULL AND nr_seq_laudo_w::text <> '') then
			begin
				begin

				select	ds_laudo
				into STRICT	ds_laudo_w
				from	laudo_paciente
				where	nr_sequencia = nr_seq_laudo_w;

				exception
				when others then
					ds_laudo_w := ds_resumo_w;
				end;
			insert into w_valor_long values (ds_laudo_w);

			end;
		else
			begin
			insert into w_valor_long values (ds_resumo_w);
			end;
		end if;
		end;
	end loop;
	close c01;

	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_resumo_consulta_pep_js ( cd_pessoa_fisica_p text, nm_procedure_p text, nm_usuario_p text) FROM PUBLIC;
