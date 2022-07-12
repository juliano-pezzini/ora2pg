-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_imagem_leito_ocup_hosp ( nr_status_p bigint) RETURNS bigint AS $body$
DECLARE


nr_imagem_w	bigint	:= 0;
		

BEGIN

if (nr_status_p = 1) then	
	nr_imagem_w	:= 202; -- Higienização
elsif (nr_status_p = 2) then
	nr_imagem_w	:= 205; -- Reservado
elsif (nr_status_p = 3) then
	nr_imagem_w	:= 195; -- Adulto M	
elsif (nr_status_p = 4) then
	nr_imagem_w	:= 196; -- Adulto F	
elsif (nr_status_p = 5) then
	nr_imagem_w	:= 203; -- Livre	
elsif (nr_status_p = 6) then
	nr_imagem_w	:= 201; -- Em Alta	
elsif (nr_status_p = 7) then
	nr_imagem_w	:= 200; -- Acompanhante	
elsif (nr_status_p = 8) then
	nr_imagem_w	:= 206; -- Interditado	
elsif (nr_status_p = 9) then
	nr_imagem_w	:= 207; -- Isolamento	
elsif (nr_status_p = 10) then
	nr_imagem_w	:= 204; -- Temporário Livre	
elsif (nr_status_p = 11) then
	nr_imagem_w	:= 209; -- Isolamento M
elsif (nr_status_p = 12) then
	nr_imagem_w	:= 190; -- Criança M
elsif (nr_status_p = 13) then
	nr_imagem_w	:= 191; -- Criança F	
elsif (nr_status_p = 14) then
	nr_imagem_w	:= 192; -- Adolescente M	
elsif (nr_status_p = 15) then
	nr_imagem_w	:= 193; -- Adolescente F	
elsif (nr_status_p = 16) then
	nr_imagem_w	:= 197; -- Idoso M	
elsif (nr_status_p = 17) then
	nr_imagem_w	:= 198; -- Idoso F	
elsif (nr_status_p = 18) then
	nr_imagem_w	:= 208; -- Saída interdição	
elsif (nr_status_p = 19) then
	nr_imagem_w	:= 199; -- Alta médica
elsif (nr_status_p = 23) then
	nr_imagem_w	:= 265; -- Aguard hig
elsif (nr_status_p = 24) then
	nr_imagem_w	:= 264; -- Manutenção
elsif (nr_status_p = 25) then
	nr_imagem_w	:= 263; -- Chamado manutenção
elsif (nr_status_p = 26) then
	nr_imagem_w	:= 278; -- Alta prev
elsif (nr_status_p = 22) then
	nr_imagem_w	:= 332; -- Interditado rad
elsif (nr_status_p = 21) then
	nr_imagem_w	:= 330; -- Paciente rad
elsif (nr_status_p = 27) then
	nr_imagem_w	:= 329; -- Pend Alta tes
elsif (nr_status_p = 20) then
	nr_imagem_w 	:= 446; -- Alta admin
elsif (nr_status_p = 28) then
	nr_imagem_w 	:= 738; -- Serviço em pausa
elsif (nr_status_p = 29) then
	nr_imagem_w 	:= 813; -- Leito isolado
elsif (nr_status_p = 30) then
	nr_imagem_w 	:= 875; -- Aguard hig (isol)	
elsif (nr_status_p = 31) then
	nr_imagem_w 	:= 891; -- Leito adaptado
elsif (nr_status_P = 32) then
	nr_imagem_w	:= 904; -- Saída temp
elsif (nr_status_P = 33) then
	nr_imagem_w	:= 949; -- Alta tes
elsif (nr_status_P = 34) then
	nr_imagem_w	:= 3663; -- patient away from bed
end if;

return	nr_imagem_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_imagem_leito_ocup_hosp ( nr_status_p bigint) FROM PUBLIC;

