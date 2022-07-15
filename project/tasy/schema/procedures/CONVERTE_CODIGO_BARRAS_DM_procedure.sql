-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE array_identif AS (array_identif varchar(10)[6]);


CREATE OR REPLACE PROCEDURE converte_codigo_barras_dm ( cd_mat_barra_p text, cd_estabelecimento_p bigint, ie_retorno_p text, ds_retorno_p INOUT text) AS $body$
DECLARE


/*Esta procedure decodifica os padrões GTIN e HBIC. Outros padrões ou variações destes podem não ser analisados corretamente.*/


			
/*Retorno
MAT	= Código do material do Tasy
01	= Código de Barras indicado na etiqueta (GTIN)
10	= Lote
17	= Data de validade com formatação dd/mm/yyyy
17S	= Data de validade sem formatação
713	= Registro Anvisa
*/


/* Versao alterada da procedure  converte_codigo_barras_DMATRIX - por LSSILVA */


/* OS 1623438 - Criacao da procedure, adicao dos identificadores 21 e 11 - LSSILVA */


/* OS 1701677 - Adicionado identificador 240 - LSSILVA */


/* OS 1701677 - Para ajustar identificadores com '-' */


/* OS 1706304 - Para verificar o identificador 30*/


/* OS 1689811 - Melhora identificador 240 */

ds_identif			varchar(5);
cd_mat_barra_w		varchar(4000);
ie_identificador_w		varchar(2);
IA_0			varchar(18);
ds_retorno_w		varchar(255);

cd_material_w		integer;
ie_achou_w		varchar(1);

dt_validade_ww		varchar(10);
dt_validade_w		varchar(10);

ds_lote_w		varchar(255);
ds_lote_ww		varchar(50);

ds_id_240_w		varchar(255);
ds_id_240_ww		varchar(50);

dt_producao_ww		varchar(10);
dt_producao_w		varchar(10);

ds_numero_serie		varchar(20);

pos_w			integer;

nr_registro_anvisa_w	material.nr_registro_anvisa%type;

identif_validos_count	integer;

identif_validos			array_identif;
identif_procurados		array_identif;
identif_encontrados		array_identif;

idendif_procurados_id	smallint;
identif_aux				integer;

ie_aux					boolean;

nr_serie_material_w		material_lote_fornec.nr_serie_material%type;

BEGIN
identif_validos := array_identif('10', '11', '17', '21', '240', '713');
identif_procurados := array_identif('10', '11', '17', '21', '240', '713');
identif_encontrados := array_identif('X', 'X', 'X', 'X', 'X', 'X');

ie_aux := false;

/* HIBC (Health Industy Bar Code)  */


--Tratamento específico para o padrão HIBC (Health Industy Bar Code) em pacotes unitários.
if (substr(cd_mat_barra_p, 1, 1) = '+') then
	begin
	
		cd_mat_barra_w		:= cd_mat_barra_p;
		ie_identificador_w	:= substr(cd_mat_barra_w, 1,1);

		select	CASE WHEN ie_identificador_w='+' THEN 	substr(cd_mat_barra_w, 1, position(';' in cd_mat_barra_w) - 1)  ELSE '' END ,
			CASE WHEN ie_identificador_w='+' THEN 	substr(cd_mat_barra_w, position(';' in cd_mat_barra_w), 4000)  ELSE substr(cd_mat_barra_w, 1, 4000) END /*Utilizado na nota fiscal, na pasta Identificação barras item*/
		into STRICT	IA_0,
			cd_mat_barra_w	
		;
		
		if (ie_retorno_p = 'MAT') then
			begin
				select	coalesce(max(cd_material),0)
				into STRICT	cd_material_w
				from	material_cod_barra
				where	cd_barra_material	= IA_0;

				ds_retorno_w	:= substr(cd_material_w,1,255);	
			end;
		elsif (ie_retorno_p = '01') then
			begin
				ds_retorno_w	:= IA_0;
			end;
		elsif	((ie_retorno_p = '17') or (ie_retorno_p = '10') or (ie_retorno_p = '17S')) then
			begin
				
				/* 17 - dt_validade_w */

				dt_validade_ww	:= substr(cd_mat_barra_w, position(';' in cd_mat_barra_w) + 1,5);
				dt_validade_w	:= to_char(to_date('01/01/20' || substr(dt_validade_ww,1,2),'dd/mm/yyyy') + substr(dt_validade_ww,3,3) - 1,'dd/mm/yyyy');
				cd_mat_barra_w	:= replace(cd_mat_barra_w, ';' || dt_validade_ww, '');	
				
				/* 713 - nr_registro_anvisa_w */

				nr_registro_anvisa_w	:= substr(cd_mat_barra_w,1,length(cd_mat_barra_w) - 1);
				cd_mat_barra_w	:= replace(cd_mat_barra_w, ';' || nr_registro_anvisa_w, '');
				
				/* 10 - ds_lote_w */

				ds_lote_w	:= substr(cd_mat_barra_w,1,length(cd_mat_barra_w) - 1);	
		
			end;
		end if;	
	
	/* Fim HIBC (Health Industy Bar Code)  */
	
	end;
