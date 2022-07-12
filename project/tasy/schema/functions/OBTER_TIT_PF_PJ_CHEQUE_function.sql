-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tit_pf_pj_cheque (nr_seq_cheque_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w		varchar(3999);
nr_titulos_w		varchar(255);
cd_pessoa_fisica_w	varchar(10);
cd_cgc_w		varchar(14);
ds_auxiliar_w		varchar(3999);	
 
C01 CURSOR FOR  -- Buscar titulos vinculados ao cheque 
	SELECT x.* 	 
	from ( 
		SELECT	a.nr_titulo 
		from	cheque_bordero_titulo b, 
			titulo_pagar a 
		where	a.nr_titulo	= b.nr_titulo 
		and	b.nr_seq_cheque	= nr_seq_cheque_p 
		
union
 
		select	a.nr_titulo 
		from	cheque_bordero_titulo b, 
			titulo_pagar a 
		where	a.nr_bordero	= b.nr_bordero 
		and	b.nr_seq_cheque	= nr_seq_cheque_p 
		
union
 
		select	a.nr_titulo 
		from	titulo_pagar a 
		where	exists (select	1 
			 from	adiantamento_pago_cheque z, 
				titulo_pagar_adiant y 
			 where	y.nr_titulo		= a.nr_titulo 
			 and	y.nr_adiantamento	= z.nr_adiantamento 
			 and	z.nr_seq_cheque		= nr_seq_cheque_p) 
		
union
 
		select	a.nr_titulo 
		from	titulo_pagar a 
		where	exists (select	1 
			from	adiantamento_pago_cheque z 
			where	z.nr_seq_cheque		= nr_seq_cheque_p 
			and	z.nr_adiantamento	= a.nr_adiant_pago) 
		) x 
		order by 1;
		
C02 CURSOR FOR  -- Buscar PF/PJ dos titulos 
	SELECT cd_pessoa_fisica, 
		cd_cgc 
	from	titulo_pagar 
	where	nr_titulo = nr_titulos_w;
		

BEGIN 
 
open C01;
loop 
fetch C01 into	 
	nr_titulos_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	if (nr_titulos_w IS NOT NULL AND nr_titulos_w::text <> '') then 
	 
		open C02;
		loop 
		fetch C02 into	 
			cd_pessoa_fisica_w, 
			cd_cgc_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin 
			ds_retorno_w := ds_retorno_w || nr_titulos_w ||' - '|| SUBSTR(obter_nome_pf_pj(cd_pessoa_fisica_w,cd_cgc_w),1,80)||', ';	
			end;
		end loop;
		close C02;
	 
	end if;
	 
	end;
end loop;
close C01;
 
return	substr(ds_retorno_w,1,3999);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tit_pf_pj_cheque (nr_seq_cheque_p bigint) FROM PUBLIC;
