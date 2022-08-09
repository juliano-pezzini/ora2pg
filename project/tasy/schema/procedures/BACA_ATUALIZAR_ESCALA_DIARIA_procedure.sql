-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_atualizar_escala_diaria () AS $body$
DECLARE



cd_pessoa_fisica_w	varchar(10);
cd_pessoa_duplic_w	varchar(10);
nr_sequencia_w		bigint;

c01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.cd_pessoa_fisica
	from	escala_diaria a
	where	(a.cd_pessoa_fisica IS NOT NULL AND a.cd_pessoa_fisica::text <> '')
	and	not exists (SELECT 1
		from	pessoa_fisica b
		where	b.cd_pessoa_fisica	= a.cd_pessoa_fisica);



BEGIN

open	c01;
loop
fetch	c01 into
	nr_sequencia_w,
	cd_pessoa_fisica_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select	coalesce(max(a.cd_pessoa_fisica),'0')
	into STRICT	cd_pessoa_duplic_w
	from	pessoa_fisica b,
		pessoa_fisica_duplic a
	where	a.cd_cadastro		= cd_pessoa_fisica_w
	and	a.cd_pessoa_fisica 	= b.cd_pessoa_fisica;

	if (cd_pessoa_duplic_w <> '0') then
		begin

		update	escala_diaria
		set	cd_pessoa_fisica	= cd_pessoa_duplic_w
		where	nr_sequencia		= nr_sequencia_w;

		/*insert	into logxxxxx_tasy (dt_atualizacao, nm_usuario, cd_log, ds_log)
			values (sysdate, 'TASY', 56001, 'Acerto Pessoa Escala Diaria ' || cd_pessoa_fisica_w || ' para ' || cd_pessoa_duplic_w || ' Seq. ' || nr_sequencia_w); */
		end;
	else
		begin

		update	escala_diaria
		set	cd_pessoa_fisica	 = NULL
		where	nr_sequencia		= nr_sequencia_w;

		/*insert	into logxxxxx_tasy (dt_atualizacao, nm_usuario, cd_log, ds_log)
			values (sysdate, 'TASY', 56002, 'Não Acerto Pessoa Escala Diaria ' || cd_pessoa_fisica_w || ' Null Seq. ' || nr_sequencia_w); */
		end;
	end if;


	end;
end loop;
close c01;

CALL exec_sql_dinamico('TASY', ' ALTER TABLE ESCALA_DIARIA ADD
				(CONSTRAINT ESCDIAR_PESFISI_FK FOREIGN KEY (
				               CD_PESSOA_FISICA)
				REFERENCES PESSOA_FISICA (
				               CD_PESSOA_FISICA)) ');

CALL exec_sql_dinamico('TASY', ' CREATE INDEX ESCDIAR_PESFISI_FK_I ON ESCALA_DIARIA(CD_PESSOA_FISICA) ');



commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_atualizar_escala_diaria () FROM PUBLIC;
