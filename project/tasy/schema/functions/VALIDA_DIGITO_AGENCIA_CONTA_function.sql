-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION valida_digito_agencia_conta ( cd_banco_p bigint, nr_agencia_p text, nr_conta_p text, nr_tipo_conta_p text) RETURNS varchar AS $body$
DECLARE
								
/*
Informações no layout enviado na OS 1943551
Nr conta e nr agencia são varchar pois podem começar com zeros.
Alguns bancos pendem um tipo de conta p

Se atentar no que é utilizado em cada banco para validar agência e conta.

Banco  	Descrição Banco 			Tamanho da Agência 		DV Agência 	Tamanho do Tipo de Conta 	Tamanho da Conta 	DV Conta		O que enviar para validar agencia?      		O que enviar para validar conta?
001 		BCO DO BRASIL S/A  			4					 1				 --- 				8 				1 		             Banco e agência					 	    Banco e conta     
033 		SANTANDER BANESPA 		4 					--- 				2 				6 				1 			  Banco e agência						    Banco,  agência, conta e tipo de conta
041 		BANRISUL 				4 					2 				2 				7 				1 			  Banco e agência						    Banco, conta e tipo de conta
104 		CAIXA ECONOMICA FEDERAL  	4 					--- 				3 				8 				1 			  Banco e agência						    Banco,  agência, conta e tipo de conta	
237 		BCO BRADESCO S/A  			4 					1 				--- 				7				1 			  Banco e agência					               Banco e conta 			
341		BCO ITAU S/A  				4 					--- 				--- 				5 				1 			  Banco e agência                                                            Banco, agência e conta 
356 		REAL / ABN 				4 					--- 				--- 				7 				1 			  Banco e agência						    Banco, agência e conta 
399		HSBC BANK BRASIL S.A.  		4 					--- 				--- 				6 				1 			  Banco e agência						    Banco, agência e conta 
745 		CITIBANK S.A.  				4 					--- 				--- 				10 				1 			  Banco e agência						    Banco e conta 	

*/
									   
									   
nr_digito_w				varchar(255);
nr_digito_aux_w			varchar(255)	:= 0;
nr_peso_w				varchar(255)	:= 0;	
vl_soma_w				bigint		:= 0;	
vl_tamanho_w			bigint		:= 0;
inc_w					bigint;	
vl_soma_aux_w			bigint		:= 0;	
ie_recalcula_digito_2_w	varchar(1);

qt_dig_solic_w			bigint;	
qt_dig_agencia_inf_w	bigint;			
									   

BEGIN

/*BCO DO BRASIL S/A*/

if (to_char(cd_banco_p,'FM000') = 001) then

	if (nr_agencia_p IS NOT NULL AND nr_agencia_p::text <> '') then
	
		if (length(nr_agencia_p) <> 4) then
			qt_dig_solic_w 			:= 4;
			qt_dig_agencia_inf_w 	:= length(nr_agencia_p);
			nr_digito_w := substr(wheb_mensagem_pck.get_texto(1086167,'qt_dig_solic_w='||qt_dig_solic_w||';qt_dig_agencia_inf_w='||qt_dig_agencia_inf_w),1,255);
						 
		else 
			nr_peso_w 		:= '5432';
			vl_tamanho_w	:= length(nr_agencia_p);

			FOR inc_w in 1..vl_tamanho_w loop
				vl_soma_w := vl_soma_w + ((substr(nr_agencia_p,inc_w,1))::numeric  * (substr(nr_peso_w,inc_w,1))::numeric );
			end loop;

			nr_digito_w := 11 -  mod(vl_soma_w,11);
			
			if (mod(vl_soma_w,11) = 10) then
				nr_digito_w := 'X';
			elsif (mod(vl_soma_w,11) = 11) then
				nr_digito_w := '0';
			end if;
		end if;	

	elsif (nr_conta_p IS NOT NULL AND nr_conta_p::text <> '') then
	
		if (length(nr_conta_p) <> 8) then
			qt_dig_solic_w 			:= 8;
			qt_dig_agencia_inf_w 	:= length(nr_conta_p);
			nr_digito_w := substr(wheb_mensagem_pck.get_texto(1086168,'qt_dig_solic_w='||qt_dig_solic_w||';qt_dig_agencia_inf_w='||qt_dig_agencia_inf_w),1,255);
		else 
			nr_peso_w 		:= '98765432';
			vl_tamanho_w	:= length(nr_conta_p);

			for inc_w in 1..vl_tamanho_w loop
				vl_soma_w := vl_soma_w + ((substr(nr_conta_p,inc_w,1))::numeric  * (substr(nr_peso_w,inc_w,1))::numeric );
			end loop;

			nr_digito_w := 11 -  mod(vl_soma_w,11);
			
			if (mod(vl_soma_w,11) = 10) then
				nr_digito_w := 'X';
			elsif (mod(vl_soma_w,11) = 11) then
				nr_digito_w := '0';
			end if;
		end if;		

	end if;

