-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_checksum_activation ( cd_key_p text) RETURNS varchar AS $body$
DECLARE


ds_caracter_w  varchar(1);
ds_retorno_w  varchar(255);
ds_Char_Table_w  varchar(255);
i   integer  := 0;
j   integer  := 0;
vl_value_w  bigint;
vl_total_w  bigint;
vl_final_w  bigint;
tamanho    bigint;


BEGIN
ds_retorno_w := '';
ds_Char_Table_w := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ*';
vl_total_w := 0;
vl_final_w := 0;

if (cd_key_p IS NOT NULL AND cd_key_p::text <> '') then

 tamanho := length(cd_key_p);

 for i in 1..tamanho loop
  begin
  ds_caracter_w := substr(cd_key_p, i,1);
  j := 0;
  while(length(ds_Char_Table_w) > j) loop
   begin
   j := j + 1;
   if (substr( ds_Char_Table_w, j,1) = to_char(ds_caracter_w)) then
    begin
    vl_value_w := trunc(j-1);
    vl_total_w := trunc((vl_value_w * (power(2, tamanho - i+1))));

    vl_final_w := vl_final_w + vl_total_w;
    end;
   end if;
   end;
  end loop;
  end;
 end loop;

 select substr(ds_Char_Table_w,mod(38 - mod(vl_final_w,37),37)+1,1)
 into STRICT ds_retorno_w
;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_checksum_activation ( cd_key_p text) FROM PUBLIC;

