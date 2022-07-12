-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ptu_obter_versao_dominio ( ie_tipo_transacao_p text, cd_interface_p bigint) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Retornar a versao do PTU de acordo com o dominio 6107
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[ ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
	SE ATUALIZAR ESTA ROTINA, FAVOR ATUALIZAR:
		PTU_OBTER_VERSAO
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w			varchar(255);


BEGIN
if (ie_tipo_transacao_p = 'A100') then
	if (cd_interface_p = 2051) then
		ds_retorno_w	:= '040';
	elsif (cd_interface_p = 2312) then
		ds_retorno_w	:= '041';
	elsif (cd_interface_p = 2452) then
		ds_retorno_w	:= '050';
	elsif (cd_interface_p = 2590) then
		ds_retorno_w	:= '060';
	elsif (cd_interface_p = 2644) then
		ds_retorno_w	:= '062';
	end if;
	
elsif (ie_tipo_transacao_p = 'A200') then
	if (cd_interface_p = 2052) then
		ds_retorno_w	:= '040';
		
	elsif (cd_interface_p = 2483) then
		ds_retorno_w	:= '050';
		
	elsif (cd_interface_p = 2591) then
		ds_retorno_w	:= '060';
	end if;
	
elsif (ie_tipo_transacao_p = 'A400') then
	if (cd_interface_p = 2050) then
		ds_retorno_w	:= '040';
		
	elsif (cd_interface_p = 2319) then
		ds_retorno_w	:= '041';
		
	elsif (cd_interface_p = 2477) then
		ds_retorno_w	:= '050';
		
	elsif (cd_interface_p = 2583) then
		ds_retorno_w	:= '060';
		
	elsif (cd_interface_p = 2647) then
		ds_retorno_w	:= '062';
		
	elsif (cd_interface_p = 2689) then
		ds_retorno_w	:= '063';
		
	elsif (cd_interface_p = 2751) then
		ds_retorno_w	:= '070';
		
	elsif (cd_interface_p = 2786) then
		ds_retorno_w	:= '080';
		
	elsif (cd_interface_p = 2831) then
		ds_retorno_w	:= '081';
		
	elsif (cd_interface_p = 2922) then
		ds_retorno_w	:= '100';
		
	elsif (cd_interface_p = 2977) then
		ds_retorno_w	:= '110';
		
	elsif (cd_interface_p = 3083) then
		ds_retorno_w	:= '111';
	end if;
	
elsif (ie_tipo_transacao_p = 'A450') then
	if (cd_interface_p = 2085) then
		ds_retorno_w	:= '040';
		
	elsif (cd_interface_p = 2324) then
		ds_retorno_w	:= '041';
		
	elsif (cd_interface_p in (2479,2516)) then
		ds_retorno_w	:= '050';
		
	elsif (cd_interface_p = 2690) then
		ds_retorno_w	:= '063';
		
	elsif (cd_interface_p = 2781) then
		ds_retorno_w	:= '080';
		
	elsif (cd_interface_p = 2923) then
		ds_retorno_w	:= '100';
	end if;
	
elsif (ie_tipo_transacao_p = 'A500') then
	if (cd_interface_p = 2153) then
		ds_retorno_w	:= '040';
		
	elsif (cd_interface_p = 2350) then
		ds_retorno_w	:= '041';
		
	elsif (cd_interface_p in (2472,2574)) then
		ds_retorno_w	:= '050';
		
	elsif (cd_interface_p = 2585) then
		ds_retorno_w	:= '060';
		
	elsif (cd_interface_p = 2637) then
		ds_retorno_w	:= '061';
		
	elsif (cd_interface_p = 2698) then
		ds_retorno_w	:= '063';
		
	elsif (cd_interface_p in (2745,2767)) then
		ds_retorno_w	:= '070';
		
	elsif (cd_interface_p in (2789,2791)) then
		ds_retorno_w	:= '080';
		
	elsif (cd_interface_p in (2833,2836)) then
		ds_retorno_w	:= '090';
		
	elsif (cd_interface_p in (2906, 2907)) then
		ds_retorno_w	:= '091';

	elsif (cd_interface_p in (2924, 2925)) then
		ds_retorno_w	:= '100';
		
	elsif (cd_interface_p = 2940) then
		ds_retorno_w	:= '101';
		
	elsif (cd_interface_p = 2976) then
		ds_retorno_w	:= '110';
		
	elsif (cd_interface_p = 3066) then
		ds_retorno_w	:= '111';	-- INTERFACE 11.0a, na rotina a variavel e number e nao tem como por 11.0a entao tratamos com '111'
		
	elsif (cd_interface_p = 3091) then
		ds_retorno_w	:= '113';
	end if;
	
elsif (ie_tipo_transacao_p = 'A550') then
	if (cd_interface_p = 2188) then
		ds_retorno_w	:= '040';
		
	elsif (cd_interface_p in (2349,2435)) then
		ds_retorno_w	:= '041';
		
	elsif (cd_interface_p in (2480,2575)) then
		ds_retorno_w	:= '050';
		
	elsif (cd_interface_p = 2588) then
		ds_retorno_w	:= '060';
		
	elsif (cd_interface_p = 2746) then
		ds_retorno_w	:= '070';
		
	elsif (cd_interface_p = 2790) then
		ds_retorno_w	:= '080';
		
	elsif (cd_interface_p = 2834) then
		ds_retorno_w	:= '090';
		
	elsif (cd_interface_p = 2908) then
		ds_retorno_w	:= '091';
		
	elsif (cd_interface_p = 2978) then
		ds_retorno_w	:= '110';
		
	elsif (cd_interface_p = 3092) then
		ds_retorno_w	:= '113';
	end if;
	
elsif (ie_tipo_transacao_p = 'A560') then
	if (cd_interface_p = 2184) then
		ds_retorno_w	:= '040';
		
	elsif (cd_interface_p in (2351,2436)) then
		ds_retorno_w	:= '041';
		
	elsif (cd_interface_p in (2481,2576)) then
		ds_retorno_w	:= '050';
		
	elsif (cd_interface_p = 2589) then
		ds_retorno_w	:= '060';

	elsif (cd_interface_p = 2747) then
		ds_retorno_w	:= '070';
		
	elsif (cd_interface_p = 2782) then
		ds_retorno_w	:= '080';
	end if;
	
elsif (ie_tipo_transacao_p = 'A580') then

	if (cd_interface_p = 2909) then
		ds_retorno_w	:= '091';
		
	elsif (cd_interface_p = 2979) then
		ds_retorno_w	:= '110';
	end if;
	
elsif (ie_tipo_transacao_p = 'A600') then
	if (cd_interface_p = 2298) then
		ds_retorno_w	:= '040';
		
	elsif (cd_interface_p = 2357) then
		ds_retorno_w	:= '041';
		
	elsif (cd_interface_p = 2478) then
		ds_retorno_w	:= '050';
		
	elsif (cd_interface_p = 2584) then
		ds_retorno_w	:= '060';
	end if;
	
elsif (ie_tipo_transacao_p = 'A700') then
	if (cd_interface_p in (2097,2241)) then
		ds_retorno_w	:= '040';
		
	elsif (cd_interface_p in (2369,2372)) then
		ds_retorno_w	:= '041';
		
	elsif (cd_interface_p = 2456) then
		ds_retorno_w	:= '050';
		
	elsif (cd_interface_p = 2587) then
		ds_retorno_w	:= '060';
		
	elsif (cd_interface_p = 2638) then
		ds_retorno_w	:= '061';
		
	elsif (cd_interface_p = 2788) then
		ds_retorno_w	:= '080';
		
	elsif (cd_interface_p = 2835) then
		ds_retorno_w	:= '090';
		
	elsif (cd_interface_p = 2926) then
		ds_retorno_w	:= '100';
		
	elsif (cd_interface_p = 2941) then
		ds_retorno_w	:= '101';
		
	elsif (cd_interface_p = 2980) then
		ds_retorno_w	:= '110';
		
	elsif (cd_interface_p = 3090) then
		ds_retorno_w	:= '113';
		
	elsif (cd_interface_p	= 10083) then
		ds_retorno_w	:= '130';
	end if;
	
elsif (ie_tipo_transacao_p = 'A800') then
	if (cd_interface_p = 2266) then
		ds_retorno_w	:= '040';
		
	elsif (cd_interface_p = 2473) then
		ds_retorno_w	:= '050';
		
	elsif (cd_interface_p = 2593) then
		ds_retorno_w	:= '060';
	end if;
	
elsif (ie_tipo_transacao_p = 'A1200') then
	if (cd_interface_p = 2183) then
		ds_retorno_w	:= '040';
		
	elsif (cd_interface_p = 2750) then
		ds_retorno_w	:= '070';
		
	elsif (cd_interface_p = 2787) then
		ds_retorno_w	:= '080';
		
	elsif (cd_interface_p = 2837) then
		ds_retorno_w	:= '090';

	elsif (cd_interface_p = 3073) then
		ds_retorno_w	:= '011'; -- 11a
        elsif (cd_interface_p = 3153) then
		ds_retorno_w	:= '013'; -- 13
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ptu_obter_versao_dominio ( ie_tipo_transacao_p text, cd_interface_p bigint) FROM PUBLIC;
