-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ordem_apres_item_arv_pep (vl_dominio_p text) RETURNS bigint AS $body$
DECLARE


nr_seq_apresent_w	bigint := 999;


BEGIN
if (vl_dominio_p IS NOT NULL AND vl_dominio_p::text <> '') then
	begin
	/*  Inicio do bloco de sequência dos itens da árvore inicial no primeiro nivel. */

	if (vl_dominio_p = '21') then
		begin
		nr_seq_apresent_w	:= 1;
		end;
	elsif (vl_dominio_p = '26') then
		begin
		nr_seq_apresent_w	:= 10;
		end;
	elsif (vl_dominio_p = '35') then
		begin
		nr_seq_apresent_w	:= 20;
		end;
	elsif (vl_dominio_p = '50') then
		begin
		nr_seq_apresent_w	:= 21;
		end;
	elsif (vl_dominio_p = '49') then
		begin
		nr_seq_apresent_w	:= 22;
		end;
	elsif (vl_dominio_p = '40') then
		begin
		nr_seq_apresent_w	:= 25;
		end;
	elsif (vl_dominio_p = '32') then
		begin
		nr_seq_apresent_w	:= 30;
		end;
	elsif (vl_dominio_p = '29') then
		begin
		nr_seq_apresent_w	:= 40;
		end;
	elsif (vl_dominio_p = '8') then
		begin
		nr_seq_apresent_w	:= 50;
		end;
	elsif (vl_dominio_p = '39') then
		begin
		nr_seq_apresent_w	:= 60;
		end;
	elsif (vl_dominio_p = '34') then
		begin
		nr_seq_apresent_w	:= 70;
		end;
	elsif (vl_dominio_p = '42') then
		begin
		nr_seq_apresent_w	:= 75;
		end;
	elsif (vl_dominio_p = '19') then
		begin
		nr_seq_apresent_w	:= 80;
		end;
	elsif (vl_dominio_p = '36') then
		begin
		nr_seq_apresent_w	:= 90;
		end;
	elsif (vl_dominio_p = '16') then
		begin
		nr_seq_apresent_w	:= 100;
		end;
	elsif (vl_dominio_p = '114') then
		begin
		nr_seq_apresent_w	:= 105;
		end;
	elsif (vl_dominio_p = '120') then
		begin
		nr_seq_apresent_w	:= 108;
		end;
	elsif (vl_dominio_p = '33') then
		begin
		nr_seq_apresent_w	:= 110;
		end;
	elsif (vl_dominio_p = '20') then
		begin
		nr_seq_apresent_w	:= 120;
		end;
	elsif (vl_dominio_p = '7') then
		begin
		nr_seq_apresent_w	:= 130;
		end;
	elsif (vl_dominio_p = '30') then
		begin
		nr_seq_apresent_w	:= 140;
		end;
	elsif (vl_dominio_p = '25') then
		begin
		nr_seq_apresent_w	:= 145;
		end;
	elsif (vl_dominio_p = '11') then
		begin
		nr_seq_apresent_w	:= 150;
		end;
	elsif (vl_dominio_p = '24') then
		begin
		nr_seq_apresent_w	:= 160;
		end;
	/*  Fim do bloco de sequência dos itens da árvore inicial no primeiro nivel. */

	/*  Inicio do bloco de sequência dos itens da árvore inicial no segundo nivel  "Consultas". */

	elsif (vl_dominio_p = '41') then
		begin
		nr_seq_apresent_w	:= 165;
		end;
	elsif (vl_dominio_p = '22') then
		begin
		nr_seq_apresent_w	:= 170;
		end;
	elsif (vl_dominio_p = '5') then
		begin
		nr_seq_apresent_w	:= 180;
		end;
	elsif (vl_dominio_p = '2') then
		begin
		nr_seq_apresent_w	:= 190;
		end;
	elsif (vl_dominio_p = '3') then
		begin
		nr_seq_apresent_w	:= 200;
		end;
	elsif (vl_dominio_p = '1') then
		begin
		nr_seq_apresent_w	:= 210;
		end;
	elsif (vl_dominio_p = '4') then
		begin
		nr_seq_apresent_w	:= 220;
		end;
	elsif (vl_dominio_p = '14') then
		begin
		nr_seq_apresent_w	:= 230;
		end;
	elsif (vl_dominio_p = '10') then
		begin
		nr_seq_apresent_w	:= 240;
		end;
	elsif (vl_dominio_p = '9') then
		begin
		nr_seq_apresent_w	:= 250;
		end;
	elsif (vl_dominio_p = '6') then
		begin
		nr_seq_apresent_w	:= 260;
		end;
	elsif (vl_dominio_p = '23') then
		begin
		nr_seq_apresent_w	:= 270;
		end;
	elsif (vl_dominio_p = '12') then
		begin
		nr_seq_apresent_w	:= 280;
		end;
	elsif (vl_dominio_p = '27') then
		begin
		nr_seq_apresent_w	:= 290;
		end;
	elsif (vl_dominio_p = '15') then
		begin
		nr_seq_apresent_w	:= 300;
		end;
	elsif (vl_dominio_p = '38') then
		begin
		nr_seq_apresent_w	:= 310;
		end;
	elsif (vl_dominio_p = '43') then
		begin
		nr_seq_apresent_w	:= 313;
		end;
	elsif (vl_dominio_p = '45') then
		begin
		nr_seq_apresent_w	:= 316;
		end;
	/*  Fim do bloco de sequência dos itens da árvore inicial no segundo nivel  "Consultas". */

	/*  Inicio do bloco de sequência dos itens da árvore inicial "Meus pacientes" .*/

	elsif (vl_dominio_p = '17') then
		begin
		nr_seq_apresent_w	:= 320;
		end;
	elsif (vl_dominio_p = '18') then
		begin
		nr_seq_apresent_w	:= 330;
		end;
	elsif (vl_dominio_p = '37') then
		begin
		nr_seq_apresent_w	:= 340;
		end;
	elsif (vl_dominio_p = '31') then
		begin
		nr_seq_apresent_w	:= 350;
		end;
	/*  Fim do bloco de sequência dos itens da árvore inicial "Meus pacientes" . */

	end if;
	end;
end if;
return nr_seq_apresent_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ordem_apres_item_arv_pep (vl_dominio_p text) FROM PUBLIC;