else
	begin
/* GS1 */

	cd_mat_barra_w := cd_mat_barra_p;
	
	pos_w := position('(99)' in cd_mat_barra_w)-1;

	if (pos_w > 0) then
		begin
			cd_mat_barra_w	:= substr(cd_mat_barra_w, 1, pos_w);
		end;
	end if;

	cd_mat_barra_w := replace(replace(cd_mat_barra_w,'(',''),')','');
	
	if (position('P00' in cd_mat_barra_w) > 0)then
		cd_mat_barra_w := substr(cd_mat_barra_w,4);
	end if;
	
	/* Se possui espaco, considera que esta no padrao GS1, identificadores com tamanho dinamico terminando com espaco */

	if (position(' ' in cd_mat_barra_w) > 0)then
		begin
		
			cd_mat_barra_w := replace(replace(cd_mat_barra_w,'.',''),'-','');
		
			/*
				identificadores validos
				XX, 00, 01, 02, 
				10 = ds_lote_w
				17 = dt_validade_w
				713 = nr_registro_anvisa_w		
			*/
			
			while(length(cd_mat_barra_w) > 1) loop
				
				if (substr(cd_mat_barra_w,1,2) = 'XX')then
					IA_0 := '';
					cd_mat_barra_w := substr(cd_mat_barra_w, 1, 4000);
					/*Utilizado na nota fiscal, na pasta Identificação barras item*/

			
				elsif (substr(cd_mat_barra_w,1,2) = '00')then
					IA_0 := substr(cd_mat_barra_w, 1 + 2, 18);
					cd_mat_barra_w := substr(cd_mat_barra_w, 1 + 2 + 18);	
					
				elsif (substr(cd_mat_barra_w,1,2) = '01'
					or substr(cd_mat_barra_w,1,2) = '02') then
					IA_0 := substr(cd_mat_barra_w, 1 + 2,14);
					cd_mat_barra_w := substr(cd_mat_barra_w, 1 + 2 + 14);
					
				elsif (substr(cd_mat_barra_w,1,2) = '10') then
					if (position(' ' in cd_mat_barra_w) = 0)then
						ds_lote_w := substr(cd_mat_barra_w, 2 + position('10' in cd_mat_barra_w));
						cd_mat_barra_w := '';
					else
						ds_lote_w := substr(cd_mat_barra_w, 2 + position('10' in cd_mat_barra_w), position(' ' in cd_mat_barra_w)-3);
						cd_mat_barra_w := substr(cd_mat_barra_w, 1 + position(' ' in cd_mat_barra_w));					
					end if;
					
				elsif (substr(cd_mat_barra_w,1,2) in ('11','12','13','15')) then
					cd_mat_barra_w := substr(cd_mat_barra_w, 1 + 2 + 6);
					
				elsif (substr(cd_mat_barra_w,1,2) = '17') then
					
					dt_validade_ww	:= substr(cd_mat_barra_w, position('17' in cd_mat_barra_w) + 2, 6);
					dt_validade_w	:= substr(dt_validade_ww, 5,2) || '/' || substr(dt_validade_ww, 3,2) || '/20' || substr(dt_validade_ww, 1,2);
					
					cd_mat_barra_w := substr(cd_mat_barra_w, 1 + 2 + 6);
					
					
				elsif (substr(cd_mat_barra_w,1,2) = '20') then
					cd_mat_barra_w := substr(cd_mat_barra_w, 1 + 2 + 2);
				elsif (substr(cd_mat_barra_w,1,2) = '21') then
					if (position(' ' in cd_mat_barra_w) = 0)then
						nr_serie_material_w := substr(cd_mat_barra_w, 2 + position('21' in cd_mat_barra_w));
						cd_mat_barra_w := '';
					else
						nr_serie_material_w := substr(cd_mat_barra_w, 2 + position('21' in cd_mat_barra_w), position(' ' in cd_mat_barra_w) - 3);
						cd_mat_barra_w := substr(cd_mat_barra_w, 1 + position(' ' in cd_mat_barra_w));					
					end if;
					
				elsif (substr(cd_mat_barra_w,1,2) in ('22','30')
					or substr(cd_mat_barra_w,1,3) in ('240','241','242','250','251','253','254')) then
					if (position(' ' in cd_mat_barra_w) = 0)then
						cd_mat_barra_w := '';
					else
						cd_mat_barra_w := substr(cd_mat_barra_w, 1 + position(' ' in cd_mat_barra_w));
					end if;
								
				elsif (substr(cd_mat_barra_w,1,3) in ('310','311','312','313','314','315','316','320','321','322')) then
					cd_mat_barra_w := substr(cd_mat_barra_w, 1 + 4 + 6);	
				
				elsif (substr(cd_mat_barra_w,1,3) = '323') then
					cd_mat_barra_w := substr(cd_mat_barra_w, 1 + 2 + 18);
				
				elsif (substr(cd_mat_barra_w,1,3) in ('324','325')) then
					cd_mat_barra_w := substr(cd_mat_barra_w, 1 + 2 + 14);
				
				elsif (substr(cd_mat_barra_w,1,3) = '326') then
					if (position(' ' in cd_mat_barra_w) = 0)then
						cd_mat_barra_w := '';
					else
						cd_mat_barra_w := substr(cd_mat_barra_w, 1 + position(' ' in cd_mat_barra_w));
					end if;
				
				elsif (substr(cd_mat_barra_w,1,3) in ('327','328','329','330','331')) then
					cd_mat_barra_w := substr(cd_mat_barra_w, 1 + 2 + 6);
				
				elsif (substr(cd_mat_barra_w,1,3) = '327') then
					cd_mat_barra_w := substr(cd_mat_barra_w, 1 + 2 + 2);
				
				elsif (substr(cd_mat_barra_w,1,3) in ('333','334','335','336'
								,'337','340','341','342','343','344')) then
					if (position(' ' in cd_mat_barra_w) = 0)then
						cd_mat_barra_w := '';
					else
						cd_mat_barra_w := substr(cd_mat_barra_w, 1 + position(' ' in cd_mat_barra_w));
					end if;

				elsif (substr(cd_mat_barra_w,1,3) in ('345','346'
								,'347','348'
								,'349','350'
								,'351','352')) then
					cd_mat_barra_w := substr(cd_mat_barra_w, 1 + 4 + 6);
					
				elsif (substr(cd_mat_barra_w,1,3) in ('353','354','355','356','357'
								,'360','361','362','363'
								,'364','365','366','367'
								,'368','369')) then
					cd_mat_barra_w := substr(cd_mat_barra_w, 1 + 2 + 6);
				
				elsif (substr(cd_mat_barra_w,1,2) = '37'
					or substr(cd_mat_barra_w,1,3) in ('390','391','393','400','401','403','420')) then
					if (position(' ' in cd_mat_barra_w) = 0)then
						cd_mat_barra_w := '';
					else
						cd_mat_barra_w := substr(cd_mat_barra_w, 1 + position(' ' in cd_mat_barra_w));
					end if;

				elsif (substr(cd_mat_barra_w,1,3) = '402') then
					cd_mat_barra_w := substr(cd_mat_barra_w, 1 + 3 + 17);
				
				elsif (substr(cd_mat_barra_w,1,3) in ('410','411','412','413','414','415')) then
					cd_mat_barra_w := substr(cd_mat_barra_w, 1 + 3 + 13);
				
				elsif (substr(cd_mat_barra_w,1,3) = '421') then
					if (position(' ' in cd_mat_barra_w) = 0)then
						cd_mat_barra_w := '';
					else
						cd_mat_barra_w := substr(cd_mat_barra_w, 1 + position(' ' in cd_mat_barra_w));
					end if;
				
				elsif (substr(cd_mat_barra_w,1,3) = '422') then
					cd_mat_barra_w := substr(cd_mat_barra_w, 1 + 3 + 3);
				
				elsif (substr(cd_mat_barra_w,1,3) = '422') then
					if (position(' ' in cd_mat_barra_w) = 0)then
						cd_mat_barra_w := '';
					else
						cd_mat_barra_w := substr(cd_mat_barra_w, 1 + position(' ' in cd_mat_barra_w));
					end if;
				
				elsif (substr(cd_mat_barra_w,1,3) in ('424','425','426')) then
					cd_mat_barra_w := substr(cd_mat_barra_w, 1 + 3 + 3);
				
				elsif (substr(cd_mat_barra_w,1,3) = '713') then
					nr_registro_anvisa_w := substr(cd_mat_barra_w, 3 + position('713' in cd_mat_barra_w), 13);
					cd_mat_barra_w := substr(cd_mat_barra_w, 1 + 3 + 13);
					if (position(' ' in cd_mat_barra_w) = 1)then
						cd_mat_barra_w := substr(cd_mat_barra_w, 2);
					end if;
				
				elsif (substr(cd_mat_barra_w,1,4) = '7001') then
					cd_mat_barra_w := substr(cd_mat_barra_w, 1 + 4 + 13);
				
				elsif (substr(cd_mat_barra_w,1,4) = '7002') then
					if (position(' ' in cd_mat_barra_w) = 0)then
						cd_mat_barra_w := '';
					else
						cd_mat_barra_w := substr(cd_mat_barra_w, 1 + position(' ' in cd_mat_barra_w));
					end if;
				
				elsif (substr(cd_mat_barra_w,1,4) = '7003') then
					cd_mat_barra_w := substr(cd_mat_barra_w, 1 + 4 + 12);
				
				elsif (substr(cd_mat_barra_w,1,4) in ('7030','7031','7032','7033','7034','7035','7036','7037','7038','7039')) then
					if (position(' ' in cd_mat_barra_w) = 0)then
						cd_mat_barra_w := '';
					else
						cd_mat_barra_w := substr(cd_mat_barra_w, 1 + position(' ' in cd_mat_barra_w));
					end if;
				
				elsif (substr(cd_mat_barra_w,1,4) = '8001') then
					cd_mat_barra_w := substr(cd_mat_barra_w, 1 + 4 + 14);
				
				elsif (substr(cd_mat_barra_w,1,4) in ('8002','8003','8004')) then
					if (position(' ' in cd_mat_barra_w) = 0)then
						cd_mat_barra_w := '';
					else
						cd_mat_barra_w := substr(cd_mat_barra_w, 1 + position(' ' in cd_mat_barra_w));
					end if;
				
				elsif (substr(cd_mat_barra_w,1,4) = '8005') then
					cd_mat_barra_w := substr(cd_mat_barra_w, 1 + 4 + 6);
				
				elsif (substr(cd_mat_barra_w,1,4) = '8006') then
					cd_mat_barra_w := substr(cd_mat_barra_w, 1 + 4 + 14 + 2 + 2);
					
				elsif (substr(cd_mat_barra_w,1,4) in ('8007','8008','8018','8020')) then
					if (position(' ' in cd_mat_barra_w) = 0)then
						cd_mat_barra_w := '';
					else
						cd_mat_barra_w := substr(cd_mat_barra_w, 1 + position(' ' in cd_mat_barra_w));
					end if;
				
				elsif (substr(cd_mat_barra_w,1,4) = '8100') then
					cd_mat_barra_w := substr(cd_mat_barra_w, 1 + 4 + 8);
				
				elsif (substr(cd_mat_barra_w,1,4) = '8101') then
					cd_mat_barra_w := substr(cd_mat_barra_w, 1 + 4 + 1 + 5 + 4);
				
				elsif (substr(cd_mat_barra_w,1,4) = '8102') then
					cd_mat_barra_w := substr(cd_mat_barra_w, 1 + 4 + 1 + 1);
					
				elsif (substr(cd_mat_barra_w,1,4) = '8110'
					or substr(cd_mat_barra_w,1,2) in ('90','91','92','93','94','95','96','97','98','99')
					) then
					if (position(' ' in cd_mat_barra_w) = 0)then
						cd_mat_barra_w := '';
					else
						cd_mat_barra_w := substr(cd_mat_barra_w, 1 + position(' ' in cd_mat_barra_w));
					end if;
				else
					CALL wheb_mensagem_pck.exibir_mensagem_abort(90667);
				end if;
			
			end loop;
			
			if (ie_retorno_p = 'MAT') then
				begin
					select	coalesce(max(cd_material),0)
					into STRICT	cd_material_w
					from	material_cod_barra
					where	cd_barra_material	= IA_0;

					ds_retorno_w	:= substr(cd_material_w,1,255);	
				end;
			elsif (ie_retorno_p = '01') then
				begin
				ds_retorno_w	:= IA_0;
				end;
			end if;
		end;
	else
		begin
		
		ie_identificador_w	:= substr(cd_mat_barra_w, 1,2);

		if (ie_identificador_w in ('00', '01', '02', 'XX')) then
			begin
			
			select	CASE WHEN ie_identificador_w='00' THEN 	substr(cd_mat_barra_w, position(ie_identificador_w in cd_mat_barra_w) + 2,18) WHEN ie_identificador_w='01' THEN 	substr(cd_mat_barra_w, position(ie_identificador_w in cd_mat_barra_w) + 2,14) WHEN ie_identificador_w='02' THEN 	substr(cd_mat_barra_w, position(ie_identificador_w in cd_mat_barra_w) + 2,14) WHEN ie_identificador_w='XX' THEN 	'' END ,
			CASE WHEN ie_identificador_w='00' THEN 	substr(cd_mat_barra_w, 21, 4000) WHEN ie_identificador_w='01' THEN 	substr(cd_mat_barra_w, 17, 4000) WHEN ie_identificador_w='02' THEN 	substr(cd_mat_barra_w, 17, 4000) WHEN ie_identificador_w='XX' THEN 	substr(cd_mat_barra_w, 1, 4000) END /*Utilizado na nota fiscal, na pasta Identificação barras item*/
			into STRICT	IA_0,
				cd_mat_barra_w	
			;
			
			end;
		end if;
		
		if (ie_retorno_p = 'MAT') then
			begin
				select	coalesce(max(cd_material),0)
				into STRICT	cd_material_w
				from	material_cod_barra
				where	cd_barra_material	= IA_0;

				ds_retorno_w	:= substr(cd_material_w,1,255);	
			end;
		elsif (ie_retorno_p = '01') then
			begin
				ds_retorno_w	:= IA_0;
			end;
		elsif	((ie_retorno_p = '10') or (ie_retorno_p = '17') or (ie_retorno_p = '17S') or (ie_retorno_p = '713')) then
			begin				
		
				while(length(cd_mat_barra_w) > 1) loop
					ds_identif := substr(cd_mat_barra_w, 1, 2);

					if (ds_identif = '10') then
						/* Rotina para identificar o lote dentro do Barras */

						begin
							ds_lote_ww	:= substr(cd_mat_barra_w, position('10' in cd_mat_barra_w) + 2, 20);
							ds_lote_w := '';
							/* Confere se outro indicador existe dentro do lote */

							
							identif_validos_count := 0;
							
							for j in 1..2 loop
								for i in 1..identif_validos.count loop
									begin
										if	((identif_validos(i) <> 'X') and (position(identif_validos(i) in ds_lote_ww) = 1)) then
											begin
												ds_lote_w := ds_lote_w || substr(ds_lote_ww, 1, length(identif_validos(i)));
												ds_lote_ww := substr(ds_lote_ww, 1+length(identif_validos(i)));
												exit;
											end;
										end if;									
									end;
								end loop;						
							end loop;	
							
							idendif_procurados_id := -1;
							identif_aux := length(ds_lote_ww)+1;

							/* Verifica onde termina a informacao */

							for i in 1..identif_procurados.count loop
								begin
									if	((identif_procurados(i) <> 'X') and (identif_procurados(i) <> '10') and (position(identif_procurados(i) in ds_lote_ww) > 0)) then
										begin
											if (identif_aux > position(identif_procurados(i) in ds_lote_ww)) then
												begin	
													ie_aux := true;
													/* Verifica se os proximos digitos sao validos para o identificador encontrado */

													if (identif_validos(i) = '11'
														and position('-' in substr(ds_lote_ww, position(identif_validos(i) in ds_lote_ww) + length(identif_validos(i)), 6)) > 0) then
														begin				
															/* Identificador 11 com - no meio, ex.  11 17-01172209 */
												
															ie_aux := false;												
														end;
													elsif (identif_validos(i) = '17'
														and position('-' in substr(ds_lote_ww, position(identif_validos(i) in ds_lote_ww) + length(identif_validos(i)), 6)) > 0) then
														begin				
															/* Identificador 17 com - no meio, ex.  17 11-01782209 */
												
															ie_aux := false;												
														end;												
													end if;
												
													if (ie_aux)then
														idendif_procurados_id := i;
														identif_aux := position(identif_procurados(i) in ds_lote_ww);
													end if;													
												end;
											end if;																		
										end;
									end if;
								end;
							end loop;
							
							if (idendif_procurados_id <> -1) then
								begin
									ds_lote_ww:= substr(ds_lote_ww, 1, position(identif_procurados(idendif_procurados_id) in ds_lote_ww) -1);
								end;
							end if;
							
							ds_lote_w := ds_lote_w || ds_lote_ww;
													
							cd_mat_barra_w := substr(cd_mat_barra_w, 1 + length(ds_identif || ds_lote_w), 4000);	

							identif_encontrados(1) := '10';
							identif_procurados(1) := 'X';						
						end;
					elsif (ds_identif = '11') then
						begin
							if (substr(cd_mat_barra_w, position('11' in cd_mat_barra_w) + 6, 1) = '-') then
								dt_producao_ww	:= substr(cd_mat_barra_w, position('11' in cd_mat_barra_w) + 2,7);
								dt_producao_w	:= '00' || '/' || substr(dt_producao_ww, 6,2) || '/' || substr(dt_producao_ww, 1,4);
							else
								dt_producao_ww	:= substr(cd_mat_barra_w, position('11' in cd_mat_barra_w) + 2, 6);
								dt_producao_w	:= substr(dt_validade_ww, 5,2) || '/' || substr(dt_producao_ww, 3,2) || '/20' || substr(dt_producao_ww, 1,2);
							end if;

							cd_mat_barra_w := substr(cd_mat_barra_w, 1 + length(ds_identif || dt_producao_ww), 4000);

							identif_encontrados(2) := '11';
							identif_procurados(2) := 'X';
							
						end;
					elsif (ds_identif = '17') then
						begin
							if (substr(cd_mat_barra_w, position('17' in cd_mat_barra_w) + 6, 1) = '-') then
								dt_validade_ww	:= substr(cd_mat_barra_w, position('17' in cd_mat_barra_w) + 2,7);
								dt_validade_w	:= '00' || '/' || substr(dt_validade_ww, 6,2) || '/' || substr(dt_validade_ww, 1,4);
							else
								dt_validade_ww	:= substr(cd_mat_barra_w, position('17' in cd_mat_barra_w) + 2, 6);
								dt_validade_w	:= substr(dt_validade_ww, 5,2) || '/' || substr(dt_validade_ww, 3,2) || '/20' || substr(dt_validade_ww, 1,2);
							end if;
							
							cd_mat_barra_w := substr(cd_mat_barra_w, 1 + length(ds_identif || dt_validade_ww), 4000);
							
							identif_encontrados(3) := '17';
							identif_procurados(3) := 'X';
							
						end;
					elsif (ds_identif = '21') then
						begin
							cd_mat_barra_w := substr(cd_mat_barra_w, 1 + length(ds_identif) + 13, 4000);
							
							identif_encontrados(4) := '21';
							identif_procurados(4) := 'X';
							
						end;
					elsif (ds_identif = '30') then
						begin					
							if (identif_encontrados(1) = 'X') and (identif_procurados(1) = '10') and (position('10' in cd_mat_barra_w) > 3) and (position('10' in cd_mat_barra_w) <> (length(cd_mat_barra_w)-1)) then
								cd_mat_barra_w := substr(cd_mat_barra_w, (length(substr(cd_mat_barra_w, 1, position('10' in cd_mat_barra_w)-1))+1), 4000);								
							else
								cd_mat_barra_w := substr(cd_mat_barra_w, 1 + length(ds_identif) + 2, 4000);
							end if;							
						end;
					elsif (substr(cd_mat_barra_w, 1, 3) = '713') then
						begin
							ds_identif := substr(cd_mat_barra_w, 1, 3);
							
							nr_registro_anvisa_w := substr(cd_mat_barra_w, position('713' in cd_mat_barra_w) + 3, 13);
							cd_mat_barra_w := substr(cd_mat_barra_w, 1 + length(ds_identif || nr_registro_anvisa_w), 4000);
							
							identif_encontrados(6) := '713';
							identif_procurados(6) := 'X';						
						end;
					elsif (substr(cd_mat_barra_w, 1, 3) = '240') then
						/* Rotina para identificar informacao adicional do material -  OS 1701677*/

						begin
							ds_identif := substr(cd_mat_barra_w, 1, 3);
						
							if (position('-' in cd_mat_barra_w) > 0)then
							begin
								ds_id_240_ww	:= substr(cd_mat_barra_w, position(ds_identif in cd_mat_barra_w)+3
									, position('-' in cd_mat_barra_w) - (position(ds_identif in cd_mat_barra_w)+length(ds_identif)) + 3);
							end;
							else
							begin
								ds_id_240_ww	:= substr(cd_mat_barra_w, position(ds_identif in cd_mat_barra_w) + length(ds_identif), 30);
							end;						
							end if;
						
							ds_id_240_w := '';
							
							identif_validos_count := 0;					
							
							for j in 1..2 loop
								for i in 1..identif_validos.count loop
									begin
										if	((identif_validos(i) <> 'X') and (position(identif_validos(i) in ds_id_240_ww) = 1)) then
											begin		
												ds_id_240_w := ds_id_240_w || substr(ds_id_240_ww, 1, length(identif_validos(i)));
												ds_id_240_ww := substr(ds_lote_ww, 1+length(identif_validos(i)));	
												exit;											
											end;
										end if;
									end;
								end loop;						
							end loop;
													
							idendif_procurados_id := -1;
							identif_aux := length(ds_id_240_ww)+1;

							/* Verifica onde termina a informacao */

							for i in 1..identif_procurados.count loop
								begin
									if	((identif_procurados(i) <> 'X') and (identif_procurados(i) <> '240') and (position(identif_procurados(i) in ds_id_240_ww) > 0)) then
										begin
											if (identif_aux > position(identif_procurados(i) in ds_id_240_ww)) then
												begin	
													ie_aux := true;
													/* Verifica se os proximos digitos sao validos para o identificador encontrado */

													if(identif_validos(i) = '11'
														and ((position('-' in substr(ds_id_240_ww, 
																		position(identif_validos(i) in ds_id_240_ww) + length(identif_validos(i)), 6)) > 0)
															OR (length(SOMENTE_LETRA(substr(ds_id_240_ww,
																		position(identif_validos(i) in ds_id_240_ww) + length(identif_validos(i)), 6))) > 0) 
														))then
														begin				
															/* Identificador 11 com - no meio, ex.  11 17-01172209 */
												
															ie_aux := false;												
														end;
													elsif (identif_validos(i) = '17'
														and position('-' in substr(ds_id_240_ww, 
																		position(identif_validos(i) in ds_id_240_ww) + length(identif_validos(i)), 6)) > 0) then
														begin				
															/* Identificador 17 com - no meio, ex.  17 11-01782209 */
												
															ie_aux := false;												
														end;
													end if;
																								
													if (ie_aux)then
														idendif_procurados_id := i;
														identif_aux := position(identif_procurados(i) in ds_id_240_ww);
													end if;													
												end;
											end if;																		
										end;
									end if;
								end;
							end loop;					
							
							if (idendif_procurados_id <> -1) then
								begin
									ds_id_240_ww := substr(ds_id_240_ww, 1, position(identif_procurados(idendif_procurados_id) in ds_id_240_ww) -1);
								end;
							end if;
							
							ds_id_240_w := ds_id_240_w || ds_id_240_ww;
													
							cd_mat_barra_w := substr(cd_mat_barra_w, 1 + length(ds_identif || ds_id_240_w), 4000);	

							identif_encontrados(5) := '240';
							identif_procurados(5) := 'X';						
						end;
					else
						begin
							cd_mat_barra_w := '';
						end;
					end if;	
				end loop;	
			end;
		end if;
		
		end;
		
	end if;

	end;
	
end if;

/* Retorno procedure */

if (ie_retorno_p = '10') then
	begin
		ds_retorno_w	:= ds_lote_w;
	end;
elsif (ie_retorno_p in ('17','17S')) then
	begin
		if (substr(dt_validade_w,1,2) = '00') then /*Se for dia 00*/
			ds_retorno_w	:= to_char(last_day(to_date('01' || substr(dt_validade_w,3,255),'dd/mm/yyyy')),'dd/mm/yyyy');
		else
			ds_retorno_w	:= dt_validade_w;
		end if;

		if (ie_retorno_p = '17S') then
			ds_retorno_w	:=	to_char(to_date(ds_retorno_w,'dd/mm/yyyy'));
		end if;
	end;
elsif (ie_retorno_p = '21') then
	begin
		ds_retorno_w := nr_serie_material_w;
	end;
elsif (ie_retorno_p = '713') then
	begin
		ds_retorno_w	:= nr_registro_anvisa_w;
	end;
end if;

ds_retorno_p	:= substr(ds_retorno_w,1,255);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE converte_codigo_barras_dm ( cd_mat_barra_p text, cd_estabelecimento_p bigint, ie_retorno_p text, ds_retorno_p INOUT text) FROM PUBLIC;

