-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ul_acertar_duplic_pf_base (nr_codigo_acesso_p bigint, nr_registros_p bigint) AS $body$
DECLARE


cd_pf_w	varchar(10);
cd_pf_ww	varchar(10);
qt_err_w	bigint;
nr_seq_w	bigint;
log_w		varchar(2000);

c01 CURSOR FOR
SELECT	a.cd_pessoa_fisica,
	b.cd_pessoa_fisica
from	pessoa_fisica a,
	pessoa_fisica b
where	a.cd_pessoa_fisica		<> b.cd_pessoa_fisica
and	upper(a.nm_pessoa_fisica)	= upper(b.nm_pessoa_fisica)
and	a.dt_nascimento		= b.dt_nascimento
and	a.nr_cpf			= b.nr_cpf
and	not exists (	select	1
						from	ul_log_ac_dupl_pf
						where	cd_orig = a.cd_pessoa_fisica
						and	cd_dest = b.cd_pessoa_fisica
						and	ie = 'N')
order by
	a.cd_pessoa_fisica,
	b.cd_pessoa_fisica LIMIT (-1);


BEGIN

if (nr_codigo_acesso_p = 834) and (nr_registros_p > 0) and (nr_registros_p <= 100) then

	open c01;
	loop
	fetch c01 into	cd_pf_w,
				cd_pf_ww;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin

		select	nextval('ul_log_ac_dupl_pf_seq')
		into STRICT	nr_seq_w
		;

		insert into ul_log_ac_dupl_pf(
			nr_seq,
			cd_orig,
			cd_dest,
			ie
			)
		values (
			nr_seq_w,
			cd_pf_w,
			cd_pf_ww,
			'S'
			);

		begin
			qt_err_w := acertar_duplic_pessoa_fisica(cd_pf_w, cd_pf_ww, 'R', 'ULACDUPLPF', 'N', clock_timestamp(), qt_err_w);
			qt_err_w := acertar_duplic_pessoa_fisica(cd_pf_w, cd_pf_ww, 'T', 'ULACDUPLPF', 'N', clock_timestamp(), qt_err_w);
		exception
		when others then

			log_w	:= substr(sqlerrm, 1,2000);

			update	ul_log_ac_dupl_pf
			set	ie	= 'N',
				log	= log_w
		 	where	nr_seq	= nr_seq_w;

		end;

		end;
	end loop;
	close c01;

elsif (nr_registros_p > 100) then

	RAISE EXCEPTION '%', 'O número máximo de registros permitidos é 100!' USING ERRCODE = '45011';

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ul_acertar_duplic_pf_base (nr_codigo_acesso_p bigint, nr_registros_p bigint) FROM PUBLIC;
