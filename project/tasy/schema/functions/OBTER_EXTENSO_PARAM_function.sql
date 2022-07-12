-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_extenso_param (valor_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
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

ie_moeda_w		varchar(10)	:= ' Reais';
ie_centavo_w	varchar(10) 		:= ' Centavos';

/* IE_OPCAO_P não será utilizado por enquanto */

BEGIN

Unidades_w(1)	:= 'Um';
Unidades_w(2)	:= 'Dois';
Unidades_w(3)	:= 'Três';
Unidades_w(4)	:= 'Quatro';
Unidades_w(5)	:= 'Cinco';
Unidades_w(6)	:= 'Seis';
Unidades_w(7)	:= 'Sete';
Unidades_w(8)	:= 'Oito';
Unidades_w(9)	:= 'Nove';
Unidades_w(10)	:= 'Dez';
Unidades_w(11)	:= 'Onze';
Unidades_w(12)	:= 'Doze';
Unidades_w(13)	:= 'Treze';
Unidades_w(14)	:= 'Quatorze';  --Corrigido a ortografia em 18/09/06, OS40583, Rafael Freitas Caldas
Unidades_w(15)	:= 'Quinze';
Unidades_w(16)	:= 'Dezesseis';
Unidades_w(17)	:= 'Dezessete';
Unidades_w(18)	:= 'Dezoito';
Unidades_w(19)	:= 'Dezenove';

Dezenas_w(1)	:= 'Dez';
Dezenas_w(2)	:= 'Vinte';
Dezenas_w(3)	:= 'Trinta';
Dezenas_w(4)	:= 'Quarenta';
Dezenas_w(5)	:= 'Cinquenta';
Dezenas_w(6)	:= 'Sessenta';
Dezenas_w(7)	:= 'Setenta';
Dezenas_w(8)	:= 'Oitenta';
Dezenas_w(9)	:= 'Noventa';

Centenas_w(1)	:= 'Cem';
Centenas_w(2)	:= 'Duzentos';
Centenas_w(3)	:= 'Trezentos';
Centenas_w(4)	:= 'Quatrocentos';
Centenas_w(5)	:= 'Quinhentos';
Centenas_w(6)	:= 'Seiscentos';
Centenas_w(7)	:= 'Setecentos';
Centenas_w(8)	:= 'Oitocentos';
Centenas_w(9)	:= 'Novecentos';

valor_w 	:= Trunc(valor_p);
centavos_w	:= trunc((valor_p - trunc(valor_p)) * 100);

if (valor_w = 1) then
	ie_moeda_w := ' Real';
end if;

if (centavos_w = 1) then
	ie_centavo_w := ' Centavo';
end if;

if (valor_w >= 1000000000) then
	if (Trunc(valor_w/1000000000) = 1) then
		ds_valor_w	:= ds_valor_w || ' ' || Unidades_w(Trunc(valor_w/1000000000)) || ' Bilhão,';
	else
		ds_valor_w	:= ds_valor_w || ' ' || Unidades_w(Trunc(valor_w/1000000000)) || ' Bilhões,';
	end if;
	valor_w := mod(valor_w,1000000000);
end if;

if (valor_w >= 100000000) then
	if ((mod(valor_w,1000000000) < 1000000) and (Trunc(valor_w/100000000) = 1)) or (mod(valor_w,100000000) > 1)then
		ds_valor_w	:= ds_valor_w || ' ' || Centenas_w(Trunc(valor_w/100000000));
	else
		ds_valor_w	:= ds_valor_w || ' ' || 'Cento';
	end if;
	valor_w := mod(valor_w,100000000);
	if (valor_w = 0) or (valor_w < 1000000) then
		ds_valor_w := ds_valor_w || ' Milhões,';
	end if;
end if;

if (valor_w >= 20000000) then
	if (ds_valor_w IS NOT NULL AND ds_valor_w::text <> '') then
		ds_valor_w := ds_valor_w || ' e';
	end if;
	ds_valor_w := ds_valor_w || ' ' || Dezenas_w(Trunc(valor_w/10000000));
      valor_w := mod(valor_w,10000000);
	if (valor_w = 0) or (valor_w < 1000000) then
		ds_valor_w := ds_valor_w || ' Milhões';
	end if;
end if;

if (valor_w >= 1000000) then
	if (ds_valor_w IS NOT NULL AND ds_valor_w::text <> '') then
		ds_valor_w := ds_valor_w || ' e';
	end if;
	if (Trunc(valor_w / 1000000) = 1) then
		ds_valor_w := ds_valor_w || ' ' || Unidades_w(Trunc(valor_w / 1000000)) || ' Milhão';
	else
		ds_valor_w := ds_valor_w || ' ' || Unidades_w(Trunc(valor_w / 1000000)) || ' Milhões';
	end if;
	valor_w := Mod(valor_w,1000000);
end if;

if (valor_w >= 100000) then
	if (ds_valor_w IS NOT NULL AND ds_valor_w::text <> '') then
		if (mod(valor_w, 100000) > 0) then
			ds_valor_w := ds_valor_w || ',';
		else
			ds_valor_w := ds_valor_w || ' e';
		end if;
	end if;

	if ((mod(valor_w,100000) < 1000) and (Trunc(valor_w / 100000) = 1)) or (Trunc(valor_w / 100000) > 1) then
		ds_valor_w := ds_valor_w || ' ' || Centenas_w(Trunc(valor_w / 100000));
	else
		ds_valor_w := ds_valor_w || ' ' || 'Cento';
	end if;
	valor_w := mod(valor_w, 100000);
	if (valor_w = 0) or (valor_w < 1000) then
		ds_valor_w := ds_valor_w || ' Mil';
	end if;
end if;

if (valor_w >= 20000) then
	if (ds_valor_w IS NOT NULL AND ds_valor_w::text <> '') then
		ds_valor_w := ds_valor_w || ' e';
	end if;
	ds_valor_w := ds_valor_w || ' ' || Dezenas_w(Trunc(valor_w / 10000));
	valor_w := mod(valor_w, 10000);
	if (valor_w = 0) or (valor_w < 1000) then
		ds_valor_w := ds_valor_w || ' Mil';
	end if;
end if;

if (valor_w >= 1000) then
	if (ds_valor_w IS NOT NULL AND ds_valor_w::text <> '') then
		ds_valor_w := ds_valor_w || ' e';
	end if;
	ds_valor_w := ds_valor_w || ' ' || Unidades_w(Trunc(valor_w / 1000));
	valor_w := mod(valor_w, 1000);
	ds_valor_w := ds_valor_w || ' Mil';
end if;

if (valor_w >= 100) then
	if (ds_valor_w IS NOT NULL AND ds_valor_w::text <> '') then
		if (mod(valor_w, 100) > 0) then
			ds_valor_w := ds_valor_w || ',';
		else
			ds_valor_w := ds_valor_w || ' e';
		end if;
	end if;

	if ((valor_w / 100) = 1) or (Trunc(valor_w / 100) > 1) then
		ds_valor_w := ds_valor_w || ' ' || Centenas_w(Trunc(valor_w / 100));
	else
		ds_valor_w := ds_valor_w || ' ' || 'Cento';
	end if;
	valor_w := mod(valor_w, 100);
end if;

if (valor_w >= 20) then
	if (ds_valor_w IS NOT NULL AND ds_valor_w::text <> '') then
		ds_valor_w := ds_valor_w || ' e';
	end if;
	ds_valor_w := ds_valor_w || ' ' || Dezenas_w(Trunc(valor_w / 10));
	valor_w := mod(valor_w, 10);
end if;

if (valor_w >= 1) then
	if (ds_valor_w IS NOT NULL AND ds_valor_w::text <> '') then
		ds_valor_w := ds_valor_w || ' e';
	end if;
	ds_valor_w := ds_valor_w || ' ' || Unidades_w(valor_w);
end if;

/* Tratamento para milhões */

if (trunc(valor_p) >= 1000000) and (mod(valor_p, 1000000) = 0) and (valor_w = 0) then
	ds_valor_w := ds_valor_w || ' de';
end if;

if (ds_valor_w IS NOT NULL AND ds_valor_w::text <> '') then
	ds_valor_w := ds_valor_w || ie_moeda_w;
end if;

if (Centavos_w > 0) then
	if (Centavos_w >= 20) then
		if (ds_valor_w IS NOT NULL AND ds_valor_w::text <> '') then
      	   ds_valor_w := ds_valor_w || ' e';
		end if;
		ds_valor_w := ds_valor_w || ' ' || Dezenas_w(Trunc(Centavos_w / 10));
		Centavos_w := mod(Centavos_w, 10);
	end if;

	if (Centavos_w >= 1) then
		if (ds_valor_w IS NOT NULL AND ds_valor_w::text <> '') then
	         ds_valor_w := ds_valor_w || ' e';
		end if;
		ds_valor_w := ds_valor_w || ' ' || Unidades_w(Centavos_w);
	end if;
	ds_valor_w := ds_valor_w || ie_centavo_w;
end if;

return ds_valor_w || '.';

RAISE NOTICE '%', ds_valor_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_extenso_param (valor_p bigint, ie_opcao_p text) FROM PUBLIC;