/*SANTANDER BANESPA*/
	
elsif (to_char(cd_banco_p,'FM000') = 033) then
	
	if (nr_agencia_p IS NOT NULL AND nr_agencia_p::text <> '') and (coalesce(nr_conta_p::text, '') = '')then /*Esse banco não tem dígito na agência, então será consistindo apenas a quantidade de dígitos*/
		
		if (length(nr_agencia_p) <> 4) then
			qt_dig_solic_w 			:= 4;
			qt_dig_agencia_inf_w 	:= length(nr_agencia_p);
			nr_digito_w := substr(wheb_mensagem_pck.get_texto(1086167,'qt_dig_solic_w='||qt_dig_solic_w||';qt_dig_agencia_inf_w='||qt_dig_agencia_inf_w),1,255);
		end if;
	
	elsif (nr_conta_p IS NOT NULL AND nr_conta_p::text <> '') and (nr_agencia_p IS NOT NULL AND nr_agencia_p::text <> '') and (nr_tipo_conta_p IS NOT NULL AND nr_tipo_conta_p::text <> '') then /*Essa banco usa agencia + nr_tipo_conta_p + conta para validar o digito*/
	

		if (length(nr_conta_p) <> 8) then
			qt_dig_solic_w 			:= 8;
			qt_dig_agencia_inf_w 	:= length(nr_conta_p);
			nr_digito_w := substr(wheb_mensagem_pck.get_texto(1086168,'qt_dig_solic_w='||qt_dig_solic_w||';qt_dig_agencia_inf_w='||qt_dig_agencia_inf_w),1,255); 	
		elsif (length(nr_agencia_p) <> 4) then
			qt_dig_solic_w 			:= 4;
			qt_dig_agencia_inf_w 	:= length(nr_agencia_p);
			nr_digito_w := substr(wheb_mensagem_pck.get_texto(1086167,'qt_dig_solic_w='||qt_dig_solic_w||';qt_dig_agencia_inf_w='||qt_dig_agencia_inf_w),1,255);
		elsif (length(nr_tipo_conta_p) <> 2) then
			qt_dig_solic_w 			:= 2;
			qt_dig_agencia_inf_w 	:= length(nr_tipo_conta_p);
			nr_digito_w := substr(wheb_mensagem_pck.get_texto(1086175,'qt_dig_solic_w='||qt_dig_solic_w||';qt_dig_agencia_inf_w='||qt_dig_agencia_inf_w),1,255);
		elsif (length(nr_tipo_conta_p) = 2) and (nr_tipo_conta_p not in ('01','02','03','05','07','09','13','27','35','37','43','45','46','48','50','53','60','92')) then
			nr_digito_w := substr(wheb_mensagem_pck.get_texto(1086176,'nr_tipo_conta_w='||nr_tipo_conta_p),1,255);
		else 
			nr_peso_w 		:= '97310097131973';
			vl_tamanho_w	:= length(nr_agencia_p||nr_tipo_conta_p||nr_conta_p);

			for inc_w in 1..vl_tamanho_w loop
				vl_soma_aux_w := ((substr(nr_agencia_p||'00'||nr_conta_p,inc_w,1))::numeric  * (substr(nr_peso_w,inc_w,1))::numeric );
				if (vl_soma_aux_w > 9) then
					vl_soma_aux_w := substr(vl_soma_aux_w,2,1); -- Quando a soma tiver dezenas (2 casas) desprezar a dezena e considerar somente a unidade. Deixei fixo o substr 2,1, pois o máximo seria 9 x 9 que é 81, 2 casas;.
				end if;
				vl_soma_w := vl_soma_w + vl_soma_aux_w;
			end loop;

			if (substr(length(vl_soma_w),1) = 0) then /*Se a unidade do total for 0, o DV será 0 também.*/
				nr_digito_w := 0;
			else
				if (length(vl_soma_w) = 3) then /*Se a soma der 3 unidadades, no manual nao diz mas vamos desprezar a centena. Acho q isso nunca deve ocorrer...*/
					vl_soma_w := substr(vl_soma_w,2,2);
				elsif (length(vl_soma_w) = 2) then
					vl_soma_w := substr(vl_soma_w,2,1); /*Se somar 2, desprezar dezena, e manter a unidade*/
				end if;
				nr_digito_w := 10 - vl_soma_w;	
			end if;	

		end if;	

	end if;
	
