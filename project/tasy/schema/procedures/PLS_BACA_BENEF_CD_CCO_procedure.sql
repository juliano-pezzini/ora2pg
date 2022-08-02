-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


procedure pls_baca_benef_cd_cco is 
 
type t_varchar2_table_12 is table of varchar2(12) index by pls_integer; 
 
tb_nr_seq_segurado_w	pls_util_cta_pck.t_number_table; 
tb_cd_cco_w		t_varchar2_table_12; 
x			number(10); 
Cursor C01 is 
	select	nr_sequencia, 
		lpad(nr_cco,10,0) || lpad(nvl(ie_digito_cco,0),2,0) cd_cco 
	from	pls_segurado 
	where	nr_cco is not null 
	and	cd_cco is null; 
 



CREATE OR REPLACE PROCEDURE atualiza_registros (ie_final_p text) AS $body$
BEGIN
if (x >= 500 or ie_final_p = 'S') then 
	if (tb_nr_seq_segurado_w.count > 0) then 
		forall i in tb_nr_seq_segurado_w.first..tb_nr_seq_segurado_w.last 
			update	pls_segurado 
			set	cd_cco		= tb_cd_cco_w(i) 
			where	nr_sequencia	= tb_nr_seq_segurado_w(i);
		commit;
		 
		tb_nr_seq_segurado_w.delete;
		tb_cd_cco_w.delete;
		x := 0;
	end if;
else 
	x := x + 1;
end if;
end;
 
begin 
x := 0;
tb_nr_seq_segurado_w.delete;
tb_cd_cco_w.delete;
for r_c01_w in C01 loop 
	begin 
	tb_nr_seq_segurado_w(x)	:= r_c01_w.nr_sequencia;
	tb_cd_cco_w(x)		:= r_c01_w.cd_cco;
	 
	CALL atualiza_registros('N');
	end;
end loop;
 
CALL atualiza_registros('S');
 
end;
$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON PROCEDURE atualiza_registros (ie_final_p text) FROM PUBLIC;

