-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE material_ficha_tecnica_prod ( productcode_p bigint, nm_usuario_p text, nr_seq_ficha_tecnica_p INOUT bigint, nr_mims_version_p bigint) AS $body$
DECLARE

			
qt_reg_w		bigint;
produc_code_w		bigint;
nr_seq_ficha_tecnica_w	bigint;
nr_seq_superior_w	bigint;
gen_code_superior_w	bigint;
ds_superior_w		varchar(255);
ie_unico_w		boolean;
cd_atc_w		varchar(255);
ie_varios_w		varchar(10);
mims_ficha_prod_w	mims_ficha_prod%rowtype;

	
C02 CURSOR FOR
	SELECT	distinct b.*,
		coalesce(b.approved,b.GENCODE) generic_code
	from	ActiveComposition a,
		GENDAT b
	where	a.genericcode = b.GENCODE
	and 	a.ProductCode = produc_code_w;
	
	
C03 CURSOR FOR
	SELECT	 a.gencode, max(a.genericsort) genericsort, b.generic
	from	GMDAT a,
		GENDAT b
	where	a.prodcode = produc_code_w
	and	b.gencode = a.gencode
	group by a.gencode,  b.generic
	order by genericsort;
	
	
c04 CURSOR FOR
	SELECT	a.nr_sequencia nr_seq_ficha_tecnica
	from	medic_ficha_tecnica a,
		DCB_MEDIC_CONTROLADO b
	where	a.nr_seq_dcb	= b.nr_sequencia
	and	ie_varios_w = 'N'
	and	coalesce(a.nr_seq_superior::text, '') = ''
	and	exists (	SELECT	1
				from	ActiveComposition x,
					GENDAT y
				where	x.genericcode = y.GENCODE
				and 	x.ProductCode = produc_code_w
				and	coalesce(to_char(y.approved),to_char(y.GENCODE)) = b.CD_DCB)
	
union
	
	select	a.nr_seq_superior nr_seq_ficha_tecnica
	from	medic_ficha_tecnica a,
		DCB_MEDIC_CONTROLADO b
	where	a.nr_seq_dcb	= b.nr_sequencia
	and	(a.nr_seq_superior IS NOT NULL AND a.nr_seq_superior::text <> '')
	and	ie_varios_w = 'S'
	and	exists (	select	1
				from	ActiveComposition x,
					GENDAT y
				where	x.genericcode = y.GENCODE
				and 	x.ProductCode = produc_code_w
				and	coalesce(to_char(y.approved),to_char(y.GENCODE)) = b.CD_DCB);
	
BEGIN

select	max(nr_seq_ficha_tecnica)
into STRICT	nr_seq_superior_w
from	mims_ficha_prod
where	productcode	= productcode_p
-- and nr_seq_mims_version is null;
and NR_MAIN_TABLES_REF_VERSION = nr_mims_version_p;