/*BANRISUL */
	
elsif (to_char(cd_banco_p,'FM000') = 041) then	

	if (nr_agencia_p IS NOT NULL AND nr_agencia_p::text <> '') then
	
		if (length(nr_agencia_p) <> 4) then
			qt_dig_solic_w 			:= 4;
			qt_dig_agencia_inf_w 	:= length(nr_agencia_p);
			nr_digito_w := substr(wheb_mensagem_pck.get_texto(1086167,'qt_dig_solic_w='||qt_dig_solic_w||';qt_dig_agencia_inf_w='||qt_dig_agencia_inf_w),1,255);
		else
			/*Esse banco são 2 dígitos para agência.*/

			nr_peso_w 		:= '1212';
			vl_tamanho_w	:= length(nr_agencia_p);

			for inc_w in 1..vl_tamanho_w loop
				vl_soma_aux_w 	:= ((substr(nr_agencia_p,inc_w,1))::numeric  * (substr(nr_peso_w,inc_w,1))::numeric );
				if (vl_soma_aux_w > 9) then
					vl_soma_aux_w := coalesce(substr(vl_soma_aux_w,1,1),0) + coalesce(substr(vl_soma_aux_w,2,1),0); --Se tiver 2 unidades, somar os valores;
				end if;
				vl_soma_w 		:= vl_soma_w + vl_soma_aux_w;
			end loop;

			nr_digito_w := 	10 - mod(vl_soma_w,10);
			
			if (mod(vl_soma_w,10) = 0) then
				nr_digito_w := 0;
			end if;
			
			/*Dígito 2*/

			nr_peso_w 		:= '65432';
			vl_tamanho_w	:= length(nr_agencia_p||nr_digito_w);
			inc_w			:= 0;
			vl_soma_w		:= 0;
			vl_soma_aux_w	:= 0;
			ie_recalcula_digito_2_w := 'N';

			for inc_w in 1..vl_tamanho_w loop
				vl_soma_w := vl_soma_w + ((substr(nr_agencia_p||nr_digito_w,inc_w,1))::numeric  * (substr(nr_peso_w,inc_w,1))::numeric );
			end loop;	

			nr_digito_aux_w	:= 11 - mod(vl_soma_w,11);
			
			if (mod(vl_soma_w,11) = 1) and (nr_digito_w <> '9') then
				nr_digito_aux_w := nr_digito_aux_w + 1;
				ie_recalcula_digito_2_w := 'S';
			elsif (mod(vl_soma_w,11) = 1) and (nr_digito_w = '9') then
				nr_digito_w := 0;
				ie_recalcula_digito_2_w := 'S';
			end if;
			
			/*Recalcular o segundo digito*/

			if (coalesce(ie_recalcula_digito_2_w,'N') = 'S') then
				nr_peso_w 		:= '65432';
				vl_tamanho_w	:= length(nr_agencia_p||nr_digito_w);
				inc_w			:= 0;
				vl_soma_w		:= 0;
				vl_soma_aux_w	:= 0;
				ie_recalcula_digito_2_w := 'N';

				for inc_w in 1..vl_tamanho_w loop
					vl_soma_w := vl_soma_w + ((substr(nr_agencia_p||nr_digito_w,inc_w,1))::numeric  * (substr(nr_peso_w,inc_w,1))::numeric );
				end loop;	

				nr_digito_aux_w	:= 11 - mod(vl_soma_w,11);
				
				if (mod(vl_soma_w,11) = 0) then
					nr_digito_aux_w := 0;
				elsif (mod(vl_soma_w,11) <> 1) and (mod(vl_soma_w,11) <> 0) then
					nr_digito_aux_w := 11 - mod(vl_soma_w,11);
				end if;
				
			end if;
			nr_digito_w := nr_digito_w || nr_digito_aux_w;
		end if;	
		
	elsif (nr_conta_p IS NOT NULL AND nr_conta_p::text <> '') and (nr_tipo_conta_p IS NOT NULL AND nr_tipo_conta_p::text <> '') then	
	
		if (length(nr_conta_p) <> 7) then
			qt_dig_solic_w 			:= 7;
			qt_dig_agencia_inf_w 	:= length(nr_conta_p);
			nr_digito_w := substr(wheb_mensagem_pck.get_texto(1086168,'qt_dig_solic_w='||qt_dig_solic_w||';qt_dig_agencia_inf_w='||qt_dig_agencia_inf_w),1,255);
		elsif (length(nr_tipo_conta_p) <> 2) then
			qt_dig_solic_w 			:= 2;
			qt_dig_agencia_inf_w 	:= length(nr_tipo_conta_p);
			nr_digito_w := substr(wheb_mensagem_pck.get_texto(1086175,'qt_dig_solic_w='||qt_dig_solic_w||';qt_dig_agencia_inf_w='||qt_dig_agencia_inf_w),1,255); 		
		else
			nr_peso_w 		:= '324765432';
			vl_tamanho_w	:= length(nr_tipo_conta_p||nr_conta_p);
			
			for inc_w IN REVERSE vl_tamanho_w..1 loop
				vl_soma_w := vl_soma_w + ((substr(nr_tipo_conta_p||nr_conta_p,inc_w,1))::numeric  * (substr(nr_peso_w,inc_w,1))::numeric );
			end loop;
			
			nr_digito_w	:= mod(vl_soma_w,11);
			
			if (nr_digito_w = 0) then
				nr_digito_w := 0;
			elsif (nr_digito_w = 1) then
				nr_digito_w := 6;
			else
				nr_digito_w := 11 - mod(vl_soma_w,11);
			end if;

		end if;	
			
	end if;
	
