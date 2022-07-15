-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dacon_registro_r16a ( nr_seq_dacon_p bigint, nm_usuario_P text) AS $body$
DECLARE


cd_conta_contabil_w	conta_contabil.cd_conta_contabil%type;
vl_debito_w		ctb_saldo.vl_debito%type;
vl_credito_w		ctb_saldo.vl_credito%type;
vl_saldo_w		ctb_saldo.vl_saldo%type;
vl_movimento_w		ctb_saldo.vl_movimento%type;
ie_tipo_conta_w		varchar(10);
ie_tipo_valor_w		varchar(10);
dt_referencia_w		timestamp;
vl_apuracao_w		double precision;
vl_receita_total_w	double precision;
vl_receita_nao_cum_w	double precision;
vl_receita_bens_w	double precision;
vl_desp_energ_w		double precision;
ds_arquivo_w		varchar(2000);
vl_receita_bem_165_w	double precision;
vl_receita_bem_065_w	double precision;

C01 CURSOR FOR
	SELECT  coalesce(cd_conta_contabil,'X'),
		coalesce(ie_tipo_conta,'X'),
		coalesce(ie_tipo_valor,'X')
	from    dacon_regra_conta_ctb
	where   nr_seq_dacon = nr_seq_dacon_p
	and	cd_registro  = 'R16A';

C02 CURSOR FOR
	SELECT	rpad('R16A',4,' ')						--01
		||lpad((to_char(dt_referencia, 'MM'))::numeric ,2,0)		--02
		||lpad(1,2,0) 							--03
		||lpad(0,14,0) 					--04
		||lpad(0,14,0)							--05
		||lpad(0,14,0)				--06
		||lpad(0,14,0)							--07
		||lpad(0,14,0)					--08
		||lpad(0,14,0)							--09
		||lpad(0,14,0)				--10
		||lpad(0,14,0)							--11
		||lpad(0,14,0)							--12
		||lpad(0,14,0)							--13
		||lpad(0,14,0)							--14
		||lpad(0,14,0)							--15
		||lpad(0,14,0)							--16
		||lpad(0,14,0)							--17
		||lpad(0,14,0)							--18
		||lpad(0,14,0)							--19
		||lpad(0,14,0)							--20
		||lpad(0,14,0)							--21
		||lpad(0,14,0)							--22
		||lpad(0,14,0)							--23
		||lpad(0,14,0)							--24
		||lpad(0,14,0)							--25
		||lpad(0,14,0)							--26
		||lpad(0,14,0)							--27
		||lpad(0,14,0)							--28
		||lpad(0,14,0)							--29
		||lpad(0,14,0)							--30
		||lpad(0,14,0)							--31
		||lpad(0,14,0)							--32
		||lpad(0,14,0)							--33
		||lpad(0,14,0)							--34
		||lpad(0,14,0)							--35
		||lpad(0,14,0)							--36
		||lpad(0,38,0)							--37
		||lpad(0,10,0)							--38
	from	dacon
	where	nr_sequencia = nr_seq_dacon_p
	
union all

	SELECT	rpad('R16A',4,' ')				--01
		||lpad((to_char(dt_referencia, 'MM'))::numeric ,2,0) --02
		||lpad(2,2,0) --coluna,				--03
		||lpad(0,14,0)					--04
		||lpad(0,14,0)			--05
		||lpad(0,14,0)					--06
		||lpad(0,14,0)			--07
		||lpad(0,14,0)					--08
		||lpad(0,14,0)					--09
		||lpad(0,14,0)					--10
		||lpad(0,14,0)					--11
		||lpad(0,14,0)					--12
		||lpad(0,14,0)					--13
		||lpad(0,14,0)					--14
		||lpad(0,14,0)					--15
		||lpad(0,14,0)					--16
		||lpad(0,14,0)					--17
		||lpad(0,14,0)					--18
		||lpad(0,14,0)					--19
		||lpad(0,14,0)					--20
		||lpad(0,14,0)					--21
		||lpad(0,14,0)					--22
		||lpad(0,14,0)					--23
		||lpad(0,14,0)					--24
		||lpad(0,14,0)					--25
		||lpad(0,14,0)					--26
		||lpad(0,14,0)					--27
		||lpad(0,14,0)					--28
		||lpad(0,14,0)					--29
		||lpad(0,14,0)					--30
		||lpad(0,14,0)					--31
		||lpad(0,14,0)					--32
		||lpad(0,14,0)					--33
		||lpad(0,14,0)					--34
		||lpad(0,14,0)					--35
		||lpad(0,14,0)					--36
		||lpad(0,38,0)					--37
		||lpad(0,10,0)					--38
	from	dacon
	where	nr_sequencia = nr_seq_dacon_p
	
