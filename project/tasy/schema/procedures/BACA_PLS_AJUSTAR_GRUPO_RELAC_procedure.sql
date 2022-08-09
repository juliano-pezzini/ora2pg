-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_pls_ajustar_grupo_relac (cd_estabelecimento_p bigint) AS $body$
DECLARE


qt_registros_w		bigint;
nr_seq_relatorio_w	bigint;
ie_padrao_w		varchar(2);

nr_seq_grupo_w		bigint;
nr_seq_grupo_ww		bigint;

C01 CURSOR FOR
	SELECT  b.nr_seq_relatorio,
		b.ie_padrao
	from	pls_regra_relat_grupo  a,
		pls_regra_relatorio  b
	where	a.nr_sequencia = b.nr_seq_grupo
	and	a.nr_seq_grupo_relat  = (SELECT max(nr_sequencia) from pls_grupo_relatorio where cd_grupo = '35');


BEGIN

select	max(nr_sequencia)
into STRICT	nr_seq_grupo_ww
from	pls_grupo_relatorio
where	cd_grupo = '42';

if (nr_seq_grupo_ww IS NOT NULL AND nr_seq_grupo_ww::text <> '') then

	select	count(1)
	into STRICT	qt_registros_w
	from	pls_regra_relat_grupo
	where 	nr_seq_grupo_relat = nr_seq_grupo_ww;

	if (qt_registros_w = 0) then

		select	nextval('pls_regra_relat_grupo_seq')
		into STRICT	nr_seq_grupo_w
		;

		insert into pls_regra_relat_grupo(nr_sequencia, ie_grupo, dt_atualizacao,
						  nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
						  cd_estabelecimento, nr_seq_anterior, nr_seq_grupo_relat)
					    values (nr_seq_grupo_w, null, clock_timestamp(),
						   'BACA', clock_timestamp(), 'BACA',
						   cd_estabelecimento_p, null, nr_seq_grupo_ww);

		open C01;
		loop
		fetch C01 into
			nr_seq_relatorio_w,
			ie_padrao_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
				insert into pls_regra_relatorio(nr_sequencia, nr_seq_grupo, dt_atualizacao,
								nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
								nr_seq_relatorio, ie_padrao)
							values (nextval('pls_regra_relatorio_seq'), nr_seq_grupo_w, clock_timestamp(),
								'BACA', clock_timestamp(), 'BACA',
								nr_seq_relatorio_w, ie_padrao_w);

			end;
		end loop;
		close C01;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_pls_ajustar_grupo_relac (cd_estabelecimento_p bigint) FROM PUBLIC;