/*CAIXA ECONOMICA FEDERAL */
	
elsif (to_char(cd_banco_p,'FM000') = 104) then		
	/*Como a caixa nao tem digito para agencia, veriifca apenas a quantidade de digitos.*/

	if (nr_agencia_p IS NOT NULL AND nr_agencia_p::text <> '') and (length(nr_agencia_p) <> 4) and (coalesce(nr_conta_p::text, '') = '') and (coalesce(nr_tipo_conta_p::text, '') = '') then
		qt_dig_solic_w 			:= 4;
		qt_dig_agencia_inf_w 	:= length(nr_agencia_p);
		nr_digito_w := substr(wheb_mensagem_pck.get_texto(1086167,'qt_dig_solic_w='||qt_dig_solic_w||';qt_dig_agencia_inf_w='||qt_dig_agencia_inf_w),1,255);
	elsif (nr_conta_p IS NOT NULL AND nr_conta_p::text <> '') and (nr_agencia_p IS NOT NULL AND nr_agencia_p::text <> '') and (nr_tipo_conta_p IS NOT NULL AND nr_tipo_conta_p::text <> '')then
	
		if (length(nr_conta_p) <> 8) then
			qt_dig_solic_w 			:= 8;
			qt_dig_agencia_inf_w 	:= length(nr_conta_p);
			nr_digito_w := substr(wheb_mensagem_pck.get_texto(1086168,'qt_dig_solic_w='||qt_dig_solic_w||';qt_dig_agencia_inf_w='||qt_dig_agencia_inf_w),1,255);
		elsif (length(nr_tipo_conta_p) <> 3) then
			qt_dig_solic_w 			:= 3;
			qt_dig_agencia_inf_w 	:= length(nr_tipo_conta_p);
			nr_digito_w := substr(wheb_mensagem_pck.get_texto(1086175,'qt_dig_solic_w='||qt_dig_solic_w||';qt_dig_agencia_inf_w='||qt_dig_agencia_inf_w),1,255); 	
		else
		
			nr_peso_w 		:= '876543298765432';
			vl_tamanho_w	:= length(nr_agencia_p||nr_tipo_conta_p||nr_conta_p);

			FOR inc_w IN REVERSE vl_tamanho_w..1 loop
				vl_soma_w := vl_soma_w + ((substr(nr_agencia_p||nr_tipo_conta_p||nr_conta_p,inc_w,1))::numeric  * (substr(nr_peso_w,inc_w,1))::numeric );
			end loop;			

			nr_digito_w := vl_soma_w * 10;	
			
			nr_digito_w := nr_digito_w - (trunc(nr_digito_w/11) * 11);
			
			if (nr_digito_w = 10) then
				nr_digito_w := 0;
			end if;
		
		end if;
		
	end if;
	
