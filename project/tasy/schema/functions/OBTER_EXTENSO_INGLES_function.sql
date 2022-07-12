-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_extenso_ingles (valor_p bigint) RETURNS varchar AS $body$
DECLARE


type Unidades is table of varchar(200) index by integer;
type Dezenas is table of varchar(200) index by integer;
type Centenas is table of varchar(200) index by integer;

Unidades_w		Unidades;
Dezenas_w		Dezenas;
Centenas_w		Centenas;
valor_w			integer := 0;
centavos_w		integer := 0;
ds_valor_w		varchar(2000) := '';

ie_moeda_w		varchar(10) := ' ';
ie_centavo_w	varchar(10) := ' Cents';


BEGIN

Unidades_w(1)	:= 'One';
Unidades_w(2)	:= 'Two';
Unidades_w(3)	:= 'Three';
Unidades_w(4)	:= 'Four';
Unidades_w(5)	:= 'Five';
Unidades_w(6)	:= 'Six';
Unidades_w(7)	:= 'Seven';
Unidades_w(8)	:= 'Eight';
Unidades_w(9)	:= 'Nine';
Unidades_w(10)	:= 'Ten';
Unidades_w(11)	:= 'Eleven';
Unidades_w(12)	:= 'Twelve';
Unidades_w(13)	:= 'Thirteen';
Unidades_w(14)	:= 'Fourteen';  --Corrigido a ortografia em 18/09/06, OS40583, Rafael Freitas Caldas
Unidades_w(15)	:= 'fifteen';
Unidades_w(16)	:= 'Sixteen';
Unidades_w(17)	:= 'Seventeen';
Unidades_w(18)	:= 'Eighteen';
Unidades_w(19)	:= 'Nineteen';

Dezenas_w(1)	:= 'Ten';
Dezenas_w(2)	:= 'Tweenty';
Dezenas_w(3)	:= 'Thirty';
Dezenas_w(4)	:= 'Fourty';
Dezenas_w(5)	:= 'Fifty';
Dezenas_w(6)	:= 'Sixty';
Dezenas_w(7)	:= 'Seventy';
Dezenas_w(8)	:= 'Eighty';
Dezenas_w(9)	:= 'Ninety';

Centenas_w(1)	:= 'One hundred';
Centenas_w(2)	:= 'Two hundred';
Centenas_w(3)	:= 'Three hundred';
Centenas_w(4)	:= 'Four hundred';
Centenas_w(5)	:= 'Five hundred';
Centenas_w(6)	:= 'Six hundred';
Centenas_w(7)	:= 'Seven hundred';
Centenas_w(8)	:= 'Eight hundred';
Centenas_w(9)	:= 'Nine hundred';

valor_w 	:= Trunc(valor_p);
centavos_w	:= trunc((valor_p - trunc(valor_p)) * 100);

if (valor_w = 1) then
	ie_moeda_w := ' USD';
end if;

-- if (centavos_w = 1) then
	-- ie_centavo_w := ' Cents';
-- end if;
if (valor_w >= 1000000000) then
	if (Trunc(valor_w/1000000000) = 1) then
		ds_valor_w	:= ds_valor_w || ' ' || Unidades_w(Trunc(valor_w/1000000000)) || ' Billion,';
	else
		ds_valor_w	:= ds_valor_w || ' ' || Unidades_w(Trunc(valor_w/1000000000)) || ' Billion,';
	end if;
	valor_w := mod(valor_w,1000000000);
end if;

if (valor_w >= 100000000) then
	if ((mod(valor_w,1000000000) < 1000000) and (Trunc(valor_w/100000000) = 1)) or (mod(valor_w,100000000) > 1)then
		ds_valor_w	:= ds_valor_w || ' ' || Centenas_w(Trunc(valor_w/100000000));
	else
		ds_valor_w	:= ds_valor_w || ' ' || 'One Hundred';
	end if;
	valor_w := mod(valor_w,100000000);
	if (valor_w = 0) or (valor_w < 1000000) then
		ds_valor_w := ds_valor_w || ' Million,';
	end if;
end if;

if (valor_w >= 20000000) then
	if (ds_valor_w IS NOT NULL AND ds_valor_w::text <> '') then
		ds_valor_w := ds_valor_w || '';
	end if;
	ds_valor_w := ds_valor_w || ' ' || Dezenas_w(Trunc(valor_w/10000000));
      valor_w := mod(valor_w,10000000);
	if (valor_w = 0) or (valor_w < 1000000) then
		ds_valor_w := ds_valor_w || ' Million,';
	end if;