union all

	select	rpad('R16A',4,' ')				--01
		||lpad((to_char(dt_referencia, 'MM'))::numeric ,2,0) --02
		||lpad(3,2,0) --coluna,				--03
		||lpad(0,14,0)					--04
		||lpad(0,14,0)			--05
		||lpad(0,14,0)					--06
		||lpad(0,14,0)			--07
		||lpad(0,14,0)					--08
		||lpad(0,14,0)					--09
		||lpad(0,14,0)					--10
		||lpad(0,14,0)					--11
		||lpad(0,14,0)					--12
		||lpad(0,14,0)					--13
		||lpad(0,14,0)					--14
		||lpad(0,14,0)					--15
		||lpad(0,14,0)					--16
		||lpad(0,14,0)					--17
		||lpad(0,14,0)					--18
		||lpad(0,14,0)					--19
		||lpad(0,14,0)					--20
		||lpad(0,14,0)					--21
		||lpad(0,14,0)					--22
		||lpad(0,14,0)					--23
		||lpad(0,14,0)					--24
		||lpad(0,14,0)					--25
		||lpad(0,14,0)					--26
		||lpad(0,14,0)					--27
		||lpad(0,14,0)					--28
		||lpad(0,14,0)					--29
		||lpad(0,14,0)					--30
		||lpad(0,14,0)					--31
		||lpad(0,14,0)					--32
		||lpad(0,14,0)					--33
		||lpad(0,14,0)					--34
		||lpad(0,14,0)					--35
		||lpad(0,14,0)					--36
		||lpad(0,38,0)					--37
		||lpad(0,10,0)					--38
	from	dacon
	where	nr_sequencia = nr_seq_dacon_p;

BEGIN

select	dt_referencia
into STRICT	dt_referencia_w
from	dacon
where	nr_sequencia = nr_seq_dacon_p;

open C01;
loop
fetch C01 into
	cd_conta_contabil_w,
	ie_tipo_conta_w,
	ie_tipo_valor_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	vl_apuracao_w	:= 0;

	select sum(vl_debito),
	       sum(vl_credito),
	       sum(vl_saldo),
	       sum(vl_movimento)
	into STRICT   vl_debito_w,
	       vl_credito_w,
	       vl_saldo_w,
	       vl_movimento_w
	from   ctb_saldo
	where  cd_conta_contabil = cd_conta_contabil_w
	and	to_char(ctb_obter_mes_ref(nr_seq_mes_ref),'mm/yyyy') = to_char(dt_referencia_w,'mm/yyyy');

	--Verifica o tipo de valor a ser exportado; credito,debito,saldo,movimento.
	if (ie_tipo_valor_w = 'C')then
		vl_apuracao_w	:=	vl_credito_w;
	elsif (ie_tipo_valor_w = 'D')then
		vl_apuracao_w	:=	vl_debito_w;
	elsif (ie_tipo_valor_w = 'S')then
		vl_apuracao_w	:=	vl_saldo_w;
	elsif (ie_tipo_valor_w = 'M')	then
		vl_apuracao_w	:=	vl_movimento_w;
	end if;

	--Verifica o tipo de conta, e insere os valores para cada tipo
	if (ie_tipo_conta_w = 1)then
		vl_receita_total_w   :=  coalesce(vl_receita_total_w,0)    + coalesce(vl_apuracao_w,0);
	elsif (ie_tipo_conta_w = 2)then
		vl_receita_nao_cum_w :=  coalesce(vl_receita_nao_cum_w,0)  + coalesce(vl_apuracao_w,0);
	elsif (ie_tipo_conta_w = 3)	then
		vl_desp_energ_w	     :=	 coalesce(vl_desp_energ_w,0)       + coalesce(vl_apuracao_w,0);
	elsif (ie_tipo_conta_w in (4,5))	then
		vl_receita_bens_w    :=	 coalesce(vl_receita_bens_w,0)     + coalesce(vl_apuracao_w,0);
	end if;

	end;
end loop;
close C01;

open C02;
loop
fetch C02 into
	ds_arquivo_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin

	insert into w_dacon(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				ds_arquivo,
				nr_linha,
				ie_tipo_registro)
	values (
				nextval('w_dacon_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				ds_arquivo_w,
				1, --'Alterar', buscar o nr_linhas passando como parametro out
				34);
	end;
end loop;
close C02;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dacon_registro_r16a ( nr_seq_dacon_p bigint, nm_usuario_P text) FROM PUBLIC;