/*BRADESCO*/
	
elsif (to_char(cd_banco_p,'FM000') = 237) then	

	if (nr_agencia_p IS NOT NULL AND nr_agencia_p::text <> '') then
	
		if (length(nr_agencia_p) <> 4) then
			qt_dig_solic_w 			:= 4;
			qt_dig_agencia_inf_w 	:= length(nr_agencia_p);
			nr_digito_w := substr(wheb_mensagem_pck.get_texto(1086167,'qt_dig_solic_w='||qt_dig_solic_w||';qt_dig_agencia_inf_w='||qt_dig_agencia_inf_w),1,255); 	
		else
			nr_peso_w 		:= '5432';
			vl_tamanho_w	:= length(nr_agencia_p);

			for inc_w in 1..vl_tamanho_w loop
				vl_soma_w := vl_soma_w + ((substr(nr_agencia_p,inc_w,1))::numeric  * (substr(nr_peso_w,inc_w,1))::numeric );
			end loop;	

			nr_digito_w := 11 - mod(vl_soma_w,11);
			if (nr_digito_w = 10) then
				nr_digito_w := 'P';
			elsif (nr_digito_w = 11) then
				nr_digito_w := '0';
			end if;
		
		end if;
		
	elsif (nr_conta_p IS NOT NULL AND nr_conta_p::text <> '') then	
	
		if (length(nr_conta_p) <> 7) then
			qt_dig_solic_w 			:= 7;
			qt_dig_agencia_inf_w 	:= length(nr_conta_p);
			nr_digito_w := substr(wheb_mensagem_pck.get_texto(1086168,'qt_dig_solic_w='||qt_dig_solic_w||';qt_dig_agencia_inf_w='||qt_dig_agencia_inf_w),1,255); 	
		else
			nr_peso_w 		:= '2765432';
			vl_tamanho_w	:= length(nr_conta_p);

			for inc_w in 1..vl_tamanho_w loop
				vl_soma_w := vl_soma_w + ((substr(nr_conta_p,inc_w,1))::numeric  * (substr(nr_peso_w,inc_w,1))::numeric );
			end loop;	

			nr_digito_w := 11 - mod(vl_soma_w,11);
			
			if (mod(vl_soma_w,11) = 0) then
				nr_digito_w := 0;
			elsif (mod(vl_soma_w,11) = 1) then
				nr_digito_w := 'P';
			end if;
			
		end if;
		
	end if;
	
/*ITAU*/
	
