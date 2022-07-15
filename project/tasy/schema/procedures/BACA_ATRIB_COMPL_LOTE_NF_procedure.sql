-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_atrib_compl_lote_nf () AS $body$
DECLARE



C01 CURSOR FOR
SELECT	nm_atributo,
	nr_sequencia
from	atributo_compl_hist
where	cd_tipo_lote_contab = 2
order by nr_sequencia;

c_nota_saida CURSOR FOR
SELECT	nm_atributo,
	nr_sequencia
from	atributo_compl_hist
where	cd_tipo_lote_contab = 51
order by nr_sequencia;

nm_atributo_w		varchar(255);
nr_sequencia_w		bigint;
qt_atrib_lote_nf_w	bigint;
qt_atrib_lote_saida_w	bigint;
i integer;

type Vetor is table of c01%RowType index by integer;
atrib_nf_padrao		Vetor;
atrib_nf_saida		Vetor;

BEGIN

select	count(nr_sequencia)
into STRICT	qt_atrib_lote_nf_w
from	atributo_compl_hist
where	cd_tipo_lote_contab	= 2;

select	count(nr_sequencia)
into STRICT	qt_atrib_lote_saida_w
from	atributo_compl_hist
where	cd_tipo_lote_contab	= 51;

if (qt_atrib_lote_nf_w = qt_atrib_lote_saida_w) and (qt_atrib_lote_saida_w > 0) then
	begin
	CALL exec_sql_dinamico('Matheus','create table bkp_atributo_compl_hist as select * from atributo_compl_hist');
	qt_atrib_lote_nf_w := obter_valor_dinamico('select count(*) from bkp_atributo_compl_hist', qt_atrib_lote_nf_w);
	if (qt_atrib_lote_nf_w > 0) then
		begin
		i := 0;
		OPEN C01;
		LOOP
		FETCH C01 into
			nm_atributo_w,
			nr_sequencia_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			i := I + 1;
			atrib_nf_padrao[i].nm_atributo	:= nm_atributo_w;
			atrib_nf_padrao[i].nr_sequencia	:= nr_sequencia_w;
		END LOOP;
		CLOSE C01;

		i := 0;
		OPEN c_nota_saida;
		LOOP
		FETCH c_nota_saida into
			nm_atributo_w,
			nr_sequencia_w;
		EXIT WHEN NOT FOUND; /* apply on c_nota_saida */
			i := I + 1;
			atrib_nf_saida[i].nm_atributo	:= nm_atributo_w;
			atrib_nf_saida[i].nr_sequencia	:= nr_sequencia_w;
		END LOOP;
		CLOSE c_nota_saida;

		for i in 1..atrib_nf_padrao.Count loop
			begin
			update	atributo_compl_hist
			set	nm_atributo	= atrib_nf_padrao[i].nm_atributo
			where	nr_sequencia	= atrib_nf_saida[i].nr_sequencia
			and	atrib_nf_saida[i].nm_atributo <> atrib_nf_padrao[i].nm_atributo
			and	cd_tipo_lote_contab = 51;

			end;
		end loop;
		end;
	end if;
	end;
commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_atrib_compl_lote_nf () FROM PUBLIC;