end if;

if (valor_w >= 1000000) then
	if (ds_valor_w IS NOT NULL AND ds_valor_w::text <> '') then
		ds_valor_w := ds_valor_w || '';
	end if;
	if (Trunc(valor_w / 1000000) = 1) then
		ds_valor_w := ds_valor_w || ' ' || Unidades_w(Trunc(valor_w / 1000000)) || ' Million,';
	else
		ds_valor_w := ds_valor_w || ' ' || Unidades_w(Trunc(valor_w / 1000000)) || ' Million,';
	end if;
	valor_w := Mod(valor_w,1000000);
end if;

if (valor_w >= 100000) then
	if ((mod(valor_w,100000) < 1000) and (Trunc(valor_w / 100000) = 1)) or (Trunc(valor_w / 100000) > 1) then
		ds_valor_w := ds_valor_w || ' ' || Centenas_w(Trunc(valor_w / 100000));
	else
		ds_valor_w := ds_valor_w || ' ' || 'One Hundred';
	end if;
	valor_w := mod(valor_w, 100000);
	if (valor_w = 0) or (valor_w < 1000) then
		ds_valor_w := ds_valor_w || ' Thousand ';
	end if;
end if;

if (valor_w >= 20000) then
	if (ds_valor_w IS NOT NULL AND ds_valor_w::text <> '') then
		ds_valor_w := ds_valor_w || '';
	end if;
	ds_valor_w := ds_valor_w || ' ' || Dezenas_w(Trunc(valor_w / 10000));
	valor_w := mod(valor_w, 10000);
	if (valor_w = 0) or (valor_w < 1000) then
		ds_valor_w := ds_valor_w || ' Thousand ';
	end if;
end if;

if (valor_w >= 1000) then
	if (ds_valor_w IS NOT NULL AND ds_valor_w::text <> '') then
		ds_valor_w := ds_valor_w || '';
	end if;
	ds_valor_w := ds_valor_w || ' ' || Unidades_w(Trunc(valor_w / 1000));
	valor_w := mod(valor_w, 1000);
	ds_valor_w := ds_valor_w || ' Thousand';
end if;

if (valor_w >= 100) then
	if ((valor_w / 100) = 1) or (Trunc(valor_w / 100) > 1) then
		ds_valor_w := ds_valor_w || ' ' || Centenas_w(Trunc(valor_w / 100));
	else
		ds_valor_w := ds_valor_w || ' ' || 'One Hundred';
	end if;
	valor_w := mod(valor_w, 100);
end if;

if (valor_w >= 20) then
	if (ds_valor_w IS NOT NULL AND ds_valor_w::text <> '') then
		ds_valor_w := ds_valor_w || '';
	end if;
	ds_valor_w := ds_valor_w || ' ' || Dezenas_w(Trunc(valor_w / 10));
	valor_w := mod(valor_w, 10);
end if;

if (valor_w >= 1) then
	if (ds_valor_w IS NOT NULL AND ds_valor_w::text <> '') then
		ds_valor_w := ds_valor_w || ' ';
	end if;
	ds_valor_w := ds_valor_w || ' ' || Unidades_w(valor_w);
end if;

ds_valor_w := ds_valor_w || ie_moeda_w;

if (Centavos_w > 0) then
	-- if (Centavos_w >= 20) then
		-- if (ds_valor_w is not null) then
      	   -- ds_valor_w := ds_valor_w || ' ';
		-- end if;
		-- ds_valor_w := ds_valor_w || ' ' || Dezenas_w(Trunc(Centavos_w / 10));
		-- Centavos_w := mod(Centavos_w, 10);
	-- end if;
	-- if (Centavos_w >= 1) then
		-- if (ds_valor_w is not null) then
	         -- ds_valor_w := ds_valor_w || ' ';
		-- end if;
		-- ds_valor_w := ds_valor_w || ' ' || Unidades_w(Centavos_w);
	-- end if;
	-- ds_valor_w := ds_valor_w || ie_centavo_w;
	ds_valor_w := ds_valor_w||' '||Centavos_w||'/100';
end if;

return ds_valor_w || ' USD';

RAISE NOTICE '%', ds_valor_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_extenso_ingles (valor_p bigint) FROM PUBLIC;