elsif (to_char(cd_banco_p,'FM000') = 341) then		

	if (nr_agencia_p IS NOT NULL AND nr_agencia_p::text <> '') and (coalesce(nr_conta_p::text, '') = '')  then
	
		if (length(nr_agencia_p) <> 4) and (coalesce(nr_conta_p::text, '') = '') then
			qt_dig_solic_w 			:= 4;
			qt_dig_agencia_inf_w 	:= length(nr_agencia_p);
			nr_digito_w := substr(wheb_mensagem_pck.get_texto(1086167,'qt_dig_solic_w='||qt_dig_solic_w||';qt_dig_agencia_inf_w='||qt_dig_agencia_inf_w),1,255); 		
		end if;
		
	elsif (nr_conta_p IS NOT NULL AND nr_conta_p::text <> '') and (nr_agencia_p IS NOT NULL AND nr_agencia_p::text <> '') then

		if (length(nr_conta_p) <> 5) then
			qt_dig_solic_w 			:= 5;
			qt_dig_agencia_inf_w 	:= length(nr_conta_p);
			nr_digito_w := substr(wheb_mensagem_pck.get_texto(1086168,'qt_dig_solic_w='||qt_dig_solic_w||';qt_dig_agencia_inf_w='||qt_dig_agencia_inf_w),1,255); 		
		elsif (length(nr_agencia_p) <> 4) then
			qt_dig_solic_w 			:= 4;
			qt_dig_agencia_inf_w 	:= length(nr_agencia_p);
			nr_digito_w := substr(wheb_mensagem_pck.get_texto(1086167,'qt_dig_solic_w='||qt_dig_solic_w||';qt_dig_agencia_inf_w='||qt_dig_agencia_inf_w),1,255); 		
		else
			nr_peso_w 		:= '212121212';
			vl_tamanho_w	:= length(nr_agencia_p||nr_conta_p);

			for inc_w in 1..vl_tamanho_w loop
				vl_soma_aux_w 	:= ((substr(nr_agencia_p||nr_conta_p,inc_w,1))::numeric  * (substr(nr_peso_w,inc_w,1))::numeric );
				if (vl_soma_aux_w > 9) then
					vl_soma_aux_w := coalesce(substr(vl_soma_aux_w,1,1),0) + coalesce(substr(vl_soma_aux_w,2,1),0); --Se tiver 2 unidades, somar os valores;
				end if;
				vl_soma_w 		:= vl_soma_w + vl_soma_aux_w;
			end loop;	

			nr_digito_w := 10 - mod(vl_soma_w,10);
			
			if (mod(vl_soma_w,10) = 0) then
				nr_digito_w := 0;
			end if;
		
		end if;
	
	end if;

/*BANCO REAL*/
	
elsif (to_char(cd_banco_p,'FM000') = 356) then	

	if (nr_agencia_p IS NOT NULL AND nr_agencia_p::text <> '') and (coalesce(nr_conta_p::text, '') = '')  then
	
		if (length(nr_agencia_p) <> 4) and (coalesce(nr_conta_p::text, '') = '') then
			qt_dig_solic_w 			:= 4;
			qt_dig_agencia_inf_w 	:= length(nr_agencia_p);
			nr_digito_w := substr(wheb_mensagem_pck.get_texto(1086167,'qt_dig_solic_w='||qt_dig_solic_w||';qt_dig_agencia_inf_w='||qt_dig_agencia_inf_w),1,255); 		
		end if;	
		
	elsif (nr_conta_p IS NOT NULL AND nr_conta_p::text <> '') and (nr_agencia_p IS NOT NULL AND nr_agencia_p::text <> '') then
	
		if (length(nr_conta_p) <> 7) then
			qt_dig_solic_w 			:= 7;
			qt_dig_agencia_inf_w 	:= length(nr_conta_p);
			nr_digito_w := substr(wheb_mensagem_pck.get_texto(1086168,'qt_dig_solic_w='||qt_dig_solic_w||';qt_dig_agencia_inf_w='||qt_dig_agencia_inf_w),1,255); 			
		elsif (length(nr_agencia_p) <> 4) then	
			qt_dig_solic_w 			:= 4;
			qt_dig_agencia_inf_w 	:= length(nr_agencia_p);
			nr_digito_w := substr(wheb_mensagem_pck.get_texto(1086167,'qt_dig_solic_w='||qt_dig_solic_w||';qt_dig_agencia_inf_w='||qt_dig_agencia_inf_w),1,255); 				
		else
			nr_peso_w 		:= '81472259395';
			vl_tamanho_w	:= length(nr_agencia_p||nr_conta_p);		
	
			for inc_w in 1..vl_tamanho_w loop
				vl_soma_w := vl_soma_w + ((substr(nr_agencia_p||nr_conta_p,inc_w,1))::numeric  * (substr(nr_peso_w,inc_w,1))::numeric );
			end loop;	

			nr_digito_w := 11 - mod(vl_soma_w,11);	
			
			if (mod(vl_soma_w,11) = 1) then
				nr_digito_w := 0;
			elsif (mod(vl_soma_w,11) = 0) then
				nr_digito_w := 1;
			end if;
			
		end if;	
	
	end if;
	
/*HSBC*/
	
