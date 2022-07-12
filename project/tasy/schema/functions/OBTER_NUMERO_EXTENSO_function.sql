-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_numero_extenso (valor_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*	ie_opcao
	F  = Feminino (Uma, duas ...)
	M = Masculino (Um, dois...) 
	ME = Masculino sem e virgulas - Idioma Espanhol */
type Unidades is table of varchar(200) index by integer;
type Dezenas is table of varchar(200) index by integer;
type Centenas is table of varchar(200) index by integer;

Unidades_w		Unidades;
Dezenas_w		Dezenas;
Centenas_w		Centenas;
valor_w			integer := 0;
ds_valor_w		varchar(2000) := '';

ds_bilhao_w		varchar(200);
ds_bilhoes_w	varchar(200);
ds_cento_w		varchar(200);
ds_milhao_w 	varchar(200);
ds_milhoes_w	varchar(200);
ds_e_w			varchar(200);
ds_mil_w		varchar(200);
ds_um_w			varchar(200);
ds_uma_w		varchar(200);
ds_dois_w		varchar(200);
ds_duas_w		varchar(200);
ds_tos_w		varchar(200);
ds_tas_w		varchar(200);
ds_virgula_w    varchar(2);


BEGIN

Unidades_w(1)	:= obter_desc_expressao(725859); --'Um'; Conotacao numeral. Ex. 1001 - Mil e um litros de soro
Unidades_w(2)	:= obter_desc_expressao(725871); --'Dois'
Unidades_w(3)	:= obter_desc_expressao(676523); --'Tres'
Unidades_w(4)	:= obter_desc_expressao(676501); --'Quatro'
Unidades_w(5)	:= obter_desc_expressao(676502); --'Cinco'
Unidades_w(6)	:= obter_desc_expressao(676503); --'Seis'
Unidades_w(7)	:= obter_desc_expressao(725875); --'Sete'
Unidades_w(8)	:= obter_desc_expressao(725877); --'Oito'
Unidades_w(9)	:= obter_desc_expressao(725881); --'Nove'
Unidades_w(10)	:= obter_desc_expressao(725883); --'Dez'
Unidades_w(11)	:= obter_desc_expressao(725885); --'Onze'
Unidades_w(12)	:= obter_desc_expressao(725887); --'Doze'
Unidades_w(13)	:= obter_desc_expressao(725889); --'Treze'
Unidades_w(14)	:= obter_desc_expressao(725891); --'Quatorze'
Unidades_w(15)	:= obter_desc_expressao(725893); --'Quinze'
Unidades_w(16)	:= obter_desc_expressao(725895); --'Dezesseis'
Unidades_w(17)	:= obter_desc_expressao(725897); --'Dezessete'
Unidades_w(18)	:= obter_desc_expressao(725899); --'Dezoito'
Unidades_w(19)	:= obter_desc_expressao(725901); --'Dezenove'
Dezenas_w(1)	:= obter_desc_expressao(725883); --'Dez'
Dezenas_w(2)	:= obter_desc_expressao(725903); --'Vinte'
Dezenas_w(3)	:= obter_desc_expressao(725907); --'Trinta'
Dezenas_w(4)	:= obter_desc_expressao(725911); --'Quarenta'
Dezenas_w(5)	:= obter_desc_expressao(725917); --'Cinquenta'
Dezenas_w(6)	:= obter_desc_expressao(725919); --'Sessenta'
Dezenas_w(7)	:= obter_desc_expressao(725925); --'Setenta'
Dezenas_w(8)	:= obter_desc_expressao(725929); --'Oitenta';
Dezenas_w(9)	:= obter_desc_expressao(725937); --'Noventa'
Centenas_w(1)	:= obter_desc_expressao(725955); --'Cem'
Centenas_w(2)	:= obter_desc_expressao(725969); --'Duzentos'
Centenas_w(3)	:= obter_desc_expressao(725971); --'Trezentos'
Centenas_w(4)	:= obter_desc_expressao(725973); --'Quatrocentos'
Centenas_w(5)	:= obter_desc_expressao(725977); --'Quinhentos'
Centenas_w(6)	:= obter_desc_expressao(725985); --'Seiscentos'
Centenas_w(7)	:= obter_desc_expressao(725987); --'Setecentos'
Centenas_w(8)	:= obter_desc_expressao(725989); --'Oitocentos'
Centenas_w(9)	:= obter_desc_expressao(725991); --'Novecentos'
ds_bilhao_w	:= obter_desc_expressao(725993); --Bilhao
ds_bilhoes_w    := obter_desc_expressao(725997); --Bilhoes
ds_cento_w      := obter_desc_expressao(725999); --Cento
ds_milhao_w     := obter_desc_expressao(726003); --Milhao
ds_milhoes_w    := obter_desc_expressao(726001); --Milhoes
ds_mil_w        := obter_desc_expressao(726005); --Mil
ds_um_w		:= Unidades_w(1);                --Um
ds_uma_w	:= obter_desc_expressao(676521); --Uma
ds_dois_w	:= Unidades_w(2);                --Dois
ds_duas_w	:= obter_desc_expressao(676522); --Duas
ds_tos_w	:= obter_desc_expressao(726007); --tos
ds_tas_w 	:= obter_desc_expressao(726009); --tas
valor_w 	:= Trunc(valor_p);

if (ie_opcao_p = 'ME') then
	ds_e_w      	:= '';
	ds_virgula_w    := '';
else
	ds_e_w      	:= ' ' || obter_desc_expressao(312342); --e
	ds_virgula_w    := ',';
end if;


if (valor_w >= 1000000000) then
	if (Trunc(valor_w/1000000000) = 1) then
		ds_valor_w	:= ds_valor_w || ' ' || Unidades_w(Trunc(valor_w/1000000000)) || ' ' || ds_bilhao_w || ds_virgula_w;
	else
		ds_valor_w	:= ds_valor_w || ' ' || Unidades_w(Trunc(valor_w/1000000000)) || ' ' || ds_bilhoes_w || ds_virgula_w;
	end if;
	valor_w := mod(valor_w,1000000000);
end if;

if (valor_w >= 100000000) then
	if ((mod(valor_w,1000000000) < 1000000) and (Trunc(valor_w/100000000) = 1)) or (mod(valor_w,100000000) > 1)then
		ds_valor_w	:= ds_valor_w || ' ' || Centenas_w(Trunc(valor_w/100000000));
	else
		ds_valor_w	:= ds_valor_w || ' ' || ds_cento_w;
	end if;
	valor_w := mod(valor_w,100000000);
	if (valor_w = 0) or (valor_w < 1000000) then
		ds_valor_w := ds_valor_w || ' ' || ds_milhoes_w || ds_virgula_w;
	end if;
end if;

if (valor_w >= 20000000) then
	if (ds_valor_w IS NOT NULL AND ds_valor_w::text <> '') then
		ds_valor_w := ds_valor_w || ds_e_w;
	end if;
	ds_valor_w := ds_valor_w || ' ' || Dezenas_w(Trunc(valor_w/10000000));
      valor_w := mod(valor_w,10000000);
	if (valor_w = 0) or (valor_w < 1000000) then
		ds_valor_w := ds_valor_w || ' ' || ds_milhoes_w || ds_virgula_w;
	end if;
end if;

if (valor_w >= 1000000) then
	if (ds_valor_w IS NOT NULL AND ds_valor_w::text <> '') then
		ds_valor_w := ds_valor_w || ds_e_w;
	end if;
	if (Trunc(valor_w / 1000000) = 1) then
		ds_valor_w := ds_valor_w || ' ' || Unidades_w(Trunc(valor_w / 1000000)) || ' ' || ds_milhao_w || ' ' || ds_virgula_w;
	else
		ds_valor_w := ds_valor_w || ' ' || Unidades_w(Trunc(valor_w / 1000000)) || ' ' || ds_milhoes_w || ds_virgula_w;
	end if;
	valor_w := Mod(valor_w,1000000);
end if;

if (valor_w >= 100000) then
	if ((mod(valor_w,100000) < 1000) and (Trunc(valor_w / 100000) = 1)) or (Trunc(valor_w / 100000) > 1) then
		ds_valor_w := ds_valor_w || ' ' || Centenas_w(Trunc(valor_w / 100000));
	else
		ds_valor_w := ds_valor_w || ' ' || ds_cento_w;
	end if;
	valor_w := mod(valor_w, 100000);
	if (valor_w = 0) or (valor_w < 1000) then
		ds_valor_w := ds_valor_w || ' ' || ds_mil_w || ds_virgula_w;
	end if;
end if;

if (valor_w >= 20000) then
	if (ds_valor_w IS NOT NULL AND ds_valor_w::text <> '') then
		ds_valor_w := ds_valor_w || ds_e_w;
	end if;
	ds_valor_w := ds_valor_w || ' ' || Dezenas_w(Trunc(valor_w / 10000));
	valor_w := mod(valor_w, 10000);
	if (valor_w = 0) or (valor_w < 1000) then
		ds_valor_w := ds_valor_w || ' ' || ds_mil_w ||ds_virgula_w;
	end if;
end if;

if (valor_w >= 1000) then
	if (ds_valor_w IS NOT NULL AND ds_valor_w::text <> '') then
		ds_valor_w := ds_valor_w || ds_e_w;
	end if;
	ds_valor_w := ds_valor_w || ' ' || Unidades_w(Trunc(valor_w / 1000));
	valor_w := mod(valor_w, 1000);
	ds_valor_w := ds_valor_w || ' ' || ds_mil_w || ds_virgula_w;
end if;

if (valor_w >= 100) then
	if ((valor_w / 100) = 1) or (Trunc(valor_w / 100) > 1) then
		ds_valor_w := ds_valor_w || ' ' || Centenas_w(Trunc(valor_w / 100));
	else
		ds_valor_w := ds_valor_w || ' ' || ds_cento_w;
	end if;
	valor_w := mod(valor_w, 100);
end if;

if (valor_w >= 20) then
	if (ds_valor_w IS NOT NULL AND ds_valor_w::text <> '') then
		ds_valor_w := ds_valor_w || ds_e_w;
	end if;
	ds_valor_w := ds_valor_w || ' ' || Dezenas_w(Trunc(valor_w / 10));
	valor_w := mod(valor_w, 10);
end if;

if (valor_w >= 1) then
	if (ds_valor_w IS NOT NULL AND ds_valor_w::text <> '') then
		ds_valor_w := ds_valor_w || ds_e_w;
	end if;
	ds_valor_w := ds_valor_w || ' ' || Unidades_w(valor_w);
end if;

if (ie_opcao_p = 'F') then
	ds_valor_w := replace(ds_valor_w,ds_um_w,ds_uma_w);
	ds_valor_w := replace(ds_valor_w,ds_dois_w,ds_duas_w);
	ds_valor_w := replace(ds_valor_w,ds_tos_w,ds_tas_w);
end if;	

return ds_valor_w;

RAISE NOTICE '%', ds_valor_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_numero_extenso (valor_p bigint, ie_opcao_p text) FROM PUBLIC;