if (coalesce(nr_seq_superior_w::text, '') = '') then
	produc_code_w	:= productcode_p;

	select	CASE WHEN count(distinct genericcode)=1 THEN 'N'  ELSE 'S' END
	into STRICT	ie_varios_w
	from	ActiveComposition
	where	productcode = produc_code_w;
	


	for r_c04 in c04 loop
		begin
		select	count(1)
		into STRICT	qt_reg_w
		from (	SELECT	distinct to_char(coalesce(y.approved,y.GENCODE))
				from	ActiveComposition x,
					GENDAT y
				where	x.genericcode = y.GENCODE
				and 	x.ProductCode = produc_code_w
				EXCEPT
				SELECT	z.cd_dcb
				from (	select	b.CD_DCB
						from	medic_ficha_tecnica a,
							DCB_MEDIC_CONTROLADO b
						where	a.nr_seq_dcb	= b.nr_sequencia
						and	ie_varios_w = 'N'
						and	a.nr_sequencia = r_c04.nr_seq_ficha_tecnica
						and	coalesce(a.nr_seq_superior::text, '') = ''
						
union
	
						select	b.CD_DCB
						from	medic_ficha_tecnica a,
							DCB_MEDIC_CONTROLADO b
						where	a.nr_seq_dcb	= b.nr_sequencia
						and	a.nr_seq_superior = r_c04.nr_seq_ficha_tecnica
						and	ie_varios_w = 'S') z
			) alias5;
		
		if (qt_reg_w	=0) then
			select	count(1)
			into STRICT	qt_reg_w
			from (	SELECT	z.CD_DCB
					from (
							SELECT	b.CD_DCB
							from	medic_ficha_tecnica a,
								DCB_MEDIC_CONTROLADO b
							where	a.nr_seq_dcb	= b.nr_sequencia
							and	ie_varios_w = 'N'
							and	a.nr_sequencia = r_c04.nr_seq_ficha_tecnica
							and	coalesce(a.nr_seq_superior::text, '') = ''
							
union
	
							select	b.CD_DCB
							from	medic_ficha_tecnica a,
								DCB_MEDIC_CONTROLADO b
							where	a.nr_seq_dcb	= b.nr_sequencia
							and	a.nr_seq_superior = r_c04.nr_seq_ficha_tecnica
							and	ie_varios_w = 'S')  z
					EXCEPT
					select	distinct to_char(coalesce(y.approved,y.GENCODE))
					from	ActiveComposition x,
						GENDAT y
					where	x.genericcode = y.GENCODE
					and 	x.ProductCode = produc_code_w
				) alias6;

				
				if (qt_reg_w	= 0) then
					nr_seq_superior_w	:= r_c04.nr_seq_ficha_tecnica;
					exit;
				end if;
			
		end if;
		
	
		end;
	end loop;
	

	if (coalesce(nr_seq_superior_w::text, '') = '') then
		begin
		nr_seq_ficha_tecnica_w	:= null;
		ds_superior_w		:= null;
		
		
		if (produc_code_w IS NOT NULL AND produc_code_w::text <> '')  then
			
			select	count(distinct genericcode)
			into STRICT	qt_reg_w
			from	ActiveComposition
			where	productcode = produc_code_w;
			
			ie_unico_w	:= (qt_reg_w = 1);
			
			if (not ie_unico_w) then
				
				for r_c03 in c03 loop
					begin
					
					if (coalesce(ds_superior_w::text, '') = '') or (length(ds_superior_w || ' + '|| r_c03.generic ) < 80) then
						if (coalesce(ds_superior_w::text, '') = '') then
							ds_superior_w	:= r_c03.generic;
						else
							ds_superior_w	:= ds_superior_w || ' + '|| r_c03.generic;
						end if;
						
					else
						ds_superior_w	:= substr(ds_superior_w || ' + '||'etc.' ,1,80);
						exit;
					end if;
					
					
					end;
				end loop;
			
				nr_seq_superior_w := material_imp_ficha_tec(	null, ds_superior_w, null, nr_seq_superior_w, null, null, nm_usuario_p
              );
				
				
			end if;
					

			for r_c02 in c02 loop
				begin
				
				nr_seq_ficha_tecnica_w := material_imp_ficha_tec(	r_c02.generic_code, r_c02.GENERIC, nr_seq_superior_w, nr_seq_ficha_tecnica_w, r_c02.generic_code, null, nm_usuario_p
              );
				
				null;
				
				end;
			end loop;
			
			nr_seq_superior_w	:= coalesce(nr_seq_superior_w,nr_seq_ficha_tecnica_w);
			
					
		end if;
		
		end;
	end if;
	
	if (nr_seq_superior_w IS NOT NULL AND nr_seq_superior_w::text <> '') then
		
		mims_ficha_prod_w.PRODUCTCODE		:= productcode_p;
		mims_ficha_prod_w.NR_SEQ_FICHA_TECNICA	:= nr_seq_superior_w;
		mims_ficha_prod_w.NR_MAIN_TABLES_REF_VERSION := nr_mims_version_p;
		
		insert into mims_ficha_prod values (mims_ficha_prod_w.*);
		
	end if;

end if;

nr_seq_ficha_tecnica_p	:= nr_seq_superior_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE material_ficha_tecnica_prod ( productcode_p bigint, nm_usuario_p text, nr_seq_ficha_tecnica_p INOUT bigint, nr_mims_version_p bigint) FROM PUBLIC;