elsif (to_char(cd_banco_p,'FM000') = 399) then

	if (nr_agencia_p IS NOT NULL AND nr_agencia_p::text <> '') and (coalesce(nr_conta_p::text, '') = '')  then
	
		if (length(nr_agencia_p) <> 4) and (coalesce(nr_conta_p::text, '') = '') then
			qt_dig_solic_w 			:= 4;
			qt_dig_agencia_inf_w 	:= length(nr_agencia_p);
			nr_digito_w := substr(wheb_mensagem_pck.get_texto(1086167,'qt_dig_solic_w='||qt_dig_solic_w||';qt_dig_agencia_inf_w='||qt_dig_agencia_inf_w),1,255); 	
		end if;	
		
	elsif (nr_conta_p IS NOT NULL AND nr_conta_p::text <> '') and (nr_agencia_p IS NOT NULL AND nr_agencia_p::text <> '') then
		if (length(nr_conta_p) <> 6) then
			qt_dig_solic_w 			:= 6;
			qt_dig_agencia_inf_w 	:= length(nr_conta_p);
			nr_digito_w := substr(wheb_mensagem_pck.get_texto(1086168,'qt_dig_solic_w='||qt_dig_solic_w||';qt_dig_agencia_inf_w='||qt_dig_agencia_inf_w),1,255); 		
		elsif (length(nr_agencia_p) <> 4) then
			qt_dig_solic_w 			:= 4;
			qt_dig_agencia_inf_w 	:= length(nr_agencia_p);
			nr_digito_w := substr(wheb_mensagem_pck.get_texto(1086167,'qt_dig_solic_w='||qt_dig_solic_w||';qt_dig_agencia_inf_w='||qt_dig_agencia_inf_w),1,255); 			
		else
			nr_peso_w 		:= '8923456789';
			vl_tamanho_w	:= length(nr_agencia_p||nr_conta_p);	

			for inc_w in 1..vl_tamanho_w loop
				vl_soma_w := vl_soma_w + ((substr(nr_agencia_p||nr_conta_p,inc_w,1))::numeric  * (substr(nr_peso_w,inc_w,1))::numeric );
			end loop;	
		
			nr_digito_w := mod(vl_soma_w,11);
			
			if (nr_digito_w in ('0','10')) then
				nr_digito_w := 0;
			end if;
			
		end if;
		
	end if;
	
/*CITIBANK*/
	
elsif (to_char(cd_banco_p,'FM000') = 745) then	
		
	if (nr_agencia_p IS NOT NULL AND nr_agencia_p::text <> '')  then
	
		if (length(nr_agencia_p) <> 4) and (coalesce(nr_conta_p::text, '') = '') then
			qt_dig_solic_w 			:= 4;
			qt_dig_agencia_inf_w 	:= length(nr_agencia_p);
			nr_digito_w := substr(wheb_mensagem_pck.get_texto(1086167,'qt_dig_solic_w='||qt_dig_solic_w||';qt_dig_agencia_inf_w='||qt_dig_agencia_inf_w),1,255); 			
		end if;	

	elsif (nr_conta_p IS NOT NULL AND nr_conta_p::text <> '') then
		if (length(nr_conta_p) <> 10) then
			qt_dig_solic_w 			:= 10;
			qt_dig_agencia_inf_w 	:= length(nr_conta_p);
			nr_digito_w := substr(wheb_mensagem_pck.get_texto(1086168,'qt_dig_solic_w='||qt_dig_solic_w||';qt_dig_agencia_inf_w='||qt_dig_agencia_inf_w),1,255); 			
		else
			nr_peso_w 		:= '12';
			vl_tamanho_w	:= length(nr_conta_p);

			for inc_w in 1..vl_tamanho_w loop
				vl_soma_w := vl_soma_w + ((substr(nr_conta_p,inc_w,1))::numeric  * (nr_peso_w-inc_w)::numeric );
			end loop;

			nr_digito_w := 11 - mod(vl_soma_w,11);

			if (mod(vl_soma_w,11) in ('0','1')) then
				nr_digito_w := 0;
			end if;

		end if;

	end if;
		
end if;

return	nr_digito_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION valida_digito_agencia_conta ( cd_banco_p bigint, nr_agencia_p text, nr_conta_p text, nr_tipo_conta_p text) FROM PUBLIC;
