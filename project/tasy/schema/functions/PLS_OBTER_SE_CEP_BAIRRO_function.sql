-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_cep_bairro ( nr_seq_bairro_p bigint, cd_cep_p text) RETURNS varchar AS $body$
DECLARE


cd_cep_ww			varchar(15)	:= null;
ie_retorno_w			varchar(1);
nr_seq_loc_w			bigint;
nr_seq_bairro_inicial_w		integer;
nr_seq_bairro_final_w		integer;

C05 CURSOR FOR
	SELECT	cd_bairro_inicial,
		cd_bairro_final,
		cd_cep
	from	cep_log
	where	nr_seq_loc		= nr_seq_loc_w
	and	cd_bairro_inicial	= nr_seq_bairro_p; -- OS 445248 - Assim funciona lá (só eles usam bairro)
BEGIN
select	max(c.nr_seq_loc)
into STRICT	nr_seq_loc_w
from	cep_bairro c
where	c.nr_sequencia	= nr_seq_bairro_p;

if (nr_seq_bairro_p IS NOT NULL AND nr_seq_bairro_p::text <> '') then
	open C05;
	loop
	fetch C05 into
		nr_seq_bairro_inicial_w,
		nr_seq_bairro_final_w,
		cd_cep_ww;
	EXIT WHEN NOT FOUND; /* apply on C05 */
		begin
		--if	(nr_seq_bairro_inicial_w = nr_seq_bairro_p) then -- OS 445248 - Assim funciona lá (só eles usam bairro)
			--(nr_seq_bairro_final_w >= nr_seq_bairro_p) then
		if (cd_cep_p = cd_cep_ww) then
			ie_retorno_w	:= 'S';
			exit;
		else
			ie_retorno_w	:= 'N';
		end if;
		--end if;
		end;
	end loop;
	close C05;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_cep_bairro ( nr_seq_bairro_p bigint, cd_cep_p text) FROM PUBLIC;

