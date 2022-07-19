-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE set_pessoa_receb_por_titulos ( nr_seq_caixa_rec_p bigint) AS $body$
DECLARE


cd_pessoa_fisica_w		TITULO_RECEBER.CD_PESSOA_FISICA%type;
cd_cgc_w				TITULO_RECEBER.CD_CGC%type;
last_cd_pessoa_fisica_w	TITULO_RECEBER.CD_PESSOA_FISICA%type;
last_cd_cgc_w			TITULO_RECEBER.CD_CGC%type;
ie_result_pf_w			boolean;
ie_result_pj_w			boolean;


c01 CURSOR FOR
SELECT b.cd_pessoa_fisica
from TITULO_RECEBER_LIQ a, 
	TITULO_RECEBER b 
where a.nr_titulo = b.nr_titulo
and (b.cd_pessoa_fisica IS NOT NULL AND b.cd_pessoa_fisica::text <> '')
and a.nr_seq_caixa_rec = nr_seq_caixa_rec_p;

c02 CURSOR FOR
SELECT b.cd_cgc
from TITULO_RECEBER_LIQ a, 
	TITULO_RECEBER b 
where a.nr_titulo = b.nr_titulo
and (b.cd_cgc IS NOT NULL AND b.cd_cgc::text <> '')
and a.nr_seq_caixa_rec = nr_seq_caixa_rec_p;


BEGIN

ie_result_pf_w := true;
ie_result_pj_w := true;

open	c01;
loop
fetch	c01 into
	cd_pessoa_fisica_w;
	
if c01%rowcount = 0 then
	ie_result_pf_w := false;
end if;
	
EXIT WHEN NOT FOUND; /* apply on c01 */

	if (coalesce(last_cd_pessoa_fisica_w::text, '') = '') then
		last_cd_pessoa_fisica_w := cd_pessoa_fisica_w;
	end if;
	
	if (last_cd_pessoa_fisica_w <> cd_pessoa_fisica_w) then
		ie_result_pf_w := false;
	end if;
	
	last_cd_pessoa_fisica_w := cd_pessoa_fisica_w;

end	loop;
close	c01;

open	c02;
loop
fetch	c02 into	
	cd_cgc_w;
	
if c02%rowcount = 0 then
	ie_result_pj_w := false;
end if;
	
EXIT WHEN NOT FOUND; /* apply on c02 */

	if (coalesce(last_cd_cgc_w::text, '') = '') then
		last_cd_cgc_w := cd_cgc_w;
	end if;
	
	if (last_cd_cgc_w <> cd_cgc_w) then
		ie_result_pj_w := false;
	end if;
	
	last_cd_cgc_w := cd_cgc_w;

end	loop;
close	c02;

-- XOR function can be used only on Oracle 11.2 and above
if (( ie_result_pf_w or ie_result_pj_w ) and not( ie_result_pj_w and ie_result_pf_w )) then

	select cd_pessoa_fisica, cd_cgc 
	into STRICT cd_pessoa_fisica_w, cd_cgc_w 
	from CAIXA_RECEB 
	where nr_sequencia = nr_seq_caixa_rec_p;
	
	if (coalesce(cd_pessoa_fisica_w::text, '') = '' and coalesce(cd_cgc_w::text, '') = '') then
		
		update CAIXA_RECEB
		set cd_pessoa_fisica = last_cd_pessoa_fisica_w, cd_cgc = last_cd_cgc_w 
		where nr_sequencia = nr_seq_caixa_rec_p;
		
		commit;
		
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE set_pessoa_receb_por_titulos ( nr_seq_caixa_rec_p bigint) FROM PUBLIC;

